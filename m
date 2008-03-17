Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYCQJPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYCQJPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYCQJPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:15:42 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:37876
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbYCQJPm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:15:42 -0400
Message-Id: <47DE44F6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Mon, 17 Mar 2008 09:16:22 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com> <47DAE909.20006@redhat.com>
In-Reply-To: <47DAE909.20006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.25-rc5/include/asm-x86/bitops.h	2008-03-10 13:24:33.000000000 +0100
>> +++ 2.6.25-rc5-x86-clear-bit/include/asm-x86/bitops.h	2008-03-13 08:45:40.000000000 +0100
>> @@ -24,9 +24,12 @@
>>  /* Technically wrong, but this avoids compilation errors on some gcc
>>     versions. */
>>  #define ADDR "=m" (*(volatile long *) addr)
>> +#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
>>  #else
>>  #define ADDR "+m" (*(volatile long *) addr)
>> +#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
>>  #endif
>> +#define BASE_ADDR "m" (*(volatile int *) addr)
>
>Can't you just do everything with unsigned longs, like this?

That's not very desirable: For one part, because there are uses of
bitops on arrays of ints (and casting these up isn't fully correct on
x86-64 because of the same reason that using the bitops on char
arrays isn't correct (see the other response I sent to Jeremy's reply),
but also because operating on longs requires REX prefixes n x86-64,
hence making the code bigger for no good reason.

>>In include/asm-x86/types.h:
>>
>> ifdef CONFIG_X86_32
>> # define BITS_PER_LONG 32
>>+# define BITMAP_ORDER 5
>> #else
>> # define BITS_PER_LONG 64
>>+# define BITMAP_ORDER 6
>> #endif
>
>Then:
>
>>  #define ADDR "=m" (*(volatile long *) addr)
>> +#define BIT_ADDR "=m" (((volatile long *) addr)[nr >> BITMAP_ORDER])
>>  #else
>>  #define ADDR "+m" (*(volatile long *) addr)
>> +#define BIT_ADDR "+m" (((volatile long *) addr)[nr >> BITMAP_ORDER])
>>  #endif
>
>No need for BASE_ADDR that way (or ADDR could be renamed to that.)

Not really, since BASE_ADDR is an input, whereas ADDR is an output.
However, ultimately all uses of ADDR should go (since even if any of
the functions needs the memory clobber to stay, using an input for
specifying the array base address is sufficient - such operations simply
don't need an exact "m" output operand then).

Jan

