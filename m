Return-Path: <linux-kernel-owner+w=401wt.eu-S934878AbZAOVFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878AbZAOVFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933733AbZAOUhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:37:36 -0500
Received: from www.tglx.de ([62.245.132.106]:52053 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbZAOUhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:37:34 -0500
Date: Thu, 15 Jan 2009 21:37:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Blechmann <tim@klingt.org>
cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
In-Reply-To: <1232010853.6541.4.camel@thinkpad>
Message-ID: <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>  <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>  <1230894257.6072.10.camel@thinkpad>  <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>  <1231957184.13033.70.camel@thinkpad> 
 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain> <1232010853.6541.4.camel@thinkpad>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Tim Blechmann wrote:
> On Thu, 2009-01-15 at 09:46 +0100, Thomas Gleixner wrote:
> > Tim,
> > 
> > On Wed, 14 Jan 2009, Tim Blechmann wrote:
> > > this code (line 81/82), changes counter_width from 32 to 40.
> > > 
> > > if (counter_width < eax.split.bit_width)
> > >         counter_width = eax.split.bit_width;
> > > 
> > > however when removing these lines, and thus keeping the value 32 for
> > > counter_width, doesn't change the behavior, only one NMI per cpu.
> > 
> > It would only help, when the reported bit_width would be bogus. We
> > know that you get at least one NMI, so lets look at the results we get
> > there.
> 
> it seems, that ppro_check_ctrs is never called:
> [  982.238639] oprofile: using NMI interrupt.
> 
> hth, tim

Hmm, that confuses the hell out of me. Can you try the patch below,
which restores the original code of writing the counter registers ?

Thanks,

	tglx
---
Subject: x86-oprofile-debug2.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Jan 2009 21:25:55 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/oprofile/op_model_ppro.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/op_model_ppro.c
+++ linux-2.6/arch/x86/oprofile/op_model_ppro.c
@@ -101,9 +101,9 @@ static void ppro_setup_ctrs(struct op_ms
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
 
