Return-Path: <linux-kernel-owner+w=401wt.eu-S934149AbYDNSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbYDNSkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbYDNSkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:40:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:58583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbYDNSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:40:23 -0400
Message-ID: <4803A512.2070405@colorfullife.com>
Date: Mon, 14 Apr 2008 20:40:18 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 2/2] fix sys_unshare()+SEM_UNDO: perform an implicit CLONE_SYSVSEM
 in CLONE_NEWIPC
References: <200804130848.m3D8mdo2007124@mail.q-ag.de> <20080414150057.GB15667@sergelap.austin.ibm.com>
In-Reply-To: <20080414150057.GB15667@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Manfred Spraul (manfred@colorfullife.com):
>   
>> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
>> cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
>> undo lists.
>> Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.
>> CLONE_NEWIPC creates a new IPC namespace, the task cannot access the
>> existing semaphore arrays after the unshare syscall. Thus the task
>> can/must detach from the existing undo list entries, too.
>>
>> This fixes the kernel corruption, because it makes it impossible that
>> undo records from two different namespaces are in sysvsem.undo_list.
>>     
>
> So this was never an issue with clone(CLONE_NEWIPC|CLONE_SYSVSEM), which
> should have had the same result as unshare(CLONE_NEWIPC&~CLONE_SYSVSEM)?
>
>   
Actually, the story is slightly different:
unshare(CLONE_NEWIPC|CLONE_SYSVSEM) returns -EINVAL right now.

Thus all apps right now call unshare(CLONE_NEWIPC|&~CLONE_SYSVSEM).
This combination doesn't make much sense. Even worse - it easily causes 
a kernel oops.
Thus my fix is twofold:
- add support for unshare(CLONE_SYSVSEM).
- implicitely add CLONE_SYSVSEM to all calls that set CLONE_NEWIPC.

It's not really pretty: If a pivot_namespace syscall is ever added, then 
CLONE_NEWIPC&~CLONE_SYSVSEM would make sense again.
What do you think? Can we break backward compatibility and add
    if ( (unshare_flags & CLONE_NEWIPC) && !(unshare_flags & 
CLONE_SYSVSEM) )
       return -EINVAL;
into sys_unshare()?
I have decided against that, it breaks the current ABI.
And we gain virtually nothing - most if not all unshare users will be 
single threaded apps that do not use sysvsem at all, and even most 
sysvsem users do not use SEM_UNDO.

--
    Manfred
