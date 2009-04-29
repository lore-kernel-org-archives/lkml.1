Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZD2Pn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZD2Pn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZD2Pnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:43:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47656 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZD2Pns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:43:48 -0400
Message-ID: <49F875B1.2050502@monstr.eu>
Date: Wed, 29 Apr 2009 17:43:45 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <200904291258.40667.arnd@arndb.de> <49F87009.1000905@monstr.eu> <200904291735.28964.arnd@arndb.de>
In-Reply-To: <200904291735.28964.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 29 April 2009, Michal Simek wrote:
>>> The above is just the nommu variant. For mmu, you need to
>>> have exception handling in __clear_user to take care of the
>>> case where the address is part of the user mapping (access_ok)
>>> but not currently mapped.
>> Is it possible to do it for noMMU kernel too? I mean current MMU
>> implementation of __clear_user in asm is faster than call memset
>> for noMMU. I think I can use MMU implementation for noMMU too.
>> Add two words to __ex_table just extend size of one section but
>> not too much and won't be used for noMMU. 
> 
> Well, you can probably do something like this:
> 
> #ifdef CONFIG_MMU
> #define __FIXUP_SECTION		".section .fixup,\"ax\"\n"
> #define __EX_TABLE_SECTION	".section __ex_table,\"a\"\n"
> #else
> #define __FIXUP_SECTION		".section .discard,\"ax\"\n"
> #define __EX_TABLE_SECTION	".section .discard,\"a\"\n"
> #endif
> 
> +#define __get_user_asm(insn, __gu_ptr, __gu_val, __gu_err)             \
> +({                                                                     \
> +       __asm__ __volatile__ (                                          \
> +                       "1:"    insn    " %1, %2, r0; \n"               \
> +                       "       addk    %0, r0, r0;   \n"               \
> +                       "2:                           \n"               \
> +                        __FIXUP_SECTION				\
> +                       "3:      brid    2b	      \n"               \
> +                       "        addik   %0, r0, %3   \n"               \
> +                       ".previous		      \n"               \
> +                        __EX_TABLE_SECTION	                        \
> +                       ".word   1b,3b		      \n"               \
> +                       ".previous		      \n"               \
> +               : "=r"(__gu_err), "=r"(__gu_val)                        \
> +               : "r"(__gu_ptr), "i"(-EFAULT)                           \
> +       );                                                              \
> +})
> 
> This should simply throw away all the fixups if you list the .discard
> section in vmlinux.lds.S under '/DISCARD/:', so you have no
> overhead at all.

ok. I'll try it.

I look at user_bad macros.

#define __get_user_bad()	(bad_user_access_length(), (-EFAULT))

For powerpc I found these tree references. Where is the __get_user_bad definition?
arch/powerpc/include/asm/uaccess.h:216:extern long __get_user_bad(void);
arch/powerpc/include/asm/uaccess.h:263:         (x) = __get_user_bad();                         \
arch/powerpc/include/asm/uaccess.h:269: default: (x) = __get_user_bad();                        \

Michal


> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
