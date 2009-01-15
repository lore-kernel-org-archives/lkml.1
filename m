Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZAOKyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZAOKyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759147AbZAOKyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:54:25 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:53336 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763557AbZAOKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qPrCqRZ+T3LJzYcnGAU0TZPSZJKgRg10JdqNGlpFAVN8Kaqz0GlUsxCpcfXJbPOiSe
         cYba33K3tAx858NuNkv/3QR6YjB+DORYmYKEDyoA7mECvk/zP6LXUSjzh7rwMj6SmJSe
         CyjprbfUIvhNViyXku4xlLn+vHUydOeO0bibM=
Date: Thu, 15 Jan 2009 10:54:17 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Denys Fedoryschenko <denys@visp.net.lb>, Chris Caputo <ccaputo@alt.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115105417.GG5461@ff.dom.local>
References: <1231937404.14825.4.camel@laptop> <200901141505.46929.denys@visp.net.lb> <20090114131257.GC6117@ff.dom.local> <1231938929.14825.6.camel@laptop> <20090114132603.GD6117@ff.dom.local> <1231939946.14825.9.camel@laptop> <20090114141311.GA6643@ff.dom.local> <1231943283.14825.14.camel@laptop> <20090115090120.GE4190@ff.dom.local> <1232016408.8870.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232016408.8870.43.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:46:48AM +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-15 at 09:01 +0000, Jarek Poplawski wrote:
...
> > spin_lock
> > (not this hrtimer's anymore)
> > __remove_hrtimer
> > list_add_tail			enqueue_hrtimer
> > 
> 
> (looking at .28 code)
> 
> run_hrtimer_pending() reads like:
> 
> while (pending timers) {
>   __remove_hrtimer(timer, HRTIMER_STATE_CALLBACK);
>   spin_unlock(&cpu_base->lock);
> 
>   fn(timer);
> 
>   spin_lock(&cpu_base->lock);
>   timer->state &= ~HRTIMER_STATE_CALLBACK; // _should_ result in HRTIMER_STATE_INACTIVE
>   if (HRTIMER_RESTART)
>     re-queue
>   else if (timer->state != INACTIVE) {
>     // so another cpu re-queued this timer _while_ we were executing it.
>     if (timer is first && !reprogramm) {
>       __remove_hrtimer(timer, HRTIMER_STATE_PENDING);
>       list_add_tail(timer, &cb_pending);
>     }
>   } 
> }
> 
> So in the window where we drop the lock, one can, as you said, have
> another cpu requeue the timer, but the rb_entry and list_entry are free,
> so it should not cause the data corruption we're seeing.
> 

Can't they be enqueued to the list (without a lock) and rbtree at the
same time? Then removing is done for the list only?

Jarek P. 
