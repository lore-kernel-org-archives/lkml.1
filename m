Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZCPNM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZCPNM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZCPNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:12:50 -0400
Received: from mail-gx0-f165.google.com ([209.85.217.165]:48073 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZCPNMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:12:49 -0400
X-Greylist: delayed 82582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 09:12:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UEhqXn1nm30TcB6eey/3DanovmFlwQNc143T8kZOk5WhbZZ0VdM0SNG+7mlUrp63jE
         1DdQ5v+gCtGMffCF/2Mpo2Yjl+Y8BEJVqCD6mvo9HLZ3bu3HG7oV5km41Oiv6oPlrTs8
         7ri8rED7qXwgM9vXLrkJY3mOvvzY1MQEMd7Ug=
MIME-Version: 1.0
In-Reply-To: <49BD2FC7.5050903@goop.org>
References: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com>
	 <49BD2FC7.5050903@goop.org>
Date: Mon, 16 Mar 2009 10:12:45 -0300
Message-ID: <ce0170d90903160612j15054a43pe758d59df3be66a8@mail.gmail.com>
Subject: Re: x86: asm doubt
From: Sergio Luis <eeeesti@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 1:41 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Sergio Luis wrote:
>>
>> Hi there,
>>
>> taking a look at arch/x86/power/cpu_(32|64).c, I saw the 32.c one
>> using the following macros
>>
>> #define savesegment(seg, value)                         \
>>        asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
>>
>>
>> #define loadsegment(seg, value)                 \
>>        asm volatile("\n"                       \
>>                     "1:\t"                     \
>>                     "movl %k0,%%" #seg "\n"    \
>>                     "2:\n"                     \
>>                     ".section .fixup,\"ax\"\n" \
>>                     "3:\t"                     \
>>                     "movl %k1, %%" #seg "\n\t" \
>>                     "jmp 2b\n"                 \
>>                     ".previous\n"              \
>>                     _ASM_EXTABLE(1b,3b)        \
>>                     : :"r" (value), "r" (0) : "memory")
>>
>>
>> saving and loading segment registers as in
>>
>> savesegment(es, ctxt->es);
>> loadsegment(es, ctxt->es);
>>
>> the code in cpu_64.c doesn't make use of such macros, doing the following:
>>
>> saving:
>>  asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
>>
>> loading:
>> asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
>>
>> So, my question is... what's the actual difference between both
>> versions? Aren't the macros suitable for the 64 version as well?
>>
>
> In 32-bit mode, moving to a segment register can fault if the underlying
> GDT/LDT entry is invalid.  In 64-bit mode, segment registers are mostly
> decorative and have no function, and moving arbitrary values into them
> doesn't fault, making the exception catching unnecessary.
>
> But it would be good to use the same syntax to load segment registers for
> both architectures to help with unification.
>
>   J
>

Thanks for the explanation, Jeremy. So, maybe we could define those
same macros for X86_64 with something like the following? (sorry, it's
probably whitespace damaged since I am sending through this webmail
thing, but can you at least tell whether it's correct or not?)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 8e626ea..259b85e 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -262,6 +262,20 @@ static inline void native_write_cr8(unsigned long val)
 {
 	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
 }
+
+/*
+ * In 64-bit mode, segment registers are mostly decorative
+ * and have no function, and moving arbitrary values into
+ * them doesn't fault, making the exception catching unnecessary.
+ */
+#define loadsegment(seg, value)			\
+	asm volatile ("movw %%" #seg ", %0" : "=r" (value) : : "memory");
+
+/*
+ * Save a segment register away
+ */
+#define savesegment(seg, value)			\
+	asm volatile ("movw %%" #seg ", %0" : "=m" (value) : : "memory");
 #endif

 static inline void native_wbinvd(void)

---

and a last unrelated question. why do we have a asm/system_64.h file
which defines only two functions read_cr8/write_cr8 that are exactly
identical to native_read_cr8/native_write_cr8 defined in system.h?

Thank you again,
Sergio.
