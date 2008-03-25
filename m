Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYCYKkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYCYKkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYCYKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:40:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17125 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYCYKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:40:24 -0400
Date: Tue, 25 Mar 2008 11:39:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: corbet@lwn.net (Jonathan Corbet),
       Andrew Morton <akpm@linux-foundation.org>, stern@rowland.harvard.edu,
       mb@bu3sch.de, hmh@hmh.eng.br, david-b@pacbell.net, rpurdie@rpsys.net,
       linux-kernel@vger.kernel.org, mingo@elte.hu, geert@linux-m68k.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080325113942.06fe388b@hyperion.delvare>
In-Reply-To: <7vbq53mbh1.fsf@gitster.siamese.dyndns.org>
References: <20080324124229.5d49ded6.akpm@linux-foundation.org>
	<25897.1206388397@vena.lwn.net>
	<7vbq53mbh1.fsf@gitster.siamese.dyndns.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 01:52:58 -0700, Junio C Hamano wrote:
> corbet@lwn.net (Jonathan Corbet) writes:
> 
> > diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> > index 4982998..63a7782 100644
> > --- a/include/linux/hardirq.h
> > +++ b/include/linux/hardirq.h
> > @@ -72,6 +72,13 @@
> >  #define in_softirq()		(softirq_count())
> >  #define in_interrupt()		(irq_count())
> >  
> > +/*
> > + * Are we running in atomic context?  WARNING: this macro cannot
> > + * always detect atomic context; in particular, it cannot know about
> > + * held spinlocks in non-preemptible kernels.  Thus it should not be
> > + * used in the general case to determine whether sleeping is possible.
> > + * Do not use in_atomic() in driver code.
> > + */
> >  #define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
> >  
> >  #ifdef CONFIG_PREEMPT
> 
> Is it just me who feels this comment that says "in_atomic() is not a way
> to tell if we are in atomic reliably and cannot be used for such and such"
> very reader-unfriendly?  Ok, maybe the macro is not reliable and is not
> meant to be used for the purpose its name seems to suggest (at least to a
> non-kernel person).  An inevitable question is, then what is it good for?
> What's the right situation to use this macro?
> 
> I guess an additional comment "even if this says no, you could still be in
> atomic, but if this says yes, then you definitely are in atomic and cannot
> sleep" may help unconfuse a clueless reader like myself.

Andrew explained that in_atomic() could deadlock if called in a
condition where it is unreliable (although I did not understand the
details). Documenting that a "yes" from in_atomic() can always be
trusted, would invite driver authors to still use it, when my
understanding is that they still shouldn't.

If drivers shouldn't use in_atomic() at all then I think that the
long-term solution is to move its definition out of <linux/hardirq.h>.
But of course this means fixing all the drivers that still use it first.

-- 
Jean Delvare
