Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYGBPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYGBPlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYGBPkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:40:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53266 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbYGBPkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:40:52 -0400
Message-ID: <486BA181.5040908@firstfloor.org>
Date: Wed, 02 Jul 2008 17:40:49 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>	<486B8B6C.2050109@firstfloor.org>	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>	<486B9987.8000601@firstfloor.org> <m3y74ki9ob.fsf@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m3y74ki9ob.fsf@gravicappa.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
>>>>>> Overall you could write it much simpler with a rep ; movs I think,
>>>>>> like traditional linux did.
>>>> rep movs can fail.
>> How? (if it's a byte copy?)
> 
> Parameter len is a number of uncopied bytes,

But that is exactly what copy_*_user wants to return

 it doesn't count bytes
> which were loaded into registers before GPF in unrolled
> loop. copy_user_handle_tail tries to do a byte copy for, possibly,
> remaining bytes, but it can fail at the first read/write, or at the
> second, etc. It doesn't know where it will fail.

The original version I wrote returned "unfaulted bytes" which was wrong.
Correct is "uncopied" as fixed by Linus. rep ; movs returns uncopied.

> 
>>>>>> I think a simple memset would be actually ok, i don't think we ever zero
>>>>>> anything that faults. That would be obviously racy anyways. If the zero
>>>>>> are supposed to override something  then a racing user thread could always
>>>>>> catch it.
>>>> Linus wanted this routine to be extremely dumb. This is the reason why tail
>>>> handling was moved from assembly to C. Yeah, my original patches were in
>>>> assembly and on the top of your realization.
>> My point was that it could be simpler because zeroing should not ever fault
>> (copy_in_user is not supposed to zero)
> 
> Why do you think that zeroing can never fail, even in userspace?

There's no zeroing in user space, only in kernel space.

The only reason kernel does it is to avoid leaking uninitialized data,
but for user space it doesn't make sense (see above)

-Andi


