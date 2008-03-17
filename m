Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYCQJIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYCQJIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYCQJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:07:51 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:37501
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbYCQJHu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:07:50 -0400
Message-Id: <47DE4323.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Mon, 17 Mar 2008 09:08:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com> <47DACA43.2000700@goop.org>
In-Reply-To: <47DACA43.2000700@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.03.08 19:56 >>>
>Jan Beulich wrote:
>> This (simplified) piece of code didn't behave as expected due to
>> incorrect constraints in some of the bitops functions, when
>> X86_FEATURE_xxx is referring to other than the first long:
>>
>> int test(struct cpuinfo_x86 *c) {
>> 	if (cpu_has(c, X86_FEATURE_xxx))
>> 		clear_cpu_cap(c, X86_FEATURE_xxx);
>> 	return cpu_has(c, X86_FEATURE_xxx);
>> }
>>
>> I'd really like understand, though, what the policy of (not) having a
>> "memory" clobber in these operations is - currently, this appears to
>> be totally inconsistent.
>I think there's years of history here, much of it involving rites with 
>chicken entrails.
>
>"memory" clobber is generally needed because the bit operations can 
>touch memory beyond their apparent arguments.  Proper "m" constraints 
>are the way to go.

I'm mainly afraid to break some implicit assumptions potentially made
somewhere that the memory clobber is there (as e.g. implicitly
documented for set_bit() by the comment before clear_bit()) ...

>>  Also, many comments of the non-atomic
>> functions say those may also be re-ordered - this contradicts the use
>> of "asm volatile" in there, which again I'd like to understand.
>>   
>
>"asm volatile" has no effect on ordering.  It's only necessary to force 
>an asm with no apparent side-effects to get emitted (ie, an asm with 
>outputs which don't get used; asms without outputs are implicitly volatile).

Ah, right, it's there just to accompany the memory clobber.

>All these operations should either explicitly list memory modification 
>as an output.  The bit tests have no side-effects, so there's no problem 
>if gcc decides they don't need to be emitted.
>
>> As much as all of these, using 'int' for the 'nr' parameter and
>> 'void *' for the 'addr' one is in conflict with
>> Documentation/atomic_ops.txt, especially because bt{,c,r,s} indeed
>> take the bit index as signed (which hence would really need special
>> precaution) and access the full 32 bits (if 'unsigned long' was used
>> properly here, 64 bits for x86-64) pointed at, so invalid uses like
>> referencing a 'char' array cannot currently be caught.
>>   
>
>What's the problem with accessing a char array as bits?

The fact that a char array may be of a size that is not a multiple of the
word size used by bt{,c,r,s}, i.e. you may either touch memory outside
of the actual bit field (problematic if what follows is an atomic variable,
and the bit operation used is not an atomic one, or if the bit array is
mis-aligned and the access would cross a page boundary).

>> Finally, the code with and without this patch relies heavily on the
>> -fno-strict-aliasing compiler switch and I'm not certain this really
>> is a good idea.
>>   
>
>Doesn't the casting via void * stomp all that?

Apparently not, as you can see from the example I gave that gets
fixed with the patch.

>> In the light of all of this I'm sending this as RFC, as fixing the
>> above might warrant a much bigger patch...
>>
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>> ---
>>  include/asm-x86/bitops.h |   43 ++++++++++++++++++++++++-------------------
>>  1 file changed, 24 insertions(+), 19 deletions(-)
>>
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
>>   
>
>Hm, hardcoding ">> 5" seems like asking for trouble.  At least make the 
>"int" an explicitly sized type.  It should also pass "nr" in as an 

Are you expecting int to ever be other than 32-bits wide? I'm afraid a
lot of other code makes assumptions here...

>explicit macro argument rather than just picking it up.

Not really, since ADDR doesn't take addr as parameter either...

>Does plain ADDR still get used?

It shouldn't in the end, but as long as the atomic ones that do use
memory clobbers don't use proper "m" operands (where it was part of
the purpose of the original mail to find out whether these need to
stay), they'll continue to use ADDR.

>It's unfortunate that gcc will runtime-compute the address of 
>addr[nr>>5] even though we only need it for proper compile-time
>constraints.

Yes, but I fixed this meanwhile by forcing a maximum size structure
to be used as operand when the bit index is not constant, as in

struct __bits { int _[0x7ffffff]; };
...
#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
#define FULL_ADDR "+m" (*(volatile struct __bits *) addr)
...
static inline void __clear_bit(int nr, volatile void *addr)
{
	if (__builtin_constant_p(nr))
		asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
	else
		asm volatile("btr %1,%0" : FULL_ADDR : "r" (nr));
}

Of course, it would be even better if we knew the size of the object,
but that would require all of these to become macros (so __typeof__(),
sizeof(), and __alignof__() could be applied). I'm not certain that's
worthwhile.

Jan
