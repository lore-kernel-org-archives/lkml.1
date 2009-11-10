Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZKJQOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZKJQOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZKJQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:55 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60323 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbZKJQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:49 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 12/12] AppArmor: Enable configuring and building of the AppArmor security module
Date: Tue, 10 Nov 2009 08:13:05 -0800
Message-Id: <1257869585-7092-13-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Makefiles to enable configuration and building of AppArmor.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/Kconfig             |    1 +
 security/Makefile            |    2 +
 security/apparmor/.gitignore |    5 +++
 security/apparmor/Kconfig    |   62 ++++++++++++++++++++++++++++++++++++++++++
 security/apparmor/Makefile   |   25 +++++++++++++++++
 5 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/.gitignore
 create mode 100644 security/apparmor/Kconfig
 create mode 100644 security/apparmor/Makefile

diff --git a/security/Kconfig b/security/Kconfig
index fb363cd..2f5fb0f 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -162,6 +162,7 @@ config LSM_MMAP_MIN_ADDR
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
+source security/apparmor/Kconfig
 
 source security/integrity/ima/Kconfig
 
diff --git a/security/Makefile b/security/Makefile
index 95ecc06..8bcd805 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
+subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 
 # always enable default capabilities
 obj-y		+= commoncap.o min_addr.o
@@ -18,6 +19,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
+obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
new file mode 100644
index 0000000..0a0a99f
--- /dev/null
+++ b/security/apparmor/.gitignore
@@ -0,0 +1,5 @@
+#
+# Generated include files
+#
+af_names.h
+capability_names.h
diff --git a/security/apparmor/Kconfig b/security/apparmor/Kconfig
new file mode 100644
index 0000000..01c8754
--- /dev/null
+++ b/security/apparmor/Kconfig
@@ -0,0 +1,62 @@
+config SECURITY_APPARMOR
+	bool "AppArmor support"
+	depends on SECURITY && SECURITY_NETWORK && NET && INET
+	select AUDIT
+	select SECURITY_PATH
+	select SECURITYFS
+	default n
+	help
+	  This enables the AppArmor security module.
+	  Required userspace tools (if they are not included in your
+	  distribution) and further information may be found at
+	  <http://forge.novell.com/modules/xfmod/project/?apparmor>
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_APPARMOR_NETWORK
+       bool "AppArmor network support"
+       depends on SECURITY_APPARMOR
+       default n
+       help
+	 This enables AppArmor to mediate applications network use.
+	 This will enable the SECURITY_NETWORK hooks.
+
+config SECURITY_APPARMOR_BOOTPARAM_VALUE
+	int "AppArmor boot parameter default value"
+	depends on SECURITY_APPARMOR
+	range 0 1
+	default 1
+	help
+	  This option sets the default value for the kernel parameter
+	  'apparmor', which allows AppArmor to be enabled or disabled
+          at boot.  If this option is set to 0 (zero), the AppArmor
+	  kernel parameter will default to 0, disabling AppArmor at
+	  bootup.  If this option is set to 1 (one), the AppArmor
+	  kernel parameter will default to 1, enabling AppArmor at
+	  bootup.
+
+	  If you are unsure how to answer this question, answer 1.
+
+config SECURITY_APPARMOR_DISABLE
+	bool "AppArmor runtime disable"
+	depends on SECURITY_APPARMOR
+	default n
+	help
+	  This option enables writing to a apparmorfs node 'disable', which
+	  allows AppArmor to be disabled at runtime prior to the policy load.
+	  AppArmor will then remain disabled until the next boot.
+	  This option is similar to the apparmor.enabled=0 boot parameter,
+	  but is to support runtime disabling of AppArmor, e.g. from
+	  /sbin/init, for portability across platforms where boot
+	  parameters are difficult to employ.
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_APPARMOR_COMPAT_24
+	bool "Enable AppArmor 2.4 compatability"
+	depends on SECURITY_APPARMOR
+	default y
+	help
+	  This option enables compatability with AppArmor 2.4.  It is
+          recommended if compatability with older versions of AppArmor
+          is desired.
diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
new file mode 100644
index 0000000..02d7f3c
--- /dev/null
+++ b/security/apparmor/Makefile
@@ -0,0 +1,25 @@
+# Makefile for AppArmor Linux Security Module
+#
+obj-$(CONFIG_SECURITY_APPARMOR) += apparmor.o
+
+apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
+              path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
+              resource.o sid.o file.o
+
+apparmor-$(CONFIG_SECURITY_APPARMOR_NETWORK) += net.o
+apparmor-$(CONFIG_SECURITY_APPARMOR_COMPAT_24) += apparmorfs-24.o
+
+clean-files: capability_names.h af_names.h
+
+quiet_cmd_make-caps = GEN     $@
+cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
+
+quiet_cmd_make-af = GEN     $@
+cmd_make-af = echo "static const char *address_family_names[] = {" > $@ ; sed -n -e "/AF_MAX/d" -e "/AF_LOCAL/d" -e "s/^\#define[ \\t]\\+AF_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
+
+$(obj)/capability.o : $(obj)/capability_names.h
+$(obj)/net.o : $(obj)/af_names.h
+$(obj)/capability_names.h : $(srctree)/include/linux/capability.h
+	$(call cmd,make-caps)
+$(obj)/af_names.h : $(srctree)/include/linux/socket.h
+	$(call cmd,make-af)
-- 
1.6.3.3

