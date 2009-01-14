Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbZANRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbZANRKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762450AbZANRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:10:40 -0500
Received: from www.tglx.de ([62.245.132.106]:34332 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZANRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:10:39 -0500
Date: Wed, 14 Jan 2009 18:10:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Blechmann <tim@klingt.org>
cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
In-Reply-To: <1230894257.6072.10.camel@thinkpad>
Message-ID: <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>  <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com> <1230894257.6072.10.camel@thinkpad>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

On Fri, 2 Jan 2009, Tim Blechmann wrote:
> On Fri, 2008-12-26 at 03:42 +0100, Andi Kleen wrote:
> > Tim Blechmann wrote:
> > >> i am experiencing an issue, similar to the one reported in
> > >> http://lkml.org/lkml/2008/10/30/319.
> > > 
> > > bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> > > (oprofile: Implement Intel architectural perfmon support) caused the
> > > problem. 
> > > oddly, the newly introduced api is not used, since the model struct is
> > > set during the ppro_init call ...
> > 
> > We're still investigating the problem. Thanks for the report.
> 
> btw, this issue still exists in tip/oprofile ... not sure, whether this
> may be related, but i am running the machine in 64-bit mode ...

can you please apply the patch below and provide the output ?

That's one of the subtle differences to the 2.6.27 code, where the
counter width is fixed to 32bit, which is correct anyway as the
counter MSRs can only write the lower 32bits and sign extend bit 31
according to intel documentation.

There are more subtle changes, but this is the most obvious one.

Thanks,

	tglx
---
 arch/x86/oprofile/op_model_ppro.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/op_model_ppro.c
+++ linux-2.6/arch/x86/oprofile/op_model_ppro.c
@@ -80,6 +80,8 @@ static void ppro_setup_ctrs(struct op_ms
 		eax.full = cpuid_eax(0xa);
 		if (counter_width < eax.split.bit_width)
 			counter_width = eax.split.bit_width;
+
+		printk(KERN_INFO "ppro counter_width: %d\n", counter_width);
 	}
 
 	/* clear all counters */
