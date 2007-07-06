Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXGFNpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXGFNpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXGFNpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:45:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbXGFNpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:45:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/2] PM: Optional beeping during resume from suspend to RAM
Date: Fri, 6 Jul 2007 15:50:26 +0200
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
Message-Id: <200707061550.27189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nigel Cunningham <nigel@nigel.suspend2.net>

Add a feature allowing the user to make the system beep during a resume from
suspend to RAM, on x86_64 and i386.

This is useful for the users with broken resume from RAM, so that they can
verify if the control reaches the kernel after a wake-up event.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/kernel/acpi/wakeup.S   |   27 +++++++++++++++++++++++++++
 arch/x86_64/kernel/acpi/wakeup.S |   25 +++++++++++++++++++++++++
 include/linux/acpi.h             |    1 +
 kernel/power/main.c              |   23 +++++++++++++++++++++++
 4 files changed, 76 insertions(+)
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/acpi/wakeup.S
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/acpi/wakeup.S
@@ -28,6 +28,21 @@
 	movb	$15, %al; 	\
 	outb	%al, $66;
 
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
 ALIGN
 	.align	4096
 ENTRY(wakeup_start)
@@ -49,6 +64,11 @@ wakeup_code:
 	movw	%cs, %ax
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
+
+	testl   $1, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
 	movw	$0x0e00 + 'S', %fs:(0x12)
 
@@ -106,6 +126,10 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
+	testl   $2, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
 
 real_save_gdt:	.word 0
@@ -116,6 +140,7 @@ real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
 video_flags:	.long 0
+beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
@@ -280,6 +305,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	movl	%edx, video_mode - wakeup_start (%eax)
 	movl	acpi_video_flags, %edx
 	movl	%edx, video_flags - wakeup_start (%eax)
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
 	popl	%ebx
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/acpi/wakeup.S
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/acpi/wakeup.S
@@ -16,6 +16,21 @@
 # cs = 0x1234, eip = 0x05
 #
 
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
 
 ALIGN
 	.align	16
@@ -33,6 +48,13 @@ wakeup_code:
 	movw	%cs, %ax
 	movw	%ax, %ds		# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
+
+	# Data segment must be set up before we can see whether to beep.
+	testl   $1, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+
 					# Private stack is needed for ASUS board
 	mov	$(wakeup_stack - wakeup_code), %sp
 
@@ -229,6 +251,7 @@ gdt_48a:
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
 	
 real_magic:	.quad 0
+beep_flags:	.quad 0
 video_mode:	.quad 0
 video_flags:	.quad 0
 
@@ -344,6 +367,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
 	pushq	%rdx
 
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (,%rdi)
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
 	movl	acpi_video_flags, %edx
Index: linux-2.6.22-rc6-mm1/include/linux/acpi.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/acpi.h
+++ linux-2.6.22-rc6-mm1/include/linux/acpi.h
@@ -121,6 +121,7 @@ extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
 extern unsigned long acpi_video_flags;
+extern unsigned long s2ram_beep;
 
 #else	/* !CONFIG_ACPI */
 
Index: linux-2.6.22-rc6-mm1/kernel/power/main.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/main.c
+++ linux-2.6.22-rc6-mm1/kernel/power/main.c
@@ -332,6 +332,27 @@ static ssize_t state_store(struct kset *
 
 power_attr(state);
 
+unsigned long s2ram_beep = 0;
+
+static ssize_t s2ram_beep_show(struct kset *kset, char *buf)
+{
+	return sprintf(buf, "%d\n", s2ram_beep);
+}
+
+static ssize_t
+s2ram_beep_store(struct kset *kset, const char *buf, size_t n)
+{
+	int val;
+
+	if (sscanf(buf, "%d", &val) > 0) {
+		s2ram_beep = val;
+		return n;
+	}
+	return -EINVAL;
+}
+
+power_attr(s2ram_beep);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -357,11 +378,13 @@ power_attr(pm_trace);
 static struct attribute * g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] = {
 	&state_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */

