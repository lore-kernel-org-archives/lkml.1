Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZGJPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZGJPuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZGJPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:50:42 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:48616 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZGJPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v5qkZzoUCUYNKkGtjdJhh0NQdsEvpiiPdhl9VtV0EFynZTJitlIEVGqdplEeBdebTR
         bZSZ4fsXyiYASMaXP319tW8CEo+ZBj27s2rSoeNYpmm1p5hqx4MCE2dfM6vU818fHnUs
         cIlPr/z1wVrgPtLMj0fPAOf51k0Ir7ddXdSXQ=
Date: Fri, 10 Jul 2009 17:50:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from
	cond_resched()
Message-ID: <20090710155037.GC5318@nowhere>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <200907101717.39460.arnd@arndb.de> <20090710152425.GB5318@nowhere> <200907101735.29463.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907101735.29463.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 05:35:29PM +0200, Arnd Bergmann wrote:
> On Friday 10 July 2009, Frederic Weisbecker wrote:
> > On Fri, Jul 10, 2009 at 05:17:38PM +0200, Arnd Bergmann wrote:
> > > On Friday 10 July 2009, Frederic Weisbecker wrote:
> > > > --- a/kernel/sched.c
> > > > +++ b/kernel/sched.c
> > > > @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
> > > >          * PREEMPT_ACTIVE, which could trigger a second
> > > >          * cond_resched() call.
> > > >          */
> > > > -       do {
> > > > -               add_preempt_count(PREEMPT_ACTIVE);
> > > > -               schedule();
> > > > -               sub_preempt_count(PREEMPT_ACTIVE);
> > > > -       } while (need_resched());
> > > > +       add_preempt_count(PREEMPT_ACTIVE);
> > > > +       schedule();
> > > > +       sub_preempt_count(PREEMPT_ACTIVE);
> > > >  }
> > > >  
> > > 
> > > If you drop the loop, then you should also remove the comment that
> > > explains why it was put there.
> > > 
> > 
> > Hmm, these comments seem to actually explain why we do the PREEMPT_ACTIVE
> > trick, which is to prevent from cond_resched() recursion, right?
> > 
> 
> I think we both misinterpreted the comment, which seemed to refer
> to older code added by Ingo in 5bbcfd900 "cond_resched(): fix bogus
> might_sleep() warning" and removed by Andrew in e7b384043e2
> "cond_resched() fix".
> 
> The original code in Ingos version looked like
> 
>  static inline void __cond_resched(void)
>  {
>        /*
>         * The BKS might be reacquired before we have dropped
>         * PREEMPT_ACTIVE, which could trigger a second
>         * cond_resched() call.
>         */
>        if (unlikely(preempt_count()))
>                return;
>        do {
>                add_preempt_count(PREEMPT_ACTIVE);
>                schedule();
> 	...
> 
> 
> So, it's got nothing to do with the loop, but should still be removed
> because the 'if (unlikely(preempt_count()))' is no longer there.


Yeah, but the comment still fits the code after this patch, don't you think? :-)

