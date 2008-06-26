Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYFZTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYFZTNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYFZTNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:13:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33283 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYFZTNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:13:22 -0400
Date: Thu, 26 Jun 2008 21:14:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Message-ID: <20080626191406.GC13699@uranus.ravnborg.org>
References: <20080623060939.6b6b3183.pj@sgi.com> <86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org> <20080624220810.b2ec0c6a.pj@sgi.com> <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org> <20080625145331.GA20941@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625145331.GA20941@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

> Sparse is a cool tool that extends upon C types (and more), but it's 
> been made too hard to use widely:
> 
>  - right now it's opt-in with no ability for testers to use it
>    transparently while also building the kernel. Forcing a second
>    kernel build just for 'debugging' reduces the userbase.

This is waht make C=1 is for. If this is broken then we should
fix it.
Just trying it out:
$ make C=1 kernel/sched.o
  CHECK   kernel/sched.c
kernel/sched_fair.c:37:14: warning: symbol 'sysctl_sched_latency' was not declar                                                                   ed. Should it be static?
kernel/sched_fair.c:43:14: warning: symbol 'sysctl_sched_min_granularity' was no                                                                   t declared. Should it be static?
kernel/sched_fair.c:72:14: warning: symbol 'sysctl_sched_wakeup_granularity' was                                                                    not declared. Should it be static?
...
  CC      kernel/sched.o


So make C=1 works as intended and let you run sparse on the files
that are built - and only those.

 
> Fortunately these problems are all solvable gradually:
> 
>  - a kbuild mechanism to get _parallel_ Sparse checks. I.e. both the 
>    real .o gets produced but also the "make C=1" output is produced. 
>    Testers would be enabled to do Sparse checks "alongside" of a normal 
>    kernel build. (Sparse is plenty fast for this to be practical)
Already present.

> 
>  - kbuild mechanism with which subsystem maintainers could mark specific 
>    files (or all of their subdirectories) of their subsystem as to be 
>    Sparse-checked by default. [if a .config debug option is enabled]
>    For example we'd mark all of arch/x86/*.o and kernel/sched*.o in such 
>    a way for example.
That would then be on a directory basis.
You can do:
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..1ba00aa 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the linux kernel.
 #

+KBUILD_CHECKSRC=1
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
            exit.o itimer.o time.o softirq.o resource.o \
            sysctl.o capability.o ptrace.o timer.o user.o \

already today.
It applies recursively so we will then run sparse on kernel/time/*.o too.

There is no easy way to cover all of arch/x86/*.o as the files are distributed
in several Makefiles and there is no common one.

> 
>  - a second layer would be very useful as well: failures would turn into 
>    build failures if a debug .config switch is enabled.
This could be a simple:
ifdef CONFIG_CHECK_IS_ERROR
CHECKFLAGS += -Werror
endif

And teach sparse about -Werror

> On a similar note, it would be nice if subsystem maintainers had a 
> kbuild mechanism to have the fails they maintain to be built via -Werr 
> (if an opt-in .config option is enabled).

For each Makefile (does not apply recursively):
ccflags-$(CONFIG_PROMOTE_WARNINGS_TO_ERROR) += -Werror

When I get around to it:
ccflags-sched.o-$(CONFIG_PROMOTE_WARNINGS_TO_ERROR) += -Werror

	Sam
