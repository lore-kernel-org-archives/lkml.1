Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXGDV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXGDV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXGDV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:29:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36607 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755735AbXGDV3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:29:20 -0400
Date: Wed, 4 Jul 2007 23:29:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070704212907.GA3213@elf.ucw.cz>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706301215.20334.rjw@sisk.pl> <20070630101112.GA10444@elf.ucw.cz> <200706302230.19040.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706302230.19040.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> > > > > 
> > > > > Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> > > > > variable (I assume this is what you're thinking of), we only create cause for 
> > > > > confusion. A variable should for debugging or for controlling quirks, not for 
> > > > > both at the same time.
> > > > 
> > > > Cause for confusion? We are currently using 2 bits of that variable,
> > > > and we want to add one more bit. I seriously doubt that can confuse
> > > > anyone.
> > > 
> > > Well, indeed it would be more elegant to rename the existing flags variable
> > > and use another bit out of it, but I personally don't think it's _that_
> > > important.  At least, I don't think we should block the patch
> > > because of that.
> > 
> > It is not _that_ important.
> > 
> > > BTW, has anyone confirmed that it works on i386?
> > 
> > If you have patch somewhere nearby, I can test it on i386 and make it
> > use just one flags variable.
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc6/patches/28-Optional-Beeping-During-Resume-From-RAM.patch
> 

I can confirm that (Nigel's patch) works on i386; but it causes a warning:

kernel/power/main.c: In function 's2ram_beep_show':
kernel/power/main.c:319: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'


Here's the version that uses just one variable, relative to Nigel's
patch. Hmm, and it also closes nasty trap for the user in
acpi_sleep_setup; order of parameters actually mattered there,
acpi_sleep=s3_bios,s3_mode doing something different from
acpi_sleep=s3_mode,s3_bios .  It actually works here.

Will you fold it into  patch28, or should I create a changelog?
Testing welcome :-).
								Pavel

diff --git a/arch/i386/kernel/acpi/sleep.c b/arch/i386/kernel/acpi/sleep.c
index 4ee8357..5b67866 100644
--- a/arch/i386/kernel/acpi/sleep.c
+++ b/arch/i386/kernel/acpi/sleep.c
@@ -14,7 +14,7 @@ #include <asm/smp.h>
 
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
 
diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
index 68e58f1..443fe85 100644
--- a/arch/i386/kernel/acpi/wakeup.S
+++ b/arch/i386/kernel/acpi/wakeup.S
@@ -50,7 +50,7 @@ #	BEEP
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
 
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -64,7 +64,7 @@ #	BEEP
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -72,7 +72,7 @@ #	BEEP
 	movw	%ax, %ss
 1:
 
-	testl	$2, video_flags - wakeup_code
+	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
 	call	mode_set
@@ -111,11 +111,11 @@ #	BEEP
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
@@ -124,7 +124,7 @@ real_save_cr3:	.long 0
 real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
-video_flags:	.long 0
+realmode_flags:	.long 0
 beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
@@ -288,10 +288,8 @@ ENTRY(acpi_copy_wakeup_routine)
 
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
diff --git a/arch/x86_64/kernel/acpi/sleep.c b/arch/x86_64/kernel/acpi/sleep.c
index 195b703..4277f2b 100644
--- a/arch/x86_64/kernel/acpi/sleep.c
+++ b/arch/x86_64/kernel/acpi/sleep.c
@@ -55,7 +55,7 @@ #ifdef CONFIG_ACPI_SLEEP
 
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
diff --git a/arch/x86_64/kernel/acpi/wakeup.S b/arch/x86_64/kernel/acpi/wakeup.S
index ed63d18..13f1480 100644
--- a/arch/x86_64/kernel/acpi/wakeup.S
+++ b/arch/x86_64/kernel/acpi/wakeup.S
@@ -50,7 +50,7 @@ # Running in *copy* of this code, somewh
 	movw	%ax, %ss
 
 	# Data segment must be set up before we can see whether to beep.
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -70,7 +70,7 @@ # Running in *copy* of this code, somewh
 	testl	%eax, %eax
 	jnz	no_longmode
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -78,7 +78,7 @@ # Running in *copy* of this code, somewh
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
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f26df82..9287d89 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -122,8 +122,7 @@ extern struct acpi_mcfg_allocation *pci_
 extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
-extern unsigned long acpi_video_flags;
-extern unsigned long s2ram_beep;
+extern unsigned long acpi_realmode_flags;
 
 #else	/* !CONFIG_ACPI */
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 516c24e..fc45ed2 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -312,27 +312,6 @@ static ssize_t state_store(struct kset *
 
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
 
@@ -358,13 +337,11 @@ power_attr(pm_trace);
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 30ee462..40d616b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -569,7 +569,7 @@ #ifdef CONFIG_ACPI_SLEEP
 	{
 		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
-		.data		= &acpi_video_flags,
+		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,


(s2ram patch for testing follows)

Index: s2ram.c
===================================================================
RCS file: /cvsroot/suspend/suspend/s2ram.c,v
retrieving revision 1.46
diff -u -u -r1.46 s2ram.c
--- s2ram.c	10 Jan 2007 08:04:55 -0000	1.46
+++ s2ram.c	4 Jul 2007 21:28:22 -0000
@@ -35,13 +35,14 @@
 /* flags for the whitelist */
 #define S3_BIOS     0x01	/* machine needs acpi_sleep=s3_bios */
 #define S3_MODE     0x02	/* machine needs acpi_sleep=s3_mode */
-#define VBE_SAVE    0x04	/* machine needs "vbetool save / restore" */
-#define VBE_POST    0x08	/* machine needs "vbetool post" */
-#define RADEON_OFF  0x10	/* machine needs "radeontool light off" */
-#define UNSURE      0x20	/* unverified entries from acpi-support 0.59 */
-#define NOFB        0x40	/* must not use a frame buffer */
-#define VBE_MODE    0x80	/* machine needs "vbetool vbemode get / set" */
-#define PCI_SAVE   0x100	/* we need to save the VGA PCI registers */
+#define S3_BEEP     0x04	/* debugging beep */
+#define VBE_SAVE    0x08	/* machine needs "vbetool save / restore" */
+#define VBE_POST    0x10	/* machine needs "vbetool post" */
+#define RADEON_OFF  0x20	/* machine needs "radeontool light off" */
+#define UNSURE      0x40	/* unverified entries from acpi-support 0.59 */
+#define NOFB        0x80	/* must not use a frame buffer */
+#define VBE_MODE    0x100	/* machine needs "vbetool vbemode get / set" */
+#define PCI_SAVE   0x200	/* we need to save the VGA PCI registers */
 
 #include "whitelist.c"
 
@@ -188,8 +189,8 @@
 	int ret = 0;
 
 	/* 0 means: don't touch what was set on kernel commandline */
-	if (flags & (S3_BIOS | S3_MODE))
-		ret = set_acpi_video_mode(flags & (S3_BIOS | S3_MODE));
+	if (flags & (S3_BIOS | S3_MODE | S3_BEEP))
+		ret = set_acpi_video_mode(flags & (S3_BIOS | S3_MODE | S3_BEEP));
 
 	if (ret)
 		return ret;
@@ -368,7 +369,7 @@
 			flags |= RADEON_OFF;
 			break;
 		case 'a':
-			flags |= (atoi(optarg) & (S3_BIOS | S3_MODE));
+			flags |= (atoi(optarg) & (S3_BIOS | S3_MODE | S3_BEEP));
 			break;
 		case 'v':
 			flags |= PCI_SAVE;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
