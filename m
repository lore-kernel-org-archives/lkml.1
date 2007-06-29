Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbXF2N5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbXF2N5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765031AbXF2N5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:57:48 -0400
Received: from mail.screens.ru ([213.234.233.54]:43971 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763610AbXF2N5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:57:47 -0400
Date: Fri, 29 Jun 2007 17:58:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070629135848.GA332@tv-sign.ru>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629131605.GA25964@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Ingo Molnar wrote:
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Yes, I think cinergyt2 is buggy.
> 
> > cinergyt2_release() does flush_scheduled_work() under cinergyt2->sem. 
> > flush_scheduled_work() hangs because cinergyt2_query_rc() waits for 
> > the same cinergyt2->sem.
> > 
> > ->disconnect_pending is used without any locks/barriers, perhaps this 
> > is the reason.

I misread cinergyt2_release, it checks !->disconnect_pending, so it is
very clear why cinergyt2_query_rc() tries to take the mutex.

> > I'll try to look further tomorrow. In any case, cinergyT2 should not 
> > use flush_scheduled_work() at all.
> 
> would the hack below be worth trying, to see whether there are any 
> further problems?
> 
> 	Ingo
> 
> Index: linux/drivers/media/dvb/cinergyT2/cinergyT2.c
> ===================================================================
> --- linux.orig/drivers/media/dvb/cinergyT2/cinergyT2.c
> +++ linux/drivers/media/dvb/cinergyT2/cinergyT2.c
> @@ -523,7 +523,6 @@ static int cinergyt2_release (struct ino
>  
>  	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
>  		cancel_delayed_work(&cinergyt2->query_work);
> -		flush_scheduled_work();
>  		cinergyt2_sleep(cinergyt2, 1);
>  	}

I don't think we can just kill flush_scheduled_work(). We can use
cancel_rearming_delayed_work() instead of
cancel_delayed_work()+flush_scheduled_work()

Still we can't do this under cinergyt2->sem, because cinergyt2_query()
takes it too. This all looks very wrong to me, I hope maintaners can
explain.

I think cinergyt2_query() and cinergyt2_query_rc() should not use
->disconnect_pending at all. cinergyt2_disconnect() should set
->disconnect_pending = 1 and cancel both delayed_works.

cinergyt2_release() checks !->disconnect_pending and does the cancel
without mutex.

Oleg.

