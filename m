Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXEKB4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXEKB4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbXEKB4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:56:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:31124 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbXEKB4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pO49nJc0/pXPcIb2ae2hTKyR09o42fW50SsgZPkuwMPveRiCFsOiKnbGLc7ZPtVFmJ895vqx4iZJGuwubA56nzaWYO5O33jP3oh61GxWyGsuOXJdVOg/jhT0bzIpltnGfEaVeSZUjy/1zi2odbORGbKD8J7cZEJYFu9EFwlJfnc=
Message-ID: <4643CD44.1090903@gmail.com>
Date: Fri, 11 May 2007 09:56:20 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Esben Nielsen <nielsen.esben@googlemail.com>
Subject: Re: Hi, I have one question about rt_mutex.
References: <4642CCEB.6010908@gmail.com> <4643176C.6050305@redhat.com>
In-Reply-To: <4643176C.6050305@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Li Yu wrote:
>   
>>> Now since mutexes can be defined by user-land applications, we don't
>>>       
>> want a DOS
>>     
>>> type of application that nests large amounts of mutexes to create a large
>>> PI chain, and have the code holding spin locks while looking at a large
>>> amount of data. So to prevent this, the implementation not only implements
>>> a maximum lock depth, but also only holds at most two different locks at a
>>> time, as it walks the PI chain. More about this below.
>>>       
>> After read the implementation of rt_mutex_adjust_prio_chain(), I found
>> the we really require maximin lock depth (1024 default), but I can not
>> see the check for more same locks duplication. Does this doc is
>> inconsistent with code?
>>     
>
> Nope, the code and the doc are still the same.
>
> The thing that was most difficult in writing that document, was a way to
> talk about the user locks (futex - fast user mutex) and the kernel locks
> (spin_locks) without confusing the two.  The max depth is in reference
> to the user futex, but the comment about the "at most two different
> locks" is referencing the kernel's spin_locks.
>
> I don't remember talking about looking for "lock duplication", which I'm
> thinking you are referring to circular dead locks. I didn't cover that
> in the document and I believe I even mentioned that I would not cover
> the debug aspect of the code which would handle catching circular deadlocks.
>
> But back to the "no more than two kernel locks held". This is very
> important. Some PI implementations requires all locks in the PI chain to
> have their internal locks held (as in spin_locks).  But letting user
> space determine the number of spin locks held can cause large latencies
> for the rest of the system.  So we designed a method to only need to
> hold two internal spin_locks in the PI chain at a time.  The kernel
> doesn't care if the user application is abusing itself (holding too many
> of it's own user locks).  But the kernel does care if a user application
> can affect other non related applications.
>
> As Esben already mentioned, the PI chain even lets the locking user
> mutex schedule without holding any kernel locks.  This is very key. It
> keeps the latency down on setting up a PI chain which can be very expensive.
>
> Note: Esben helped a lot in the development of the final design of
> rtmutex.c.
>
> -- Steve
>   
First, Thanks for such good explanation from you two guru in time.

Er, I think these two locks which you said are task->pi_lock and
rt_mutex->wait_lock.

>The max depth is in reference to the user futex, but the comment
>about the "at most two different locks" is referencing the 
>kernel's spin_locks.

This sentence make the my world clear from now on ;)

However, I found the sys_futex() do not use rt_mutex, so what's mean of the user futex you said?
Even, I have not found any usage for rt_mutex in kernel code. Or, some beautiful story will happen in future?

Goodluck.

- Li Yu



