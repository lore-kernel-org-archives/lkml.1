Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZHBBVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZHBBVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 21:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZHBBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 21:21:04 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59591 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZHBBVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 21:21:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19060.59896.983880.446901@cargo.ozlabs.ibm.com>
Date: Sun, 2 Aug 2009 11:20:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <alpine.LFD.2.01.0908011501470.3352@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
	<alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
	<20090731195705.GA12270@elte.hu>
	<alpine.LFD.2.01.0908011214330.3304@localhost.localdomain>
	<4A7499BA.2000405@zytor.com>
	<alpine.LFD.2.01.0908011501470.3352@localhost.localdomain>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> On Sat, 1 Aug 2009, H. Peter Anvin wrote:
> > In particular, if I remember right the problem with using __thread for 
> > percpu was exactly that the current cpuness can change almost anywhere, 
> > unless preemption is disabled.
> 
> That shouldn't matter. If it uses '%gs', it should all just work 
> automatically. But if gcc does something different for thread-local, it's 
> basically useless.

When I tried using __thread for per-cpu variables on ppc64, I found
that gcc would sometimes precompute and cache the address of a per-cpu
variable even though it could always access the variable using an
offset from r13.  The cached address was wrong if the task got moved
to a different cpu, of course, but there was no way to tell gcc that.
Compiler barriers don't help because they say that the contents of
variables might have changed, but not their addresses.

So on x86 the concern would be that gcc might do lea %gs:foo,%rbx and
then use (%rbx) to refer to foo later on.  It would be possible to use
__thread for per-task variables rather than having to put all per-task
things in the task_struct, but __thread doesn't work for per-cpu
variables in my experience.

Paul.
