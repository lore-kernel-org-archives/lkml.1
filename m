Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbZAPJAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbZAPJAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZAPI7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:59:52 -0500
Received: from www.tglx.de ([62.245.132.106]:33595 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436AbZAPI7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:59:51 -0500
Date: Fri, 16 Jan 2009 09:59:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Blechmann <tim@klingt.org>
cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
In-Reply-To: <1232067181.6134.74.camel@thinkpad>
Message-ID: <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>  <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>  <1230894257.6072.10.camel@thinkpad>  <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>  <1231957184.13033.70.camel@thinkpad> 
 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>  <1232010853.6541.4.camel@thinkpad>  <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain> <1232067181.6134.74.camel@thinkpad>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Tim Blechmann wrote:
> > Hmm, that confuses the hell out of me. Can you try the patch below,
> > which restores the original code of writing the counter registers ?
> 
> no difference ... i must admit, i already spent some time, trying to
> revert the specific changes of this commit ... i gave up to wait for
> some help from someone, who actually knows how the code is working ...
> 
> possibly it makes sense to compile a full kernel of the first bad kommit
> and introduce the different changes one by one ... i will try to find
> some time for this during the next few days ...
> 
> but if you have more patches, that i can test, please let me know ...

Here is another one, which also reverts the counter reset code and
disables the cpuid(0xa) call. Can you verify that counters are set up
? Can you please provide me your .config ? What's your kernel command
line ?

Thanks,

	tglx
---
Subject: x86-oprofile-debug2.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Jan 2009 21:25:55 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/oprofile/op_model_ppro.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/op_model_ppro.c
+++ linux-2.6/arch/x86/oprofile/op_model_ppro.c
@@ -75,7 +75,7 @@ static void ppro_setup_ctrs(struct op_ms
 			return;
 	}
 
-	if (cpu_has_arch_perfmon) {
+	if (0 && cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
 		if (counter_width < eax.split.bit_width)
@@ -95,15 +95,15 @@ static void ppro_setup_ctrs(struct op_ms
 	for (i = 0; i < num_counters; ++i) {
 		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
 			continue;
-		wrmsrl(msrs->counters[i].addr, -1LL);
+		wrmsr(msrs->counters[i].addr, (u32) 0xFFFFFFFF, 0);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < num_counters; ++i) {
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
-			reset_value[i] = counter_config[i].count;
+			reset_value[i] = (1ULL << 32) - counter_config[i].count;
 
-			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
+			wrmsr(msrs->counters[i].addr, (u32) reset_value[i], 0);
 
 			CTRL_READ(low, high, msrs, i);
 			CTRL_CLEAR(low);
@@ -132,7 +132,7 @@ static int ppro_check_ctrs(struct pt_reg
 		rdmsrl(msrs->counters[i].addr, val);
 		if (CTR_OVERFLOWED(val)) {
 			oprofile_add_sample(regs, i);
-			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
+			wrmsr(msrs->counters[i].addr, (u32) reset_value[i], 0);
 		}
 	}
 
