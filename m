Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZCPWI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZCPWI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZCPWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:08:46 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:58694 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZCPWIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EA+0p8EKbFrv1L8uASjkQUgQI2ttW/3r0zbctrACvExpbC6MdOVBB109U2RVBVwqCU
         JVvjPpmA9PDl2OMyDbQVrHW28tm+q+CRVR+XzHskNyeLpxbxcbr2LtN/vbRKaxHf+KcI
         OYOli2ZnIwBaduOCbEG8zISnde6pghLhgKbrM=
MIME-Version: 1.0
In-Reply-To: <200903161521.00036.rob@landley.net>
References: <200903120437.03837.rob@landley.net>
	 <10f740e80903130514k194fbdackd373d2951a9f76ba@mail.gmail.com>
	 <49BE48B3.6060108@snapgear.com> <200903161521.00036.rob@landley.net>
Date: Mon, 16 Mar 2009 23:08:39 +0100
X-Google-Sender-Auth: 345fe0bcc5bfdb25
Message-ID: <10f740e80903161508r3c5f2017sbdb45779662fc854@mail.gmail.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 21:20, Rob Landley <rob@landley.net> wrote:
> On Monday 16 March 2009 07:40:19 Greg Ungerer wrote:
>> Geert Uytterhoeven wrote:
>> > On Fri, Mar 13, 2009 at 11:52, Greg Ungerer <gerg@snapgear.com> wrote:
>> >> Sam Ravnborg wrote:
>> >>> On Fri, Mar 13, 2009 at 09:33:18AM +0100, Geert Uytterhoeven wrote:
>> >>>> On Fri, Mar 13, 2009 at 09:25, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >>>>> On Fri, Mar 13, 2009 at 05:04:57PM +1000, Greg Ungerer wrote:
>> >>>>>> I pretty quick time I can fix up the last couple on the above list.
>> >>>>>> But do we want to put all that change into 2.6.29-rc at this point?
>> >>>>>
>> >>>>> In general we do not want to have headers_check broken in mainline,
>> >>>>
>> >>>> headers_check is not broken, headers_install is.
>> >>>>
>> >>>> Hmm, in some sense headers_check _is_ broken, as it doesn't notice
>> >>>> headers_install
>> >>>> installs headers that refer to other headers that are not installed...
>> >>>
>> >>> This is what scripts/headers_check are supposed to do - strange.
>> >>>
>> >>>> Greg, I had a quick look at your signcontext.h and signal.h merge, and
>> >>>> the MMU
>> >>>> part seems to be OK.
>> >>>>
>> >>>> However, some of the installed headers still have checks for
>> >>>> CONFIG_MMU:
>> >>>>
>> >>>> param.h:#ifdef CONFIG_MMU
>> >>>> sigcontext.h:#ifndef CONFIG_MMU
>> >>>> sigcontext.h:#ifdef CONFIG_MMU
>> >>>> siginfo.h:#ifdef CONFIG_MMU
>> >>>> siginfo.h:#ifdef CONFIG_MMU
>> >>>> siginfo.h:#endif /* CONFIG_MMU */
>> >>>> swab.h:#elif defined(CONFIG_MMU)
>> >>>>
>> >>>> so these have to be added to the generic unifdef-y list (is that
>> >>>> include/asm-generic/Kbuild.asm?).
>> >>
>> >> Hmmm, yes your right.
>> >>
>> >>> include/asm-generic/Kbuild.asm impacts all architectures so be carefull
>> >>> there.
>> >>> It looks like some updates to arch/m68k/include/asm/Kbuild is needed,
>> >>> and not the generic list of files to export.
>> >>>
>> >>> Also use og CONFIG_MMU suprises me.
>> >>> We used #ifdef __uClinux__ in the non-merged headers to avoid use
>> >>> of a CONFIG_* symbol that is not valid outside the kernel namespace.
>> >>> So if param.h in m68k uses CONFIG_MMU it is broken.
>> >>
>> >> I have been trying to use CONFIG_MMU wherever possible (so for non-
>> >> exported headers), since that matches what is actually in the code
>> >> proper. I am concerned at the longer term use of __uClinux__ for
>> >> distinguishing MMU and non-MMU. I plan on switching to use a normal
>> >> m68k toolchain soon. And it won't define __uClinux__ on its own.
>> >> (I already do this on ARM for example - same toolchain on both
>> >> MMU an non-MMU).
>> >>
>> >> What I have done so far is or the most part a very simple merge
>> >> of the files. I know there is room for some improvements in quite a
>> >> few of these files.
>> >>
>> >> The use of CONFIG_MMU in swab.h (is this actually exported to user
>> >> space?) is not actually for code that is MMU or non-MMU. It is
>> >> actually architecture specific. Most ColdFire parts don't have the
>> >> "rolw" instruction. The condition test can be better. Geert, any
>> >> ideas on what is more appropriate here?
>> >
>> > The `rolw' variant is already protected by `#if defined
>> > (__mcfisaaplus__) || defined (__mcfisac__)',
>> > so I think you can replace the `#elif defined(CONFIG_MMU)' by a plain
>> > `#else'. Or are there cases where you don't want to have __arch_swab32 at
>> > all?
>>
>> Not all ColdFire fit into '(__mcfisaaplus__) || defined (__mcfisac__)'
>> so #else won't be good enough. Though I suspect it is true that the
>> older m68k varients (68328, etc) can do "rolw" - or I am I mistaken on
>> that?
>>
>> >> I can switch back to using __uClinux__ on siginfo.h and sigcontext.h.
>> >> If I am not mistaken we can't change these structures without breaking
>> >> backwards compatibility?  The sigcontext change is particularly ugly :-(
>> >
>> > Copying the signal experts on linux-m68k...
>> >
>> >> Similarly for param.h, it looks like a switch back to using
>> >> __uClinux__ for now is the only option.
>> >>
>> >> Now after these fixups should I create a git branch with these header
>> >> merges in for inclusion into 2.6.29-rc?  To fix the regression we
>> >> only need to do the handful of files that Rob listed, right?
>> >
>> > Yes.
>>
>> Ok, I have created a git branch for this as:
>>
>> The following changes since commit
>> 5bee17f18b595937e6beafeee5197868a3f74a06: Kyle McMartin (1):
>>          parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>> fix-includes
>>
>> Greg Ungerer (8):
>>        m68k: merge the non-MMU and MMU versions of param.h
>>        m68k: merge the non-MMU and MMU versions of swab.h
>>        m68k: merge the non-MMU and MMU versions of sigcontext.h
>>        m68k: merge the non-MMU and MMU versions of siginfo.h
>>        m68k: use MMU version of setup.h for both MMU and non-MMU
>>        m68k: merge the non-MMU and MMU versions of ptrace.h
>>        m68k: merge the non-MMU and MMU versions of signal.h
>>        m68k: use the MMU version of unistd.h for all m68k platforms
>>
>>   arch/m68k/include/asm/param.h         |   25 ++-
>>   arch/m68k/include/asm/param_mm.h      |   22 --
>>   arch/m68k/include/asm/param_no.h      |   22 --
>>   arch/m68k/include/asm/ptrace.h        |   88 ++++++++-
>>   arch/m68k/include/asm/ptrace_mm.h     |   80 -------
>>   arch/m68k/include/asm/ptrace_no.h     |   87 --------
>>   arch/m68k/include/asm/setup.h         |  377
>> ++++++++++++++++++++++++++++++++-
>>   arch/m68k/include/asm/setup_mm.h      |  376
>> --------------------------------
>>   arch/m68k/include/asm/setup_no.h      |   10 -
>>   arch/m68k/include/asm/sigcontext.h    |   25 ++-
>>   arch/m68k/include/asm/sigcontext_mm.h |   19 --
>>   arch/m68k/include/asm/sigcontext_no.h |   17 --
>>   arch/m68k/include/asm/siginfo.h       |   95 ++++++++-
>>   arch/m68k/include/asm/siginfo_mm.h    |   92 --------
>>   arch/m68k/include/asm/siginfo_no.h    |    6 -
>>   arch/m68k/include/asm/signal.h        |  216 ++++++++++++++++++-
>>   arch/m68k/include/asm/signal_mm.h     |  206 ------------------
>>   arch/m68k/include/asm/signal_no.h     |  159 --------------
>>   arch/m68k/include/asm/swab.h          |   30 +++-
>>   arch/m68k/include/asm/swab_mm.h       |   16 --
>>   arch/m68k/include/asm/swab_no.h       |   24 --
>>   arch/m68k/include/asm/unistd.h        |  377
>> ++++++++++++++++++++++++++++++++-
>>   arch/m68k/include/asm/unistd_mm.h     |  372
>> --------------------------------
>>   arch/m68k/include/asm/unistd_no.h     |  372
>> --------------------------------
>>   24 files changed, 1206 insertions(+), 1907 deletions(-)
>>   delete mode 100644 arch/m68k/include/asm/param_mm.h
>>   delete mode 100644 arch/m68k/include/asm/param_no.h
>>   delete mode 100644 arch/m68k/include/asm/ptrace_mm.h
>>   delete mode 100644 arch/m68k/include/asm/ptrace_no.h
>>   delete mode 100644 arch/m68k/include/asm/setup_mm.h
>>   delete mode 100644 arch/m68k/include/asm/setup_no.h
>>   delete mode 100644 arch/m68k/include/asm/sigcontext_mm.h
>>   delete mode 100644 arch/m68k/include/asm/sigcontext_no.h
>>   delete mode 100644 arch/m68k/include/asm/siginfo_mm.h
>>   delete mode 100644 arch/m68k/include/asm/siginfo_no.h
>>   delete mode 100644 arch/m68k/include/asm/signal_mm.h
>>   delete mode 100644 arch/m68k/include/asm/signal_no.h
>>   delete mode 100644 arch/m68k/include/asm/swab_mm.h
>>   delete mode 100644 arch/m68k/include/asm/swab_no.h
>>   delete mode 100644 arch/m68k/include/asm/unistd_mm.h
>>   delete mode 100644 arch/m68k/include/asm/unistd_no.h
>>
>>
>> I have only patched those files that I saw mentioned in the previous
>> emails in this thread.
>>
>> Geert, can you check an m68k build?

You introduced a build regression by moving the #include <asm-generic/siginfo.h>
to the bottom of arch/m68k/include/asm/siginfo.h.

After fixing that (patch below, did gmail webmail preserve the tabs?),
atari_defconfig builds
and runs on ARAnyM. I'm now building a sun3_defconfig...

diff --git a/arch/m68k/include/asm/siginfo.h b/arch/m68k/include/asm/siginfo.h
index 9999e7d..f88b4a7 100644
--- a/arch/m68k/include/asm/siginfo.h
+++ b/arch/m68k/include/asm/siginfo.h
@@ -4,7 +4,11 @@
 #ifndef __uClinux__
 #define HAVE_ARCH_SIGINFO_T
 #define HAVE_ARCH_COPY_SIGINFO
+#endif
+
+#include <asm-generic/siginfo.h>

+#ifndef __uClinux__
 typedef struct siginfo {
 	int si_signo;
 	int si_errno;
@@ -89,6 +93,4 @@ static inline void copy_siginfo(struct siginfo *to,
struct siginfo *from)
 #endif /* __KERNEL__ */
 #endif /* __uClinux__ */

-#include <asm-generic/siginfo.h>
-
 #endif

>> Rob, can you check that you can build what you used to be able to?
>
> Nope.  Pulled the repository, tarred it up, stuck it in my build system, and
> the uClibc build still dies attempting to generate syscalls:
>
>  GEN include/bits/sysnum.h
> In file included from <stdin>:1:
> /home/landley/firmware/firmware/build/cross-compiler-
> m68k/include/asm/unistd.h:4:23: error: unistd_mm.h: No such file or directory
> In file included from <stdin>:1:
> /home/landley/firmware/firmware/build/cross-compiler-
> m68k/include/asm/unistd.h:4:23: error: unistd_mm.h: No such file or directory
> ERROR: Could not generate syscalls.

I guess you forgot to check out branch fix-includes? There's no unistd_mm.h in
that branch.

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
