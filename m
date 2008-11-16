Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYKPVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYKPVZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYKPVZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:25:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYKPVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:25:17 -0500
Message-Id: <20081116212428.938752312@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 16 Nov 2008 16:24:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/7] Porting dynmaic ftrace to PowerPC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are for my work on porting the new dynamic ftrace
framework to PowerPC.  The issue I had with both PPC64 and PPC32 is
that the calls to mcount are 24 bit jumps. Since the modules are
loaded in vmalloc address space, the call to mcount is farther than
what a 24 bit jump can make. The way PPC solves this is with the use
of trampolines. The trampoline is a memory space allocated within the
24 bit region of the module. The code in the trampoline that the
jump is made to does a far jump to the core kernel code.

The way PPC64 implements this is slightly different than the way
PPC32 does. Since my PPC64 box has a serial port it makes developing
and debugging easier, so my first patches port to PPC64, and then
the later patches include the work to get PPC32 working.

I'm describing what both PPC archs do in a bit of detail so that the
PPC exports CC'd can tell me if I'm incorrect. I did not read any
PPC specs to find out what was happening, I only reviewed the existing
PPC code that was in Linux.

The PPC64 dynamic ftrace:

PPC64, although works with 64 bit registers, the op codes are still
32 bit in length.  PPC64 uses table of contents (TOC) fields
to make their calls to functions. A function name is really a pointer
into the TOC table that stores the actual address of the function
along with the TOC of that function. The r2 register plays as the
TOC pointer. The actual name of the function is the function name
with a dot '.' prefix.  The reference name "schedule" is really
to the TOC entry, which calls the actual code with the reference
name ".schedule". This also explains why the list of available filter
functions on PPC64 all have a dot prefix.

When a funtion is called, it uses the 'bl' command which is a 24
bit function jump (saving the return address in the link register).
The next operation after all 'bl' calls is a nop. What the module
load code does when one of these 'bl' calls is farther than 24 bits
can handle, it creates a entry in the TOC and has the 'bl' call to
that entry. The entry in the TOC will save the r2 register on the
stack "40(r1)" load the actually function into the ctrl register
and make the far jump using that register (I'm using the term
'far' to mean more than 24 bits, nothing to do with the x86 far jumps
that deal with segments).  The module linker also modifies the
nop after the 'bl' call in the module into an op code that will restore
the r2 register 'ld r2,40(r1)'.

Now for what we need to do with dynamic ftrace on PPC64:

Dynamic ftrace needs to convert these calls to mcount into nops. It
also needs to be able to convert them back into a call to the
ftrace_caller (mcount is just a stub, the actual function recording
is done by a different function called ftrace_caller).

Before the dynamic ftrace modifies any code, it first makes sure
what it is changing is indeed what it expects it to be. This means
the dynamic ftrace code for PPC64 must be fully aware of the module
trampolines. When a mcount call is farther than 24 bits, it
takes a look at where that mcount call is at. The call should be into
an entry in the TOC, and the dynamic ftrace code reads the entry
that the call points to. It makes sure that the entry will make a
call to mcount (otherwise it returns failure).

After verifying that the 'bl' call calls into the TOC that calls
mcount, it converts that 'bl' call into a nop. It also converts
the following op code (the load of r2) into a nop since the TOC
is no longer saved. It does test that the following op is a load
of r2 before making any of the above changes. It also stores the
module structure pointer into the dyn_ftrace record field, for later
use.

On enabling the call back to ftrace_caller, the dynamic ftrace code
first verifys that the two op codes are two nops. It then reads
the dyn_ftrace structure module pointer to find the TOC and the entry
for the ftrace_caller (the ftrace_caller is added to the module
TOC on module load).  It then changes the call to the ftrace_caller
and the op that reloads the r2 register.

Note, to disable the ftrace_caller, the same as the disabling of
mcount is done, but instead it verifies that the TOC entry calls
the ftrace_caller and not mcount.


The PPC32 dynamic ftrace:

The work for PPC32 is very much the same as the PPC64 code but the 32
version does not need to deal with TOCS. This makes the code much
simpler. Pretty much everything as PPC64 is done, except it does not
need to index a TOC.

To disable mcount (or ftrace_caller):

If the call is greater than 24 bits, it looks to see where the 'bl'
jumps to. It verifies that the trampoline that it jumps to makes the
call to 'mcount' (or ftrace_caller if that is what is expected).
It then simply converts the 'bl' to a nop.

To enable ftrace_caller:

The 'bl' is converted to jump to the ftrace_caller trampoline entry
that was created on module load.

I've tested the following patches on both PPC64 and PPC32. I will
admit that the PPC64 does not seem that stable, but neither does the
code when all this is not enabled ;-)  I'll debug it more to see if
I can find the cause of my crashes, which may or may not be related
to the dynamic ftrace code. But the use of TOCS in PPC64 make me
a bit nervious that I did not do this correctly. Any help in reviewing
my code for mistakes would be greatly appreciated.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/ppc


Steven Rostedt (7):
      ftrace, PPC: do not latency trace idle
      ftrace, ppc: convert to new dynamic ftrace arch API
      ftrace: powerpc mcount record port
      ftrace, PPC: use probe_kernel API to modify code
      ftrace, PPC64: handle module trampolines for dyn ftrace
      ftrace,ppc32: enabled dynamic ftrace
      ftrace,ppc32: dynamic ftrace to handle modules

----
 arch/powerpc/Kconfig              |    2 +
 arch/powerpc/include/asm/ftrace.h |   14 +-
 arch/powerpc/include/asm/module.h |   16 ++-
 arch/powerpc/kernel/ftrace.c      |  460 +++++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/idle.c        |    5 +
 arch/powerpc/kernel/module_32.c   |   10 +
 arch/powerpc/kernel/module_64.c   |   13 +
 scripts/recordmcount.pl           |   18 ++-
 8 files changed, 495 insertions(+), 43 deletions(-)
