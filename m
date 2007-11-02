Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbXKBRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbXKBRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXKBRHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:07:10 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:45747 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755760AbXKBRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:07:08 -0400
Date: Fri, 2 Nov 2007 11:07:06 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] 9p: loopback transport
Message-ID: <20071102170706.GI16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

9P loopback transport that can be used between 9P in-kernel servers and v9fs
on the same machine.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 net/9p/Kconfig      |    7 +
 net/9p/Makefile     |    4 +
 net/9p/trans_loop.c |  371 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 382 insertions(+), 0 deletions(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 979c781..ae341f0 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -23,6 +23,13 @@ config NET_9P_FD
 	  file descriptors.  TCP/IP is the default transport for 9p,
 	  so if you are going to use 9p, you'll likely want this.
 
+config NET_9P_LOOP
+	depends on NET_9P
+	default y if NET_9P
+	tristate "9P Loopback Transport (Experimental)"
+	help
+	  Loopback transport.
+
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
diff --git a/net/9p/Makefile b/net/9p/Makefile
index d143e4a..da05d35 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
+obj-$(CONFIG_NET_9P_LOOP) += 9pnet_loop.o
 obj-$(CONFIG_NET_9P_SRV) += 9psrv.o
 
 9pnet-objs := \
@@ -10,6 +11,9 @@ obj-$(CONFIG_NET_9P_SRV) += 9psrv.o
 	fcprint.o \
 	util.o \
 
+9pnet_loop-objs := \
+	trans_loop.o \
+
 9psrv-objs := \
 	srv.o \
 
diff --git a/net/9p/trans_loop.c b/net/9p/trans_loop.c
new file mode 100644
index 0000000..7e7793b
--- /dev/null
+++ b/net/9p/trans_loop.c
@@ -0,0 +1,371 @@
+/*
+ * linux/fs/9p/trans_fd.c
+ *
+ * Loopback transport. Used for testing.
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/in.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/un.h>
+#include <linux/uaccess.h>
+#include <linux/inet.h>
+#include <linux/idr.h>
+#include <linux/file.h>
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+
+struct p9_trans_loop {
+	spinlock_t			lock;
+	char				*name;
+	struct p9_trans			*ctrans;
+	struct p9_trans			*strans;
+	struct p9_trans_listener	listener;
+	struct list_head		trans_list;
+};
+
+struct p9_loop_opts {
+	char *name;
+};
+
+static struct p9_trans *p9lo_clt_create(const char *, char *);
+static void p9lo_clt_request(struct p9_trans *, struct p9_trans_req *);
+static int p9lo_clt_cancel(struct p9_trans *, struct p9_trans_req *);
+static void p9lo_clt_destroy(struct p9_trans *);
+static int p9lo_srv_create(struct p9_trans_loop *lt);
+static void p9lo_srv_destroy(struct p9_trans *);
+static int p9lo_srv_cancel(struct p9_trans *, struct p9_trans_req *);
+static void p9lo_srv_respond(struct p9_trans *, struct p9_trans_req *);
+static struct p9_trans_listener *p9lo_listener_create(char *);
+static void p9lo_trans_listener_destroy(struct p9_trans_listener *);
+
+static struct p9_trans_module p9lo_trans_mod = {
+	.name = "loop",
+	.maxsize = 65536,
+	.def = 0,
+	.create_client = p9lo_clt_create,
+	.create_listener = p9lo_listener_create,
+};
+
+enum {
+	Opt_name, Opt_err,
+};
+
+static match_table_t tokens = {
+	{Opt_name, "name=%s"},
+	{Opt_err, NULL},
+};
+
+static DEFINE_MUTEX(p9lo_lock);
+static LIST_HEAD(p9lo_trans_list);
+
+static void parse_opts(char *options, struct p9_loop_opts *opts)
+{
+	int token;
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+
+	opts->name = NULL;
+	if (!options)
+		return;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		if (*p == '\0')
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_name:
+			opts->name = match_strdup(&args[0]);
+			break;
+		default:
+			continue;
+		}
+	}
+}
+
+static struct p9_trans_loop *p9lo_trans_find(char *name)
+{
+	struct p9_trans_loop *lo;
+
+	mutex_lock(&p9lo_lock);
+	list_for_each_entry(lo, &p9lo_trans_list, trans_list) {
+		if (!strcmp(name, lo->name)) {
+			mutex_unlock(&p9lo_lock);
+			return lo;
+		}
+	}
+	mutex_unlock(&p9lo_lock);
+	return ERR_PTR(-ENOENT);
+}
+
+static struct p9_trans_loop *p9lo_trans_create(char *name)
+{
+	struct p9_trans_loop *lo;
+
+	mutex_lock(&p9lo_lock);
+	list_for_each_entry(lo, &p9lo_trans_list, trans_list) {
+		if (!strcmp(name, lo->name)) {
+			mutex_unlock(&p9lo_lock);
+			return ERR_PTR(-EEXIST);
+		}
+	}
+
+	lo = kmalloc(sizeof(*lo) + strlen(name) + 1, GFP_KERNEL);
+	spin_lock_init(&lo->lock);
+	lo->name = (char *) lo + sizeof(*lo);
+	strcpy(lo->name, name);
+	lo->ctrans = NULL;
+	lo->strans = NULL;
+	lo->listener.err = 0;
+	lo->listener.aux = NULL;
+	lo->listener.taux = lo;
+	lo->listener.newtrans = NULL;
+	lo->listener.destroy = p9lo_trans_listener_destroy;
+	list_add_tail(&lo->trans_list, &p9lo_trans_list);
+	mutex_unlock(&p9lo_lock);
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p\n", lo);
+	return lo;
+}
+
+static void p9lo_trans_destroy(struct p9_trans_loop *lo)
+{
+	if (lo->ctrans || lo->strans || !list_empty(&lo->trans_list))
+		return;
+	
+	kfree(lo);
+}
+
+static struct p9_trans *p9lo_clt_create(const char *devname, char *options)
+{
+	int err;
+	struct p9_trans *ctrans;
+	struct p9_trans_loop *lt;
+	struct p9_loop_opts opts;
+
+	parse_opts(options, &opts);
+	if (!opts.name)
+		return ERR_PTR(-ENOENT);
+
+	lt = p9lo_trans_find(opts.name);
+	if (IS_ERR(lt))
+		return (struct p9_trans *) lt;
+
+	ctrans = kmalloc(sizeof(*ctrans), GFP_KERNEL);
+	if (!ctrans)
+		return ERR_PTR(-ENOMEM);
+
+	ctrans->err = 0;
+	ctrans->priv = lt;
+	ctrans->request = p9lo_clt_request;
+	ctrans->cancel = p9lo_clt_cancel;
+	ctrans->destroy = p9lo_clt_destroy;
+
+	spin_lock(&lt->lock);
+	if (lt->ctrans || lt->strans) {
+		spin_unlock(&lt->lock);
+		kfree(ctrans);
+		return ERR_PTR(-EEXIST);
+	}
+
+	lt->ctrans = ctrans;
+	spin_unlock(&lt->lock);
+
+	err = p9lo_srv_create(lt);
+	if (err) {
+		spin_lock(&lt->lock);
+		lt->ctrans = NULL;
+		spin_unlock(&lt->lock);
+		kfree(ctrans);
+		return ERR_PTR(err);
+	}
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p ctrans %p\n", ctrans->priv,
+		ctrans);
+
+	return ctrans;
+}
+
+static void p9lo_clt_destroy(struct p9_trans *ctrans)
+{
+	struct p9_trans_loop *lt;
+
+	lt = ctrans->priv;
+	spin_lock(&lt->lock);
+	lt->ctrans = NULL;
+	if (lt->strans)
+		lt->strans->err = -EIO;
+	spin_unlock(&lt->lock);
+
+	if (lt->strans)
+		(*lt->strans->request)(lt->strans, NULL);
+
+	p9lo_trans_destroy(lt);
+}
+
+static void p9lo_clt_request(struct p9_trans *trans, struct p9_trans_req *creq)
+{
+	struct p9_trans_req *sreq;
+	struct p9_trans_loop *lt;
+
+	lt = trans->priv;
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p ctrans %p\n", lt, trans);
+	sreq = kmalloc(sizeof(*sreq), GFP_KERNEL);
+	sreq->tag = creq->tag;
+	sreq->err = 0;
+	sreq->tc = creq->tc;
+	sreq->rc = creq->rc;
+	sreq->cb = p9lo_srv_respond;
+	sreq->cba = NULL;
+	sreq->aux = creq;
+	INIT_LIST_HEAD(&sreq->req_list);
+
+	spin_lock(&lt->lock);
+	if (!lt->strans) {
+		lt->strans->err = -EIO;
+		spin_unlock(&lt->lock);
+		return;
+	}
+	spin_unlock(&lt->lock);
+
+	(*lt->strans->request)(lt->strans, sreq);
+}
+
+static int p9lo_clt_cancel(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	return 0;
+}
+
+static int p9lo_srv_create(struct p9_trans_loop *lt)
+{
+	struct p9_trans *strans;
+
+	strans = kmalloc(sizeof(*strans), GFP_KERNEL);
+	if (!strans)
+		return -ENOMEM;
+
+	strans->err = 0;
+	strans->priv = lt;
+	strans->request = NULL;
+	strans->cancel = p9lo_srv_cancel;
+	strans->destroy = p9lo_srv_destroy;
+
+	spin_lock(&lt->lock);
+	if (lt->strans) {
+		spin_unlock(&lt->lock);
+		kfree(strans);
+		return -EEXIST;
+	}
+
+	lt->strans = strans;
+	spin_unlock(&lt->lock);
+
+	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p strans %p\n", strans->priv,
+		strans);
+
+	(*lt->listener.newtrans)(&lt->listener, strans);
+	return 0;
+}
+
+static void p9lo_srv_destroy(struct p9_trans *strans)
+{
+	struct p9_trans_loop *trans;
+
+	trans = strans->priv;
+	spin_lock(&trans->lock);
+	trans->strans = NULL;
+	if (trans->ctrans)
+		trans->ctrans->err = -EIO;
+	spin_unlock(&trans->lock);
+}
+
+static int p9lo_srv_cancel(struct p9_trans *trans, struct p9_trans_req *req)
+{
+	return 0;
+}
+
+static void p9lo_srv_respond(struct p9_trans *trans, struct p9_trans_req *sreq)
+{
+	struct p9_trans_loop *t;
+	struct p9_trans_req *creq;
+
+	t = trans->priv;
+	creq = sreq->aux;
+
+	if (sreq->rc != creq->rc) {
+		kfree(creq->rc);
+		creq->rc = sreq->rc;
+	}
+
+	kfree(sreq);
+	P9_DPRINTK(P9_DEBUG_TRANS, "id %d size %d\n", creq->rc->id, creq->rc->size);
+	(*creq->cb)(t->ctrans, creq);
+}
+
+static struct p9_trans_listener *p9lo_listener_create(char *options)
+{
+	struct p9_trans_loop *lt;
+	struct p9_loop_opts opts;
+
+	parse_opts(options, &opts);
+	if (!opts.name)
+		return ERR_PTR(-ENOENT);
+
+	lt = p9lo_trans_create(opts.name);
+	if (IS_ERR(lt))
+		return (struct p9_trans_listener *) lt;
+
+	return &lt->listener;
+}
+
+static void p9lo_trans_listener_destroy(struct p9_trans_listener *lis)
+{
+	struct p9_trans_loop *lt;
+
+	lt = lis->taux;
+	mutex_lock(&p9lo_lock);
+	list_del(&lt->trans_list);
+	mutex_unlock(&p9lo_lock);
+	p9lo_trans_destroy(lt);
+}
+
+static int __init p9lo_init(void)
+{
+	v9fs_register_trans(&p9lo_trans_mod);
+
+	return 1;
+}
+
+static void __exit p9lo_exit(void) {
+	printk(KERN_ERR "Removal of 9p transports not implemented\n");
+	BUG();
+}
+
+module_init(p9lo_init);
+module_exit(p9lo_exit);
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_LICENSE("GPL");
