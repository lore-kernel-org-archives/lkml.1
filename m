Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXDHULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXDHULi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDHULi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:11:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbXDHULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:11:37 -0400
Date: Sun, 8 Apr 2007 13:10:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Kaindl <bk@suse.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 2/4] Save the MTRRs of the BSP before booting an AP
Message-Id: <20070408131056.b943bfca.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704031559080.7626@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
	<200703272213.51947.ak@suse.de>
	<Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
	<200703291525.59116.ak@suse.de>
	<Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
	<Pine.LNX.4.64.0704031559080.7626@jbgna.fhfr.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 16:00:36 +0200 (CEST) Bernhard Kaindl <bk@suse.de> wrote:

> --- linux-2.6.20.orig/arch/i386/kernel/smpboot.c
> +++ linux-2.6.20/arch/i386/kernel/smpboot.c
> @@ -59,6 +59,7 @@
>  #include <asm/nmi.h>
>  #include <asm/pda.h>
>  #include <asm/genapic.h>
> +#include <asm/mtrr.h>
> 

This inclusion breaks `make headers_check'.

Please always at least test allmodconfig builds before releasing a
patchset.  Additional hints are in Documentation/SubmitChecklist.

+static __inline__ void mtrr_save_state (void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}

- Please use inline, not __inline__

- No space before the (

- We should uninline this function

  - It is not performance critical

  - It is probably too large to be inlined anwyay

  - It uses a lot of tricky stuff which requires a lot of header files.


From: Andrew Morton <akpm@linux-foundation.org>

Fix `make headers_check'.

Cc: Andi Kleen <ak@suse.de>
Cc: Bernhard Kaindl <bk@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c |   11 +++++++++++
 include/asm-i386/mtrr.h          |   12 +-----------
 include/asm-x86_64/proto.h       |   12 +-----------
 3 files changed, 13 insertions(+), 22 deletions(-)

diff -puN arch/i386/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/i386/kernel/smpboot.c
diff -puN arch/x86_64/kernel/smpboot.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/x86_64/kernel/smpboot.c
diff -puN include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix include/asm-i386/mtrr.h
--- a/include/asm-i386/mtrr.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/include/asm-i386/mtrr.h
@@ -25,7 +25,6 @@
 
 #include <linux/ioctl.h>
 #include <linux/errno.h>
-#include <linux/smp.h>
 
 #define	MTRR_IOCTL_BASE	'M'
 
@@ -71,16 +70,7 @@ struct mtrr_gentry
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
-/**
- * Save current fixed-range MTRR state of the BSP
- */
-static __inline__ void mtrr_save_state (void)
-{
-	if (smp_processor_id() == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-}
+extern void mtrr_save_state(void);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
diff -puN include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/include/asm-x86_64/proto.h
@@ -2,7 +2,6 @@
 #define _ASM_X8664_PROTO_H 1
 
 #include <asm/ldt.h>
-#include <linux/smp.h>
 
 /* misc architecture specific prototypes */
 
@@ -19,16 +18,7 @@ extern void mcheck_init(struct cpuinfo_x
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern void mtrr_save_fixed_ranges(void *);
-static __inline__ void mtrr_save_state (void)
-{
-	/*
-	 * Save current fixed-range MTRR state of the BSP:
-	 */
-	if (smp_processor_id() == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-}
+extern void mtrr_save_state(void);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
diff -puN arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -729,6 +729,17 @@ void mtrr_ap_init(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * Save current fixed-range MTRR state of the BSP
+ */
+void mtrr_save_state(void)
+{
+	if (smp_processor_id() == 0)
+		mtrr_save_fixed_ranges(NULL);
+	else
+		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
_

