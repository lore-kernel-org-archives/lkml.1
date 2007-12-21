Return-Path: <linux-kernel-owner+w=401wt.eu-S1765997AbXLUApH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765997AbXLUApH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765713AbXLUAos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:44:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765702AbXLUAor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:44:47 -0500
Date: Fri, 21 Dec 2007 01:44:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-ID: <20071221004416.GA15922@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org> <20071220145415.f737e7f3.akpm@linux-foundation.org> <20071220234759.GA29776@elte.hu> <20071220161934.0f55029a.akpm@linux-foundation.org> <20071221003035.GA10123@elte.hu> <20071220164000.58c43b42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220164000.58c43b42.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +		raw_local_irq_save(flags);
> >  		__raw_spin_lock(&die.lock);
> > -		raw_local_save_flags(flags);
> >  		die.lock_owner = smp_processor_id();
> >  		die.lock_owner_depth = 0;
> >  		bust_spinlocks(1);
> > -	}
> > -	else
> > -		raw_local_save_flags(flags);
> > +	} else
> > +		raw_local_irq_save(flags);
> >  
> >  	if (++die.lock_owner_depth < 3) {
> >  		unsigned long esp;
> 
> Looks sane.
> 
> I suppose there's some reason why we can't just use 
> spin_lock_irqsave(). But that reason was either so obvious or so 
> unimportant that a comment was not needed.  Sigh.

bug was introduced via:

  commit 39743c9ef717fd4f2b5583f010115c5f2482b8ae
  Author: Andi Kleen <ak@suse.de>
  Date:   Fri Oct 19 20:35:03 2007 +0200

      x86: use raw locks during oopses

-               spin_lock_irqsave(&die.lock, flags);
+               __raw_spin_lock(&die.lock);
+               raw_local_save_flags(flags);

that is not a correct open-coding of spin_lock_irqsave(): both the 
ordering is wrong (irqs should be disabled _first_), and the wrong 
flags-saving API was used.

so this is a post-2.6.23 regression and the fix is (now) obvious.

	Ingo
