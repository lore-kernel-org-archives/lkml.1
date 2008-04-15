Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYDOHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYDOHCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYDOHCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:02:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51142 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYDOHCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:02:35 -0400
Message-Id: <48046F4F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 15 Apr 2008 08:03:11 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <480378CC.76E4.0078.0@novell.com> <48038482.90500@goop.org>
In-Reply-To: <48038482.90500@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.04.08 18:21 >>>
>Jan Beulich wrote:
>>  
>> +struct __bits { int _[1UL << (32 - 3 - sizeof(int))]; };
>>   
>
>I don't understand what you're doing here.  The array can be 1<<(32 - 1) 
>bytes (assuming we never allow a 64-bit bit offset).  The int array 
>makes that 1<<(32 - 1 - log2(sizeof(int))) ints.  But I don't see what 
>the sizeof(int) is doing in there.

The array really can be only 1<<(32-1) bits (the bit offset is signed,
but I intentionally neglect this here for not further complicating things,
since its meaningless in this context), hence 1<<(32-4) bytes and
1<<(32-6) ints. So the -3 in there represents the bits-to-bytes
conversion, and the sizeof(int) is for the bytes-to-ints one.

>> +
>>  #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
>>  /* Technically wrong, but this avoids compilation errors on some gcc
>>     versions. */
>> -#define ADDR "=m" (*(volatile long *)addr)
>> -#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
>> +#define ADDR "=m" (*(volatile long *) addr)
>> +#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
>> +#define FULL_ADDR "=m" (*(volatile struct __bits *) addr)
>>  #else
>>  #define ADDR "+m" (*(volatile long *) addr)
>> -#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
>> +#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
>> +#define FULL_ADDR "+m" (*(volatile struct __bits *) addr)
>>  #endif
>> -#define BASE_ADDR "m" (*(volatile int *)addr)
>> +#define BASE_ADDR "m" (*(volatile int *) addr)
>>   
>
>Shouldn't BASE_ADDR also use __bits?  Otherwise it won't get write-read 
>dependencies right (a read could move before a write).

No, BASE_ADDR is used for the address calculation that the raw bt?
instructions are to use, BIT_ADDR specifies the actual field that
changes. They are always used together (and it's BIT_ADDR that's
responsible for representing the dependency), and always under
__builtin_constant_p(nr) (so we know the compiler doesn't need to
generate extra code for computing the [not needed in the instruction]
second address).

Jan

