Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbZCPXLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbZCPXLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbZCPXKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:10:51 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:39818 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755243AbZCPXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:10:50 -0400
Message-ID: <49BEDC75.1080704@snapgear.com>
Date: Tue, 17 Mar 2009 09:10:45 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net> <10f740e80903130514k194fbdackd373d2951a9f76ba@mail.gmail.com> <49BE48B3.6060108@snapgear.com> <200903161521.00036.rob@landley.net>
In-Reply-To: <200903161521.00036.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rob,

Rob Landley wrote:
> On Monday 16 March 2009 07:40:19 Greg Ungerer wrote:
>> Geert Uytterhoeven wrote:
>>> On Fri, Mar 13, 2009 at 11:52, Greg Ungerer <gerg@snapgear.com> wrote:
>>>> Sam Ravnborg wrote:
>>>>> On Fri, Mar 13, 2009 at 09:33:18AM +0100, Geert Uytterhoeven wrote:
>>>>>> On Fri, Mar 13, 2009 at 09:25, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>>>>> On Fri, Mar 13, 2009 at 05:04:57PM +1000, Greg Ungerer wrote:
>>>>>>>> I pretty quick time I can fix up the last couple on the above list.
>>>>>>>> But do we want to put all that change into 2.6.29-rc at this point?
>>>>>>> In general we do not want to have headers_check broken in mainline,
>>>>>> headers_check is not broken, headers_install is.
>>>>>>
>>>>>> Hmm, in some sense headers_check _is_ broken, as it doesn't notice
>>>>>> headers_install
>>>>>> installs headers that refer to other headers that are not installed...
>>>>> This is what scripts/headers_check are supposed to do - strange.
>>>>>
>>>>>> Greg, I had a quick look at your signcontext.h and signal.h merge, and
>>>>>> the MMU
>>>>>> part seems to be OK.
>>>>>>
>>>>>> However, some of the installed headers still have checks for
>>>>>> CONFIG_MMU:
>>>>>>
>>>>>> param.h:#ifdef CONFIG_MMU
>>>>>> sigcontext.h:#ifndef CONFIG_MMU
>>>>>> sigcontext.h:#ifdef CONFIG_MMU
>>>>>> siginfo.h:#ifdef CONFIG_MMU
>>>>>> siginfo.h:#ifdef CONFIG_MMU
>>>>>> siginfo.h:#endif /* CONFIG_MMU */
>>>>>> swab.h:#elif defined(CONFIG_MMU)
>>>>>>
>>>>>> so these have to be added to the generic unifdef-y list (is that
>>>>>> include/asm-generic/Kbuild.asm?).
>>>> Hmmm, yes your right.
>>>>
>>>>> include/asm-generic/Kbuild.asm impacts all architectures so be carefull
>>>>> there.
>>>>> It looks like some updates to arch/m68k/include/asm/Kbuild is needed,
>>>>> and not the generic list of files to export.
>>>>>
>>>>> Also use og CONFIG_MMU suprises me.
>>>>> We used #ifdef __uClinux__ in the non-merged headers to avoid use
>>>>> of a CONFIG_* symbol that is not valid outside the kernel namespace.
>>>>> So if param.h in m68k uses CONFIG_MMU it is broken.
>>>> I have been trying to use CONFIG_MMU wherever possible (so for non-
>>>> exported headers), since that matches what is actually in the code
>>>> proper. I am concerned at the longer term use of __uClinux__ for
>>>> distinguishing MMU and non-MMU. I plan on switching to use a normal
>>>> m68k toolchain soon. And it won't define __uClinux__ on its own.
>>>> (I already do this on ARM for example - same toolchain on both
>>>> MMU an non-MMU).
>>>>
>>>> What I have done so far is or the most part a very simple merge
>>>> of the files. I know there is room for some improvements in quite a
>>>> few of these files.
>>>>
>>>> The use of CONFIG_MMU in swab.h (is this actually exported to user
>>>> space?) is not actually for code that is MMU or non-MMU. It is
>>>> actually architecture specific. Most ColdFire parts don't have the
>>>> "rolw" instruction. The condition test can be better. Geert, any
>>>> ideas on what is more appropriate here?
>>> The `rolw' variant is already protected by `#if defined
>>> (__mcfisaaplus__) || defined (__mcfisac__)',
>>> so I think you can replace the `#elif defined(CONFIG_MMU)' by a plain
>>> `#else'. Or are there cases where you don't want to have __arch_swab32 at
>>> all?
>> Not all ColdFire fit into '(__mcfisaaplus__) || defined (__mcfisac__)'
>> so #else won't be good enough. Though I suspect it is true that the
>> older m68k varients (68328, etc) can do "rolw" - or I am I mistaken on
>> that?
>>
>>>> I can switch back to using __uClinux__ on siginfo.h and sigcontext.h.
>>>> If I am not mistaken we can't change these structures without breaking
>>>> backwards compatibility?  The sigcontext change is particularly ugly :-(
>>> Copying the signal experts on linux-m68k...
>>>
>>>> Similarly for param.h, it looks like a switch back to using
>>>> __uClinux__ for now is the only option.
>>>>
>>>> Now after these fixups should I create a git branch with these header
>>>> merges in for inclusion into 2.6.29-rc?  To fix the regression we
>>>> only need to do the handful of files that Rob listed, right?
>>> Yes.
>> Ok, I have created a git branch for this as:
>>
>> The following changes since commit
>> 5bee17f18b595937e6beafeee5197868a3f74a06: Kyle McMartin (1):
>>          parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>> fix-includes
>>
>> Greg Ungerer (8):
>>        m68k: merge the non-MMU and MMU versions of param.h
>>        m68k: merge the non-MMU and MMU versions of swab.h
>>        m68k: merge the non-MMU and MMU versions of sigcontext.h
>>        m68k: merge the non-MMU and MMU versions of siginfo.h
>>        m68k: use MMU version of setup.h for both MMU and non-MMU
>>        m68k: merge the non-MMU and MMU versions of ptrace.h
>>        m68k: merge the non-MMU and MMU versions of signal.h
>>        m68k: use the MMU version of unistd.h for all m68k platforms
>>
>>   arch/m68k/include/asm/param.h         |   25 ++-
>>   arch/m68k/include/asm/param_mm.h      |   22 --
>>   arch/m68k/include/asm/param_no.h      |   22 --
>>   arch/m68k/include/asm/ptrace.h        |   88 ++++++++-
>>   arch/m68k/include/asm/ptrace_mm.h     |   80 -------
>>   arch/m68k/include/asm/ptrace_no.h     |   87 --------
>>   arch/m68k/include/asm/setup.h         |  377
>> ++++++++++++++++++++++++++++++++-
>>   arch/m68k/include/asm/setup_mm.h      |  376
>> --------------------------------
>>   arch/m68k/include/asm/setup_no.h      |   10 -
>>   arch/m68k/include/asm/sigcontext.h    |   25 ++-
>>   arch/m68k/include/asm/sigcontext_mm.h |   19 --
>>   arch/m68k/include/asm/sigcontext_no.h |   17 --
>>   arch/m68k/include/asm/siginfo.h       |   95 ++++++++-
>>   arch/m68k/include/asm/siginfo_mm.h    |   92 --------
>>   arch/m68k/include/asm/siginfo_no.h    |    6 -
>>   arch/m68k/include/asm/signal.h        |  216 ++++++++++++++++++-
>>   arch/m68k/include/asm/signal_mm.h     |  206 ------------------
>>   arch/m68k/include/asm/signal_no.h     |  159 --------------
>>   arch/m68k/include/asm/swab.h          |   30 +++-
>>   arch/m68k/include/asm/swab_mm.h       |   16 --
>>   arch/m68k/include/asm/swab_no.h       |   24 --
>>   arch/m68k/include/asm/unistd.h        |  377
>> ++++++++++++++++++++++++++++++++-
>>   arch/m68k/include/asm/unistd_mm.h     |  372
>> --------------------------------
>>   arch/m68k/include/asm/unistd_no.h     |  372
>> --------------------------------
>>   24 files changed, 1206 insertions(+), 1907 deletions(-)
>>   delete mode 100644 arch/m68k/include/asm/param_mm.h
>>   delete mode 100644 arch/m68k/include/asm/param_no.h
>>   delete mode 100644 arch/m68k/include/asm/ptrace_mm.h
>>   delete mode 100644 arch/m68k/include/asm/ptrace_no.h
>>   delete mode 100644 arch/m68k/include/asm/setup_mm.h
>>   delete mode 100644 arch/m68k/include/asm/setup_no.h
>>   delete mode 100644 arch/m68k/include/asm/sigcontext_mm.h
>>   delete mode 100644 arch/m68k/include/asm/sigcontext_no.h
>>   delete mode 100644 arch/m68k/include/asm/siginfo_mm.h
>>   delete mode 100644 arch/m68k/include/asm/siginfo_no.h
>>   delete mode 100644 arch/m68k/include/asm/signal_mm.h
>>   delete mode 100644 arch/m68k/include/asm/signal_no.h
>>   delete mode 100644 arch/m68k/include/asm/swab_mm.h
>>   delete mode 100644 arch/m68k/include/asm/swab_no.h
>>   delete mode 100644 arch/m68k/include/asm/unistd_mm.h
>>   delete mode 100644 arch/m68k/include/asm/unistd_no.h
>>
>>
>> I have only patched those files that I saw mentioned in the previous
>> emails in this thread.
>>
>> Geert, can you check an m68k build?
>> Rob, can you check that you can build what you used to be able to?
> 
> Nope.  Pulled the repository, tarred it up, stuck it in my build system, and 
> the uClibc build still dies attempting to generate syscalls:
> 
>   GEN include/bits/sysnum.h
> In file included from <stdin>:1:
> /home/landley/firmware/firmware/build/cross-compiler-
> m68k/include/asm/unistd.h:4:23: error: unistd_mm.h: No such file or directory
> In file included from <stdin>:1:
> /home/landley/firmware/firmware/build/cross-compiler-
> m68k/include/asm/unistd.h:4:23: error: unistd_mm.h: No such file or directory
> ERROR: Could not generate syscalls.

Did you get the "fix-includes" branch?

There is no reference to unistd_mm.h in that branch...

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
