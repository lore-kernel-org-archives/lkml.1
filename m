Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXCBVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXCBVVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965657AbXCBVVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:21:51 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:22637 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbXCBVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WeAvtQg2KlwLAevOepnX9va/C6jxe3YRGEZS6ENzKbcdc2r4Ltp7utKjza84nV0y28jEdR7x8r5ATlIBCXZkkmZrJDUsaCkY0FF818xDwMDOq5isanDQU3KjZhRGzdgB3iB4hBdlW2AZdqJGXi95qI6hySZmiXfpNLV4LvaUBZM=
Message-ID: <f2b55d220703021321r1491daa1if64ad555aade7060@mail.gmail.com>
Date: Fri, 2 Mar 2007 13:21:48 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133018.GB30177@2ka.mipt.ru>
	 <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu>
	 <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu>
	 <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
	 <20070302193941.GB8450@elte.hu>
	 <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
	 <20070302202931.GA5101@elte.hu>
	 <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> For threadlets, it might be. Now think about a task wanting to dispatch N
> parallel AIO requests as N independent syslets.
> Think about this task having USEDFPU set, so the FPU context is dirty.
> When it returns from async_exec, with one of the requests being become
> sleepy, it needs to have the same FPU context it had when it entered,
> otherwise it won't prolly be happy.
> For the same reason a schedule() must preserve/sync the "prev" FPU
> context, to be reloaded at the next FPU fault.

And if you actually think this through, I think you will arrive at (a
subset of) the conclusions I did a week ago: to keep the threadlets
lightweight enough to schedule and migrate cheaply, they can't be
allowed to "own" their own FPU and TLS context.  They have to be
allowed to _use_ the FPU (or they're useless) and to _use_ TLS (or
they can't use any glibc wrapper around a syscall, since they
practically all set the thread-local errno).  But they have to
"quiesce" the FPU and stash any thread-local state they want to keep
on their stack before entering the next syscall, or else it'll get
clobbered.

Keep thinking, especially about FPU flags, and you'll see why
threadlets spawned from the _same_ threadlet entrypoint should all run
in the same pool of threads, one per CPU, while threadlets from
_different_ entrypoints should never run in the same thread (FPU/TLS
context).  You'll see why threadlets in the same pool shouldn't be
permitted to preempt one another except at syscalls that block, and
the cost of preempting the real thread associated with one threadlet
pool with another real thread associated with a different threadlet
pool is the same as any other thread switch.  At which point,
threadlet pools are themselves first-class objects (to use the snake
oil phrase), and might as well be enhanced to a data structure that
has efficient operations for reprioritization, bulk cancellation, and
all that jazz.

Did I mention that there is actually quite a bit of prior art in this
area, which makes a much better guide to the design of round wheels
than micro-benchmarks do?

Cheers,
- Michael
