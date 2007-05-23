Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbXEWGUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbXEWGUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbXEWGUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:20:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbXEWGUe (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:20:34 -0400
Date: Wed, 23 May 2007 08:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       LKML <Linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LOCKDEP: possible irq lock inversion dependency detected
Message-ID: <20070523062023.GA26814@elte.hu>
References: <1179879569.25500.74.camel@sx.thebigcorporation.com> <1179893180.12708.145.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179893180.12708.145.camel@chaos>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Hmm. That's the code in question:
> 
> void __init timekeeping_init(void)                                                                                                                    
> {                                                                                                                                                     
>         unsigned long flags;                                                                                                                          
>         unsigned long sec = read_persistent_clock();                                                                                                  
>                                                                                                                                                       
>         write_seqlock_irqsave(&xtime_lock, flags);  
> 
> The rtc_lock is never taken inside the xtime_lock.
> 
> Looks like code reordering due to gcc extra magic. Which compiler ?

i dont think it's due to code reordering. The code that lockdep flagged 
is the new code in arch/i386/kernel/bootflag.c, sbf_read() and 
sbf_write(). It does:

                spin_lock_irqsave(&rtc_lock, flags);
                CMOS_WRITE(v, sbf_port);
                spin_unlock_irqrestore(&rtc_lock, flags);

and:

        spin_lock_irqsave(&rtc_lock, flags);
        v = CMOS_READ(sbf_port);
        spin_unlock_irqrestore(&rtc_lock, flags);

and is apparently called with the xtime_lock held. Was that code ever 
booted with CONFIG_PROVE_LOCKING enabled?

	Ingo
