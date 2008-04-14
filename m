Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbYDNTXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbYDNTXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYDNTXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:23:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41351 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYDNTXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:23:35 -0400
Date: Mon, 14 Apr 2008 14:23:26 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 2/2] fix sys_unshare()+SEM_UNDO: perform an implicit
	CLONE_SYSVSEM in CLONE_NEWIPC
Message-ID: <20080414192326.GA27930@sergelap.austin.ibm.com>
References: <200804130848.m3D8mdo2007124@mail.q-ag.de> <20080414150057.GB15667@sergelap.austin.ibm.com> <4803A512.2070405@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4803A512.2070405@colorfullife.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Manfred Spraul (manfred@colorfullife.com):
> Serge E. Hallyn wrote:
>> Quoting Manfred Spraul (manfred@colorfullife.com):
>>   
>>> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this 
>>> can
>>> cause a kernel memory corruption. CLONE_NEWIPC must detach from the 
>>> existing
>>> undo lists.
>>> Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.
>>> CLONE_NEWIPC creates a new IPC namespace, the task cannot access the
>>> existing semaphore arrays after the unshare syscall. Thus the task
>>> can/must detach from the existing undo list entries, too.
>>>
>>> This fixes the kernel corruption, because it makes it impossible that
>>> undo records from two different namespaces are in sysvsem.undo_list.
>>>     
>>
>> So this was never an issue with clone(CLONE_NEWIPC|CLONE_SYSVSEM), which
>> should have had the same result as unshare(CLONE_NEWIPC&~CLONE_SYSVSEM)?
>>
>>   
> Actually, the story is slightly different:
> unshare(CLONE_NEWIPC|CLONE_SYSVSEM) returns -EINVAL right now.

Right, but it's feasible with clone (where CLONE_SYSVSEM has the
opposite meaning of with unshare) right?  According to the
comment, CLONE_SYSVSEM was disabled mainly out of fear that it
would be confusing to enable it since it does have the inverse meaning
in unshare as in clone.

> Thus all apps right now call unshare(CLONE_NEWIPC|&~CLONE_SYSVSEM).
> This combination doesn't make much sense. Even worse - it easily causes a 
> kernel oops.
> Thus my fix is twofold:
> - add support for unshare(CLONE_SYSVSEM).
> - implicitely add CLONE_SYSVSEM to all calls that set CLONE_NEWIPC.

Right but your fix ignores the fact that you can achieve the same
result as unshare(CLONE_NEWIPC&~CLONE_SYSVSEM) by doing
clone(CLONE_NEWIPC|CLONE_SYSVSEM).

> It's not really pretty: If a pivot_namespace syscall is ever added, then 
> CLONE_NEWIPC&~CLONE_SYSVSEM would make sense again.
> What do you think? Can we break backward compatibility and add
>    if ( (unshare_flags & CLONE_NEWIPC) && !(unshare_flags & CLONE_SYSVSEM) 
> )
>       return -EINVAL;
> into sys_unshare()?

I don't think we need to, I think what you're doing makes perfect sense.
If you asked for CLONE_NEWIPC, then you wanted to do CLONE_SYSVSEM (uh, or,
in clone parlance, !CLONE_SYSVSEM :)

> I have decided against that, it breaks the current ABI.
> And we gain virtually nothing - most if not all unshare users will be 
> single threaded apps that do not use sysvsem at all, and even most sysvsem 
> users do not use SEM_UNDO.

And most importantly sharing your semundo list but not your sems with
your parent is silly!

-serge
