Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYDUSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYDUSB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbYDUSBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:01:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:50909 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYDUSBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:01:51 -0400
Message-ID: <480CD658.6030801@windriver.com>
Date: Mon, 21 Apr 2008 13:00:56 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: i386 single-step vs int $0x80 issues
References: <20080416023650.E3CBDEFFEA@magilla.localdomain>
In-Reply-To: <20080416023650.E3CBDEFFEA@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2008 18:00:45.0422 (UTC) FILETIME=[9F3328E0:01C8A3D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> Jason made a change, 1e2e99f0e4aa6363e8515ed17011c210c8f1b52a on 2007-7-6:
>
>     i386: fix regression, endless loop in ptrace singlestep over an int80
>
> I'm trying to figure out what the full story behind that was.  The
> log message includes source for a test program.  I cannot reproduce
> anything like the problem described.  I tried it when building the
> kernel sources from the state just before that commit, as well as
> the current kernel with that commit's patch reverted.
>
> The list traffic I found about this did not seem to say it was an
> intermittent problem.  I really cannot understand how the failure
> mode described could have been happening (except in one racy way on
> SMP only, that I don't know how to provoke).  The logic of the
> change is wrong IMHO, and it broke some cases that worked before it
> (stepping into sigreturn).


Certainly I am interested in making all the cases work correctly.  The
failure behavior was observed on an SMP system.  I re-tested to
confirm the problem was still there.

>
> The description of the behavior of the test suggests it assumed
> that libc calls like write would use an int $0x80 syscall, which
> is not something you can rely on.  I replaced the "write" call in
> the test with:
>
>     asm volatile ("push %%ebx; mov %1,%%ebx; int $0x80; pop %%ebx"
>           : "=a" (ret)
>           : "g" (1), "a" (4), "c" (str), "d" (sizeof str - 1)
>           : "ebx");
>
> But still I could not find any way to reproduce the failure mode
> that Jason's report described.
>
> The patch below and the comments it includes describe what's going
> on, why the 1e2e99f0... change was wrong, and revert it while fixing
> the one thing I saw wrong with Chuck's 635cf99a... change.
>
> But I'm not submitting this change now.  Firstly, I really want to
> understand what it was that Jason saw and if there is some scenario
> here I have overlooked.  Secondly, while doing this I realized there
> are some 32/64 differences in how all this handling works, and I
> think I'll rejigger it all some more to clean it up.
>
>

Certainly I'll sign off on a "tested-by" or "acked-by" header.   I
tested your changes with the tip of the kernel tree on the same system
where I first saw the problem and it does not occur.

Ideally the handling on 32/64 can be closer to the same logic.

Thanks,
Jason.

