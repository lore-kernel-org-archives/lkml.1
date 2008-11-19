Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYKSIUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYKSIUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYKSIUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:20:11 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:42310 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYKSIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ltPOtb74wn3ajxLbhjfOPsEG0xUBw5IKKn1QrwPASk8K69R8e0BfExPv/BARfjLYEp
         A68wpU9yfWNsTGbVN3zXVi3PfuHNpDWkIrxqvaZDWVlRdzG3RMR2WFfucHIQzZodd4KS
         L91djR9Ad+CyKCTx1FjEe6r+nWDGPmGLwb6oc=
Message-ID: <386072610811190020w619e5623p8fe2caf3373f8012@mail.gmail.com>
Date: Wed, 19 Nov 2008 16:20:07 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: gyang <graf.yang@analog.com>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin header files and machine common code
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <1227081170.24481.41.camel@dyang>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-3-git-send-email-cooloney@kernel.org>
	 <20081118225629.eddd23ae.akpm@linux-foundation.org>
	 <1227081170.24481.41.camel@dyang>
X-Google-Sender-Auth: 75a6fc3268da0da6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 3:52 PM, gyang <graf.yang@analog.com> wrote:
>
> 在 2008-11-18二的 22:56 -0800，Andrew Morton写道：
>> On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu <cooloney@kernel.org> wrote:
>>
>> > From: Graf Yang <graf.yang@analog.com>
>> >
>> > Blackfin dual core BF561 processor can support SMP like features.
>> > https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>> >
>> > In this patch, we provide SMP extend to Blackfin header files
>> > and machine common code
>> >
>> >
>> > ...
>> >
>> > +#define atomic_add_unless(v, a, u)                         \
>> > +({                                                         \
>> > +   int c, old;                                             \
>> > +   c = atomic_read(v);                                     \
>> > +   while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
>> > +           c = old;                                        \
>> > +   c != (u);                                               \
>> > +})
>>
>> The macro references its args multiple times and will do weird or
>> inefficient things when called with expressions which have
>> side-effects, or which do slow things.
>>
>> >
>> > ...
>> >
>> > +#include <asm/system.h>            /* save_flags */
>> > +
>> > +static inline void set_bit(int nr, volatile unsigned long *addr)
>> >  {
>> >     int *a = (int *)addr;
>> >     int mask;
>> > @@ -57,21 +91,23 @@ static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
>> >     a += nr >> 5;
>> >     mask = 1 << (nr & 0x1f);
>> >     local_irq_save(flags);
>> > -   *a &= ~mask;
>> > +   *a |= mask;
>>
>> I think you just broke clear_bit().  Maybe I'm misreading the diff.
> OK, We have corrected it on our own tree.

Both the code and the patch are all right. Because the mess from diff,
we all misread it.

-Bryan

>>
>> >     local_irq_restore(flags);
>> >  }
>> >
>> >
>> > ...
>> >
>> > +#define smp_mb__before_clear_bit() barrier()
>> > +#define smp_mb__after_clear_bit()  barrier()
>> > +
>> > +static inline void __set_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int *a = (int *)addr;
>> > +   int mask;
>> > +
>> > +   a += nr >> 5;
>> > +   mask = 1 << (nr & 0x1f);
>> > +   *a |= mask;
>> > +}
>> > +
>> > +static inline void __clear_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int *a = (int *)addr;
>> > +   int mask;
>> > +
>> > +   a += nr >> 5;
>> > +   mask = 1 << (nr & 0x1f);
>> > +   *a &= ~mask;
>> > +}
>> > +
>> > +static inline void __change_bit(int nr, volatile unsigned long *addr)
>> > +{
>> > +   int mask;
>> > +   unsigned long *ADDR = (unsigned long *)addr;
>> > +
>> > +   ADDR += nr >> 5;
>> > +   mask = 1 << (nr & 31);
>> > +   *ADDR ^= mask;
>> > +}
>>
>> I'm surprised there isn't any generic code which can be used for the above.
>>
>> >
>> > ...
>> >
>>
>> Gad what a lot of code.  I don't think I have time to read it all, sorry.
>
