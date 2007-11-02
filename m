Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbXKBRQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbXKBRQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbXKBRQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:16:07 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:56108 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbXKBRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:16:01 -0400
Date: Fri, 2 Nov 2007 10:53:31 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 9p: basic sysfs support
Message-ID: <20071102165331.GA16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the basic sysfs support for 9p. If CONFIG_NET_9P_DEBUG
is defined, allows reading and modifying the debug level via
/sysfs/fs/9p/debuglevel.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 include/net/9p/9p.h |    1 +
 net/9p/mod.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 686425a..9ace484 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -377,6 +377,7 @@ struct p9_fcall {
 };
 
 struct p9_idpool;
+extern struct kset p9_subsys;
 
 int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
 	int dotu);
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 41d70f4..8205c4b 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -29,6 +29,7 @@
 #include <net/9p/9p.h>
 #include <linux/fs.h>
 #include <linux/parser.h>
+#include <linux/fs.h>
 #include <net/9p/transport.h>
 #include <linux/list.h>
 
@@ -37,8 +38,17 @@ unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
 EXPORT_SYMBOL(p9_debug_level);
 module_param_named(debug, p9_debug_level, uint, 0);
 MODULE_PARM_DESC(debug, "9P debugging level");
+
+static ssize_t p9_debug_show(struct kset *, char *);
+static ssize_t p9_debug_store(struct kset *, const char *, size_t);
+
+static struct subsys_attribute p9_debug_attr = __ATTR(debuglevel, 0644,
+	p9_debug_show, p9_debug_store);
 #endif
 
+decl_subsys_name(p9, 9p, NULL, NULL);
+EXPORT_SYMBOL(p9_subsys);
+
 extern int p9_mux_global_init(void);
 extern void p9_mux_global_exit(void);
 
@@ -99,6 +109,27 @@ struct p9_trans_module *v9fs_default_trans(void)
 }
 EXPORT_SYMBOL(v9fs_default_trans);
 
+#ifdef CONFIG_NET_9P_DEBUG
+
+static ssize_t p9_debug_show(struct kset *k, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", p9_debug_level);
+}
+
+static ssize_t p9_debug_store(struct kset *k, const char *buf, size_t buflen)
+{
+	int n;
+	char *p;
+
+	n = simple_strtol(buf, &p, 0);
+	if (*p != '\n' && *p != '\0')
+		return EINVAL;
+
+	p9_debug_level = n;
+	return buflen;
+}
+
+#endif
 
 /**
  * v9fs_init - Initialize module
@@ -109,6 +140,19 @@ static int __init init_p9(void)
 	int ret;
 
 	p9_error_init();
+	kobj_set_kset_s(&p9_subsys, fs_subsys);
+	ret = subsystem_register(&p9_subsys);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_NET_9P_DEBUG
+	ret = subsys_create_file(&p9_subsys, &p9_debug_attr);
+	if (ret) {
+		subsystem_unregister(&p9_subsys);
+		return ret;
+	}
+#endif
+
 	printk(KERN_INFO "Installing 9P2000 support\n");
 	ret = p9_mux_global_init();
 	if (ret) {
@@ -127,6 +171,7 @@ static int __init init_p9(void)
 static void __exit exit_p9(void)
 {
 	p9_mux_global_exit();
+	subsystem_unregister(&p9_subsys);
 }
 
 module_init(init_p9)
