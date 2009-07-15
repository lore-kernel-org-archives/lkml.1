Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZGOCCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZGOCCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGOCCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:02:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57505 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZGOCCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:02:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
In-Reply-To: <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
References: <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
Message-Id: <20090715104920.39A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Jul 2009 11:01:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 14, 2009 at 6:05 PM, Rik van Riel<riel@redhat.com> wrote:
> > After moving the oom_adj value from the task struct to the
> > mm_struct, the oom_adj value was no longer properly inherited
> > by child processes.
> >
> > Copying over the oom_adj value at fork time fixes that bug.
> >
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > Reported-by: Paul Menage <manage@google.com>
> > ---
> > Paul, does this fix your bug?
> 
> It fixes that specific problem. (Although the patch title should
> probably be "copy over oom_adj value at execve time")

AFAIK mm_init() is called from both fork() and execve().


> But ironically, with this fix applied the main part of the original
> change (force all threads in a process to share a single oom_adj
> value) will start to break my code - it's no longer possible to have
> the regular threads in a process be oom-immune, then vfork() and set a
> non-disabled oom_adj in the child, since this will set it for the
> entire process. (Our job scheduler does something like this, in order
> to have the launcher be OOM immune and the running jobs be at various
> oom_adj levels depending on their priority).

Fair point.
Nobody want per-thread oom_adj, but your vfork() issue seems real regression.

David, can we make more clever implementation?

> 
> It's probably something that I can work around, but it seems like the
> kind of API change that could break unsuspecting users.
> 
> Paul
> 
> >
> >  kernel/fork.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > Index: mmotm/kernel/fork.c
> > ===================================================================
> > --- mmotm.orig/kernel/fork.c    2009-07-14 20:58:01.000000000 -0400
> > +++ mmotm/kernel/fork.c 2009-07-14 21:00:40.000000000 -0400
> > @@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct
> >        init_rwsem(&mm->mmap_sem);
> >        INIT_LIST_HEAD(&mm->mmlist);
> >        mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
> > +       mm->oom_adj = current->mm->oom_adj;
> >        mm->core_state = NULL;
> >        mm->nr_ptes = 0;
> >        set_mm_counter(mm, file_rss, 0);
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



