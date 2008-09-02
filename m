Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYIBOWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYIBOWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYIBOV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:21:58 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30473 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbYIBOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:21:57 -0400
Message-ID: <48BD4BB3.7040808@panasas.com>
Date: Tue, 02 Sep 2008 17:20:35 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5 ver2] rt2x00: Compiler warning unmasked by fix of
 BUILD_BUG_ON
References: <48BBE77D.7070007@panasas.com> <a32f33a40809010701o1069afdfuc2745f934753fb2e@mail.gmail.com> <48BC077A.9000106@panasas.com> <200809011834.45856.IvDoorn@gmail.com>
In-Reply-To: <200809011834.45856.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2008 14:19:46.0356 (UTC) FILETIME=[F388BF40:01C90D06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo van Doorn wrote:
> On Monday 01 September 2008, Boaz Harrosh wrote:
>> Ivo Van Doorn wrote:
>>
<snip>
>> Do you want that I send a fix for readability's sake?
> 
> Yes, thanks.
> 
<snip>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
>> index 7e88ce5..e71b793 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
>> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
>> @@ -136,8 +136,8 @@ struct rt2x00_field32 {
>>   */
>>  #define is_power_of_two(x)	( !((x) & ((x)-1)) )
>>  #define low_bit_mask(x)		( ((x)-1) & ~(x) )
>> -#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
>> -
>> +#define is_valid_mask(x)	is_power_of_two(1LU + (unsigned long)(x) + \
>> +					low_bit_mask((unsigned long)x))
BTW
doing only:
-#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
+#define is_valid_mask(x)	is_power_of_two(1LU (x) + low_bit_mask(x))

Also fixes the problem. (By definition of C type promotion rules)

Should I do just That?

>>  /*
>>   * Macro's to find first set bit in a variable.
>>   * These macro's behaves the same as the __ffs() function with
>> -- 1.5.6.rc1.5.gadf6 -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html Please read the FAQ at http://www.tux.org/lkml/ 
>>

This is my suggested new patch:
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 1 Sep 2008 14:47:19 +0300
Subject: [PATCH] rt2x00: Compiler warning unmasked by fix of BUILD_BUG_ON

A "Set" to a sign-bit in an "&" operation causes a compiler warning.
Make calculations unsigned.

[ The warning was masked by the old definition of BUILD_BUG_ON() ]

Also remove __builtin_constant_p from FIELD_CHECK since BUILD_BUG_ON
no longer permits non-const values.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
TO: Ivo van Doorn <IvDoorn@gmail.com>
TO: John W. Linville <linville@tuxdriver.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/wireless/rt2x00/rt2x00reg.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7e88ce5..2ea7866 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -136,7 +136,7 @@ struct rt2x00_field32 {
  */
 #define is_power_of_two(x)	( !((x) & ((x)-1)) )
 #define low_bit_mask(x)		( ((x)-1) & ~(x) )
-#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
+#define is_valid_mask(x)	is_power_of_two(1LU + (x) + low_bit_mask(x))
 
 /*
  * Macro's to find first set bit in a variable.
@@ -173,8 +173,7 @@ struct rt2x00_field32 {
  * does not exceed the given typelimit.
  */
 #define FIELD_CHECK(__mask, __type)			\
-	BUILD_BUG_ON(!__builtin_constant_p(__mask) ||	\
-		     !(__mask) ||			\
+	BUILD_BUG_ON(!(__mask) ||			\
 		     !is_valid_mask(__mask) ||		\
 		     (__mask) != (__type)(__mask))	\
 
-- 
1.5.6.rc1.5.gadf6


