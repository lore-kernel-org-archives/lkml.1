Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbYGQXYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbYGQXYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933579AbYGQXXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:23:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:36600 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529AbYGQXXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rIWv6hycfMv0yoVqzwqrde/CDwvyQ4eIFoladjdHT3lRZAlTyJysFMFoD/czh/JKcS
         HcBtY00p7H4/IhkMw3kOeT2mr+FSbqAsqyaQ9X83zqPBis0oIFWdL2DIDTmKEG2b2Cx1
         HC+b0ckhVlUlcfmNBFuS0xsNwheXInK21yGds=
Message-ID: <19f34abd0807171623j15e2e940rac790567f5874a87@mail.gmail.com>
Date: Fri, 18 Jul 2008 01:23:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 07/13] kmemcheck: add the kmemcheck core
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20080717144933.8951a558.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716002329.GH12564@localhost.localdomain>
	 <20080717144933.8951a558.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:49 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 16 Jul 2008 02:23:29 +0200 Vegard Nossum wrote:
>
>> >From fcd8f514a8962ea22aafb831b9f22a2ea1a13870 Mon Sep 17 00:00:00 2001
>
> eh?

Uhm, probably relative to my previous patch? About the date, I have no
idea. All my "git format-patch" output looks like this.

>> +++ b/arch/x86/mm/kmemcheck/error.h
>> @@ -0,0 +1,15 @@
>> +#ifndef ARCH__X86__MM__KMEMCHECK__ERROR_H
>> +#define ARCH__X86__MM__KMEMCHECK__ERROR_H
>
> We don't usually use double __ here.

But it's such a nice convention! How can we differentiate between
mm/types.h and mm_types.h!

>> +void *kmemcheck_memset(void *s, int c, size_t n)
>> +{
>> +     unsigned long addr;
>> +     unsigned long start_page, start_offset;
>> +     unsigned long end_page, end_offset;
>> +     unsigned long i;
>> +
>> +     if (!n)
>> +             return s;
>> +
>> +     if (!slab_is_available()) {
>> +             __memset(s, c, n);
>> +             return s;
>> +     }
>> +
>> +     addr = (unsigned long) s;
>> +
>> +     start_page = addr & PAGE_MASK;
>> +     end_page = (addr + n) & PAGE_MASK;
>> +
>> +     if (start_page == end_page) {
>> +             /* The entire area is within the same page. Good, we only
>> +              * need one memset(). */
>> +             memset_one_page(s, c, n);
>> +             return s;
>> +     }
>> +
>> +     start_offset = addr & ~PAGE_MASK;
>> +     end_offset = (addr + n) & ~PAGE_MASK;
>> +
>> +     /* Clear the head, body, and tail of the memory area. */
>> +     if (start_offset < PAGE_SIZE)
>> +             memset_one_page(s, c, PAGE_SIZE - start_offset);
>> +     for (i = start_page + PAGE_SIZE; i < end_page; i += PAGE_SIZE)
>> +             memset_one_page((void *) i, c, PAGE_SIZE);
>> +     if (end_offset > 0)
>> +             memset_one_page((void *) end_page, c, end_offset);
>> +
>> +     return s;
>> +}
>> +
>> +EXPORT_SYMBOL(kmemcheck_memset);
>
> We would prefer to have kernel-doc on exported functions...

Oops. I will not add a kernel-doc, but I will add an explanation.

This function is a drop-in replacement for memset, and the reason for
the EXPORT is that the real memset() in fact is just a macro that
calls this function. And memset is needed in modules. This function
should not actually have any users beside the memset() in x86 headers.

Thanks for mini-review! (Does this mean the rest was okay? :-D)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
