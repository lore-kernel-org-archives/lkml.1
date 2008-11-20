Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYKTL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYKTL7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYKTL6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:58:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbYKTL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:58:47 -0500
Date: Thu, 20 Nov 2008 06:58:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/9] powerpc: port of dynamic ftrace
In-Reply-To: <20081120081307.GD21785@elte.hu>
Message-ID: <alpine.DEB.1.10.0811200645510.17538@gandalf.stny.rr.com>
References: <20081119212204.318400312@goodmis.org> <20081120081307.GD21785@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Ingo Molnar wrote:
> 
> Hm, something like this shouldnt be pulled into the powerpc tree: it 
> touches the core kernel, x86 code and ftrace code as well.
> 
> Please do the suggestion i outlined and which Paul agreed with: 
> prepare a branch that touches _only_ powerpc files and gets these 
> changes there, without actually breaking the build on powerpc. And 
> please do not name the branch as "hack" - we dont want Paul to pull 
> such a branch name - it will show up in the upstream git logs.
> 
> Those changes should only touch powerpc files. Do not try to shoe-horn 
> already applied ftrace commits into a separate branch with different 
> sha1's. Yes, ftrace wont be enable-able on powerpc when that is 
> pulled, but it will only be for a brief period shortly before the 
> merge window. (and it will all just work fine when integrated 
> together)

As stated in the original post, I also had a separate branch called
ppc/ftrace-disable. Here's the generate posting if I were to send it:

The following patches are in:

  
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: ppc/ftrace-disable


Matt Fleming (1):
      ftrace: align __mcount_loc sections

Steven Rostedt (8):
      ftrace: disable dynamic ftrace from PowerPC
      powerpc: ftrace, do not latency trace idle
      powerpc: ftrace, convert to new dynamic ftrace arch API
      powerpc/ppc64: ftrace, mcount record powerpc port
      powerpc: ftrace, use probe_kernel API to modify code
      powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
      powerpc/ppc32: ftrace, enabled dynamic ftrace
      powerpc/ppc32: ftrace, dynamic ftrace to handle modules

----
 arch/powerpc/Kconfig              |    2 +
 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/ftrace.c      |  473 +++++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 kernel/trace/Kconfig              |    1 +
 scripts/recordmcount.pl           |   20 ++-
 9 files changed, 511 insertions(+), 43 deletions(-)

There is a dependency on Matt's commit for one of the PPC commits to 
apply.  I could hack that commit to work without Matt's patch, but then 
that just postpones conflicts later on.

Matt's change is this:

 scripts/recordmcount.pl           |   20 ++-


The commit to disable PPC is this:

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..d9127f4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -162,6 +162,7 @@ config DYNAMIC_FTRACE
        depends on FUNCTION_TRACER
        depends on HAVE_DYNAMIC_FTRACE
        depends on DEBUG_KERNEL
+       depends on !PPC
        default y
        help
          This option will modify all the calls to ftrace dynamically


This does touch generic code, but this is to handle the chicken and the 
egg problem.  I would like the disabling of PowerPC code in a separate 
commit (one easy to revert). But I can not disable the PowerPC code before 
the code is there. If I disable it after the code is there, then there 
exists a time that PowerPC will not compile due to this not being 
disabled.



> 
> Once this branch is done, and once Paul agrees that it looks OK-ish to 
> him, we can put it into ftrace-next straight away [but still keep it 
> in a separate topic tree in tip/tracing/powerpc - so it can all be 
> reconsidered reversibly if it causes too much merge trouble]. Paul 
> will then be able to pull it in a few weeks, in the runup to the 
> v2.6.29 merge window.

I guess the question comes down to, do I work around Matt's patch?

> 
> The other option is to go the slow route of 2-3 kernel releases to 
> pull this all off.

2 or 3 kernel releases seems a bit extreme. But this is Paul's call.

Paul, any suggestions?

-- Steve

> 
> ok?
> 
> 	Ingo
> 
> 
