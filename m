Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYCaQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYCaQO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYCaQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:14:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:24689 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYCaQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:14:51 -0400
Message-ID: <47F10DF7.5010702@colorfullife.com>
Date: Mon, 31 Mar 2008 18:14:47 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org>
In-Reply-To: <47F08ED6.1090103@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Manfred Spraul wrote:
>   
>> Hi,
>>
>> the attached patch should fix the combination of CLONE_NEWIPC with 
>> shared sysv undo structures (the common case, just 
>> sys_unshare(CLONE_NEWIPC)):
>> lookup_undo() now locates the undo array based on both semid and the 
>> namespace pointer.
>>     
>
> If you start using any IPC object and then call unshare with CLONE_NEWIPC,
> then it's your problem, but not the kernel.
>   
The result is a kernel memory corruption, and kernel memory corruptions 
are always the kernel's problem.

The code assumed that a semaphore id is globally unique. With 
namespaces,  this is not true anymore.
If two semaphore arrays exist with the same id, but different sizes, 
then semops will cause memory corruptions: The undo structure contains 
one element for each semaphore, thus the semop will write behind the end 
of the memory allocation.

> I agree, that we should probably destroy this one when the task calls 
> unshare, but trying to keep this list relevant is useless.
>   
A very tricky question: Let's assume we have a process with two threads.
The undo structure is shared, as per opengroup standard.
Now one thread calls unshare(CLONE_NEWIPC). What should happen? We 
cannot destroy the undo structure, the other thread might be still 
interested in it.
If we allow sys_unshare() for multithreaded processes with CLONE_NEWIPC 
and without CLONE_SYSVSEM, then we must handle this case.

--
    Manfred
