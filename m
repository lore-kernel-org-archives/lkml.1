Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbXJUBxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbXJUBxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXJUBw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56844 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXJUBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:27 -0400
Date: Sun, 21 Oct 2007 01:52:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] MultiAdmin 1.0.7
In-Reply-To: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710210151530.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 1/4] security_cap_extra() and more

    -   Renames capable() to capable_light().
        This function is used if only a capability is to be checked.

    -   Implement a new capable that calls security_cap_extra().
        Since a subadmin has almost the same capabilities as a
        superadmin, an extra helper is needed to decide whether an
        action is allowed, based on the philosophy of the LSM.

    -   implement the .cap_extra LSM hook


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, May 01 2006
July 11 2006

---
 include/linux/capability.h |    2 ++
 include/linux/security.h   |   13 +++++++++++++
 kernel/capability.c        |   19 ++++++++++++++++++-
 security/dummy.c           |    6 ++++++
 4 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6.23.1/include/linux/capability.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/capability.h
+++ linux-2.6.23.1/include/linux/capability.h
@@ -358,6 +358,8 @@ static inline kernel_cap_t cap_invert(ke
 
 #define cap_is_fs_cap(c)     (CAP_TO_MASK(c) & CAP_FS_MASK)
 
+bool capable_light(unsigned int);
+bool __capable_light(struct task_struct *, unsigned int);
 int capable(int cap);
 int __capable(struct task_struct *t, int cap);
 
Index: linux-2.6.23.1/include/linux/security.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/security.h
+++ linux-2.6.23.1/include/linux/security.h
@@ -1399,6 +1399,7 @@ struct security_operations {
 
 #endif	/* CONFIG_KEYS */
 
+	int (*cap_extra)(struct task_struct *, unsigned int);
 };
 
 /* global variables */
@@ -2132,6 +2133,12 @@ static inline void security_release_secc
 	return security_ops->release_secctx(secdata, seclen);
 }
 
+static inline int security_cap_extra(struct task_struct *task,
+    unsigned int cap)
+{
+	return security_ops->cap_extra(task, cap);
+}
+
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
@@ -2786,6 +2793,12 @@ static inline int security_netlink_recv 
 	return cap_netlink_recv (skb, cap);
 }
 
+static inline int security_cap_extra(struct task_struct *task,
+    unsigned int cap)
+{
+	return 0;
+}
+
 static inline struct dentry *securityfs_create_dir(const char *name,
 					struct dentry *parent)
 {
Index: linux-2.6.23.1/kernel/capability.c
===================================================================
--- linux-2.6.23.1.orig/kernel/capability.c
+++ linux-2.6.23.1/kernel/capability.c
@@ -238,7 +238,7 @@ out:
 
 int __capable(struct task_struct *t, int cap)
 {
-	if (security_capable(t, cap) == 0) {
+	if (security_capable(t, cap) == 0 && security_cap_extra(t, cap) == 0) {
 		t->flags |= PF_SUPERPRIV;
 		return 1;
 	}
@@ -251,3 +251,20 @@ int capable(int cap)
 	return __capable(current, cap);
 }
 EXPORT_SYMBOL(capable);
+
+bool __capable_light(struct task_struct *t, unsigned int cap)
+{
+	if (security_capable(t, cap) == 0) {
+		t->flags |= PF_SUPERPRIV;
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(__capable_light);
+
+bool capable_light(unsigned int cap)
+{
+	return __capable_light(current, cap);
+}
+EXPORT_SYMBOL(capable_light);
+
Index: linux-2.6.23.1/security/dummy.c
===================================================================
--- linux-2.6.23.1.orig/security/dummy.c
+++ linux-2.6.23.1/security/dummy.c
@@ -693,6 +693,11 @@ static int dummy_netlink_recv (struct sk
 	return 0;
 }
 
+static int dummy_cap_extra(struct task_struct *task, unsigned int cap)
+{
+	return 0;
+}
+
 #ifdef CONFIG_SECURITY_NETWORK
 static int dummy_unix_stream_connect (struct socket *sock,
 				      struct socket *other,
@@ -1132,5 +1137,6 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, key_permission);
 #endif	/* CONFIG_KEYS */
 
+	set_to_dummy_if_null(ops, cap_extra);
 }
 
