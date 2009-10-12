Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZJLMKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZJLMKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZJLMKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:10:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbZJLMKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:10:51 -0400
Date: Mon, 12 Oct 2009 14:09:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012120951.GA16799@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com> <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012140149.6789efab@marrow.netinsight.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> (Risking that Artem also replies, I'll bite on this one! Let's hope we
> agree at least :-))
> 
> On Mon, 12 Oct 2009 13:37:58 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > -       if (mtd->panic_write && in_interrupt())
> > > +       if (mtd->panic_write && (in_interrupt() || panic_on_oops))
> > >                 /* Interrupt context, we're going to panic so try and log */
> > >                 mtdoops_write(cxt, 1);
> > 
> > Hm, the code seems to be somewhat confused about this. It tries to guess 
> > when it's panic-ing, right? in_interrupt() is the wrong test for that.
> 
> Well, the main reason is to get the write done directly if we know 
> we're going to crash. The rest of the code around the patch looks like 
> this:
> 
>          if (mtd->panic_write && (in_interrupt() || panic_on_oops))
>                  /* Interrupt context, we're going to panic so try and log */
>                  mtdoops_write(cxt, 1);
>          else
>                  schedule_work(&cxt->work_write);
> 
> so if we're oopsing in interrupt context or are going to panic, we 
> just write directly. mtdoops_write will then use mtd->panic_write if 
> it's available to get the write done immediately without sleeping.

but i'm not sure that code achieves your intention.

in_interrupt() is a generic test. It will be true whenever you printk in 
irq context - be that a panic or not a panic.

Also, the panic_on_oops usage looks wrong as well: it is set on a system 
that wants a panic on oops - but the flag will be set all the time, even 
when we are not oopsing.

I suppose the intention is to add a logic like this:

 - buffer writes to the MTD async writeout thread for regular printks

 - if we are in some sort of emergency, write to the MTD device directly 
   as we cannot buffer anymore.

Correct?

> [...]
>
> To handle the panic case, I've simply added a panic notifier which 
> does
> 
>   static int mtdoops_panic(struct notifier_block *this, unsigned long event,
> 		void *ptr)
>   {
> 	struct mtdoops_context *cxt = &oops_cxt;
> 
> 	cancel_work_sync(&cxt->work_write);
> 	cxt->ready = 0;
> 	if (cxt->mtd->panic_write)
> 		mtdoops_write(cxt, 1);
> 	else
> 		printk(KERN_WARNING "mtdoops: panic_write is not defined, "
> 					"cannot store dump from panic\n");
> 
> 	return NOTIFY_DONE;
>   }
> 
> So with this one, the exported panic_on_oops is no longer needed, and 
> normal oopses are handled by the scheduled work while panic_on_oopses 
> are handled by the panic handler.

Yes, that looks like the better direction - but 'panic' is still the 
wrong trigger condition i think. We generally just crash and dont panic. 
Often we'll display a kernel warning and then hang. Etc.

Also, would it be possible to just simplify the thing and not do any 
buffering at all? Extra buffering complexity in a console driver is only 
asking for trouble. Or is flash storage write cycles optimization that 
important in this case?

	Ingo
