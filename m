Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYFYQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYFYQBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYFYQBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:01:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYFYQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:01:41 -0400
Date: Wed, 25 Jun 2008 12:01:38 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [3/10 PATCH] inline wake_up_bit
In-Reply-To: <200806251724.57689.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0806251148550.20484@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <200806251617.40871.vda.linux@googlemail.com>
 <Pine.LNX.4.64.0806251031330.7542@engineering.redhat.com>
 <200806251724.57689.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> And you know what? This is likely not the end yet! It's possible
>>> spin_lock_irqXXX, __wake_up_common, waitqueue_active or bit_waitqueue
>>> are inlines - I didn't check.
>>> --
>>> vda
>>
>> Yes, that's 0.2% code size increase
>
> ...In just 17 callsites in entire kernel.
>
>> (or none increase, if drop
>> inline-__wake_up_bit.patch and apply only the other patches).
>
> Now this is a better approach - to actually see how many
> callsites are there, and inlining only where makes sense.
> But in practice it's hard to do and also is changing all the time
> during development. What is optimal today won't be optimal in
> 2.6.45 :)
>
> Ingo's suggestion to talk to gcc people to remedy
> insane call convention sounds as a more workable solution.
>
> BTW, i386 uses regparm call convention, is similar trick
> possible for sparc64?

Sparc64 has register windows: it passes arguments in registers, but it 
must allocate space for that registers. If the call stack is too deep (8 
levels), the CPU runs out of registers and starts spilling the registers 
of the function 8-levels-deep to the stack.

The stack usage could be reduced to 176 bytes with little work from gcc 
developers and to 128 bytes with more work (ABI change). If you wanted to 
go below 128 bytes, you could use one register to indicate number of used 
registers and modify the spill/fill handlers to load only that number of 
registers and reduce the stack usage even more --- that would be a big 
code change in both gcc and linux.

Mikulas

>> To me it
>> seems crazy, how this code was refactored again and again over time, up to
>> 8 levels of functions (including passing a pointer to a method). In 2.0.x
>> kernel series, it was just a single call to wake up a queue.
>
> Yes, probably... If you can simplify it, everyone will be glad.
> --
> vda
>
