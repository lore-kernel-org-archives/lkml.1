Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbZFEEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbZFEEA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbZFEEAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:00:21 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:41833 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZFEEAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SbBPbWHe2hpIYw1+qjONm+jhMhcSADFJs7bv4Uru9CSvgOQ7w1jldOBJpilgbKAfXB
         wNoxnrDr+wHGTG2kp3J9z/wsPlMXe+aXeSxeWPGH3MXQ2v/58U5DfiJBzbcYDOuN/Eg/
         ZDdryLUobrS6V1Unj+3YJM59yBRxEpx2SG2rA=
MIME-Version: 1.0
In-Reply-To: <20090604192723.36874fcb.akpm@linux-foundation.org>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	 <20090604175030.55cc4a68.akpm@linux-foundation.org>
	 <8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
	 <20090604180420.2805fcdd.akpm@linux-foundation.org>
	 <8bd0f97a0906041850v4a41082fkf9726ae1bdd299cb@mail.gmail.com>
	 <20090604192723.36874fcb.akpm@linux-foundation.org>
Date: Fri, 5 Jun 2009 00:00:22 -0400
Message-ID: <8bd0f97a0906042100j9a44f95g7d05a515725c9d5@mail.gmail.com>
Subject: Re: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 22:27, Andrew Morton wrote:
> On Thu, 4 Jun 2009 21:50:49 -0400 Mike Frysinger wrote:
>> On Thu, Jun 4, 2009 at 21:04, Andrew Morton wrote:
>> > On Thu, 4 Jun 2009 20:55:40 -0400 Mike Frysinger wrote:
>> >> On Thu, Jun 4, 2009 at 20:50, Andrew Morton wrote:
>> >> > On Tue, __2 Jun 2009 03:17:30 -0400 Mike Frysinger wrote:
>> >> >> + __ __ instruction_pointer(&kgdbts_regs) += offset;
>> >> >
>> >> > instruction_pointer() cannot be used as an lvalue, thankfully.
>> >> >
>> >> > x86_64:
>> >> >
>> >> > drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
>> >> > drivers/misc/kgdbts.c:306: error: invalid lvalue in assignment
>> >>
>> >> should be easy to fix:
>> >> --- a/arch/x86/include/asm/ptrace.h
>> >> +++ b/arch/x86/include/asm/ptrace.h
>> >> @@ -236,10 +236,7 @@
>> >> __#endif
>> >> __}
>> >>
>> >> -static inline unsigned long instruction_pointer(struct pt_regs *regs)
>> >> -{
>> >> - __ return regs->ip;
>> >> -}
>> >> +#define instruction_pointer(regs) ((regs)->ip)
>> >>
>> >> __static inline unsigned long frame_pointer(struct pt_regs *regs)
>> >> __{
>> >
>> > argh, that's soooooo tasteless. __Look, this:
>> >
>> > __ __ __ __instruction_pointer(&kgdbts_regs) += offset;
>> >
>> > is just daft. __It's not C!
>
> Gets frustrating when I say correct things and your first reaction is
> to argue.

i'm not arguing for fun.  my solution results in less maintenance on
the people who actually have to write and maintain this code.  i never
said your points didnt make sense, just that they required more work
for questionable (imo) results.

>> it is C.  taste is one thing, but valid C is still valid C.
>
> It can be compiled.  But it is not idiomatically C.  You can implement
> any level of stupidity with the preprocessor and compile the result.
> That doesn't make it desirable.

taste vs validity -- different things

> Plus all the other things I said which you ignored.  Plus the
> conversion to a macros weakens typechecking.

i didnt ignore them.  i just didnt think the trade off of actual usage
was worth a single macro.

>> > It makes no sense to define something which
>> > looks like a function and to then assign values to it. __It means that
>> > instruction_pointer() _must_ be implemented as a macro, violating basic
>> > concepts of encapsualtion/layering/hiding/etc.
>> >
>> > Doing
>> >
>> > void instruction_pointer_set(struct pt_regs *regs, some_suitable_type val);
>> >
>> > will save many vomit bags.
>>
>> and force everyone to implement the same copy & paste set of get/set
>> modifiers ?  x86 is the only one where instruction_pointer() isnt a
>> define.
>
> Please, look at ia64:
>
> # define instruction_pointer(regs) ((regs)->cr_iip + ia64_psr(regs)->ri)

that i am willing to accept as a reason to go with inlines.  if all
arches were simply redirecting to a register, then i would disagree.
your version after all requires every arch to copy & paste this crap:
static inline unsigned long instruction_pointer(struct pt_regs *regs)
{
    return regs->ip;
}
static inline void instruction_pointer_set(struct pt_regs *regs,
unsigned long val)
{
    regs->ip = val;
}

and then actual usage turns into:
instruction_pointer_set(regs, instruction_pointer(regs) + foo);

whereas mine is two lines:
#define instruction_pointer(regs) ((regs)->ip)
instruction_pointer(regs) += val;
-mike
