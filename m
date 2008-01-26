Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYAZSoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYAZSoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 13:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYAZSoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 13:44:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50261 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYAZSop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 13:44:45 -0500
Date: Sat, 26 Jan 2008 19:44:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [RFC] __ref annotation of function/data referencing __init/__exit
Message-ID: <20080126184454.GA25591@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today we have the following annotations for functions/data
referencing __init/__exit functions / data:

__init_refok for functions
__initdata_refok for data

and
_exit_refok for functions

To simplify it and to introduce a shorter annotation I
will suggest the following annotation:

__ref      <= for functions (code) that
              references __*init / __*exit
__refdata  <= for variables
__refconst <= for const variables

This should hopefully make it more intuitive what
the annotation is for.

The mechanishm is the same as before - a special section
is created which is made part of the usual sections
in the linker script.

We would then start to see annotations like this:

  * Specific entries must come before more generic entries.
  */
-static struct pci_serial_quirk pci_serial_quirks[] = {
+static const struct pci_serial_quirk pci_serial_quirks[] __refconst = {
        /*
         * AFAVLAB cards - these may be called via parport_serial
         *  It is not clear whether this applies to all products.

-----------------

 }

-static struct notifier_block __cpuinitdata cpuid_class_cpu_notifier =
+static struct notifier_block cpuid_class_cpu_notifier __refdata =
 {
        .notifier_call = cpuid_class_cpu_callback,
 };

----------------

 /* get notified when a cpu comes on/off */
-static int threshold_cpu_callback(struct notifier_block *nfb,
+static int __ref threshold_cpu_callback(struct notifier_block *nfb,
                                            unsigned long action, void *hcpu)
 {


[The above is just samples - please do not comment on their
correctness in this thread].

The patch (on top of kbuild.git) is below.

	Sam

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 2948530..76df771 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -42,6 +42,7 @@
 #define DATA_DATA							\
 	*(.data)							\
 	*(.data.init.refok)						\
+	*(.ref.data)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
 	CPU_KEEP(init.data)						\
@@ -169,6 +170,7 @@
 									\
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
+		*(.ref.rodata)						\
 		DEV_KEEP(init.rodata)					\
 		DEV_KEEP(exit.rodata)					\
 		CPU_KEEP(init.rodata)					\
@@ -202,6 +204,7 @@
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
 		*(.text)						\
+		*(.ref.text)						\
 		*(.text.init.refok)					\
 		*(.exit.text.refok)					\
 	DEV_KEEP(init.text)						\
diff --git a/include/linux/init.h b/include/linux/init.h
index dde1eaa..2efbda0 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -52,12 +52,26 @@
  * when early init has completed so all such references are potential bugs.
  * For exit sections the same issue exists.
  * The following markers are used for the cases where the reference to
- * the init/exit section (code or data) is valid and will teach modpost
- * not to issue a warning.
+ * the *init / *exit section (code or data) is valid and will teach
+ * modpost not to issue a warning.
  * The markers follow same syntax rules as __init / __initdata. */
-#define __init_refok     noinline __section(.text.init.refok)
-#define __initdata_refok          __section(.data.init.refok)
-#define __exit_refok     noinline __section(.exit.text.refok)
+#define __ref            __section(.ref.text) noinline
+#define __refdata        __section(.ref.data)
+#define __refconst       __section(.ref.rodata)
+
+/* backward compatibility note
+ *  A few places hardcode the old section names:
+ *  .text.init.refok
+ *  .data.init.refok
+ *  .exit.text.refok
+ *  They should be converted to use the defines from this file
+ */
+
+/* compatibility defines */
+#define __init_refok     __ref
+#define __initdata_refok __refdata
+#define __exit_refok     __ref
+
 
 #ifdef MODULE
 #define __exitused
@@ -93,11 +107,9 @@
 
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
-#define __INIT_REFOK	.section	".text.init.refok","ax"
 #define __FINIT		.previous
 
 #define __INITDATA	.section	".init.data","aw"
-#define __INITDATA_REFOK .section	".data.init.refok","aw"
 
 #define __DEVINIT        .section	".devinit.text", "ax"
 #define __DEVINITDATA    .section	".devinit.data", "aw"
@@ -108,6 +120,14 @@
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
 
+/* silence warnings when references are OK */
+#define __REF            .section       ".ref.text", "ax"
+#define __REFDATA        .section       ".ref.data", "aw"
+#define __REFCONST       .section       ".ref.rodata", "aw"
+/* backward compatibility */
+#define __INIT_REFOK     .section	__REF
+#define __INITDATA_REFOK .section	__REFDATA
+
 #ifndef __ASSEMBLY__
 /*
  * Used for initialization calls..
