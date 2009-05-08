Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZEHJKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZEHJKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbZEHJKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:10:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60833 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZEHJKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:10:34 -0400
Date: Fri, 8 May 2009 11:10:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86 MCE: shut up lockdep warning
Message-ID: <20090508091015.GA2038@elte.hu>
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com> <20090508064517.GX23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508064517.GX23223@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, May 08, 2009 at 11:47:09AM +0800, Shaohua Li wrote:
> > lockdep report below warning when I try to offline one cpu:
> > [  110.835487] =================================
> > [  110.835616] [ INFO: inconsistent lock state ]
> > [  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
> > [  110.835757] ---------------------------------
> > [  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> > [  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > [  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b
> > 
> > smp_call_function_single() will disable interrupt. moving mce reenable/disable
> > to workqueue, so no irq is disabled.
> 
> Looks good. Thanks.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>

The report is useful, but the fix does not look good at all, and you 
should never have acked it:

 - it works around a lockdep warning

 - you did not realize the real bug while the warning was plain

 - plus the patch introduces a fragile (because complex)
   work_on_cpu() call into the CPU hotplug path, which could have 
   caused followup regressions.

Please also Cc: the relevant upstream subsystem maintainers in such 
cases (the x86 maintaiers in this case).

Thanks,

	Ingo
