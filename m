Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZFEETl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZFEETl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbZFEETd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:19:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZFEETc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lc9aV6hNEBhXjxKNH1UJQgsv5UMR7qcak+G8dqgGZqZ7tB2Wwibhne56gKww7Z3da2
         Ex4YOk+viDauXRYpM/m1BPK0+i6tBRUnkHuSoBXTO7JkiR8pkgPkKu8Rbv/hf3aE8Kf1
         IEjeVFEZwkBmKTEuwY1s8jamyhhzlZPY7Kakc=
MIME-Version: 1.0
In-Reply-To: <20090604211350.9aafa731.akpm@linux-foundation.org>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	 <20090604175030.55cc4a68.akpm@linux-foundation.org>
	 <8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
	 <20090604180420.2805fcdd.akpm@linux-foundation.org>
	 <8bd0f97a0906041850v4a41082fkf9726ae1bdd299cb@mail.gmail.com>
	 <20090604192723.36874fcb.akpm@linux-foundation.org>
	 <8bd0f97a0906042100j9a44f95g7d05a515725c9d5@mail.gmail.com>
	 <20090604211350.9aafa731.akpm@linux-foundation.org>
Date: Fri, 5 Jun 2009 00:19:34 -0400
Message-ID: <8bd0f97a0906042119w6f7237d6n4492740c0adb312c@mail.gmail.com>
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

On Fri, Jun 5, 2009 at 00:13, Andrew Morton wrote:
> On Fri, 5 Jun 2009 00:00:22 -0400 Mike Frysinger wrote:
>> your version after all requires every arch to copy & paste this crap:
>> static inline unsigned long instruction_pointer(struct pt_regs *regs)
>> {
>>     return regs->ip;
>> }
>> static inline void instruction_pointer_set(struct pt_regs *regs,
>> unsigned long val)
>> {
>>     regs->ip = val;
>> }
>>
>> and then actual usage turns into:
>> instruction_pointer_set(regs, instruction_pointer(regs) + foo);
>>
>> whereas mine is two lines:
>> #define instruction_pointer(regs) ((regs)->ip)
>> instruction_pointer(regs) += val;
>
> The aim isn't really to reduce the amount of typing one needs to do.
> Let's get things right, and if getting it right involves more typing
> then so be it.

the aim isnt to reduce typing (although that's a nice result), the aim
is to reduce the amount of work to (1) keep things in shape and (2)
force new ports to implement.  the less code there is, the harder it
is for it to bitrot.

> If it really worries you then you could do
>
> #define GET_IP(regs)    ((regs)->ip)
> #include <asm/generic/instruction_pointer.h>
>
> and
>
> static inline unsigned long instruction_pointer(struct pt_regs *regs)
> {
>        return GET_IP(regs);
> }
>
> static inline void instruction_pointer_set(struct pt_regs *regs,
>                                        unsigned long val)
> {
>        GET_IP(regs) = val;
> }
>
> Note that GET_IP() is all-caps, which says "this is a macro".
>
> But I don't think it's worth the ickyness, unless we also incorporate
> kernel_stack_pointer(), frame_pointer(), user_stack_pointer() and
> perhaps the _set() versions of those also.

yes, having a layer along those lines would satisfy my previous points.

> Do we know how to implement instruction_pointer_set() on ia64, btw?

i havent a clue, but it doesnt matter in this case as ia64 doesnt
support KGDB.  they can figure it out when they want to add KGDB
support :).
-mike
