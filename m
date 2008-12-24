Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbYLXRor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbYLXRor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 12:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYLXRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 12:44:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46484 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYLXRoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 12:44:37 -0500
Date: Wed, 24 Dec 2008 18:42:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH, RESEND3] getrusage: fill ru_maxrss value
Message-ID: <20081224174248.GA15887@redhat.com>
References: <20081218135945.4f8b87ed@psychotron.englab.brq.redhat.com> <20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Jiri Pirko wrote:
>
> On Wed, 24 Dec 2008 16:37:55 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
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

Well, I don't understand the explanation above, but I agree with the
code ;)

parent process's sig->cmaxrss, like other parent->signal->cxxxx fields
should only be changed by wait_task_zombie(), ->cmaxrss is not special.

The real question is why do we clear sig->maxrss on exec. Again, I agree
with the patch because this is consistent with xacct_add_tsk/etc, but
it is not clear to me whether this right or not.

Yes, technically this is right because we have the new ->mm after exec,
but this is "transparent" for the user-space. For example, we don't
clear ->min_flt on exec...

Perhaps it makes sense to change the bprm_mm_init's path to do

	if (!PF_FORKNOEXEC)
		new_mm->hiwater_xxx = old_mm->hiwater_xxx;

But once again, imho the patch does the right thing for now.

> > >  	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
> > >  	unsigned long inblock, oublock, cinblock, coublock;
> > >  	struct task_io_accounting ioac;
> > > +	unsigned long maxrss, cmaxrss;
> >
> > 	unsigned long inblock, oublock, cinblock, coublock;
> > 	unsigned long maxrss, cmaxrss;
> > 	struct task_io_accounting ioac;
> >
> > is better.
> > I like related member sit on nearly place.
> No problem with this.

Agreed.

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

I have no problem with get_task_mm() too, the optimization is minor.

(btw, that is why I didn't like the fact we discussed this patch privately,
 imho it is always better to do on lkml).

> > > +	r->ru_maxrss <<= PAGE_SHIFT - 10;
> > >  }
> >
> > using local variable is better because local variable can stay on
> > register by compiler easily, but indirect access doesn't.
> OK

Not that I have a strong opinion, but the code looks simpler without
the local var. Up to you.

> > and we need good comment. e.g. /* Convert to KB */
> > or good macros (likely linux/fs/proc/meminfo.c::K() macro)

Yes! Please ;) I just can't parse the code above, I am not compiler.
Even

	r->ru_maxrss *= (PAGE_SIZE / 1024); /* convert pages to KBs */

is much better, imho. Or at least just add the comment, so the
poor reader can understand what the code does without parsing.

> > In addision, you also need change man pages and notice to linux-api mailing list.
> I cc'ed this list while I was sending the patch.

Hmm. The biggest mistake with this patch is that you lost the
CC list completely ;) Adding Hugh.

> I was not aware I
> should change the man page. Will do that too.

Well. I don't think you must change the man page. Of course it
would be nice if you do, but in a separate patch please. But
you must cc Michael at least ;)

Oleg.

