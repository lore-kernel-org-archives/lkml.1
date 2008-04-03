Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbYDCTp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbYDCTp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbYDCTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:40:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30108 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892AbYDCTkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:40:15 -0400
Message-ID: <47F5329B.8080305@colorfullife.com>
Date: Thu, 03 Apr 2008 21:40:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1od8tiom7.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@openvz.org> writes:
>   
>>>> I agree, that we should probably destroy this one when the task calls 
>>>> unshare, but trying to keep this list relevant is useless.
>>>>   
>>>>         
>>> A very tricky question: Let's assume we have a process with two threads.
>>> The undo structure is shared, as per opengroup standard.
>>> Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
>>> cannot destroy the undo structure, the other thread might be still 
>>> interested in it.
>>> If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
>>> and without CLONE_SYSVSEM, then we must handle this case.
>>>       
>> Hm... I'd simply disable creating any new namespaces for threads.
>> I think other namespaces developers agree with me. Serge, Suka, Eric
>> what do you think?
>>     
>
> I almost agree.  sys_unshare() in a multithreaded process breaks
> all kinds of user space libs.  So you can only reasonably look at
> the problem as what we do with linux tasks that share some things
> and not others.  The posix/opengroup notion of processes and threads
> are a distraction.
>
> In this case requiring it appears that to require unsharing both
> CLONE_SYSVSEM and CLONE_NEWIPC at the same time.  (i.e. unshare
> of CLONE_SYSVSEM should fail if CLONE_NEWIPC is not also specified).
> Then to make it work we make unshare of SYSVSEM succeed when it is not shared.
>
> This looks like about a 5 line patch or two.
>
>   
Probably something like this in copy_ipcs:
       if (current->sysvsem.undo_list != NULL && 
atomic_read(current->sysvsem.undo_list->refcount) > 1)
          return -EINVAL;

I'll think about it and write a patch over the weekend.

> The effect is because we don't support unsharing of SYSVSEM currently
> we don't support a threaded process unsharing the ipc namespace.
>   
I agree.
Btw: The manpage of unshare() is IMHO a bit misleading:
 >   NAME
 >       unshare - disassociate parts of the process execution context

unshare() only operates on a single thread, shouldn't the description be 
"disassociate parts of the thread execution context"?

--
    Manfred
