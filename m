Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXGFNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXGFNpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXGFNpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:45:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXGFNpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:45:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/2] PM: Integrate beeping flag with existing acpi_sleep flags
Date: Fri, 6 Jul 2007 15:51:21 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>,
       Len Brown <len.brown@intel.com>
References: <200707061549.04952.rjw@sisk.pl>
In-Reply-To: <200707061549.04952.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061551.21938.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@suse.cz>

Move "debug during resume from s2ram" into the variable we already use
for real-mode flags to simplify code. It also closes nasty trap for
the user in acpi_sleep_setup; order of parameters actually mattered there,
acpi_sleep=s3_bios,s3_mode doing something different from
acpi_sleep=s3_mode,s3_bios.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/kernel/acpi/sleep.c    |   12 ++++++++----
 arch/i386/kernel/acpi/wakeup.S   |   18 ++++++++----------
 arch/x86_64/kernel/acpi/sleep.c  |    8 +++++---
 arch/x86_64/kernel/acpi/wakeup.S |   15 ++++++---------
 include/linux/acpi.h             |    3 +--
 kernel/power/main.c              |   23 -----------------------
 kernel/sysctl.c                  |    2 +-
 7 files changed, 29 insertions(+), 52 deletions(-)

Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/acpi/sleep.c
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/sleep.c
@@ -14,7 +14,7 @@
 
 /* address in low memory of the wakeup routine. */
 unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_video_flags;
+unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
 extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
@@ -68,9 +68,11 @@ static int __init acpi_sleep_setup(char 
 {
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_video_flags = 1;
+			acpi_realmode_flags |= 1;
 		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_video_flags |= 2;
+			acpi_realmode_flags |= 2;
+		if (strncmp(str, "s3_beep", 7) == 0)
+			acpi_realmode_flags |= 4;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
@@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char 
 
 __setup("acpi_sleep=", acpi_sleep_setup);
 
+/* Ouch, we want to delete this. We already have better version in userspace, in 
+   s2ram from suspend.sf.net project */
 static __init int reset_videomode_after_s3(struct dmi_system_id *d)
 {
-	acpi_video_flags |= 2;
+	acpi_realmode_flags |= 2;
 	return 0;
 }
 
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/acpi/wakeup.S
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/wakeup.S
@@ -65,7 +65,7 @@ wakeup_code:
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
 
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -79,7 +79,7 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -87,7 +87,7 @@ wakeup_code:
 	movw	%ax, %ss
 1:
 
-	testl	$2, video_flags - wakeup_code
+	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
 	call	mode_set
@@ -126,11 +126,11 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-	testl   $2, beep_flags - wakeup_code
+	testl   $8, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
-	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
+	ljmpl	$__KERNEL_CS, $wakeup_pmode_return
 
 real_save_gdt:	.word 0
 		.long 0
@@ -139,7 +139,7 @@ real_save_cr3:	.long 0
 real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
-video_flags:	.long 0
+realmode_flags:	.long 0
 beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
@@ -303,10 +303,8 @@ ENTRY(acpi_copy_wakeup_routine)
 
 	movl	saved_videomode, %edx
 	movl	%edx, video_mode - wakeup_start (%eax)
-	movl	acpi_video_flags, %edx
-	movl	%edx, video_flags - wakeup_start (%eax)
-	movl	s2ram_beep, %edx
-	movl	%edx, beep_flags - wakeup_start (%eax)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
 	popl	%ebx
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/acpi/sleep.c
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/sleep.c
@@ -55,7 +55,7 @@
 
 /* address in low memory of the wakeup routine. */
 unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_video_flags;
+unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
@@ -103,9 +103,11 @@ static int __init acpi_sleep_setup(char 
 {
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_video_flags = 1;
+			acpi_realmode_flags |= 1;
 		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_video_flags |= 2;
+			acpi_realmode_flags |= 2;
+		if (strncmp(str, "s3_beep", 7) == 0)
+			acpi_realmode_flags |= 4;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/wakeup.S
@@ -50,7 +50,7 @@ wakeup_code:
 	movw	%ax, %ss
 
 	# Data segment must be set up before we can see whether to beep.
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -70,7 +70,7 @@ wakeup_code:
 	testl	%eax, %eax
 	jnz	no_longmode
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -78,7 +78,7 @@ wakeup_code:
 	movw	%ax, %ss
 1:
 
-	testl	$2, video_flags - wakeup_code
+	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
 	call	mode_seta
@@ -251,9 +251,8 @@ gdt_48a:
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
 	
 real_magic:	.quad 0
-beep_flags:	.quad 0
 video_mode:	.quad 0
-video_flags:	.quad 0
+realmode_flags:	.quad 0
 
 .code16
 bogus_real_magic:
@@ -367,12 +366,10 @@ ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
 	pushq	%rdx
 
-	movl	s2ram_beep, %edx
-	movl	%edx, beep_flags - wakeup_start (,%rdi)
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
-	movl	acpi_video_flags, %edx
-	movl	%edx, video_flags - wakeup_start (,%rdi)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (,%rdi)
 	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
 	movq	$0x123456789abcdef0, %rdx
 	movq	%rdx, saved_magic
Index: linux-2.6.22-rc6-mm1/include/linux/acpi.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/acpi.h
+++ linux-2.6.22-rc6-mm1/include/linux/acpi.h
@@ -120,8 +120,7 @@ extern struct acpi_mcfg_allocation *pci_
 extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
-extern unsigned long acpi_video_flags;
-extern unsigned long s2ram_beep;
+extern unsigned long acpi_realmode_flags;
 
 #else	/* !CONFIG_ACPI */
 
Index: linux-2.6.22-rc6-mm1/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/main.c
+++ linux-2.6.22-rc6-mm1/kernel/power/main.c
@@ -332,27 +332,6 @@ static ssize_t state_store(struct kset *
 
 power_attr(state);
 
-unsigned long s2ram_beep = 0;
-
-static ssize_t s2ram_beep_show(struct kset *kset, char *buf)
-{
-	return sprintf(buf, "%d\n", s2ram_beep);
-}
-
-static ssize_t
-s2ram_beep_store(struct kset *kset, const char *buf, size_t n)
-{
-	int val;
-
-	if (sscanf(buf, "%d", &val) > 0) {
-		s2ram_beep = val;
-		return n;
-	}
-	return -EINVAL;
-}
-
-power_attr(s2ram_beep);
-
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -378,13 +357,11 @@ power_attr(pm_trace);
 static struct attribute * g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
-	&s2ram_beep_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] = {
 	&state_attr.attr,
-	&s2ram_beep_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */
Index: linux-2.6.22-rc6-mm1/kernel/sysctl.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/sysctl.c
+++ linux-2.6.22-rc6-mm1/kernel/sysctl.c
@@ -699,7 +699,7 @@ static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
-		.data		= &acpi_video_flags,
+		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
