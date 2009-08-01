Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZHABKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZHABKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 21:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZHABKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 21:10:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51690 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZHABKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 21:10:52 -0400
Message-ID: <77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
    <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
    <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
    <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
    <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
    <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
Date: Sat, 1 Aug 2009 10:10:49 +0900 (JST)
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "David Rientjes" <rientjes@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Paul Menage" <menage@google.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:

>> > It livelocks if a thread is chosen and passed to oom_kill_task() while
>> > another per-thread oom_adj value is OOM_DISABLE for a thread sharing
>> the
>> > same memory.
>> >
>> I say "why don't modify buggy selection logic?"
>>
>> Why we have to scan all threads ?
>> As fs/proc/readdir does, you can scan only "process group leader".
>>
>> per-thread scan itself is buggy because now we have per-process
>> effective-oom-adj.
>>
>
> Without my patches to change oom_adj from task_struct to mm_struct, you'd
> need to scan all tasks and not just the tgids because their oom_adj values
> can differ amongst threads in the same thread group.  So while it may now
> be possible to shorten the scan as a result of my approach, it isn't a
> solution itself to the problem.

Did I said "revert your patch in -rc" even once ?
livelock-avoidance itself is good work, thank you.
All my suggestion is based on your patch already in rc4.
Summarizing I think now .....
  - rename mm->oom_adj as mm->effective_oom_adj
  - re-add per-thread oom_adj
  - update mm->effective_oom_adj based on per-thread oom_adj
  - if necessary, plz add read-only /proc/pid/effective_oom_adj file.
    or show 2 values in /proc/pid/oom_adj
  - rewrite documentation about oom_score.
   " it's calclulated from  _process's_ memory usage and oom_adj of
    all threads which shares a memor  context".
   This behavior is not changed from old implemtation, anyway.
 - If necessary, rewrite oom_kill itself to scan only thread group
   leader. It's a way to go regardless of  vfork problem.



>
>> > How else do you propose the oom killer use oom_adj values on a
>> per-thread
>> > basis without considering other threads sharing the same memory?
>> As I wrote.
>>    per-process(signal struct) or per-thread oom_adj and add
>>    mm->effecitve_oom_adj
>>
>> task scanning isn't necessary to do per-thread scan and you can scan
>> only process-group-leader. What's bad ?
>> If oom_score is problem, plz fix it to show effective_oom_score.
>>
>
> When only using (and showing) mm->effective_oom_adj for a task, userspace
> will not be able to adjust /proc/pid/oom_score with /proc/pid/oom_adj
> as Documentation/filesystems/proc.txt says you can for a thread unless it
> exceeds effective_oom_adj.>

Is it different from old behavior ?
I think documentation is wrong. It should say "you should think of
multi-thread effect to oom_adj/oom_score".

Thanks,
-Kame

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


