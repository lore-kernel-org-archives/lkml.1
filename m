Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0ANAj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0ANAj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501Ab0ANAj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:39:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0ANAj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:39:57 -0500
Message-ID: <4B4E67C8.501@zytor.com>
Date: Wed, 13 Jan 2010 16:39:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
       torvalds@linux-foundation.org
Subject: Re: x86-32: clean up rwsem inline asm statements
References: <20100114002708.4154.qmail@science.horizon.com>
In-Reply-To: <20100114002708.4154.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 04:27 PM, George Spelvin wrote:
>> There are a number of things that can be done better... for one thing,
>> "+m" (sem->count) and "a" (sem) is just bloody wrong.  The right thing
>> would be "a" (&sem->count) for proper robustness.
> 
> Actually, no.  The "+m" (sem->count) is telling GCC that sem->count is
> updated; "a" (&sem->count) does *not* tell it to invalidate cached
> copies of sem->count that it may have lying around.
> 
> However, we can't just use "+m" (sem->count) because GCC has a poor
> grasp on the concept of atomic operations; as far as it is concerned,
> it is exactly equivalent to copying the value into a stack slot, do the
> operation there, and copy it back.

You completely missed the point.

The reason we need both "+m" (sem->count) and "a" (sem) is because we
need the address of the semaphore in %eax in case we hit the slow path.
 They're actually orthogonal requirements, and we could implement them as:

	LOCK_PREFIX xadd %1,%0
	jz 1f
	call call_rwsem_wake
1:

	: "+m" (sem->count), "=d" (tmp)
       	: "a" (sem)

... just fine, and arguably that would be more correct in the sense that
if sem->count isn't the first member of *sem, then we still pass the
address of sem in %eax to call_rwsem_wake.  In practice, with the
zero-offset sem->count, gcc will typically generate (%eax) as the
argument since it has it available anyway, but it wouldn't have to.

The code as it currently is:

	LOCK_PREFIX xadd %1,(%2)
	jz 1f
	call call_rwsem_wake
1:

	: "+m" (sem->count), "=d" (tmp)
       	: "a" (sem)

... implicitly assumes the offset of "count" is zero but doesn't enforce
it in any way.  My comment was that since the assumption is clearly that
arguments 0 and 2 point to the same memory object, it should be
(&sem->count) in the second case, but that's actually not really the
"proper" fix because call_rwsem_wake presumably expects the value of sem.
	
	-hpa
