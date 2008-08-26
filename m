Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYHZIxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYHZIxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYHZIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:52:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYHZIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:52:20 -0400
From: Tejun Heo <tj@kernel.org>
To: ericvh@gmail.com, rminnich@sandia.gov,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] 9p: implement proper trans module refcounting and unregistration
Date: Tue, 26 Aug 2008 17:50:51 +0900
Message-Id: <1219740656-26458-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219740656-26458-1-git-send-email-tj@kernel.org>
References: <1219740656-26458-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 Aug 2008 08:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9p trans modules aren't refcounted nor were they unregistered
properly.  Fix it.

* Add 9p_trans_module->owner and reference the module on each trans
  instance creation and put it on destruction.

* Protect v9fs_trans_list with a spinlock.  This isn't strictly
  necessary as the list is manipulated only during module loading /
  unloading but it's a good idea to make the API safe.

* Unregister trans modules when the corresponding module is being
  unloaded.

* While at it, kill unnecessary EXPORT_SYMBOL on p9_trans_fd_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/net/9p/9p.h        |    1 +
 include/net/9p/transport.h |    9 +++-
 net/9p/client.c            |   10 ++++-
 net/9p/mod.c               |   92 ++++++++++++++++++++++++++++++++------------
 net/9p/trans_fd.c          |   11 +++++-
 net/9p/trans_virtio.c      |    2 +
 6 files changed, 95 insertions(+), 30 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index b3d3e27..c3626c0 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -596,4 +596,5 @@ int p9_idpool_check(int id, struct p9_idpool *p);
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
 int p9_trans_fd_init(void);
+void p9_trans_fd_exit(void);
 #endif /* NET_9P_H */
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 0db3a40..3ca7371 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -26,6 +26,8 @@
 #ifndef NET_9P_TRANSPORT_H
 #define NET_9P_TRANSPORT_H
 
+#include <linux/module.h>
+
 /**
  * enum p9_trans_status - different states of underlying transports
  * @Connected: transport is connected and healthy
@@ -91,9 +93,12 @@ struct p9_trans_module {
 	int maxsize;		/* max message size of transport */
 	int def;		/* this transport should be default */
 	struct p9_trans * (*create)(const char *, char *, int, unsigned char);
+	struct module *owner;
 };
 
 void v9fs_register_trans(struct p9_trans_module *m);
-struct p9_trans_module *v9fs_match_trans(const substring_t *name);
-struct p9_trans_module *v9fs_default_trans(void);
+void v9fs_unregister_trans(struct p9_trans_module *m);
+struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name);
+struct p9_trans_module *v9fs_get_default_trans(void);
+void v9fs_put_trans(struct p9_trans_module *m);
 #endif /* NET_9P_TRANSPORT_H */
diff --git a/net/9p/client.c b/net/9p/client.c
index 2ffe40c..10e3203 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -75,7 +75,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	int option;
 	int ret = 0;
 
-	clnt->trans_mod = v9fs_default_trans();
 	clnt->dotu = 1;
 	clnt->msize = 8192;
 
@@ -108,7 +107,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 			clnt->msize = option;
 			break;
 		case Opt_trans:
-			clnt->trans_mod = v9fs_match_trans(&args[0]);
+			clnt->trans_mod = v9fs_get_trans_by_name(&args[0]);
 			break;
 		case Opt_legacy:
 			clnt->dotu = 0;
@@ -117,6 +116,10 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 			continue;
 		}
 	}
+
+	if (!clnt->trans_mod)
+		clnt->trans_mod = v9fs_get_default_trans();
+
 	kfree(options);
 	return ret;
 }
@@ -150,6 +153,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
+	clnt->trans_mod = NULL;
 	clnt->trans = NULL;
 	spin_lock_init(&clnt->lock);
 	INIT_LIST_HEAD(&clnt->fidlist);
@@ -235,6 +239,8 @@ void p9_client_destroy(struct p9_client *clnt)
 		clnt->trans = NULL;
 	}
 
+	v9fs_put_trans(clnt->trans_mod);
+
 	list_for_each_entry_safe(fid, fidptr, &clnt->fidlist, flist)
 		p9_fid_destroy(fid);
 
diff --git a/net/9p/mod.c b/net/9p/mod.c
index bdee1fb..1084feb 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -31,6 +31,7 @@
 #include <linux/parser.h>
 #include <net/9p/transport.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_NET_9P_DEBUG
 unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
@@ -44,8 +45,8 @@ MODULE_PARM_DESC(debug, "9P debugging level");
  *
  */
 
+static DEFINE_SPINLOCK(v9fs_trans_lock);
 static LIST_HEAD(v9fs_trans_list);
-static struct p9_trans_module *v9fs_default_transport;
 
 /**
  * v9fs_register_trans - register a new transport with 9p
@@ -54,48 +55,87 @@ static struct p9_trans_module *v9fs_default_transport;
  */
 void v9fs_register_trans(struct p9_trans_module *m)
 {
+	spin_lock(&v9fs_trans_lock);
 	list_add_tail(&m->list, &v9fs_trans_list);
-	if (m->def)
-		v9fs_default_transport = m;
+	spin_unlock(&v9fs_trans_lock);
 }
 EXPORT_SYMBOL(v9fs_register_trans);
 
 /**
- * v9fs_match_trans - match transport versus registered transports
+ * v9fs_unregister_trans - unregister a 9p transport
+ * @m: the transport to remove
+ *
+ */
+void v9fs_unregister_trans(struct p9_trans_module *m)
+{
+	spin_lock(&v9fs_trans_lock);
+	list_del_init(&m->list);
+	spin_unlock(&v9fs_trans_lock);
+}
+EXPORT_SYMBOL(v9fs_unregister_trans);
+
+/**
+ * v9fs_get_trans_by_name - get transport with the matching name
  * @name: string identifying transport
  *
  */
-struct p9_trans_module *v9fs_match_trans(const substring_t *name)
+struct p9_trans_module *v9fs_get_trans_by_name(const substring_t *name)
 {
-	struct list_head *p;
-	struct p9_trans_module *t = NULL;
-
-	list_for_each(p, &v9fs_trans_list) {
-		t = list_entry(p, struct p9_trans_module, list);
-		if (strncmp(t->name, name->from, name->to-name->from) == 0)
-			return t;
-	}
-	return NULL;
+	struct p9_trans_module *t, *found = NULL;
+
+	spin_lock(&v9fs_trans_lock);
+
+	list_for_each_entry(t, &v9fs_trans_list, list)
+		if (strncmp(t->name, name->from, name->to-name->from) == 0 &&
+		    try_module_get(t->owner)) {
+			found = t;
+			break;
+		}
+
+	spin_unlock(&v9fs_trans_lock);
+	return found;
 }
-EXPORT_SYMBOL(v9fs_match_trans);
+EXPORT_SYMBOL(v9fs_get_trans_by_name);
 
 /**
- * v9fs_default_trans - returns pointer to default transport
+ * v9fs_get_default_trans - get the default transport
  *
  */
 
-struct p9_trans_module *v9fs_default_trans(void)
+struct p9_trans_module *v9fs_get_default_trans(void)
 {
-	if (v9fs_default_transport)
-		return v9fs_default_transport;
-	else if (!list_empty(&v9fs_trans_list))
-		return list_first_entry(&v9fs_trans_list,
-					struct p9_trans_module, list);
-	else
-		return NULL;
+	struct p9_trans_module *t, *found = NULL;
+
+	spin_lock(&v9fs_trans_lock);
+
+	list_for_each_entry(t, &v9fs_trans_list, list)
+		if (t->def && try_module_get(t->owner)) {
+			found = t;
+			break;
+		}
+
+	if (!found)
+		list_for_each_entry(t, &v9fs_trans_list, list)
+			if (try_module_get(t->owner)) {
+				found = t;
+				break;
+			}
+
+	spin_unlock(&v9fs_trans_lock);
+	return found;
 }
-EXPORT_SYMBOL(v9fs_default_trans);
+EXPORT_SYMBOL(v9fs_get_default_trans);
 
+/**
+ * v9fs_put_trans - put trans
+ * @m: transport to put
+ *
+ */
+void v9fs_put_trans(struct p9_trans_module *m)
+{
+	if (m)
+		module_put(m->owner);
+}
 
 /**
  * v9fs_init - Initialize module
@@ -120,6 +160,8 @@ static int __init init_p9(void)
 static void __exit exit_p9(void)
 {
 	printk(KERN_INFO "Unloading 9P2000 support\n");
+
+	p9_trans_fd_exit();
 }
 
 module_init(init_p9)
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index cdf137a..6a32ffd 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1629,6 +1629,7 @@ static struct p9_trans_module p9_tcp_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 1,
 	.create = p9_trans_create_tcp,
+	.owner = THIS_MODULE,
 };
 
 static struct p9_trans_module p9_unix_trans = {
@@ -1636,6 +1637,7 @@ static struct p9_trans_module p9_unix_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
 	.create = p9_trans_create_unix,
+	.owner = THIS_MODULE,
 };
 
 static struct p9_trans_module p9_fd_trans = {
@@ -1643,6 +1645,7 @@ static struct p9_trans_module p9_fd_trans = {
 	.maxsize = MAX_SOCK_BUF,
 	.def = 0,
 	.create = p9_trans_create_fd,
+	.owner = THIS_MODULE,
 };
 
 int p9_trans_fd_init(void)
@@ -1659,4 +1662,10 @@ int p9_trans_fd_init(void)
 
 	return 0;
 }
-EXPORT_SYMBOL(p9_trans_fd_init);
+
+void p9_trans_fd_exit(void)
+{
+	v9fs_unregister_trans(&p9_tcp_trans);
+	v9fs_unregister_trans(&p9_unix_trans);
+	v9fs_unregister_trans(&p9_fd_trans);
+}
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 42adc05..94912e0 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -528,6 +528,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	.create = p9_virtio_create,
 	.maxsize = PAGE_SIZE*16,
 	.def = 0,
+	.owner = THIS_MODULE,
 };
 
 /* The standard init function */
@@ -545,6 +546,7 @@ static int __init p9_virtio_init(void)
 static void __exit p9_virtio_cleanup(void)
 {
 	unregister_virtio_driver(&p9_virtio_drv);
+	v9fs_unregister_trans(&p9_virtio_trans);
 }
 
 module_init(p9_virtio_init);
-- 
1.5.4.5

