Return-Path: <linux-kernel-owner+w=401wt.eu-S1765812AbYEVVRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765812AbYEVVRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYEVVRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:17:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbYEVVRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:17:10 -0400
Date: Thu, 22 May 2008 17:15:51 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] debug printk infrastructure -implement level controls
Message-ID: <20080522211551.GC28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/device.h         |   16 ++++++++
 include/linux/dynamic_printk.h |    9 +++++
 lib/dynamic_printk.c           |   78 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 8f3ca1f..b1aae4d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -616,6 +616,22 @@ extern const char *dev_driver_string(struct device *dev);
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
 #endif
 
+#ifdef CONFIG_PRINTK_DEBUG
+#define register_dev_dbg_handler(parent, type, max, init) \
+	__register_dev_dbg_handler(KBUILD_MODNAME, parent, type, max, init)
+#define dev_dbg_level(value, dev, format, ...) \
+	__dev_dbg_level(KBUILD_MODNAME, value, dev, format, ##__VA_ARGS__)
+#define dev_dbg_enabled(value) \
+	__dev_dbg_enabled(KBUILD_MODNAME, value)
+#else
+#define register_dev_dbg_handler(parent, type, max, init) \
+	({ if (0) __register_dev_dbg_handler(KBUILD_MODNAME, parent, type, max, init); 0; })
+#define dev_dbg_level(value, dev, format, ...) \
+	({ if (0) __dev_dbg_level(KBUILD_MODNAME, value, dev, format, ##__VA_ARGS__); 0; })
+#define dev_dbg_enabled(value) \
+	({ if (0) __dev_dbg_enabled(KBUILD_MODNAME, value); 0; })
+#endif
+
 #ifdef VERBOSE_DEBUG
 #define dev_vdbg	dev_dbg
 #else
diff --git a/include/linux/dynamic_printk.h b/include/linux/dynamic_printk.h
index b1afef3..bb366b4 100644
--- a/include/linux/dynamic_printk.h
+++ b/include/linux/dynamic_printk.h
@@ -7,6 +7,10 @@
 
 #define DYNAMIC_HASH_BITS 5
 #define FILE_TABLE_SIZE (1 << DYNAMIC_HASH_BITS)
+#define TYPE_LEVEL 1
+#define TYPE_FLAG 2
+
+struct device;
 
 struct mod_debug {
 	char *modname;
@@ -40,5 +44,10 @@ static inline unsigned int dynamic_name_hash(char *name)
         return (hash & ((1 << DYNAMIC_HASH_BITS) - 1));
 }
 
+int __register_dev_dbg_handler(char *mod_name, char *parent_name, int type, int max,
+				int init);
+void __dev_dbg_level(char *mod_name, int level, struct device *dev, char *fmt, ...);
+int __dev_dbg_enabled(char *modname, int value);
+
 #endif
 #endif
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index 3eaf874..935155c 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -33,9 +33,10 @@ struct debug_name {
 	char *name;
 	unsigned int num_uses;
 	int enable;
-	int flags;
+	int type;
 	int level;
 	int ratelimit;
+	struct debug_name *parent;
 };
 
 static struct debug_name *find_debug_file(char *module_name)
@@ -117,6 +118,67 @@ int remove_module(char *mod_name)
 }
 EXPORT_SYMBOL_GPL(remove_module);
 
+int __register_dev_dbg_handler(char *mod_name, char *parent_name, int type, 
+				int max, int init)
+{
+	struct debug_name *elem, *parent;
+
+	elem = find_debug_file(mod_name);
+	if (!elem) {
+		add_module(mod_name);
+		elem = find_debug_file(mod_name);
+	}
+	if (parent_name) {
+		parent = find_debug_file(parent_name);
+		if (!parent) {
+			add_module(parent_name);
+			parent = find_debug_file(parent_name);
+		}
+		elem->parent = parent;
+		return 0;
+	}
+
+	elem->type = type;
+	elem->level = init;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__register_dev_dbg_handler);
+
+int __dev_dbg_enabled(char *mod_name, int value)
+{
+	struct debug_name *elem;
+	int ret = 0;
+
+	if (elem = find_debug_file(mod_name)) {
+		if (elem->parent)
+			elem = elem->parent;
+		if (elem->enable) {
+			if (elem->type == TYPE_LEVEL) {
+				if (value < elem->level)
+					ret = 1;
+			} else if (elem->type == TYPE_FLAG) {
+				if (value & elem->level)
+					ret = 1;
+			}
+		}
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__dev_dbg_enabled);
+
+void __dev_dbg_level(char *mod_name, int level, struct device *dev, char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	if (__dev_dbg_enabled(mod_name, level)) {
+		vprintk(fmt, args);
+	}
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(__dev_dbg_level);
+
+
 #ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
 
 void dynamic_printk(char *module_name, char *fmt, ...)
@@ -172,7 +234,7 @@ static int disabled_hash(int i)
 static ssize_t pr_debug_write(struct file *file, const char __user *buf,
 				size_t length, loff_t *ppos)
 {
-	char *buffer, *s;
+	char *buffer, *s, *level;
 	int err, hash, i;
 	struct debug_name *elem;
 
@@ -230,6 +292,14 @@ static ssize_t pr_debug_write(struct file *file, const char __user *buf,
 			}
 			err = 0;
 		}
+	} else if (!strncmp("set level=", buffer, 10)) {
+		s = buffer + 10;
+		level = strsep(&s, " ");
+		s = strstrip(s);
+		if (elem = find_debug_file(s)) {
+			elem->level = simple_strtol(level, NULL, 10);
+			err = 0;
+		}
 	}
 	if (!err)
 		err = length;
@@ -268,8 +338,8 @@ static int pr_debug_seq_show(struct seq_file *s, void *v)
 	rcu_read_lock();
 	head = &module_table[i];
 	hlist_for_each_entry_rcu(element, node, head, hlist)
-		seq_printf(s, "%s %d %d\n", element->name, element->enable,
-				 element->num_uses);
+		seq_printf(s, "%s %d %d %d\n", element->name, element->enable,
+				 element->level, element->num_uses);
 	rcu_read_unlock();
 	return 0;
 }
-- 
1.5.4.5

