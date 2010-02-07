Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0BGLYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:24:47 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:34656 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0BGLYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=qhNgPyaA6X/MiuGkGAUlylmKsZj9ze+4IauNXJdhOh1bGTJ631Zrjrxe5Vo4a+YeCT
         gLHFezMjGdJ4D7Z15bJs1quJ9bbrpTFGUAMu7qJlVf1P4azMZPYN+QQ3fH43AuPD5JTB
         di4y+M091HHvTAA7B0c9YCmnwhfSnXoUpdwgM=
MIME-Version: 1.0
Date: Sun, 7 Feb 2010 19:24:44 +0800
Message-ID: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
Subject: [PATCH] LSM: add static to security_ops variable
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security_ops was declared as a global variable, so other drivers or
kernel code can easily change its value, like:

extern struct security_operations *security_ops;
security_ops = NULL;

then insmod this driver immediately, it will get an oops.  Other evil
drivers can aslo fake this variable as extern.

Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>
---
 security/security.c      |   25 ++++++++++++++++++++++++-
 security/selinux/hooks.c |   18 ++++++------------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/security/security.c b/security/security.c
index 24e060b..781117d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -26,7 +26,12 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 extern struct security_operations default_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);

-struct security_operations *security_ops;      /* Initialized to NULL */
+static struct security_operations *security_ops;       /* Initialized
to NULL */
+/*
+ * Minimal support for a secondary security module,
+ * just to allow the use of the capability module.
+ */
+static struct security_operations *secondary_ops;

 static inline int verify(struct security_operations *ops)
 {
@@ -63,6 +68,24 @@ int __init security_init(void)
        return 0;
 }

+void reset_secondary_ops(void)
+{
+       secondary_ops = security_ops;
+       if (!secondary_ops)
+               panic("SELinux: No initial security operations\n");
+}
+
+void reset_security_ops(void)
+{
+       /* Reset security_ops to the secondary module, dummy or capability. */
+       security_ops = secondary_ops;
+}

 /* Save user chosen LSM */
 static int __init choose_lsm(char *str)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a2ee84..9e8607e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -92,7 +92,9 @@
 #define NUM_SEL_MNT_OPTS 5

 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
-extern struct security_operations *security_ops;
+extern void reset_secondary_ops(void);
+extern void reset_security_ops(void);

 /* SECMARK reference count */
 atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
@@ -126,12 +128,6 @@ int selinux_enabled = 1;
 #endif


-/*
- * Minimal support for a secondary security module,
- * just to allow the use of the capability module.
- */
-static struct security_operations *secondary_ops;
-
 /* Lists of inode and superblock security structures initialized
    before the policy was loaded. */
 static LIST_HEAD(superblock_security_head);
@@ -5672,9 +5668,8 @@ static __init int selinux_init(void)
                                            0, SLAB_PANIC, NULL);
        avc_init();

-       secondary_ops = security_ops;
-       if (!secondary_ops)
-               panic("SELinux: No initial security operations\n");
+       reset_secondary_ops();
+
        if (register_security(&selinux_ops))
                panic("SELinux: Unable to register with kernel.\n");

@@ -5835,8 +5830,7 @@ int selinux_disable(void)
        selinux_disabled = 1;
        selinux_enabled = 0;

-       /* Reset security_ops to the secondary module, dummy or capability. */
-       security_ops = secondary_ops;
+       reset_security_ops();

        /* Try to destroy the avc node cache */
        avc_disable();
-- 
1.6.6.1
