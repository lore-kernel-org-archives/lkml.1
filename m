Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXI3XFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXI3XFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXI3XFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:05:15 -0400
Received: from 70-56-134-241.albq.qwest.net ([70.56.134.241]:57193 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbXI3XFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:05:12 -0400
Date: Sun, 30 Sep 2007 16:41:28 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ericvh@gmail.com
Subject: [RFC][PATCH 4/6] 9p: 9P server fid management
Message-ID: <20070930224128.GD25590@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support for in-kernel 9P2000 servers.

This patch adds the 9P server fid management.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 net/9p/srv/fid.c |  178 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 net/9p/srv/fid.c

diff --git a/net/9p/srv/fid.c b/net/9p/srv/fid.c
new file mode 100644
index 0000000..7c86204
--- /dev/null
+++ b/net/9p/srv/fid.c
@@ -0,0 +1,178 @@
+/*
+ * net/9p/srv/fid.c
+ *
+ * Fid Management
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
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/list.h>
+#include <linux/hash.h>
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+#include "srvimpl.h"
+
+struct p9srv_fidpool *p9srv_fidpool_create(void)
+{
+	int i;
+	struct p9srv_fidpool *fp;
+
+	fp = kmalloc(sizeof(struct p9srv_fidpool), GFP_KERNEL);
+	if (!fp)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&fp->lock);
+	for (i = 0; i < FID_HTABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&fp->hash[i]);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	return fp;
+}
+
+void p9srv_fidpool_destroy(struct p9srv_fidpool *fp)
+{
+	int i;
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	for (i = 0; i < FID_HTABLE_SIZE; i++)
+		BUG_ON(!hlist_empty(&fp->hash[i]));
+
+	kfree(fp);
+}
+
+void p9srv_fidpool_reset(struct p9srv_fidpool *fp)
+{
+	int i;
+	struct p9srv_fid *cfid;
+	struct hlist_node *hn, *htmp;
+	HLIST_HEAD(hh);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p\n", fp);
+	spin_lock(&fp->lock);
+	for (i = 0; i < FID_HTABLE_SIZE; i++) {
+		hlist_for_each_entry_safe(cfid, hn, htmp, &fp->hash[i],
+								fid_list) {
+			hlist_del(hn);
+			hlist_add_head(hn, &hh);
+		}
+	}
+	spin_unlock(&fp->lock);
+
+	hlist_for_each_entry_safe(cfid, hn, htmp, &hh, fid_list) {
+		atomic_set(&cfid->refcount, 1);
+		p9srv_fid_decref(cfid);
+	}
+}
+
+struct p9srv_fid *p9srv_fid_create(struct p9srv_fidpool *fp, u32 fid)
+{
+	unsigned long hash;
+	struct p9srv_fid *cfid, *nfid;
+	struct hlist_node *hn;
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d\n", fp, fid);
+	hash = hash_long(fid, FID_HTABLE_BITS);
+	nfid = kmalloc(sizeof(struct p9srv_fid), GFP_KERNEL);
+	if (!nfid)
+		return ERR_PTR(-ENOMEM);
+
+	nfid->fid = fid;
+	atomic_set(&nfid->refcount, 0);
+	nfid->conn = NULL;
+	nfid->aux = NULL;
+	nfid->omode = ~0;
+	nfid->type = 0;
+	nfid->diroffset = 0;
+	nfid->uid = ~0;
+	nfid->fidpool = fp;
+	INIT_HLIST_NODE(&nfid->fid_list);
+	spin_lock(&fp->lock);
+	hlist_for_each_entry(cfid, hn, &fp->hash[hash], fid_list) {
+		if (cfid->fid == fid) {
+			spin_unlock(&fp->lock);
+			kfree(nfid);
+			return ERR_PTR(-EEXIST);
+		}
+	}
+
+	hlist_add_head(&nfid->fid_list, &fp->hash[hash]);
+	spin_unlock(&fp->lock);
+	p9srv_fid_incref(nfid);
+	return nfid;
+}
+
+struct p9srv_fid *p9srv_fid_find(struct p9srv_fidpool *fp, u32 fid)
+{
+	unsigned long hash;
+	struct p9srv_fid *cfid;
+	struct hlist_node *hn;
+
+	hash = hash_long(fid, FID_HTABLE_BITS);
+	spin_lock(&fp->lock);
+	hlist_for_each_entry(cfid, hn, &fp->hash[hash], fid_list) {
+		if (cfid->fid == fid) {
+			spin_unlock(&fp->lock);
+			p9srv_fid_incref(cfid);
+			return cfid;
+		}
+	}
+	spin_unlock(&fp->lock);
+
+	return NULL;
+}
+EXPORT_SYMBOL(p9srv_fid_find);
+
+void p9srv_fid_incref(struct p9srv_fid *fid)
+{
+	if (fid)
+		atomic_inc(&fid->refcount);
+
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d count %d\n",
+		fid->fidpool, fid->fid, atomic_read(&fid->refcount));
+}
+EXPORT_SYMBOL(p9srv_fid_incref);
+
+void p9srv_fid_decref(struct p9srv_fid *fid)
+{
+	int n;
+
+	if (!fid)
+		return;
+
+	n = atomic_dec_and_test(&fid->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_FID, "fidpool %p fid %d count %d \n",
+		fid->fidpool, fid->fid, atomic_read(&fid->refcount));
+	if (n) {
+		P9_DPRINTK(P9SRV_DEBUG_FID, "destroy fidpool %p fid %d\n",
+			fid->fidpool, fid->fid);
+		spin_lock(&fid->fidpool->lock);
+		hlist_del(&fid->fid_list);
+		spin_unlock(&fid->fidpool->lock);
+		if (fid->conn && fid->conn->srv && fid->conn->srv->fiddestroy)
+			(*fid->conn->srv->fiddestroy)(fid);
+		kfree(fid);
+	}
+}
+EXPORT_SYMBOL(p9srv_fid_decref);
-- 
1.5.2.4

