Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZFXPDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZFXPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZFXPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:03:06 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:51382 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZFXPDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bn128ERJXNy2j8jcbxwl2+Iz1DvhJjcwBX6/vnrb2dFBGYC1yBuYgIOd/R9f76vbPd
         pZz6s8QtQ9DqVMF36elPoOcy5l2cuxZCqkuy8wlVCjhR0mk4tyKr7BKPFVZ5loen6FBg
         QLRbt+9wtD44FjBlwX1X6lpm3tCGQC7CMaM3o=
MIME-Version: 1.0
In-Reply-To: <200906241602.38422.arnd@arndb.de>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> 
	<20090624131357.GA6224@elte.hu> <200906241602.38422.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 11:02:48 -0400
Message-ID: <8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for 
	some arches
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:02, Arnd Bergmann wrote:
> On Wednesday 24 June 2009, Ingo Molnar wrote:
>> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> > if we look at linux/hardirq.h, it makes this claim:
>> >  * - bit 28 is the PREEMPT_ACTIVE flag
>> > if that's true, then why are we letting any arch set this define ?  a
>> > quick survey shows that half the arches (11) are using 0x10000000 (bit
>> > 28) while the other half (10) are using 0x4000000 (bit 26).  and then
>> > there is the ia64 oddity which uses bit 30.  the exact value here
>> > shouldnt really matter across arches though should it ?
>
> actually alpha, arm and avr32 also use bit 30 (0x40000000), there are only
> five (or eight, depending on how you count) architectures (blackfin, h8300,
> m68k, s390 and sparc) using bit 26.

meh, too many zeros ;)

>> Correct - what matters is to have no collision between the fields.
>>
>> > how about adding this to linux/thread_info.h:
>> > #ifndef PREEMPT_ACTIVE
>> > # ifndef PREEMPT_ACTIVE_BIT
>> > #  define PREEMPT_ACTIVE_BIT 28
>> > # endif
>> > # define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
>> > #endif
>>
>> Makes sense i guess - but do we really need that level of
>> #ifdef nesting? PREEMPT_ACTIVE_BIT should be the main control - with
>> a default to 28 if it's not set. PREEMPT_ACTIVE is then derived off
>> that, without any #ifdefs.
>
> I think it would fit better into linux/hardirq.h instead of
> linux/thread_info.h, because that is where the other bits of
> the preempt count are defined.

agreed

> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -62,6 +62,12 @@
>  #define HARDIRQ_OFFSET (1UL << HARDIRQ_SHIFT)
>  #define NMI_OFFSET     (1UL << NMI_SHIFT)
>
> +#ifndef PREEMPT_ACTIVE
> +#define PREEMPT_ACTIVE_BITS    1
> +#define PREEMPT_ACTIVE_SHIFT   (NMI_SHIFT + NMI_BITS)
> +#define PREEMPT_ACTIVE (__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)

i think you meant "<< PREEMPT_ACTIVE_SHIFT" there.  once i make that
change, it builds fine.
-mike
