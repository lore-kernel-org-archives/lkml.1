Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0BWHPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:15:49 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34691 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0BWHPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f0G9tTA1jdm19L/e9E56NZ/k6+uW6XgOdf+kUhFnry5vYzj7mkYjKHlriy3vuNTMoT
         xDrtpHxWPWZ2/n+sdFe4KEZs342lUSTynOPaBhbsusQJEojb1jgjP/Xqr81RdxxIGcOy
         ADrP7D5lOoo99L8WxG3mpxKmUMHyb3VRrDfGc=
Date: Tue, 23 Feb 2010 23:15:28 +0800
From: wzt.wzt@gmail.com
To: sds@tycho.nsa.gov
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] Security: add static to security_ops and default_security_ops variable
Message-ID: <20100223151528.GA3393@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resent this patch using mutt, thanks for your helping:)

Enhance the security framework to support resetting the active security
module. This eliminates the need for direct use of the security_ops and
default_security_ops variables outside of security.c, so make security_ops
and default_security_ops static. Also remove the secondary_ops variable as
a cleanup since there is no use for that. secondary_ops was originally used by
SELinux to call the "secondary" security module (capability or dummy),
but that was replaced by direct calls to capability and the only
remaining use is to save and restore the original security ops pointer
value if SELinux is disabled by early userspace based on /etc/selinux/config.
Further, if we support this directly in the security framework, then we can
just use &default_security_ops for this purpose since that is now available.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 include/linux/security.h |    2 ++
 security/capability.c    |    4 ----
 security/security.c      |   11 +++++++++--
 security/selinux/hooks.c |   13 +------------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2c627d3..8cbc714 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -95,6 +95,8 @@ struct seq_file;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
+void reset_security_ops(void);
+
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
diff --git a/security/capability.c b/security/capability.c
index 5c700e1..4875142 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -906,10 +906,6 @@ static void cap_audit_rule_free(void *lsmrule)
 }
 #endif /* CONFIG_AUDIT */
 
-struct security_operations default_security_ops = {
-	.name	= "default",
-};
-
 #define set_to_cap_if_null(ops, function)				\
 	do {								\
 		if (!ops->function) {					\
diff --git a/security/security.c b/security/security.c
index 122b748..663b630 100644
--- a/security/security.c
+++ b/security/security.c
@@ -23,10 +23,12 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
 
 /* things that live in capability.c */
-extern struct security_operations default_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);
 
-struct security_operations *security_ops;	/* Initialized to NULL */
+static struct security_operations *security_ops;
+static struct security_operations default_security_ops = {
+	.name	= "default",
+};
 
 static inline int verify(struct security_operations *ops)
 {
@@ -63,6 +65,11 @@ int __init security_init(void)
 	return 0;
 }
 
+void reset_security_ops(void)
+{
+	security_ops = &default_security_ops;
+}
+
 /* Save user chosen LSM */
 static int __init choose_lsm(char *str)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a2ee84..1cbf18f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -125,13 +125,6 @@ __setup("selinux=", selinux_enabled_setup);
 int selinux_enabled = 1;
 #endif
 
-
-/*
- * Minimal support for a secondary security module,
- * just to allow the use of the capability module.
- */
-static struct security_operations *secondary_ops;
-
 /* Lists of inode and superblock security structures initialized
    before the policy was loaded. */
 static LIST_HEAD(superblock_security_head);
@@ -5672,9 +5665,6 @@ static __init int selinux_init(void)
 					    0, SLAB_PANIC, NULL);
 	avc_init();
 
-	secondary_ops = security_ops;
-	if (!secondary_ops)
-		panic("SELinux: No initial security operations\n");
 	if (register_security(&selinux_ops))
 		panic("SELinux: Unable to register with kernel.\n");
 
@@ -5835,8 +5825,7 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	/* Reset security_ops to the secondary module, dummy or capability. */
-	security_ops = secondary_ops;
+	reset_security_ops();
 
 	/* Try to destroy the avc node cache */
 	avc_disable();
-- 
1.6.5.3

