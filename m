Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbXERWiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbXERWiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXERWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:37:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52333 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbXERWhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:37:55 -0400
Message-ID: <464E2AA6.3080402@garzik.org>
Date: Fri, 18 May 2007 18:37:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Phillip Susi <psusi@cfl.rr.com>, Alex Volkov <avcp-lkmail@usa.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
References: <20070509151831.f5956b66.akpm@linux-foundation.org>	<058f01c7998e$1406e370$650df7cd@MUMBA>	<20070518140624.1a4db517.akpm@linux-foundation.org>	<464E2098.8020900@cfl.rr.com> <20070518151259.319e09da.akpm@linux-foundation.org>
In-Reply-To: <20070518151259.319e09da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 May 2007 17:54:32 -0400
> Phillip Susi <psusi@cfl.rr.com> wrote:
> 
>> Andrew Morton wrote:
>>> Yes, if you agree with Jeff's original point.
>>>
>>> But I don't, actually.  Sure, on some machines+workloads, AIO is more
>>> common than sync IO.  But I expect that when we sum across all the
>>> machines+workloads in the world, sync IO is more common and is hence the
>>> case we should optimise for.
>>>
>>> That's assuming that the unlikely() actually does something.
>> But as Jeff said, that's not what unlikely is for.  It should only be 
>> used when it is unlikely for everybody, all the time, because when it is 
>> right, it helps rather little, but when it is wrong, it hurts a lot.
> 
> It does?  Tell us more.

It is difficult to quantify either way.  The details are both 
CPU-specific and compiler-specific.  The best information can be culled 
from the gcc list archives, which is where I obtained my knowledge on 
the subject (which is now ~2 years old).

Under the hood, likely() and unlikely() are implemented as percentage 
predictions.  likely() is implemented in the kernel as a 99-100% chance 
of success, and unlikely() is implemented as a 0-1% chance of success.

As such, for our purposes, likely() and unlikely() should only be used 
when a situation is [likely | unlikely] across all runtime 
configurations.  So if you mark a branch unlikely() when it is hit often 
by 1% of your users, that is an incorrect usage.

The effects are probably most dramatic on older CPUs.  Repeatedly 
hitting an unlikely() can cause a pipeline stall on every single access. 
  Branch delay slots are filled improperly, with obvious implications.

But on modern hardware, I would /guess/ that the effect of repeatedly 
hitting an unlikely() would be mitigated by smarter branch prediction.

We really need a GCC expert to answer this question in any more detail.

	Jeff


