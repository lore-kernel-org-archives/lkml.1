Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896Ab0ALOu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0ALOu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0ALOuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:50:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:27707 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0ALOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ugqy78O/gxVC41Lgny/z3kt1VjaGqdcQwA6Mejs6tNsisfXFgHxwmvPhzdTFe6Wpn3
         rJVhKc1wfsxTXsjoB2yAW9vddTe28dpzg7CghvbvYOnlN9Geab4dbhBPex6MOTGO8gnn
         4MTSsV89Q33k4fi1Ahcekhwly8hCBB3FHR8Tk=
Date: Tue, 12 Jan 2010 22:52:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andrew Athan <linux_kernel_aathan@memeplex.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
Message-ID: <20100112145213.GB3925@hack>
References: <4B4C3E4F.9060001@memeplex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4C3E4F.9060001@memeplex.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 04:18:07AM -0500, Andrew Athan wrote:
>
> After some investigation I believe I am experiencing a problem similar
> to the one described in this posting:
> http://sourceware.org/ml/libc-help/2009-10/msg00026.html, in that the
> poster suspects a problem in the futex implementation in 2.6.30 and
> above kernels.  In my case, the problem is not a soft lockup in the
> kernel, but it does result in an application lock up due to all threads
> waiting for futex's.
>
> For me this problem began to appear once I upgraded my Debian
> squeeze/testing x86_64 installation (AMD) to a new kernel.  I'm not
> sure what the prior kernel version was.  The same software running on
> different machines with earlier kernels (lenny) does not seem to
> experience the problem.
>
> I'm really not sure if this is a libc or kernel problem, but due to
> the stack trace, which shows what appears to be a hang on the internal
> __lock of the condition variable, it appears likely this is not an
> application bug.  Memory does not appear to be corrupt (I store
> sentinels around the mutexes, and they have retained their values).
>
> It appears that the cond var's __lock indicates there are waiters
> even though there are/should-be none (assuming I'm interpreting the
> __lock value of 2 correctly).  Since the __lock in question is a futex
> primitive, and it must be held regardless of other libc/nptl state  
> variables,
> I don't believe this is a libc problem.
>
> The problem occurs rarely, but innevitably, and sometimes only after
> several hours of normal program operation.  I have not yet
> successfully created a reduced test program that can faithfully
> reproduce the hang in a short timeframe.
>
> The application contains a thread pool where threads perform many
> operations between pthread calls but can be summarized as one of three
> cases below.  Due to the design of the thread pool, threads
> round-robbin or at least are randomly assigned a workload (in contrast
> to having one constant broadcast thread).
>
> case 1:  while(1){ *A* pthread_lock();pthread_unlock();}
> case 2:  pthread_lock();pthread_cond_wait();pthread_unlock();
> case 3:  pthread_lock(); *B* pthread_cond_broadcast();pthread_unlock();
>
> The application becomes hung with all threads but one stuck at *A*,
> and one thread at *B*.
>
> The stack trace and other details appear below.  I've saved the core
> file in case I can provide additional information.
>
>
> $ uname -a
> Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64  
> GNU/Linux

Hmm, thanks for reporting this here.

Adding futex experters into Cc...


-- 
Live like a child, think like the god.
 
