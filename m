Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXKRHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXKRHqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 02:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXKRHqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 02:46:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXKRHqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 02:46:12 -0500
Message-ID: <473FED5F.2010303@zytor.com>
Date: Sat, 17 Nov 2007 23:44:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
In-Reply-To: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> wing patches provide an alternative implementation of the
> sys_indirect system call which has been discussed a few times.
> This no system call allows us to extend existing system call
> interfaces with adding more system calls.
> 
> Davide's previous implementation is IMO far more complex than
> warranted.  This code here is trivial, as you can see.  I've
> discussed this approach with Linus last week and for a brief moment
> we actually agreed on something.
> 
> We pass an additional block of data to the kernel, it is copied into
> the task_struct, and then it is up to the function implementing the system
> call to interpret the data.  Each system call, which is meant to be
> extended this way, has to be white-listed in sys_indirect.  The
> alternative is to filter out those system calls which absolutely cannot
> be handled using sys_indirect (like clone, execve) since they require
> the stack layout of an ordinary system call.  This is more dangerous
> since it is too easy to miss a call.
> 

I stared at this a bit, and it took me some time to try to grok what it 
is trying to do.  Eventually I figured it out, and I wonder if there 
isn't an easier -- or at least more efficient -- way to accomplish this 
goal.

It seems to me that we could accomplish the same thing by passing the 
number of parameters in the upper bits of the system call number 
register (%eax in the case of x86.)  If set to zero, we'd fill in the 
legacy number of registers (for backwards compatibility.)  Unspecified 
arguments are then forced to zero before invoking the target function; 
we could also make a register count available if need be.

Alternatively, the same thing can be done with a dense system call 
number space by adding a number of parameters field to the system call 
table, however, that is more invasive in that one has to poke something 
into each architecture (unfortunately -- it would be so much nicer if 
there was a central metafile which one could process into the various 
architecture system call tables.)

	-hpa
