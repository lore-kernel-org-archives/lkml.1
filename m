Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYLBQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYLBQx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLBQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:53:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYLBQxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:53:18 -0500
Date: Tue, 2 Dec 2008 17:53:08 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] getrusage: fill ru_maxrss value
Message-ID: <20081202175308.5d9ca9f7@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081202160507.GA14524@redhat.com>
References: <20081202131802.5252b96d@psychotron.englab.brq.redhat.com>
	<20081202160507.GA14524@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 17:05:07 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/02, Jiri Pirko wrote:
> >
> > Based on the patch previously posted by Frank Mayhar:
> > http://kerneltrap.org/mailarchive/linux-kernel/2007/9/20/264772
> >
> > Changed to do not panic and to set the value properly. Also made some
> > modifications as Oleg suggested. maxrss value is set to pages as "time"
> > application converts it co KBs.
> >
> > This patch enables "time" application to show maxresident value
> > correctly.
> 
> I believe the changelog could be a bit more descriptive ;)
> And I think the patch needs more CCs. (Hugh and Michael cc'ed).
> 
> What about exec? Should we preserve signal_struct->maxrss, or should
> we reset it? I don't know what is the right behaviour, but imho it
> should be consistent with task_mem()/xacct_add_tsk(). And since
> bprm_mm_init() does not copy ->hiwater_xxx, perhaps we should reset.
> Or we should change the exec_mmap() path to preserve ->hiwater_xxx,
> I dunno.
> 
> > Note that even without this patch applied there is a race between two
> > parallel update_hiwater_rss() callers.
> >
> > [...snip...]
> > @@ -1051,6 +1051,8 @@ NORET_TYPE void do_exit(long code)
> >  	if (tsk->mm) {
> >  		update_hiwater_rss(tsk->mm);
> >  		update_hiwater_vm(tsk->mm);
> > +
> > +		tsk->signal->maxrss = tsk->mm->hiwater_rss;
> 
> Yes. But still it is not good the patch adds new racy calls
> (k_getrusage() too). And in fact I think this code in do_exit()
> should die, and we can update signal->maxrss in exit_mm().
> 
> Unless I missed something, the "if (tsk->mm) {}" code in
> do_exit() is not needed because xacct_add_tsk() is not right
> anyway. What we imho need is get_mm_hiwater_xxx(), can be
> also used by task_mm().
> 
> I'll send the patch a bit later, then we can tweak this patch.
> 
> Do you agree?
Okay.

Jirka
> 
> (just in case, I don't mean that mm/ uses update_hiwater_xxx()
>  "safely", afaics try_to_unmap can race with unmap_region
>  for example, but still).
> 
> Oleg.
> 
