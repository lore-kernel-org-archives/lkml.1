Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbYLYEqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbYLYEqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 23:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYLYEqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 23:46:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56559 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYLYEqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 23:46:22 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH, RESEND3] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       <oleg@redhat.com>, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
References: <20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
Message-Id: <20081225113334.5A8A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 13:46:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Dec 2008 16:37:55 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> Hi yourself.
> > 
> > > diff --git a/fs/exec.c b/fs/exec.c
> > > index ec5df9a..8d3d0f9 100644
> > > --- a/fs/exec.c
> > > +++ b/fs/exec.c
> > > @@ -870,6 +870,7 @@ static int de_thread(struct task_struct *tsk)
> > >  	sig->notify_count = 0;
> > >  
> > >  no_thread_group:
> > > +	sig->maxrss = 0;
> > >  	exit_itimers(sig);
> > >  	flush_itimer_signals();
> > >  	if (leader)
> > 
> > I don't know getrusage correct behavior so detail.
> > Why don't update parent process's sig->cmaxrss ?
> Because exec affects only this task and we want to forgot maxrss value.
> That does not implicate that we want to forgot highest maxrss value of
> our childs because exec does not affect them. I think this is right
> behavior.

Hmm, "we want" is a bit ambiguously word.
We have three reviewing viewpoint.

1) this code is consistent to other linux kernel code.

this patch fill its requrement perfectly.

2) the behavior is enough surpriseless?

Honestly, I think this patch is a bit supriseful.
example,

  1. process-A fork process-B
  2. process-A wait by wait4()
  3. process-B consume 1GB memory
  4. process-B exec another program
  5. process-B consume 100KB memory
  6. process-B exit
  7. process-A get maxrss=100KB

oh, 1GB consumption is disappeared.


However, if we choice process don't forget maxrss at exec,
another supriseful happend.
example,

  1. process-A consume 1GB memroy
  2. process-A fork process-B
  3. process-A wait by wait4()
  4. right after, process-B exec another program
  5. process-B consume 100KB memory
  6. process-B exit
  7. process-A get maxrss=1GB

oh, this design cause large process can't get child maxrss.


So either choice have both merits and demerits.
Then, I suggest to take prior other os compatibility than own thinking
good behavior.


3) if the feature is other os compatibility feature, the bahavior is
   the same other?

I think most important thing.
Some scripting language (e.g. perl, PHP) already can use getrusage()
return value. (but linux maxrss is always 0)
Any scripter don't like incompatibility behavior.

I don't know other os maxrss inheriting rule.
May I ask you investiate maxrss inheriting of exec of which os behavior?



> > > @@ -1598,6 +1601,18 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
> > >  out:
> > >  	cputime_to_timeval(utime, &r->ru_utime);
> > >  	cputime_to_timeval(stime, &r->ru_stime);
> > > +
> > > +	if (who != RUSAGE_CHILDREN) {
> > > +		task_lock(p);
> > > +		if (p->mm) {
> > > +			unsigned long maxrss = get_mm_hiwater_rss(p->mm);
> > > +
> > > +			if (r->ru_maxrss < maxrss)
> > > +				r->ru_maxrss = maxrss;
> > > +		}
> > > +		task_unlock(p);
> > 
> > get_task_mm() and mmput() instead task_lock() is better?
> Maybe it's better looking. I wanted to use these too. Oleg suggested to
> optimize the way it is in the patch. I can change it, no problem.

hm, performance is obiously important.
if you get much performance improvement, I'll withdraw my claim.


> > and, why don't this code move to "case RUSAGE_SELF" processing point?
> Because we need this to be done for RUSAGE_THREAD too. Or don't we?

Ah, I forgot RUSAGE_THREAD. thanks.
However I still think current code have unnecessary assumption.

if who==RUSAGE_BOTH,

correct behavior: max(hiwater_rss, mm_rss) + signal->cmaxrss)
this code:        max(signal->maxrss + signal->cmaxrss, max(hiwater_rss, mm_rss))

  1. if mm_rss == hiwater_rss, above two code is equivalent.
  2. if signal->maxrss == 0, above two code is equivalent too.

So all current caller keep this two assumption. but I think it is 
unnecessary assumption. imho we can write generic correct code.



