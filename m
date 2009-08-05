Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbZHECvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbZHECvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933373AbZHECve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:51:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49457 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337AbZHECvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:51:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090805114004.459a7deb.minchan.kim@barrios-desktop>
References: <20090805110107.5B97.A69D9226@jp.fujitsu.com> <20090805114004.459a7deb.minchan.kim@barrios-desktop>
Message-Id: <20090805114650.5BA1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 11:51:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed,  5 Aug 2009 11:29:34 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > Hi, Kosaki. 
> > > 
> > > I am so late to invole this thread. 
> > > But let me have a question. 
> > > 
> > > What's advantage of placing oom_adj in singal rather than task ?
> > > I mean task->oom_adj and task->signal->oom_adj ?
> > > 
> > > I am sorry if you already discussed it at last threads. 
> > 
> > Not sorry. that's very good question.
> > 
> > I'm trying to explain the detailed intention of commit 2ff05b2b4eac
> > (move oom_adj to mm_struct).
> > 
> > In 2.6.30, OOM logic callflow is here.
> > 
> > __out_of_memory
> > 	select_bad_process		for each task
> > 		badness			calculate badness of one task
> > 	oom_kill_process		search child
> > 		oom_kill_task		kill target task and mm shared tasks with it
> > 
> > example, process-A have two thread, thread-A and thread-B and it 
> > have very fat memory.
> > And, each thread have following likes oom property.
> > 
> > 	thread-A: oom_adj = OOM_DISABLE, oom_score = 0
> > 	thread-B: oom_adj = 0,           oom_score = very-high
> > 
> > Then, select_bad_process() select thread-B, but oom_kill_task refuse
> > kill the task because thread-A have OOM_DISABLE.
> > __out_of_memory() call select_bad_process() again. but select_bad_process()
> > select the same task. It mean kernel fall in the livelock.
> > 
> > The fact is, select_bad_process() must select killable task. otherwise
> > OOM logic go into livelock.
> > 
> > Is this enough explanation? thanks.
> > 
> 
> Thanks for good explanation. :)
> 
> It resulted from patch of David which moved task_struct->oom_ajd 
> to mm_struct. I understood it. 

No. It's very old problem. David's patch fixed it. 
It mean per-process oom_adj prevent select_bad_process() return
a task in unkillable process.

unfortunatelly, his patch can't treat vfork case ideally. I hope to
fix it.

> It meant oom_adj was not per-process.
> 
> AFAIU, you want to make oom_adj per-process, again. 
> And you selected the place with task->singal as per-process.
> 
> What I have a question is that why do you select task_struct->signal 
> rather than task_struct like old?
> 
> What's benefit of using task_struct->signal ?

prior Davied patch (task->oom_adj) might makes livelock.



