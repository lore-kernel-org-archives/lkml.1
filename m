Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYA1JqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYA1JqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYA1JqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:46:05 -0500
Received: from sacred.ru ([62.205.161.221]:40166 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYA1JqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:46:04 -0500
Message-ID: <479DA289.7090403@openvz.org>
Date: Mon, 28 Jan 2008 12:38:17 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vinay Sridhar <vinay@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org, drepper@redhat.com, wli@holomorphy.com,
       sripathik@in.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>	<20080127215242.b873c341.akpm@linux-foundation.org>	<479D88C7.5030101@openvz.org> <20080128011010.d162d336.akpm@linux-foundation.org>
In-Reply-To: <20080128011010.d162d336.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 12:38:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 28 Jan 2008 10:48:23 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> Andrew Morton wrote:
>>> 	On Thu, 17 Jan 2008 13:57:05 +0530 Vinay Sridhar <vinay@linux.vnet.ibm.com> wrote:
>>>
>>>> Hi All,
>>>>
>>>> Last year, there was discussion about per-thread getrusage by adding
>>>> RUSAGE_THREAD flag to getrusage(). Please refer to the thread
>>>> http://lkml.org/lkml/2007/4/4/308. Ulrich had suggested that we should
>>>> design a better user-space API. Specifically, we need a
>>>> pthread_getrusage interface in the thread library, which accepts
>>>> pthread_t, converts pthread_t into the corresponding tid and passes it
>>>> down to the syscall.
>>>>
>>>> There are two ways to implement this in the kernel:
>>>> 1) Introduce an additional parameter 'tid' to sys_getrusage() and put
>>>> code in glibc to handle getrusage() and pthread_getrusage() calls
>>>> correctly.
>>>> 2) Introduce a new system call to handle pthread_getrusage() and leave
>>>> sys_getrusage() untouched.
>>>>
>>>> We implemented the second idea above, simply because it avoids touching
>>>> any existing code. We have implemented a new syscall, thread_getrusage()
>>>> and we have exposed pthread_getrusage() API to applications.
>>>>
>>>> Could you please share your thoughts on this? Does the approach look
>>>> alright? The code is hardly complete. It is just a prototype that works
>>>> on IA32 at the moment.
>>>>
>>>> ...
>>>>
>>>> +asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru);
>>> What happens if `tid' refers to a thread in a different pid namespace?
>>>
>> That's impossible. I explicitly deny namespace creation in case the
>> CLONE_THREAD is specified. So all threads of a single process always
>> live in one pid namespace.
>>
> 
> If the code was using find_task_by_vpid() then OK (I guess).  But it is

Yup, find_task_by_vpid() will find the proper (i.e. in your namespace) task.

> looking the tids up in the init_pid_ns.  Which I assume means that if it's
> in a new namespace and is looking up a sibling thread it will simply fail?

If it looks in the init_pid_ns, then it can either fail or obtain a task 
from different namespace. The find_task_by_pid_ns() was intended to be used
in proc mainly, to get tasks from the namespace pointed by the super-block
being explored.

Please excuse my lamentable ignorance, but which code does such things with
init_pid_ns? I followed the 'per-thread rusage' thread and didn't find any.

> Or am I missing something?
> 

Thanks,
Pavel
