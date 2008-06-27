Return-Path: <linux-kernel-owner+w=401wt.eu-S1765683AbYF0Vxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765683AbYF0Vxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764591AbYF0Vp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:45:26 -0400
Received: from gw.goop.org ([64.81.55.164]:44851 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764918AbYF0VpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:45:21 -0400
Message-ID: <48655F6C.7000409@goop.org>
Date: Fri, 27 Jun 2008 14:45:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
References: <485C2875.2050204@goop.org> <20080627204954.166D0154077@magilla.localdomain>
In-Reply-To: <20080627204954.166D0154077@magilla.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I think it is clearest to talk separately about the "intended ABI", the
> "what actually works today", and the "why".  (Also note I was not the
> decision-maker in this, just picking up what I can see.)
>
> First and simplest, the 64-bit ABI.  AFAIK the intended ABI has always been
> the "syscall" instruction for 64-bit syscalls and "int $0x80" for 32-bit
> syscalls made from 64-bit tasks on CONFIG_IA32_EMULATION kernels (intended
> for valgrind).

Hm, I think that's a post-facto rationalization.  At one point I noticed 
that int 0x80 always does 32-bit syscalls and considered doing a 
32-on-64 Valgrind variant.  But I never did that, and I don't believe 
anyone else has (but it's been a while since I've been closely involved 
in Valgrind development, so I could be wrong).

>   For 64-bit processes, that's all there is meant to be and
> that's all there is to do.
>
> For the 32-bit ABI, what I believe was always the intent for what could be
> considered the proper ABI is "int 0x80" or "use the vDSO entry point".  If
> someone asked me what you could ever have expected to rely on for the
> future, I would say exactly that.  The use of the vDSO is explicitly
> intended to take the details of sysenter/syscall or other such new
> instructions out of the 32-bit ABI picture for what any proper application
> will expect from the kernel.
>
> As to what works, "int 0x80" of course works the same everywhere.  
>
> In 32-bit kernels, the vDSO uses "sysenter" when the hardware supports it.
> By the nature of "sysenter", it really cannot "allow sysenter" in a generic
> sense--it enables entry via "sysenter" when the hardware supports it, but
> it always returns to the specific PC address where it mapped the vDSO.
>
> 32-bit kernels never support using "syscall".
>
> In 64-bit kernels, the 32-bit vDSO uses "sysenter" when the hardware vendor
> is Intel or Centaur, and "syscall" otherwise (never "int 0x80", though that
> still works outside the vDSO).  All 64-bit kernels enable support for both
> 32-bit "sysenter" and 32-bit "syscall" via their respective MSRs.  (The
> vDSO selection is based on what we think the hardware actually supports.)
>   

Yes.  And it seems that there are no cpuid feature bits relating to 
32-bit compat variants of these instructions (X86_FEATURE_SEP relates to 
whether the 64-bit mode supports SEP, and X86_FEATURE_SYSCALL is only 
set on AMD processors and implicit on 64-bit Intel processors).

> As to why, here is what I've pieced together.
>
> The intent of the choices in the kernel's selection of the vDSO has always
> been "whatever is fastest on this hardware".  I have never myself been
> involved in any measuring or comparison of the various methods, so I can't
> speak to the actual choices made or how much attention was really paid.
>
> The "syscall"/"sysret" instruction interface (AMD's invention) is superior
> to "sysenter"/"sysexit" (Intel's invention).  It was always part of the
> x86_64 interface, since AMD got there first.  So all processors support
> 64-bit user tasks using "syscall".  It's good and even if the privileged
> CPU details changed, keeping "syscall" as the user instruction will be fine.
>
> AMD's were the first x86_64 CPUs, and those always supported "syscall"
> from 32-bit tasks to 64-bit kernels.  (I don't know whether AMD CPUs now
> support "sysenter" from 32-bit tasks to 64-bit kernels, and if so which
> past AMD64 CPUs may not have supported that.  On today's kernel you could
> easily test it by hacking use_sysenter=1 into syscall32_cpu_init and
> trying that kernel on an AMD64 CPU.  I wouldn't be surprised if it does
> work on all cpu_has(X86_FEATURE_SEP) CPUs from AMD too.)
>
> Intel CPUs do not support "syscall" from 32-bit tasks at all (as per their
> documentation), but do support "sysenter" from 32-bit tasks to 64-bit kernels.
> I'm not aware of there having been any Intel x86_64 CPU that did not support
> "sysenter" this way.
>   

The documentation has no caveats or exceptions.

> Using "syscall" when it works kind of looks preferable across the board
> because the interface is better.  I assume that if AMD's x86_64 CPUs do
> support 32->64 "sysenter" too, that "syscall" performs at least as well.
> I assume that if Intel or other vendors added 32->64 "syscall" support,
> they would not add it unless they were making it the optimal path.
>
> For 32-bit kernels, we assume that whenever "sysenter" is available, it's
> at least preferable to "int 0x80".  I don't know the order of AMD's
> introduction of "syscall" on 32-bit CPUs and Intel's introduction of
> "sysenter", but Linux only ever got a vsyscall using "sysenter".  
>   

K6 and Pentium II, respectively, I think (PPro claims to have it, but 
doesn't).  I seem to remember the first sysenter work going in around 
1998/9, so it was after the PII.

> It was long on my back-burner list to toss in the "syscall" version of the
> 32-bit vDSO for 32-bit kernels on hardware that supports "syscall".  But,
> several recent generations of AMD CPUs do support "sysenter" for 32-bit
> kernels, and I haven't myself had on hand for easy kernel hacking one of
> the AMD CPUs that supported "syscall" but not "sysenter".  Nowadays, more
> and more people can (and should) run a 64-bit kernel anyway.  So it hasn't
> seemed worth the trouble.  (If AMD is today making CPUs where for 32-bit
> kernels "sysenter" performs much worse than "syscall", then perhaps it is
> worth the effort if using 32-bit kernels is the fastest thing for someone.)

The AMD documentation says that syscall/sysret is higher performance 
than sysenter/sysexit, but I don't know if that's true, and if so, to 
what degree.  Intel makes no distinction.

HPA and Andi point out that the only AMD cpu which doesn't support 
sysenter is the K6, and its version of syscall is different from the K7 
and later anyway.

Thanks for the clarifying overview.  I've been piecing my understanding 
together as I've been getting 64-bit pvops Xen working, and trying to 
fit what it has to do to implement all these instructions and mode 
combinations, and it looks like I'm about right.

    J
