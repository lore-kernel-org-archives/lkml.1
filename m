Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYLPP4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYLPP4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYLPPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:55:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55926 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061AbYLPPzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:55:35 -0500
Date: Tue, 16 Dec 2008 16:54:56 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       jlim@sgi.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH, RESEND] getrusage: fill ru_maxrss value
Message-ID: <20081216165456.347e5355@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081216152054.GA17012@redhat.com>
References: <20081216155641.1411f8a7@psychotron.englab.brq.redhat.com>
	<20081216152054.GA17012@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 16:20:54 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/16, Jiri Pirko wrote:
> >
> > This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> > rss hiwater mark. This struct is filled as a parameter to
> > getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> > as "time" application converts it to KBs.
> >
> > To make this happen we extend struct signal_struct by two fields. The
> > first one is ->maxrss which we use to store rss hiwater of the task. The
> > second one is ->cmaxrss which we use to store highest rss hiwater of all
> > task childs. These values are used in k_getrusage() to actually fill
> > ->ru_maxrss. k_getrusage() uses current rss hiwater value directly
> > if mm struct exists.
> >
> > We clear the ->maxrss as a part of flush_old_exec() to be consistent
> > because bprm_mm_init() does not copy ->hiwater_rss.
> 
> Imho the patch is fine, but
> 
> > @@ -1598,6 +1601,15 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
> >  out:
> >  	cputime_to_timeval(utime, &r->ru_utime);
> >  	cputime_to_timeval(stime, &r->ru_stime);
> > +
> > +	task_lock(p);
> > +	if (p->mm) {
> > +		unsigned long maxrss = get_mm_hiwater_rss(p->mm);
> > +
> > +		if (r->ru_maxrss < maxrss)
> > +			r->ru_maxrss = maxrss;
> > +	}
> > +	task_unlock(p);
> 
> I think the code above should check "if (who != RUSAGE_CHILDREN) ?
Yes of course it should. Sorry I missed that :/ Will do new patch.
> 
> Oleg.
> 
