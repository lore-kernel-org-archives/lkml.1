Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZFXNWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZFXNWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZFXNWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:22:24 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35143 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFXNWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=M8GTNw/rDsSS32ukRaHMiJuvO3DietdqUiKOmm/pmm0RPmuir8H3zSEwkwzXDOyqEv
         PiNQ5rxr09XeY3TYLv75fHR9k3fvrNRYE4OK9iO8xZNVbznJn+WGzhAjHbi9VHHVSka8
         FHcceK+hG1EhCtJbPi1qgbhL1DTmaJeHmeByo=
MIME-Version: 1.0
In-Reply-To: <20090624131357.GA6224@elte.hu>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> 
	<20090624131357.GA6224@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 09:22:05 -0400
Message-ID: <8bd0f97a0906240622i78135066mcbaa2f0add108593@mail.gmail.com>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for 
	some arches
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:13, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> after pulling the latest mainline code, Blackfin started hitting a
>> build failure like so:
>>   CC      arch/blackfin/kernel/asm-offsets.s
>> In file included from include/linux/interrupt.h:12,
>>                  from include/linux/kernel_stat.h:8,
>>                  from arch/blackfin/kernel/asm-offsets.c:32:
>> include/linux/hardirq.h:66:2: error: #error PREEMPT_ACTIVE is too low!
>> make[1]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
>>
>> this is because we've converted to asm-generic for most of our headers
>> (including hardirq.h).  originally we were defining HARDIRQ_BITS
>> ourselves to 8, but then we dropped that in favor of the
>> asm-generic/hardirq.h which setup a default of 8.  but then they
>> dropped it in favor of the linux/hardirq.h default handling ... but it
>> sets it to MAX_HARDIRQ_BITS by default which is 10.  which pushes
>> Blackfin over the edge and into this build error.
>
> hm, you wrote this mail to me but i havent touched asm-generic nor
> blackfin in this cycle.

i didnt say you did.  you seemed to be the guy who would know about
sane values in hardirq/preempt, i was merely giving background on what
lead me here -- those changes arent wrong in any way.

>> if we look at linux/hardirq.h, it makes this claim:
>>  * - bit 28 is the PREEMPT_ACTIVE flag
>> if that's true, then why are we letting any arch set this define ?  a
>> quick survey shows that half the arches (11) are using 0x10000000 (bit
>> 28) while the other half (10) are using 0x4000000 (bit 26).  and then
>> there is the ia64 oddity which uses bit 30.  the exact value here
>> shouldnt really matter across arches though should it ?
>
> Correct - what matters is to have no collision between the fields.
>
>> how about adding this to linux/thread_info.h:
>> #ifndef PREEMPT_ACTIVE
>> # ifndef PREEMPT_ACTIVE_BIT
>> #  define PREEMPT_ACTIVE_BIT 28
>> # endif
>> # define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
>> #endif
>
> Makes sense i guess - but do we really need that level of
> #ifdef nesting? PREEMPT_ACTIVE_BIT should be the main control - with
> a default to 28 if it's not set. PREEMPT_ACTIVE is then derived off
> that, without any #ifdefs.

well, i didnt want to write it like so:
#ifndef PREEMPT_ACTIVE_BIT
# define PREEMPT_ACTIVE_BIT 28
#endif
#ifndef PREEMPT_ACTIVE
# define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
#endif

because if the arch has defined PREEMPT_ACTIVE but not
PREEMPT_ACTIVE_BIT, then things could go bad.  since the only consumer
of PREEMPT_ACTIVE_BIT that i can see is one ia64 assembly file, we can
just avoid the indirection.  i wanted to make it clear that this is
indeed defaulting to bit 28 like the comments in hardirq.h say.  i
also wanted to avoid having to change any arch files other than my own
(i.e. allow people to be grandfathered in).

i guess we can reformat it as:
#ifndef PREEMPT_ACTIVE_BIT
# define PREEMPT_ACTIVE_BIT 28
#endif
#define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
which makes me do the footwork of converting everyone over to PREEMPT_ACTIVE_BIT

> Anyway ... no objections from me in this area (and your build is
> broken so i suspect you want a fix quickly), just please make the
> override clean. Btw., why cannot blackfin use the defaults?

Blackfin is using the defaults.  the issue i pointed out is that the
defaults set up 10 hardirq bits which ultimately conflict with any
arch (and there are 10 of them) that is using bit 26 for
PREEMPT_ACTIVE.  there is no default value for PREEMPT_ACTIVE (yet).
-mike
