Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXFYEd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXFYEd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXFYEds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:33:48 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:60247 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbXFYEdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:33:47 -0400
Date: Mon, 25 Jun 2007 00:33:43 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: [PATCH try #2] security: Convert LSM into a static interface
In-Reply-To: <20070624220903.GB3723@sequoia.sous-sol.org>
Message-ID: <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org>
 <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com>
 <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com>
 <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com>
 <Line.LNX.4.64.0706241158320.12660@localhost.localdomain>
 <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
 <20070624220903.GB3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert LSM into a static interface, as the ability to unload a security 
module is not required by in-tree users and potentially complicates the 
overall security architecture.

Needlessly exported LSM symbols have been unexported, to help reduce API
abuse.

Parameters for the capability and root_plug modules are now specified at 
boot.

The SECURITY_FRAMEWORK_VERSION macro has also been removed.

Signed-off-by: James Morris <jmorris@namei.org>
---

Changes:
 - retain capability.disable kernel param name

 

 Documentation/kernel-parameters.txt |   17 +++++++++++
 security/Kconfig                    |    4 +-
 security/capability.c               |   24 ----------------
 security/commoncap.c                |    3 --
 security/dummy.c                    |    1 -
 security/root_plug.c                |   53 +++++++++++++---------------------
 security/security.c                 |    9 +----
 security/selinux/hooks.c            |    1 -
 security/selinux/xfrm.c             |    1 -
 9 files changed, 41 insertions(+), 72 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5d0283c..35e1202 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -74,10 +74,12 @@ parameter is applicable:
 	PPT	Parallel port support is enabled.
 	PS2	Appropriate PS/2 support is enabled.
 	RAM	RAM disk support is enabled.
+	ROOTPLUG The example Root Plug LSM is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
 			A lot of drivers has their options described inside of
 			Documentation/scsi/.
+	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	SERIAL	Serial support is enabled.
 	SH	SuperH architecture is enabled.
@@ -376,6 +378,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
+	capability.disable=
+			[SECURITY] Disable capabilities.  This would normally
+			be used only if an alternative security model is to be
+			configured.  Potentially dangerous and should only be
+			used if you are entirely sure of the consequences.
+
 	cdu31a=		[HW,CD]
 			Format: <io>,<irq>[,PAS]
 			See header of drivers/cdrom/cdu31a.c.
@@ -1541,6 +1549,15 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	rootfstype=	[KNL] Set root filesystem type
 
+	root_plug_vendor_id=
+			[ROOTPLUG] Override the default vendor ID
+
+	root_plug_product_id=
+			[ROOTPLUG] Override the default product ID
+
+	root_plug_debug=
+			[ROOTPLUG] Enable debugging output
+
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff --git a/security/Kconfig b/security/Kconfig
index 460e5c9..8ae5490 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -74,14 +74,14 @@ config SECURITY_NETWORK_XFRM
 	  If you are unsure how to answer this question, answer N.
 
 config SECURITY_CAPABILITIES
-	tristate "Default Linux Capabilities"
+	bool "Default Linux Capabilities"
 	depends on SECURITY
 	help
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
 
 config SECURITY_ROOTPLUG
-	tristate "Root Plug Support"
+	bool "Root Plug Support"
 	depends on USB && SECURITY
 	help
 	  This is a sample LSM module that should only be used as such.
diff --git a/security/capability.c b/security/capability.c
index 38296a0..fda6a14 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -8,7 +8,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
@@ -52,7 +51,6 @@ static int secondary;
 
 static int capability_disable;
 module_param_named(disable, capability_disable, int, 0);
-MODULE_PARM_DESC(disable, "To disable capabilities module set disable = 1");
 
 static int __init capability_init (void)
 {
@@ -75,26 +73,4 @@ static int __init capability_init (void)
 	return 0;
 }
 
-static void __exit capability_exit (void)
-{
-	if (capability_disable)
-		return;
-	/* remove ourselves from the security framework */
-	if (secondary) {
-		if (mod_unreg_security (KBUILD_MODNAME, &capability_ops))
-			printk (KERN_INFO "Failure unregistering capabilities "
-				"with primary module.\n");
-		return;
-	}
-
-	if (unregister_security (&capability_ops)) {
-		printk (KERN_INFO
-			"Failure unregistering capabilities with the kernel\n");
-	}
-}
-
 security_initcall (capability_init);
-module_exit (capability_exit);
-
-MODULE_DESCRIPTION("Standard Linux Capabilities Security Module");
-MODULE_LICENSE("GPL");
diff --git a/security/commoncap.c b/security/commoncap.c
index 384379e..04bd44b 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -339,6 +339,3 @@ EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_reparent_to_init);
 EXPORT_SYMBOL(cap_syslog);
 EXPORT_SYMBOL(cap_vm_enough_memory);
-
-MODULE_DESCRIPTION("Standard Linux Common Capabilities Security Module");
-MODULE_LICENSE("GPL");
diff --git a/security/dummy.c b/security/dummy.c
index 8ffd764..6d4e34b 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -15,7 +15,6 @@
 #undef DEBUG
 
 #include <linux/capability.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
diff --git a/security/root_plug.c b/security/root_plug.c
index 38dd4f3..3125e25 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -22,7 +22,6 @@
  *	License.
  */
 
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/security.h>
@@ -33,25 +32,34 @@ static int secondary;
 
 /* default is a generic type of usb to serial converter */
 static int vendor_id = 0x0557;
-static int product_id = 0x2008;
 
-module_param(vendor_id, uint, 0400);
-MODULE_PARM_DESC(vendor_id, "USB Vendor ID of device to look for");
+static int __init root_plug_vendor_id(char *str)
+{
+	vendor_id = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("root_plug_vendor_id=", root_plug_vendor_id);
+
+static int product_id = 0x2008;
 
-module_param(product_id, uint, 0400);
-MODULE_PARM_DESC(product_id, "USB Product ID of device to look for");
+static int __init root_plug_product_id(char *str)
+{
+	product_id = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("root_plug_product_id=", root_plug_product_id);
 
 /* should we print out debug messages */
 static int debug = 0;
 
-module_param(debug, bool, 0600);
-MODULE_PARM_DESC(debug, "Debug enabled or not");
+static int __init root_plug_debug(char *str)
+{
+	debug = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("root_plug_debug=", root_plug_debug);
 
-#if defined(CONFIG_SECURITY_ROOTPLUG_MODULE)
-#define MY_NAME THIS_MODULE->name
-#else
 #define MY_NAME "root_plug"
-#endif
 
 #define root_dbg(fmt, arg...)					\
 	do {							\
@@ -117,25 +125,4 @@ static int __init rootplug_init (void)
 	return 0;
 }
 
-static void __exit rootplug_exit (void)
-{
-	/* remove ourselves from the security framework */
-	if (secondary) {
-		if (mod_unreg_security (MY_NAME, &rootplug_security_ops))
-			printk (KERN_INFO "Failure unregistering Root Plug "
-				" module with primary module.\n");
-	} else { 
-		if (unregister_security (&rootplug_security_ops)) {
-			printk (KERN_INFO "Failure unregistering Root Plug "
-				"module with the kernel\n");
-		}
-	}
-	printk (KERN_INFO "Root Plug module removed\n");
-}
-
 security_initcall (rootplug_init);
-module_exit (rootplug_exit);
-
-MODULE_DESCRIPTION("Root Plug sample LSM module, written for Linux Journal article");
-MODULE_LICENSE("GPL");
-
diff --git a/security/security.c b/security/security.c
index fc8601b..e49dae2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 
-#define SECURITY_FRAMEWORK_VERSION	"1.0.0"
 
 /* things that live in dummy.c */
 extern struct security_operations dummy_security_ops;
@@ -51,8 +50,7 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
-	printk(KERN_INFO "Security Framework v" SECURITY_FRAMEWORK_VERSION
-	       " initialized\n");
+	printk(KERN_INFO "Security Framework initialized\n");
 
 	if (verify(&dummy_security_ops)) {
 		printk(KERN_ERR "%s could not verify "
@@ -172,8 +170,5 @@ int mod_unreg_security(const char *name, struct security_operations *ops)
 	return security_ops->unregister_security(name, ops);
 }
 
-EXPORT_SYMBOL_GPL(register_security);
-EXPORT_SYMBOL_GPL(unregister_security);
-EXPORT_SYMBOL_GPL(mod_reg_security);
-EXPORT_SYMBOL_GPL(mod_unreg_security);
+/* Export required for modular use of security.h inlines */
 EXPORT_SYMBOL(security_ops);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad8dd4e..105319a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -20,7 +20,6 @@
  *      as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index bd8d1ef..b589238 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -31,7 +31,6 @@
  *   2. Emulating a reasonable SO_PEERSEC across machines
  *   3. Testing addition of sk_policy's with security context via setsockopt
  */
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/security.h>
-- 
1.5.2.1

