Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYKNRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYKNRBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKNRBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:01:36 -0500
Received: from aun.it.uu.se ([130.238.12.36]:34399 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYKNRBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:01:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18717.44751.459961.277998@harpo.it.uu.se>
Date: Fri, 14 Nov 2008 18:01:03 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: Oprofile : need to adjust PC by 16 bytes
In-Reply-To: <491D987F.1000301@cosmosbay.com>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz>
	<20081113212446.GA5694@elte.hu>
	<alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
	<20081113213744.GA8429@elte.hu>
	<491CA0DC.8070405@cosmosbay.com>
	<491D987F.1000301@cosmosbay.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet writes:
 > Very strange results on my Intel E5450 CPU
 > 
 > I found that I have to bias regs->ip by 16 bytes in order to have
 > correct profiling.
 > 
 > Does it rings a bell to anyone ?

The term is "skid". All OO processors are susceptible to it,
as was known already to the Alpha "continous profiling"
performance counter folks.

And no, blindly subtracting 16 from IP is not a fix.

 > 
 > opcontrol --version
 > opcontrol: oprofile 0.9.4 compiled on Nov  3 2008 06:45:57
 > 
 > Thank you
 > 
 > diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
 > index 3f1b81a..051fb16 100644
 > --- a/arch/x86/oprofile/op_model_ppro.c
 > +++ b/arch/x86/oprofile/op_model_ppro.c
 > @@ -131,7 +131,9 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 >                         continue;
 >                 rdmsrl(msrs->counters[i].addr, val);
 >                 if (CTR_OVERFLOWED(val)) {
 > +                       regs->ip -= 0x10;
 >                         oprofile_add_sample(regs, i);
 > +                       regs->ip += 0x10;
 >                         wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 >                 }
 >         }
 > 
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 > 
