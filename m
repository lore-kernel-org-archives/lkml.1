Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYGBSzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYGBSzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYGBSyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:54:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48449 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYGBSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:54:39 -0400
Message-ID: <486BCEEC.4060301@firstfloor.org>
Date: Wed, 02 Jul 2008 20:54:36 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>	<486B8B6C.2050109@firstfloor.org>	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>	<486B9987.8000601@firstfloor.org>	<m3y74ki9ob.fsf@gravicappa.englab.brq.redhat.com>	<486BA181.5040908@firstfloor.org> <m3tzf8i8gw.fsf@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m3tzf8i8gw.fsf@gravicappa.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
>>>>>> rep movs can fail.
>>>> How? (if it's a byte copy?)
>>> Parameter len is a number of uncopied bytes,
>> But that is exactly what copy_*_user wants to return
> 
> Last experience showed, it doesn't.

?

> Ok, when unrolled version fails on reading quad word at unaligned
> address, it doesn't know where it was failed exactly. At this moment it
> hasn't correct number of uncopied bytes, because some bytes can still
> remain at the very end of the page. copy_user_handle_tail copies them
> and return correct value on uncopied bytes. Complicated logic for
> counting the number of these bytes is not necessary to optimize at
> assembly level, because we already missed performance. It's hard to
> complain against it.

Yes I'm talking about the "replay loop"

There's no complicated logic in a rep ; movs. And it's still
a byte copy. In fact it is far simpler than what you already have.

>> The original version I wrote returned "unfaulted bytes" which was wrong.
>> Correct is "uncopied" as fixed by Linus. rep ; movs returns uncopied.
> 
> It's not in C. If you have the proposal why it should be written in
> assembly, send it to Linus.

Well it would turn your 15+ lines C function in ~4 (well tested) lines or so.

> 
>>> Why do you think that zeroing can never fail, even in userspace?
>> There's no zeroing in user space, only in kernel space.
> 
> Agree.
> 
>> The only reason kernel does it is to avoid leaking uninitialized data,
>> but for user space it doesn't make sense (see above)
> 
> Ok, copy_in_user can pass zerorest=0 to copy_user_handle_tail. Is it ok
> for you?

My point was that for the zeroing you can just use memset(), there's
no need to support faulting there at all.

-Andi

