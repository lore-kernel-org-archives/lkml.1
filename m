Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYDOSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYDOSmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYDOSmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:42:37 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:43534 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYDOSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:42:36 -0400
Message-ID: <4804F717.4000200@colorfullife.com>
Date: Tue, 15 Apr 2008 20:42:31 +0200
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
References: <200804130848.m3D8mdo2007124@mail.q-ag.de> <20080414150057.GB15667@sergelap.austin.ibm.com> <4803A512.2070405@colorfullife.com> <20080414192326.GA27930@sergelap.austin.ibm.com>
In-Reply-To: <20080414192326.GA27930@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
>
>> Thus all apps right now call unshare(CLONE_NEWIPC|&~CLONE_SYSVSEM).
>> This combination doesn't make much sense. Even worse - it easily causes a 
>> kernel oops.
>> Thus my fix is twofold:
>> - add support for unshare(CLONE_SYSVSEM).
>> - implicitely add CLONE_SYSVSEM to all calls that set CLONE_NEWIPC.
>>     
>
> Right but your fix ignores the fact that you can achieve the same
> result as unshare(CLONE_NEWIPC&~CLONE_SYSVSEM) by doing
> clone(CLONE_NEWIPC|CLONE_SYSVSEM).
>   
Duh, I overlooked that part. You are right.
Hmm - what's the best fix? Implicitely add CLONE_SYSVSEM or return 
-EINVAL if CLONE_SYSVSEM is not set?
I don't care.
Could you write a patch? I probably won't have enough time until the 
next weekend.

>> I have decided against that, it breaks the current ABI.
>> And we gain virtually nothing - most if not all unshare users will be 
>> single threaded apps that do not use sysvsem at all, and even most sysvsem 
>> users do not use SEM_UNDO.
>>     
>
> And most importantly sharing your semundo list but not your sems with
> your parent is silly!
It's only 99% silly: a task might want to have not-yet undone changes in its parent's namespace.
As soon as the task exit, they are undone. Probably the most complex way to implement wait4().


--
Manfred
