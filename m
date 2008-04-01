Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYDAJqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYDAJqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYDAJqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:46:30 -0400
Received: from sacred.ru ([62.205.161.221]:42670 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbYDAJq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:46:28 -0400
Message-ID: <47F203EC.7090806@openvz.org>
Date: Tue, 01 Apr 2008 13:44:12 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com>
In-Reply-To: <47F10DF7.5010702@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 01 Apr 2008 13:44:06 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Pavel Emelyanov wrote:
>> Manfred Spraul wrote:
>>   
>>> Hi,
>>>
>>> the attached patch should fix the combination of CLONE_NEWIPC with 
>>> shared sysv undo structures (the common case, just 
>>> sys_unshare(CLONE_NEWIPC)):
>>> lookup_undo() now locates the undo array based on both semid and the 
>>> namespace pointer.
>>>     
>> If you start using any IPC object and then call unshare with CLONE_NEWIPC,
>> then it's your problem, but not the kernel.
>>   
> The result is a kernel memory corruption, and kernel memory corruptions 
> are always the kernel's problem.

Agree. Must be fixed, but I'm not sure we should try handling this
case by trying to de-op semaphores for former task namespace. I think
that destroying this list or returning -EBUSY for this case is OK.

> The code assumed that a semaphore id is globally unique. With 
> namespaces,  this is not true anymore.
> If two semaphore arrays exist with the same id, but different sizes, 
> then semops will cause memory corruptions: The undo structure contains 
> one element for each semaphore, thus the semop will write behind the end 
> of the memory allocation.
> 
>> I agree, that we should probably destroy this one when the task calls 
>> unshare, but trying to keep this list relevant is useless.
>>   
> A very tricky question: Let's assume we have a process with two threads.
> The undo structure is shared, as per opengroup standard.
> Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
> cannot destroy the undo structure, the other thread might be still 
> interested in it.
> If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
> and without CLONE_SYSVSEM, then we must handle this case.

Hm... I'd simply disable creating any new namespaces for threads.
I think other namespaces developers agree with me. Serge, Suka, Eric
what do you think?

> --
>     Manfred
> 

