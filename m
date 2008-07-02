Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYGBP6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYGBP6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYGBP6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:58:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:52355 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYGBP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=aryu985VDnzDoH+vwy0NzAgu94lyHA3fJTRv5d3PKKGuSP7fGFP67Ar6HOj/tLFUVu
         fFUoGgXCEXNHKX8Y072LCQzYt1FdN9G8XqQVm1HQbapWqMHA5T+VApTxRuI0hqGeoiLH
         dQvwMWAYA76oeTodw7wNmbHi2+wlDbGWn4CmM=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
	<486B9987.8000601@firstfloor.org>
	<m3y74ki9ob.fsf@gravicappa.englab.brq.redhat.com>
	<486BA181.5040908@firstfloor.org>
Date: Wed, 02 Jul 2008 17:58:23 +0200
In-Reply-To: <486BA181.5040908@firstfloor.org> (Andi Kleen's message of "Wed,
	02 Jul 2008 17:40:49 +0200")
Message-ID: <m3tzf8i8gw.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>>>>> rep movs can fail.
>>> How? (if it's a byte copy?)
>> 
>> Parameter len is a number of uncopied bytes,
>
> But that is exactly what copy_*_user wants to return

Last experience showed, it doesn't.

Ok, when unrolled version fails on reading quad word at unaligned
address, it doesn't know where it was failed exactly. At this moment it
hasn't correct number of uncopied bytes, because some bytes can still
remain at the very end of the page. copy_user_handle_tail copies them
and return correct value on uncopied bytes. Complicated logic for
counting the number of these bytes is not necessary to optimize at
assembly level, because we already missed performance. It's hard to
complain against it.

> The original version I wrote returned "unfaulted bytes" which was wrong.
> Correct is "uncopied" as fixed by Linus. rep ; movs returns uncopied.

It's not in C. If you have the proposal why it should be written in
assembly, send it to Linus.

>> Why do you think that zeroing can never fail, even in userspace?
>
> There's no zeroing in user space, only in kernel space.

Agree.

> The only reason kernel does it is to avoid leaking uninitialized data,
> but for user space it doesn't make sense (see above)

Ok, copy_in_user can pass zerorest=0 to copy_user_handle_tail. Is it ok
for you?

-- 
wbr, Vitaly
