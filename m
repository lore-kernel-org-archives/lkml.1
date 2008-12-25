Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYLYOo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYLYOo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLYOov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:44:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49683 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYLYOou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:44:50 -0500
Date: Thu, 25 Dec 2008 15:43:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH, RESEND3] getrusage: fill ru_maxrss value
Message-ID: <20081225144300.GA14659@redhat.com>
References: <20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com> <20081225113334.5A8A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225113334.5A8A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25, KOSAKI Motohiro wrote:
>
> > On Wed, 24 Dec 2008 16:37:55 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > @@ -870,6 +870,7 @@ static int de_thread(struct task_struct *tsk)
> > > >  	sig->notify_count = 0;
> > > >  
> > > >  no_thread_group:
> > > > +	sig->maxrss = 0;
> > > >  	exit_itimers(sig);
> > > >  	flush_itimer_signals();
> > > >  	if (leader)
> > > 
> > > I don't know getrusage correct behavior so detail.
> > > Why don't update parent process's sig->cmaxrss ?
> > Because exec affects only this task and we want to forgot maxrss value.
> > That does not implicate that we want to forgot highest maxrss value of
> > our childs because exec does not affect them. I think this is right
> > behavior.
> 
> Hmm, "we want" is a bit ambiguously word.
> We have three reviewing viewpoint.
> 
> 1) this code is consistent to other linux kernel code.
> 
> this patch fill its requrement perfectly.
> 
> 2) the behavior is enough surpriseless?
> 
> Honestly, I think this patch is a bit supriseful.
> example,
> 
>   1. process-A fork process-B
>   2. process-A wait by wait4()
>   3. process-B consume 1GB memory
>   4. process-B exec another program
>   5. process-B consume 100KB memory
>   6. process-B exit
>   7. process-A get maxrss=100KB
> 
> oh, 1GB consumption is disappeared.

Yes, and I also think this is not right.

But this has nothing to do with parent->signal->cmaxrss, the question
is why we lost the info.

And please note we have the same problem with xacct_add_tsk(), that
is why I think this patch is right _for now_, but see below.

> However, if we choice process don't forget maxrss at exec,
> another supriseful happend.
> example,
> 
>   1. process-A consume 1GB memroy
>   2. process-A fork process-B
>   3. process-A wait by wait4()
>   4. right after, process-B exec another program
>   5. process-B consume 100KB memory
>   6. process-B exit
>   7. process-A get maxrss=1GB
> 
> oh, this design cause large process can't get child maxrss.

Even simpler. If we never reset marxrss, we start inherit this
value from /sbin/init which is obviously wrong.

That is why I suggested to change bprm_mm_init's path to keep
mm->hiwater_xxx but only if !PF_FORKNOEXEC (and in that case
we must kill "sig->maxrss = 0" from de_thread()).

What do you think?

> if who==RUSAGE_BOTH,

Ah. I forgot to mention what the code does to discuss...

> correct behavior: max(hiwater_rss, mm_rss) + signal->cmaxrss)

I disagree. This doesn't look correct to me. ->maxrss is a maximum,
we shouldn't report the sum.

> this code:        max(signal->maxrss + signal->cmaxrss, max(hiwater_rss, mm_rss))

Afaics, no. this code reports

	max(signal->cmaxrss, max(signal->maxrss, get_mm_hiwater_rss())

and this looks right to me.

But I agree, this is debateable.

Oleg.

