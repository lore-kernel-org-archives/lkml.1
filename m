Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXFSLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXFSLSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbXFSLSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 07:18:30 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:60982 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXFSLS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 07:18:29 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Tue, 19 Jun 2007 21:18:22 +1000
User-Agent: KMail/1.9.6
Cc: pavel@ucw.cz, Rafael Wysocki <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2839312.NDQi3J478u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706192118.23706.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2839312.NDQi3J478u
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all

Here's what I have after today's work.

I haven't yet been able to test on x86, but can confirm that it works okay =
on x86_64. I'm currently working towards testing it on my old Omnibook. My =
P4 desktop won't resume from suspend to ram at all, and hasn't produced any=
 beeps.

I needed to move the BEEP invocation to after the data segment is reloaded,=
 so that the test could access the variable. That was pretty tricky to find=
 - no oops or anything bad prior, it just didn't beep when expected.

A couple of notes:

=2D I'd like to put the BEEP macro somewhere that can be shared by x86 32 a=
nd 64. If that's a good idea, any suggestions on where? Nothing occurs to m=
e straight off.
=2D I've just switched from Evo to Kmail. Please let me know if there's any=
 mangling of the patch.

Regards,

Nigel

 arch/i386/kernel/acpi/wakeup.S   |   29 ++++++++++++++++++++++++++++-
 arch/x86_64/kernel/acpi/wakeup.S |   25 +++++++++++++++++++++++++
 include/linux/acpi.h             |    1 +
 kernel/power/main.c              |   23 +++++++++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)
diff -ruNp 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S 970-str-be=
ep.patch-new/arch/i386/kernel/acpi/wakeup.S
=2D-- 970-str-beep.patch-old/arch/i386/kernel/acpi/wakeup.S	2007-06-19 12:1=
5:25.000000000 +1000
+++ 970-str-beep.patch-new/arch/i386/kernel/acpi/wakeup.S	2007-06-19 21:14:=
49.000000000 +1000
@@ -11,7 +11,22 @@
 #
 # If physical address of wakeup_code is 0x12345, BIOS should call us with
 # cs =3D 0x1234, eip =3D 0x05
=2D#=20
+#
+
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
=20
 ALIGN
 	.align	4096
@@ -31,6 +46,11 @@ wakeup_code:
 	movw	%cs, %ax
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
+
+	testl   $1, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASU=
S board
 	movw	$0x0e00 + 'S', %fs:(0x12)
=20
@@ -88,6 +108,10 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
=20
+	testl   $2, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
=20
 real_save_gdt:	.word 0
@@ -98,6 +122,7 @@ real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
 video_flags:	.long 0
+beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
@@ -261,6 +286,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	movl	%edx, video_mode - wakeup_start (%eax)
 	movl	acpi_video_flags, %edx
 	movl	%edx, video_flags - wakeup_start (%eax)
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
 	ret
diff -ruNp 970-str-beep.patch-old/arch/x86_64/kernel/acpi/wakeup.S 970-str-=
beep.patch-new/arch/x86_64/kernel/acpi/wakeup.S
=2D-- 970-str-beep.patch-old/arch/x86_64/kernel/acpi/wakeup.S	2007-06-19 12=
:15:28.000000000 +1000
+++ 970-str-beep.patch-new/arch/x86_64/kernel/acpi/wakeup.S	2007-06-19 21:1=
4:49.000000000 +1000
@@ -16,6 +16,21 @@
 # cs =3D 0x1234, eip =3D 0x05
 #
=20
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
=20
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
=20
@@ -229,6 +251,7 @@ gdt_48a:
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
 =09
 real_magic:	.quad 0
+beep_flags:	.quad 0
 video_mode:	.quad 0
 video_flags:	.quad 0
=20
@@ -344,6 +367,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
 	pushq	%rdx
=20
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (,%rdi)
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
 	movl	acpi_video_flags, %edx
diff -ruNp 970-str-beep.patch-old/include/linux/acpi.h 970-str-beep.patch-n=
ew/include/linux/acpi.h
=2D-- 970-str-beep.patch-old/include/linux/acpi.h	2007-06-19 21:15:08.00000=
0000 +1000
+++ 970-str-beep.patch-new/include/linux/acpi.h	2007-06-19 21:14:49.0000000=
00 +1000
@@ -123,6 +123,7 @@ extern int pci_mmcfg_config_num;
=20
 extern int sbf_port;
 extern unsigned long acpi_video_flags;
+extern unsigned long s2ram_beep;
=20
 #else	/* !CONFIG_ACPI */
=20
diff -ruNp 970-str-beep.patch-old/kernel/power/main.c 970-str-beep.patch-ne=
w/kernel/power/main.c
=2D-- 970-str-beep.patch-old/kernel/power/main.c	2007-06-19 12:15:55.000000=
000 +1000
+++ 970-str-beep.patch-new/kernel/power/main.c	2007-06-19 21:14:49.00000000=
0 +1000
@@ -308,6 +308,27 @@ static ssize_t state_store(struct kset *
=20
 power_attr(state);
=20
+unsigned long s2ram_beep =3D 0;
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
+		s2ram_beep =3D val;
+		return n;
+	}
+	return -EINVAL;
+}
+
+power_attr(s2ram_beep);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
=20
@@ -333,11 +354,13 @@ power_attr(pm_trace);
 static struct attribute * g[] =3D {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] =3D {
 	&state_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */


=2D-=20
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia

--nextPart2839312.NDQi3J478u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGd7t/N0y+n1M3mo0RAvu9AJ9K+RoVMmJJxsjPUAtwARMcKTRPKgCeOfyG
AU035zij6UWkrdcxiq+EoxU=
=gbAY
-----END PGP SIGNATURE-----

--nextPart2839312.NDQi3J478u--
