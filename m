Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZCMKxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZCMKxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZCMKxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:53:08 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:37074 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbZCMKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:53:06 -0400
Message-ID: <49BA3B05.9020906@snapgear.com>
Date: Fri, 13 Mar 2009 20:52:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
References: <200903120437.03837.rob@landley.net> <20090312210216.GB14205@uranus.ravnborg.org> <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com> <200903122225.04560.rob@landley.net> <49BA0599.6070206@snapgear.com> <20090313082555.GA19045@uranus.ravnborg.org> <10f740e80903130133r130b8713v690437f0f38eb0b8@mail.gmail.com> <20090313085930.GA19274@uranus.ravnborg.org>
In-Reply-To: <20090313085930.GA19274@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, Mar 13, 2009 at 09:33:18AM +0100, Geert Uytterhoeven wrote:
>> On Fri, Mar 13, 2009 at 09:25, Sam Ravnborg <sam@ravnborg.org> wrote:
>>> On Fri, Mar 13, 2009 at 05:04:57PM +1000, Greg Ungerer wrote:
>>>> I pretty quick time I can fix up the last couple on the above list.
>>>> But do we want to put all that change into 2.6.29-rc at this point?
>>> In general we do not want to have headers_check broken in mainline,
>> headers_check is not broken, headers_install is.
>>
>> Hmm, in some sense headers_check _is_ broken, as it doesn't notice
>> headers_install
>> installs headers that refer to other headers that are not installed...
> This is what scripts/headers_check are supposed to do - strange.
> 
>> Greg, I had a quick look at your signcontext.h and signal.h merge, and the MMU
>> part seems to be OK.
>>
>> However, some of the installed headers still have checks for CONFIG_MMU:
>>
>> param.h:#ifdef CONFIG_MMU
>> sigcontext.h:#ifndef CONFIG_MMU
>> sigcontext.h:#ifdef CONFIG_MMU
>> siginfo.h:#ifdef CONFIG_MMU
>> siginfo.h:#ifdef CONFIG_MMU
>> siginfo.h:#endif /* CONFIG_MMU */
>> swab.h:#elif defined(CONFIG_MMU)
>>
>> so these have to be added to the generic unifdef-y list (is that
>> include/asm-generic/Kbuild.asm?).

Hmmm, yes your right.


> include/asm-generic/Kbuild.asm impacts all architectures so be carefull there.
> It looks like some updates to arch/m68k/include/asm/Kbuild is needed,
> and not the generic list of files to export.
> 
> Also use og CONFIG_MMU suprises me.
> We used #ifdef __uClinux__ in the non-merged headers to avoid use
> of a CONFIG_* symbol that is not valid outside the kernel namespace.
> So if param.h in m68k uses CONFIG_MMU it is broken.

I have been trying to use CONFIG_MMU wherever possible (so for non-
exported headers), since that matches what is actually in the code
proper. I am concerned at the longer term use of __uClinux__ for
distinguishing MMU and non-MMU. I plan on switching to use a normal
m68k toolchain soon. And it won't define __uClinux__ on its own.
(I already do this on ARM for example - same toolchain on both
MMU an non-MMU).

What I have done so far is or the most part a very simple merge
of the files. I know there is room for some improvements in quite a
few of these files.

The use of CONFIG_MMU in swab.h (is this actually exported to user
space?) is not actually for code that is MMU or non-MMU. It is
actually architecture specific. Most ColdFire parts don't have the
"rolw" instruction. The condition test can be better. Geert, any
ideas on what is more appropriate here?

I can switch back to using __uClinux__ on siginfo.h and sigcontext.h.
If I am not mistaken we can't change these structures without breaking
backwards compatibility?  The sigcontext change is particularly ugly :-(

Similarly for param.h, it looks like a switch back to using
__uClinux__ for now is the only option.

Now after these fixups should I create a git branch with these header
merges in for inclusion into 2.6.29-rc?  To fix the regression we
only need to do the handful of files that Rob listed, right?

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
