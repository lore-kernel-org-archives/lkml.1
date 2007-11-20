Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbXKTE1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbXKTE1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXKTE1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:27:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXKTE1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:27:43 -0500
Message-ID: <47426221.6020609@zytor.com>
Date: Mon, 19 Nov 2007 20:27:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <473FED5F.2010303@zytor.com> <474007B3.30205@redhat.com> <47409484.8040304@zytor.com> <47425470.2000608@redhat.com>
In-Reply-To: <47425470.2000608@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> 
> But I still don't see that the magic encoding is a valid solution, it
> doesn't address the limited parameter number.  Plus, using sys_indirect
> could in future be used to transport entire parameters (like a sigset_t)
> along with other information, thereby saving individual copy operations.
> 

The limited number of parameters is a non-issue, we already have the 
convention for that: for more than 6 parameters, pass a parameter to 
arguments 6 and higher in the register normally used for parameter 6.

Now, for the specific case of x86-64 (as well as some of the RISC 
architectures), this meshes poorly with the C calling convention, which 
is that parameter 7+ are passed on the stack.  We would obtain a more 
efficient calling convention by allocating an additional register for 
such an indirect pointer and/or adopt the convention that the additional 
parameters are simply stored on the user stack starting at a specific 
offset, presumably +8.

I would really like to see a systematic calling convention that doesn't 
have limits that we have already broken several times.  In particular, I 
would like to see a convention that can be mapped 1:1 onto the platform 
C calling convention in a syscall-independent way.  We *almost* have 
this today, but sys_indirect would blow that out of the water in a 
particularly ugly way.(*)

> I think the sys_indirect approach is the way forward.  I'll submit a
> last version of the patch in a bit.

I think it is a horrible kluge.  It's yet another multiplexer, which we 
are trying desperately to avoid in the kernel.  Just to make things more 
painful, it is a multiplexer which creates yet another ad hoc calling 
convention, whereas we should strive to make the kernel calling 
convention as uniform as possible.

If is is NOT going to be used in the common case, then it really doesn't 
matter -- we can just use manually or automatically generated thunks. 
It's not like we have thousands of system calls, and it's not like "a 
system call" is a precious thing.

If it IS going to be used in the common case, then we should use 
something more streamlined.

	-hpa

