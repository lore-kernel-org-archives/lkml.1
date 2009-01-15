Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbZAOIqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbZAOIqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbZAOIqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:46:35 -0500
Received: from www.tglx.de ([62.245.132.106]:45152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761702AbZAOIqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:46:34 -0500
Date: Thu, 15 Jan 2009 09:46:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Blechmann <tim@klingt.org>
cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
In-Reply-To: <1231957184.13033.70.camel@thinkpad>
Message-ID: <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>  <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>  <1230894257.6072.10.camel@thinkpad>  <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain> <1231957184.13033.70.camel@thinkpad>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

On Wed, 14 Jan 2009, Tim Blechmann wrote:
> this code (line 81/82), changes counter_width from 32 to 40.
> 
> if (counter_width < eax.split.bit_width)
>         counter_width = eax.split.bit_width;
> 
> however when removing these lines, and thus keeping the value 32 for
> counter_width, doesn't change the behavior, only one NMI per cpu.

It would only help, when the reported bit_width would be bogus. We
know that you get at least one NMI, so lets look at the results we get
there.

Thanks,

	tglx
---
 arch/x86/oprofile/op_model_ppro.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/op_model_ppro.c
+++ linux-2.6/arch/x86/oprofile/op_model_ppro.c
@@ -126,11 +126,15 @@ static int ppro_check_ctrs(struct pt_reg
 	u64 val;
 	int i;
 
+	printk(KERN_INFO "ppro_check_ctrs\n");
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
+		printk(KERN_INFO "cntr %d: 0x%016lx\n", i, (unsigned long) val);
 		if (CTR_OVERFLOWED(val)) {
+			printk(KERN_INFO "cntr %d overflowed\n", i);
 			oprofile_add_sample(regs, i);
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 		}


