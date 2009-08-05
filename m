Return-Path: <linux-kernel-owner+w=401wt.eu-S933561AbZHEGxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbZHEGxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbZHEGxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:53:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42416 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbZHEGxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:53:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090805153701.b4f4385e.minchan.kim@barrios-desktop>
References: <20090805150323.2624a68f.kamezawa.hiroyu@jp.fujitsu.com> <20090805153701.b4f4385e.minchan.kim@barrios-desktop>
Message-Id: <20090805154759.5BC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 15:53:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 5 Aug 2009 15:03:23 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Wed, 5 Aug 2009 14:55:16 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> > 
> > > On Wed,  5 Aug 2009 11:51:31 +0900 (JST)
> > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > 
> > > > > On Wed,  5 Aug 2009 11:29:34 +0900 (JST)
> > > > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > > 
> > > > > > Hi
> > > > > > 
> > > > > > > Hi, Kosaki. 
> > > > > > > 
> > > > > > > I am so late to invole this thread. 
> > > > > > > But let me have a question. 
> > > > > > > 
> > > > > > > What's advantage of placing oom_adj in singal rather than task ?
> > > > > > > I mean task->oom_adj and task->signal->oom_adj ?
> > > > > > > 
> > > > > > > I am sorry if you already discussed it at last threads. 
> > > > > > 
> > > > > > Not sorry. that's very good question.
> > > > > > 
> > > > > > I'm trying to explain the detailed intention of commit 2ff05b2b4eac
> > > > > > (move oom_adj to mm_struct).
> > > > > > 
> > > > > > In 2.6.30, OOM logic callflow is here.
> > > > > > 
> > > > > > __out_of_memory
> > > > > > 	select_bad_process		for each task
> > > > > > 		badness			calculate badness of one task
> > > > > > 	oom_kill_process		search child
> > > > > > 		oom_kill_task		kill target task and mm shared tasks with it
> > > > > > 
> > > > > > example, process-A have two thread, thread-A and thread-B and it 
> > > > > > have very fat memory.
> > > > > > And, each thread have following likes oom property.
> > > > > > 
> > > > > > 	thread-A: oom_adj = OOM_DISABLE, oom_score = 0
> > > > > > 	thread-B: oom_adj = 0,           oom_score = very-high
> > > > > > 
> > > > > > Then, select_bad_process() select thread-B, but oom_kill_task refuse
> > > > > > kill the task because thread-A have OOM_DISABLE.
> > > > > > __out_of_memory() call select_bad_process() again. but select_bad_process()
> > > > > > select the same task. It mean kernel fall in the livelock.
> > > > > > 
> > > > > > The fact is, select_bad_process() must select killable task. otherwise
> > > > > > OOM logic go into livelock.
> > > > > > 
> > > > > > Is this enough explanation? thanks.
> > > > > > 
> > > 
> > > The problem resulted from David patch.
> > > It can solve live lock problem but make a new problem like vfork problem. 
> > > I think both can be solved by different approach. 
> > > 
> > > It's just RFC. 
> > > 
> > > If some process is selected by OOM killer but it have a child of OOM immune,
> > > We just decrease point of process. It can affect selection of bad process. 
> > > After some trial, at last bad score is drastically low and another process is 
> > > selected by OOM killer. So I think Live lock don't happen. 
> > > 
> > > New variable adding in task struct is rather high cost. 
> > > But i think we can union it with oomkilladj 
> > > since oomkilladj is used to present just -17 ~ 15. 
> > > 
> > > What do you think about this approach ?
> > > 
> > keeping this in "task" struct is troublesome.
> > It may not livelock but near-to-livelock state, in bad case.
> 
> Hmm. I can't understand why it is troublesome. 
> I think it's related to moving oom_adj to singal_struct. 
> Unfortunately, I can't understand why we have to put oom_adj 
> in singal_struct?
> 
> That's why I have a question to Kosaki a while ago. 
> I can't understand it still. :-(
> 
> Could you elaborate it ?

Maybe, It's because my explanation is still poor. sorry.
Please give me one more chance.

In my previous mail, I explained select_bad_process() must not
unkillable task, is this ok?
IOW, if all thread have the same oom_adj, the issue gone.

signal_struct is shared all thread in the process. then, the issue gone.


btw, signal_struct is slightly bad name. currently it is used for
process information and almost its member is not signal related.
should we rename this?

> 
> > After applying Kosaki's , oom_kill will use
> > "for_each_process()" instead of "do_each_thread", I think it's a way to go.
> 
> I didn't review kosaki's approach entirely. 
> After reviewing, let's discuss it, again. 
> 
> > But, yes, your "scale_down" idea itself is interesitng.
> > Then, hmm, merging two of yours ?
> 
> If it is possible, I will do so. 
> 
> Thnaks for good comment, kame.




