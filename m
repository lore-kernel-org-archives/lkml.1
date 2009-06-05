Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZFEBu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZFEBu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZFEBus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:50:48 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:65227 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZFEBus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b44VcsSGrIf/hZpawWPFmPibx8IFC6w/f+ePmjP86I7v0ChimYfo80vkJY9RiaPOzu
         TpOEXoq7a4Z803f0bpznnPsMYMkxviBUT/L8tyUZafkHu9O8n79QfUZn6OzmBg2qtZ+K
         prPpzrFqfnXiEJL8FCNHJVJXUTqAovMnrzHqY=
MIME-Version: 1.0
In-Reply-To: <20090604180420.2805fcdd.akpm@linux-foundation.org>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	 <20090604175030.55cc4a68.akpm@linux-foundation.org>
	 <8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
	 <20090604180420.2805fcdd.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 21:50:49 -0400
Message-ID: <8bd0f97a0906041850v4a41082fkf9726ae1bdd299cb@mail.gmail.com>
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

On Thu, Jun 4, 2009 at 21:04, Andrew Morton wrote:
> On Thu, 4 Jun 2009 20:55:40 -0400 Mike Frysinger wrote:
>> On Thu, Jun 4, 2009 at 20:50, Andrew Morton wrote:
>> > On Tue, __2 Jun 2009 03:17:30 -0400 Mike Frysinger wrote:
>> >> + __ __ instruction_pointer(&kgdbts_regs) += offset;
>> >
>> > instruction_pointer() cannot be used as an lvalue, thankfully.
>> >
>> > x86_64:
>> >
>> > drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
>> > drivers/misc/kgdbts.c:306: error: invalid lvalue in assignment
>>
>> should be easy to fix:
>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -236,10 +236,7 @@
>>  #endif
>>  }
>>
>> -static inline unsigned long instruction_pointer(struct pt_regs *regs)
>> -{
>> -   return regs->ip;
>> -}
>> +#define instruction_pointer(regs) ((regs)->ip)
>>
>>  static inline unsigned long frame_pointer(struct pt_regs *regs)
>>  {
>
> argh, that's soooooo tasteless.  Look, this:
>
>        instruction_pointer(&kgdbts_regs) += offset;
>
> is just daft.  It's not C!

it is C.  taste is one thing, but valid C is still valid C.

> It makes no sense to define something which
> looks like a function and to then assign values to it.  It means that
> instruction_pointer() _must_ be implemented as a macro, violating basic
> concepts of encapsualtion/layering/hiding/etc.
>
> Doing
>
> void instruction_pointer_set(struct pt_regs *regs, some_suitable_type val);
>
> will save many vomit bags.

and force everyone to implement the same copy & paste set of get/set
modifiers ?  x86 is the only one where instruction_pointer() isnt a
define.
-mike
