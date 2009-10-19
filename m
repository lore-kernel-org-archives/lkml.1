Return-Path: <linux-kernel-owner+w=401wt.eu-S1751041AbZJSFDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbZJSFDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZJSFDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:03:23 -0400
Received: from ozlabs.org ([203.10.76.45]:50223 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZJSFDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:03:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] cpufreq: use an enum for speedstep processor identification
Date: Mon, 19 Oct 2009 15:33:16 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Dominik Brodowski <linux@brodo.de>, dave.mueller@gmx.ch,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20091007201108.GA16813@redhat.com> <200910191418.23238.rusty@rustcorp.com.au>
In-Reply-To: <200910191418.23238.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910191533.16979.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "unsigned int processor" everywhere confused Rusty, leading to
breakage when he passed in smp_processor_id().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -39,7 +39,7 @@ static struct pci_dev *speedstep_chipset
 
 /* speedstep_processor
  */
-static unsigned int speedstep_processor;
+static enum speedstep_processor speedstep_processor;
 
 static u32 pmbase;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -34,7 +34,7 @@ static int relaxed_check;
  *                   GET PROCESSOR CORE SPEED IN KHZ                 *
  *********************************************************************/
 
-static unsigned int pentium3_get_frequency(unsigned int processor)
+static unsigned int pentium3_get_frequency(enum speedstep_processor processor)
 {
 	/* See table 14 of p3_ds.pdf and table 22 of 29834003.pdf */
 	struct {
@@ -227,7 +227,7 @@ static unsigned int pentium4_get_frequen
 
 
 /* Warning: may get called from smp_call_function_single. */
-unsigned int speedstep_get_frequency(unsigned int processor)
+unsigned int speedstep_get_frequency(enum speedstep_processor processor)
 {
 	switch (processor) {
 	case SPEEDSTEP_CPU_PCORE:
@@ -380,7 +380,7 @@ EXPORT_SYMBOL_GPL(speedstep_detect_proce
  *                     DETECT SPEEDSTEP SPEEDS                       *
  *********************************************************************/
 
-unsigned int speedstep_get_freqs(unsigned int processor,
+unsigned int speedstep_get_freqs(enum speedstep_processor processor,
 				  unsigned int *low_speed,
 				  unsigned int *high_speed,
 				  unsigned int *transition_latency,
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h
@@ -11,18 +11,18 @@
 
 
 /* processors */
-
-#define SPEEDSTEP_CPU_PIII_C_EARLY	0x00000001  /* Coppermine core */
-#define SPEEDSTEP_CPU_PIII_C		0x00000002  /* Coppermine core */
-#define SPEEDSTEP_CPU_PIII_T		0x00000003  /* Tualatin core */
-#define SPEEDSTEP_CPU_P4M		0x00000004  /* P4-M  */
-
+enum speedstep_processor {
+	SPEEDSTEP_CPU_PIII_C_EARLY = 0x00000001,  /* Coppermine core */
+	SPEEDSTEP_CPU_PIII_C	   = 0x00000002,  /* Coppermine core */
+	SPEEDSTEP_CPU_PIII_T	   = 0x00000003,  /* Tualatin core */
+	SPEEDSTEP_CPU_P4M	   = 0x00000004,  /* P4-M  */
 /* the following processors are not speedstep-capable and are not auto-detected
  * in speedstep_detect_processor(). However, their speed can be detected using
  * the speedstep_get_frequency() call. */
-#define SPEEDSTEP_CPU_PM		0xFFFFFF03  /* Pentium M  */
-#define SPEEDSTEP_CPU_P4D		0xFFFFFF04  /* desktop P4  */
-#define SPEEDSTEP_CPU_PCORE		0xFFFFFF05  /* Core */
+	SPEEDSTEP_CPU_PM	   = 0xFFFFFF03,  /* Pentium M  */
+	SPEEDSTEP_CPU_P4D	   = 0xFFFFFF04,  /* desktop P4  */
+	SPEEDSTEP_CPU_PCORE	   = 0xFFFFFF05,  /* Core */
+};
 
 /* speedstep states -- only two of them */
 
@@ -31,10 +31,10 @@
 
 
 /* detect a speedstep-capable processor */
-extern unsigned int speedstep_detect_processor (void);
+extern enum speedstep_processor speedstep_detect_processor (void);
 
 /* detect the current speed (in khz) of the processor */
-extern unsigned int speedstep_get_frequency(unsigned int processor);
+extern unsigned int speedstep_get_frequency(enum speedstep_processor processor);
 
 
 /* detect the low and high speeds of the processor. The callback
@@ -42,7 +42,7 @@ extern unsigned int speedstep_get_freque
  * SPEEDSTEP_LOW; the second argument is zero so that no
  * cpufreq_notify_transition calls are initiated.
  */
-extern unsigned int speedstep_get_freqs(unsigned int processor,
+extern unsigned int speedstep_get_freqs(enum speedstep_processor processor,
 	unsigned int *low_speed,
 	unsigned int *high_speed,
 	unsigned int *transition_latency,
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -35,7 +35,7 @@ static int smi_cmd;
 static unsigned int smi_sig;
 
 /* info about the processor */
-static unsigned int speedstep_processor;
+static enum speedstep_processor speedstep_processor;
 
 /*
  * There are only two frequency states for each processor. Values
