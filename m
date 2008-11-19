Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYKSHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYKSHmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKSHmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:42:16 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:43345 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYKSHmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rFNjjzwedDfn64IC/rhoOW9MZQjTzw2vbuqkrVbie7EzfhlF00lg70biEiW9WXQOja
         kCnQjJbA6o1DQ/9bLgpcY+xIc11JLp/KkLpL+vj+vlI/9PcUtpcKU0k+pdHw1qb6s65I
         JNWvVM2u1aK4yIcIRTQjVmCTdqalu7C//3+9E=
Message-ID: <386072610811182342i701497bcne37e6ab0dbefbc5f@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:42:14 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Graf Yang" <graf.yang@analog.com>
In-Reply-To: <20081118225629.eddd23ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-3-git-send-email-cooloney@kernel.org>
	 <20081118225629.eddd23ae.akpm@linux-foundation.org>
X-Google-Sender-Auth: 33691dd427306bff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 2:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu <cooloney@kernel.org> wrote:
>
>> From: Graf Yang <graf.yang@analog.com>
>>
>> Blackfin dual core BF561 processor can support SMP like features.
>> https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>>
>> In this patch, we provide SMP extend to Blackfin header files
>> and machine common code
>>
>>
>> ...
>>
>> +#define atomic_add_unless(v, a, u)                           \
>> +({                                                           \
>> +     int c, old;                                             \
>> +     c = atomic_read(v);                                     \
>> +     while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
>> +             c = old;                                        \
>> +     c != (u);                                               \
>> +})
>
> The macro references its args multiple times and will do weird or
> inefficient things when called with expressions which have
> side-effects, or which do slow things.
>

Right, I think we can replace them to inline functions


>>
>> ...
>>
>> +#include <asm/system.h>              /* save_flags */
>> +
>> +static inline void set_bit(int nr, volatile unsigned long *addr)
>>  {
>>       int *a = (int *)addr;
>>       int mask;
>> @@ -57,21 +91,23 @@ static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
>>       a += nr >> 5;
>>       mask = 1 << (nr & 0x1f);
>>       local_irq_save(flags);
>> -     *a &= ~mask;
>> +     *a |= mask;
>
> I think you just broke clear_bit().  Maybe I'm misreading the diff.
>
>>       local_irq_restore(flags);
>>  }
>>
>>
>> ...
>>
>> +#define smp_mb__before_clear_bit()   barrier()
>> +#define smp_mb__after_clear_bit()    barrier()
>> +
>> +static inline void __set_bit(int nr, volatile unsigned long *addr)
>> +{
>> +     int *a = (int *)addr;
>> +     int mask;
>> +
>> +     a += nr >> 5;
>> +     mask = 1 << (nr & 0x1f);
>> +     *a |= mask;
>> +}
>> +
>> +static inline void __clear_bit(int nr, volatile unsigned long *addr)
>> +{
>> +     int *a = (int *)addr;
>> +     int mask;
>> +
>> +     a += nr >> 5;
>> +     mask = 1 << (nr & 0x1f);
>> +     *a &= ~mask;
>> +}
>> +
>> +static inline void __change_bit(int nr, volatile unsigned long *addr)
>> +{
>> +     int mask;
>> +     unsigned long *ADDR = (unsigned long *)addr;
>> +
>> +     ADDR += nr >> 5;
>> +     mask = 1 << (nr & 31);
>> +     *ADDR ^= mask;
>> +}
>
> I'm surprised there isn't any generic code which can be used for the above.
>

As Nick said, include/asm-generic/bitops/non-atomic.h is the generic code.
We will try it.

>>
>> ...
>>
>
> Gad what a lot of code.  I don't think I have time to read it all, sorry.
>

Thanks a lot for the review, I will forward this patchset to linux-arch.
-Bryan
