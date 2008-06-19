Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYFSDYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYFSDYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYFSDYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:24:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYFSDYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:24:24 -0400
Date: Wed, 18 Jun 2008 23:24:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080617.210159.141238856.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
 <20080617.210159.141238856.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Tue, 17 Jun 2008 20:47:57 -0400 (EDT)
>
>> Wait queue waking looks like being written by a high-level maniac --- it
>> contains 8 levels of calls (none of them inlined). 7 of these calls (until
>> try_to_wake_up) do nothing but pass arguments to lower level call. And
>> each of these calls allocate at least 192 bytes of stack space. All these
>> 7 useless calls consume 1360 bytes of stack (and cause windows traps that
>> needlessly damage performance). Would you agree to inline most of the
>> calls to save stack? Or do you see another solution?
>
> Some of them could be inlined but there are a few limiting
> factors here.

I inlined three of them, I think I can inline another two. So hopefully, 
I'll be able to shring 8-call depth to 3-call depth.

> Even spin lock acquisitions are function calls, limiting how
> much leaf function and tail call optimizations can be done.

Tail call optimization is not done at all if you compile kernel with stack 
checking. This contributes to the stack overflow too.

> Also, wake_up_bit has this aggregate local variable "key" whose
> address is passed down to subsequent functions, which limits
> optimizations even further.
>
> It could still be improved a lot, however.
>
> But the level of recursion possible by the current device layer is
> excessive and needs to be curtained irrespective of these generic
> wakeup and sparc64 interrupt stack issues.

I fixed that too.

BTW. what's the purpose of having 192-byte stack frame? There are 16 
8-byte registers being saved per function call, so 128-byte frame should 
be sufficient, shoudn't? The ABI specifies that some additional entries 
must be present even if unused, but I don't see reason for them. Would 
something bad happen if GCC started to generate 128-byte stacks?

Mikulas
