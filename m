Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYF0Uu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYF0Uu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYF0UuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYF0UuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
In-Reply-To: Jeremy Fitzhardinge's message of  Friday, 20 June 2008 15:00:21 -0700 <485C2875.2050204@goop.org>
References: <485C2875.2050204@goop.org>
X-Windows: never had it, never will.
Message-Id: <20080627204954.166D0154077@magilla.localdomain>
Date: Fri, 20 Jun 2008 16:39:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can work out, an x86_32 kernel will use "int 0x80" and 
> "sysenter" for system calls.  64-bit kernel will use just "syscall" for 
> 64-bit processes (though you can use "int 0x80" to access the 32-bit 
> syscall interface from a 64-bit process), but will allow "sysenter", 
> "syscall" or "int 0x80" for 32-on-64 processes.

That is correct, with the caveats below.

> Why does 32-on-64 implement 32-bit syscall when native 32-bit doesn't 
> seem to?  Or am I overlooking something here?  Does 32-bit also support 
> syscall?

I think it is clearest to talk separately about the "intended ABI", the
"what actually works today", and the "why".  (Also note I was not the
decision-maker in this, just picking up what I can see.)

First and simplest, the 64-bit ABI.  AFAIK the intended ABI has always been
the "syscall" instruction for 64-bit syscalls and "int $0x80" for 32-bit
syscalls made from 64-bit tasks on CONFIG_IA32_EMULATION kernels (intended
for valgrind).  For 64-bit processes, that's all there is meant to be and
that's all there is to do.

For the 32-bit ABI, what I believe was always the intent for what could be
considered the proper ABI is "int 0x80" or "use the vDSO entry point".  If
someone asked me what you could ever have expected to rely on for the
future, I would say exactly that.  The use of the vDSO is explicitly
intended to take the details of sysenter/syscall or other such new
instructions out of the 32-bit ABI picture for what any proper application
will expect from the kernel.

As to what works, "int 0x80" of course works the same everywhere.  

In 32-bit kernels, the vDSO uses "sysenter" when the hardware supports it.
By the nature of "sysenter", it really cannot "allow sysenter" in a generic
sense--it enables entry via "sysenter" when the hardware supports it, but
it always returns to the specific PC address where it mapped the vDSO.

32-bit kernels never support using "syscall".

In 64-bit kernels, the 32-bit vDSO uses "sysenter" when the hardware vendor
is Intel or Centaur, and "syscall" otherwise (never "int 0x80", though that
still works outside the vDSO).  All 64-bit kernels enable support for both
32-bit "sysenter" and 32-bit "syscall" via their respective MSRs.  (The
vDSO selection is based on what we think the hardware actually supports.)

As to why, here is what I've pieced together.

The intent of the choices in the kernel's selection of the vDSO has always
been "whatever is fastest on this hardware".  I have never myself been
involved in any measuring or comparison of the various methods, so I can't
speak to the actual choices made or how much attention was really paid.

The "syscall"/"sysret" instruction interface (AMD's invention) is superior
to "sysenter"/"sysexit" (Intel's invention).  It was always part of the
x86_64 interface, since AMD got there first.  So all processors support
64-bit user tasks using "syscall".  It's good and even if the privileged
CPU details changed, keeping "syscall" as the user instruction will be fine.

AMD's were the first x86_64 CPUs, and those always supported "syscall"
from 32-bit tasks to 64-bit kernels.  (I don't know whether AMD CPUs now
support "sysenter" from 32-bit tasks to 64-bit kernels, and if so which
past AMD64 CPUs may not have supported that.  On today's kernel you could
easily test it by hacking use_sysenter=1 into syscall32_cpu_init and
trying that kernel on an AMD64 CPU.  I wouldn't be surprised if it does
work on all cpu_has(X86_FEATURE_SEP) CPUs from AMD too.)

Intel CPUs do not support "syscall" from 32-bit tasks at all (as per their
documentation), but do support "sysenter" from 32-bit tasks to 64-bit kernels.
I'm not aware of there having been any Intel x86_64 CPU that did not support
"sysenter" this way.

Using "syscall" when it works kind of looks preferable across the board
because the interface is better.  I assume that if AMD's x86_64 CPUs do
support 32->64 "sysenter" too, that "syscall" performs at least as well.
I assume that if Intel or other vendors added 32->64 "syscall" support,
they would not add it unless they were making it the optimal path.

For 32-bit kernels, we assume that whenever "sysenter" is available, it's
at least preferable to "int 0x80".  I don't know the order of AMD's
introduction of "syscall" on 32-bit CPUs and Intel's introduction of
"sysenter", but Linux only ever got a vsyscall using "sysenter".  

It was long on my back-burner list to toss in the "syscall" version of the
32-bit vDSO for 32-bit kernels on hardware that supports "syscall".  But,
several recent generations of AMD CPUs do support "sysenter" for 32-bit
kernels, and I haven't myself had on hand for easy kernel hacking one of
the AMD CPUs that supported "syscall" but not "sysenter".  Nowadays, more
and more people can (and should) run a 64-bit kernel anyway.  So it hasn't
seemed worth the trouble.  (If AMD is today making CPUs where for 32-bit
kernels "sysenter" performs much worse than "syscall", then perhaps it is
worth the effort if using 32-bit kernels is the fastest thing for someone.)


Thanks,
Roland
