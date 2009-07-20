Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZGTAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZGTAJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZGTAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:09:16 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:42653 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZGTAJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YlnZCV1fEq8dP3Et7LREy9qTvqeA+dkfGph22K+jKyIWUZv+r0pjIc9RIBuUCDkAOl
         cXsbDdBe7JpRXGDaY37wRy6MTd6SALVhaEK2LSj3KAHoEyOBcSbCb6kG9FynwaOVlUYn
         4Jp8R2L74hMgMhDYBEYHjz0e96BseJB4ZLO1M=
MIME-Version: 1.0
In-Reply-To: <20090719201330.GA3186@merkur.ravnborg.org>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com>
	 <20090719201330.GA3186@merkur.ravnborg.org>
Date: Sun, 19 Jul 2009 20:09:14 -0400
Message-ID: <817ecb6f0907191709u2abc756cm4bce635ee9b4d0d8@mail.gmail.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 4:13 PM, Sam Ravnborg<sam@ravnborg.org> wrote:
> On Sun, Jul 19, 2009 at 03:43:06PM -0400, Siarhei Liakh wrote:
>> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
>> (static) kernel data area as NX.
>> The following steps are taken to achieve this:
>> 1. Linker scripts are adjusted so .text always starts and end on a page boundary
>> 2. Linker scripts are adjusted so .rodata and .data always starts and
>> end on a page boundary
>> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init_64.c and
>> arch/x86/mm/init_32.c with actual functionality: NX is set for all
>> pages from _etext through _edata
>> 4. mark_nxdata_nx() called from init_post(void) in init/main.c
>>
>> The patch have been developed for Linux 2.6.30 x86 by Siarhei Liakh
>> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>
>
> The patch no longer applies.
> The file vmlinux_32.lds.S and vmlinux_64.lds.S has been unified
> into one file.

That is actually a great news. I will get the latest source and
re-write the patch.

>> --- a/arch/x86/kernel/vmlinux_32.lds.S
>> +++ b/arch/x86/kernel/vmlinux_32.lds.S
>> @@ -47,6 +47,7 @@ SECTIONS
>>       IRQENTRY_TEXT
>>       *(.fixup)
>>       *(.gnu.warning)
>> +     . = ALIGN(PAGE_SIZE);   /* .text should occupy whole number of pages */
>>       _etext = .;                     /* End of text section */
>
> So _etext cover until page boundary - makes sense.
>
>>    } :text = 0x9090
>>
>> @@ -93,6 +94,7 @@ SECTIONS
>>       *(.data.read_mostly)
>>       _edata = .;             /* End of data section */
>>    }
>> +  . = ALIGN(PAGE_SIZE);              /* needed so we can set NX for .data */
>
> But here _edata does not cover until page boundary.
> And alignmnet is located outside the output section
> definition.
> It would be better/more consistent to follow the style you use for .text here.

You are correct. _edata should be the last thing in .data, and
alignment should be done before it. However, this brings up a
question: was there any specific reason to leave .data.init_task
beyond the _edata? Should we move _edata into the the last of the
.data.* sections to have poper view of kernel layout?
