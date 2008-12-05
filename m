Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYLESvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYLESvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLESvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:51:03 -0500
Received: from relay3.sgi.com ([192.48.171.31]:47427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751439AbYLESvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:51:01 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2008 13:51:01 EST
Message-ID: <493975BE.60202@sgi.com>
Date: Fri, 05 Dec 2008 10:41:02 -0800
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx
 accounting
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0812051216020.10157@blonde.anvils>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 4 Dec 2008, Oleg Nesterov wrote:
>> On 12/03, Hugh Dickins wrote:
>>> On Wed, 3 Dec 2008, Oleg Nesterov wrote:
>>>
>>>> Unless we are going to decrease rss/vm there is no point to call the
>>>> (racy) update_hiwater_xxx() helpers. Still do_exit() does this, and
>>> I'm puzzled by this comment.  exit() _is_ about to decrease rss/vm,
>>> so isn't it right to be calling update_hiwater_xxx()?
>> Do you mean exit_mm()->...->exit_mmap() ? But this doesn't matter, this
>> ->mm is going away. Nobody can read these counters when ->mm_users == 0,
>> no?
> 
> I was conceding that point in my next sentence...
> 
>>> There is a question of who's going to be able to see the result from
>>> this point on: I forget whether I was doing it for my own satisfaction,
>>> or for a real observer.
> 
> I've looked back at it now: the hiwater fields already existed, their
> updates were slowing things down, and nothing in tree was even looking
> at the results; I changed the way they were updated to minimize the
> slowdown.
> 
> So my principal reason for putting the updates in do_exit() was simply
> that there had been an update_mem_hiwater(tsk) there in do_exit(), and
> no examples of how the results would get used, so I thought I'd better
> update them there too.

Add Jonathan Lim to cc. He is responsible for CSA. The applications
using those data are running at user space through the taskstats
interface. That was the whole point of creating taskstats interface:
move accounting modules to user space.

Regards,
jay

> 
> The /proc VmPeak & VmHWM stuff I added just to give it an intree
> consumer and example of how to handle the counters: an example which
> sadly was ignored when the tsacct.c use came in a few releases later.
> 
>>> Even if there isn't a real observer today,
>>> I think I'd prefer do_exit() to continue to update_hiwater_xxx(),
>>> in case an observer is added tomorrow - unless you feel it's
>>> unjustifiably adding code to and slowing down process exit.
>> Please see below,
>>
>>> You say "(racy)": in my view, it was only as racy as whatever might
>>> cause it to be racy.  By that, I mean that if the numbers ended up
>>> slightly wrong, you could reasonably imagine that the races happened
>>> in a different sequence which would have ended up with the numbers
>>> seen.  Have you noticed something more serious we need to fix?
>> But the difference can be huge. Let's suppose the process has 2 threads
>> T1 and T2.
>>
>> T1 exits, calls update_hiwater_vm(), notices that mm->hiwater_vm must be
>> updated, and preempted right before mm->hiwater_vm = new_value.
>>
>> T2 does free(malloc(A_LOT)) and exits. It sets the correct value for
>> ->hiwater_vm which takes A_LOT into account and disappears.
>>
>> T1 resumes, and "reverts" ->hiwater_vm to the "new_value" which was
>> calculated before.
>>
>> Now, since T1 is the last exiting thread, the whole thread group
>> exits and we report the wrong ->hiwater_vm to the userspace.
> 
> Thanks for spelling it out for me, Oleg, yes, I can see that now.
> And indeed, I seem to have been aware of it originally, when I said:
> <quote>
> What locking?  None: if the app is racy then these statistics will be
> racy, it's not worth any overhead to make them exact.  But whenever it
> suits, hiwater_vm is updated under exclusive mmap_sem, and hiwater_rss
> under page_table_lock (for now) or with preemption disabled (later on):
> without going to any trouble, minimize the time between reading current
> values and updating, to minimize those occasions when a racing thread
> bumps a count up and back down in between.
> <unquote>
> 
> Other uses of update_hiwater_vm() are protected by down_write of
> mmap_sem, so by removing the update_hiwater_vm() from do_exit(),
> you're completely fixing its raciness.  update_hiwater_rss()
> remains racy in other places, but it's less of an issue because
> rss can't be raised by large amounts, just by one page increments.
> (We may want to revisit this if we ever get around to doing the
> tlb_gather_mmu stuff without disabling preemption.)
> 
>> Yes, this race is unlikely. But there is another reason (perhaps
>> not very good) why I tried to remove update_hiwater_xxx() from
>> do_exit().
>>
>> Imho this code looks as if: from now it is "safe" to use ->hiwater_xxx
>> directly because we already updated it. But it is not. Unless we are
>> the last thread, we can't trust mm->hiwater_xxx anyway, we should
>> re-check get_mm_rss/total_vm.
> 
> Okay, you're completely eliminating one race, and we've found out
> why I sited the code there originally: go ahead, I've no objection
> to you removing it now.
> 
> But with one change: please also change the comment in exit_mmap():
> -	/* Don't update_hiwater_rss(mm) here, do_exit already did */
> +	/* update_hiwater_rss(mm) here? but nobody should be looking */
> or reword that if you prefer.
> 
> Ah, reading further down, I see you spotted that.
> 
>>>> Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() to use instead,
>>>> and kill the "if (tsk->mm) {}" code in do_exit().
>>> If you're going to add special helper macros (I don't care myself),
>>> wouldn't it be better to convert fs/proc/task_mmu.c (the original
>>> consumer) to use them too?
>> Yes, I was going to convert task_mem(), but noticed that it has
>> to read get_mm_rss() and ->total_vm anyway. Still, perhaps it
>> would be more clean to use the new macros anyway, even if this
>> wiil (unlikely) need a couple of extra cpu ticks.
> 
> No, that is a good reason to leave fs/proc/task_mmu.c as it is.
> I just wouldn't have added your accessor macros for one use myself;
> but they might help someone to avoid making the same mistake again.
> 
> Go ahead, thanks!
> Hugh

