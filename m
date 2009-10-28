Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbZJ1LE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbZJ1LE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZJ1LE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:04:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41175 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZJ1LE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:04:56 -0400
Message-ID: <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
Date: Wed, 28 Oct 2009 20:04:54 +0900 (JST)
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "David Rientjes" <rientjes@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "Andrea Arcangeli" <aarcange@redhat.com>, vedran.furac@gmail.com,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes さんは書きました：
> On Wed, 28 Oct 2009, KAMEZAWA Hiroyuki wrote:
>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> It's reported that OOM-Killer kills Gnone/KDE at first...
>> And yes, we can reproduce it easily.
>>
>> Now, oom-killer uses mm->total_vm as its base value. But in recent
>> applications, there are a big gap between VM size and RSS size.
>> Because
>>   - Applications attaches much dynamic libraries. (Gnome, KDE, etc...)
>>   - Applications may alloc big VM area but use small part of them.
>>     (Java, and multi-threaded applications has this tendency because
>>      of default-size of stack.)
>>
>> I think using mm->total_vm as score for oom-kill is not good.
>> By the same reason, overcommit memory can't work as expected.
>> (In other words, if we depends on total_vm, using overcommit more
>> positive
>>  is a good choice.)
>>
>> This patch uses mm->anon_rss/file_rss as base value for calculating
>> badness.
>>
>
> How does this affect the ability of the user to tune the badness score of
> individual threads?
Threads ? process ?

> It seems like there will now only be two polarizing
> options: the equivalent of an oom_adj value of +15 or -17.  It is now
> heavily dependent on the rss which may be unclear at the time of oom and
> very dynamic.
>
yes. and that's "dynamic" is good thing.

I think one of problems for oom now is that user says "oom-killer kills
process at random." And yes, it's correct. mm->total_vm is not related
to memory usage. Then, oom-killer seems to kill processes at random.

For example, as Vetran shows, even if memory eater runs, processes are
killed _at random_.

After this patch, the biggest memory user will be the fist candidate
and it's reasonable. Users will know "The process is killed because
it uses much memory.", (seems not random) He can consider he should
use oom_adj for memory eater or not.



> I think a longer-term solution may rely more on the difference in
> get_mm_hiwater_rss() and get_mm_rss() instead to know the difference
> between what is resident in RAM at the time of oom compared to what has
> been swaped.  Using this with get_mm_hiwater_vm() would produce a nice
> picture for the pattern of each task's memory consumption.
>
Hmm, I don't want complicated calculation (it makes oom_adj usage worse.)
but yes, bare rss may be too simple.
Anyway, as I shown, I'll add swap statistics regardless of this patch.
That may adds new hint.
For example)
   if (vm_swap_full())
       points += mm->swap_usage

>> Following is changes to OOM score(badness) on an environment with 1.6G
>> memory
>> plus memory-eater(500M & 1G).
>>
>> Top 10 of badness score. (The highest one is the first candidate to be
>> killed)
>> Before
>> badness program
>> 91228	gnome-settings-
>> 94210	clock-applet
>> 103202	mixer_applet2
>> 106563	tomboy
>> 112947	gnome-terminal
>> 128944	mmap              <----------- 500M malloc
>> 129332	nautilus
>> 215476	bash              <----------- parent of 2 mallocs.
>> 256944	mmap              <----------- 1G malloc
>> 423586	gnome-session
>>
>> After
>> badness
>> 1911	mixer_applet2
>> 1955	clock-applet
>> 1986	xinit
>> 1989	gnome-session
>> 2293	nautilus
>> 2955	gnome-terminal
>> 4113	tomboy
>> 104163	mmap             <----------- 500M malloc.
>> 168577	bash             <----------- parent of 2 mallocs
>> 232375	mmap             <----------- 1G malloc
>>
>> seems good for me.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/oom_kill.c |   10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> Index: mm-test-kernel/mm/oom_kill.c
>> ===================================================================
>> --- mm-test-kernel.orig/mm/oom_kill.c
>> +++ mm-test-kernel/mm/oom_kill.c
>> @@ -93,7 +93,7 @@ unsigned long badness(struct task_struct
>>  	/*
>>  	 * The memory size of the process is the basis for the badness.
>>  	 */
>> -	points = mm->total_vm;
>> +	points = get_mm_counter(mm, anon_rss) + get_mm_counter(mm, file_rss);
>>
>>  	/*
>>  	 * After this unlock we can no longer dereference local variable `mm'
>> @@ -116,8 +116,12 @@ unsigned long badness(struct task_struct
>>  	 */
>>  	list_for_each_entry(child, &p->children, sibling) {
>>  		task_lock(child);
>> -		if (child->mm != mm && child->mm)
>> -			points += child->mm->total_vm/2 + 1;
>> +		if (child->mm != mm && child->mm) {
>> +			unsigned long cpoints;
>> +			cpoints = get_mm_counter(child->mm, anon_rss);
>> +				  + get_mm_counter(child->mm, file_rss);
>
> That shouldn't compile.
Oh, yes...thanks.

>
>> +			points += cpoints/2 + 1;
>> +		}
>>  		task_unlock(child);
>>  	}
>>
>
> This can all be simplified by just using get_mm_rss(mm) and
> get_mm_rss(child->mm).
>
will use that.

I'll wait until the next week to post a new patch.
We don't need rapid way.

Thanks,
-Kame



