Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXETSy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXETSy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXETSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:54:22 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:55912 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXETSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:54:21 -0400
Message-ID: <46509924.8020904@cosmosbay.com>
Date: Sun, 20 May 2007 20:53:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: first little problem with private futexes
References: <465095E5.4050508@redhat.com>
In-Reply-To: <465095E5.4050508@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 20 May 2007 20:53:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Here's a first little issue with private futex I came across.  But a
> real bug but a hole.
> 
> When we use clone() with CLONE_CHILD_CLEARTID possible waiters are woken
> upon termination of the thread.  This operation uses FUTEX_WAKE so far.
>  But it in almost all cases local memory and I would even be in favor of
> setting this into stone.   It wouldn't break anything I know of.
> 
> The problem is we cannot just go over to using
> FUTEX_WAIT|FUTEX_PRIVATE_FLAG since this would break binaries using any
> glibc out there so far.
> 
> There are three ways out of this I can see:
> 
> 1.  do nothing, always use the shared futexes.  Not very attractive IMO

Why do you find this non attractive ?

How is it performance critical ?

If a program is stupid enough to create/destroy many threads per second, I 
doubt it relies on a faster thread termination :)

> 
> 2.  try private futexes first, then shared one.  This is even less
>     attractive since in the many cases there is no waiter and we cannot
>     determine whether the private futex notification succeeded and we're
>     doing the expensive work as well
> 
> 3.  tell the kernel whether we want the new or the old notification.
>     This can be done using a number of ways
> 
>     a) using some prctl().  Another unconditional syscall, not nice.
> 
>     b) using a new CLONE_* flag.  We have currently 5 bits left and can
>        recover two more (CLONE_DETACHED, CLONE_STOPPED).  And we can
>        invent ways to add more bits.
> 
> 
> I'm in favor of 3b but if somebody argues the costs are not justified
> because the effects of using the shared futex notification isn't high
> enough I can accept that, too.

