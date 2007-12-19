Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXLSWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXLSWAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXLSWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 17:00:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbXLSWAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 17:00:21 -0500
Subject: [PATCH] Allow Kconfig to set default mmap_min_addr protection
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, alan@redhat.com, chrisw@redhat.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       solar@openwall.com, wtarreau@hera.kernel.org
Content-Type: text/plain
Date: Wed, 19 Dec 2007 16:59:05 -0500
Message-Id: <1198101545.6197.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it was decided that low memory protection from userspace couldn't
be turned on by default add a Kconfig option to allow users/distros to
set a default at compile time.  This value is still tunable after boot
in /proc/sys/vm/mmap_min_addr

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 security/Kconfig    |   18 ++++++++++++++++++
 security/security.c |    4 +++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 8086e61..10c9e40 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -103,6 +103,24 @@ config SECURITY_ROOTPLUG
 	  
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_DEFAULT_MMAP_MIN_ADDR
+        int "Low address space to protect from user allocation"
+        depends on SECURITY
+        default 0
+        help
+	  This is the portion of low virtual memory which should be protected
+	  from userspace allocation.  Keeping a user from writing to low pages
+	  can help reduce the impact of kernel NULL pointer bugs.
+
+	  For most users with lots of address space a value of 65536 is
+	  reasonable and should cause no problems.  Programs which use vm86
+	  functionality would either need additional permissions from either
+	  the LSM or the capabilities module or have this protection disabled.
+
+	  This value can be changed after boot using the
+	  /proc/sys/vm/mmap_min_addr tunable.
+
+
 source security/selinux/Kconfig
 
 endmenu
diff --git a/security/security.c b/security/security.c
index 0e1f1f1..c784726 100644
--- a/security/security.c
+++ b/security/security.c
@@ -23,7 +23,9 @@ extern struct security_operations dummy_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);
 
 struct security_operations *security_ops;	/* Initialized to NULL */
-unsigned long mmap_min_addr;		/* 0 means no protection */
+
+/* amount of vm to protect from userspace access */
+unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;
 
 static inline int verify(struct security_operations *ops)
 {


