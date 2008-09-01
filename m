Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYIAPRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYIAPRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYIAPRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:17:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38955 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYIAPRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=LdKAH2t56r/kkwaz9nA/FNK6NOo5J7zKSdWUEhBkxHKtUA8bZJZ5ityQWxydFXSoWL
         4xzk4Wg+btZY3ZhDn1B97hmcj9T8rG933C+p93DedlkH9+onZKr/L93FYVhM/4oJQXAl
         IizCjGWrehJJVS+CD1nYTbVzNhWeH5zPkhc3c=
Message-ID: <48BC077A.9000106@panasas.com>
Date: Mon, 01 Sep 2008 18:17:14 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
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
References: <48BBE77D.7070007@panasas.com> <48BBEC6C.1050301@panasas.com>	 <48BBF1DA.5060808@panasas.com> <a32f33a40809010701o1069afdfuc2745f934753fb2e@mail.gmail.com>
In-Reply-To: <a32f33a40809010701o1069afdfuc2745f934753fb2e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo Van Doorn wrote:
> On Mon, Sep 1, 2008 at 3:44 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> A "Set" of a sign-bit in an "&" operation causes a compiler warning.
>> Make calculations unsigned.
>>
>> [ The warning was masked by the use of (void)() cast in the old
>>  BUILD_BUG_ON() ]
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> TO: Ivo van Doorn <IvDoorn@gmail.com>
>> TO: John W. Linville <linville@tuxdriver.com>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: Rusty Russell <rusty@rustcorp.com.au>
>> ---
>>  drivers/net/wireless/rt2x00/rt2x00reg.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
>> index 7e88ce5..e71b793 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00reg.h
>> +++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
>> @@ -136,8 +136,8 @@ struct rt2x00_field32 {
>>  */
>>  #define is_power_of_two(x)     ( !((x) & ((x)-1)) )
>>  #define low_bit_mask(x)                ( ((x)-1) & ~(x) )
>> -#define is_valid_mask(x)       is_power_of_two(1 + (x) + low_bit_mask(x))
>> -
>> +#define is_valid_mask(x)       is_power_of_two(1 + (x) + \
>> +                                       low_bit_mask((unsigned long)x))
> 
> I know I typed it wrong, but you are missing the unsigned long cast for the
> is_power_of_two argument here (Which could also be done in the
> is_valid_mask() definition).
> 

I thought you suggested that on purpose. Since at the end it is all
one expression, the compiler propagates the cast to all participants.

Do you want that I send a fix for readability's sake?

>>  /*
>>  * Macro's to find first set bit in a variable.
>>  * These macro's behaves the same as the __ffs() function with
>> --
>> 1.5.6.rc1.5.gadf6
>>

Is below what you mean? but if so then perhaps my original one is
clearer. Note that it compiles and works as is.

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7e88ce5..e71b793 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -136,8 +136,8 @@ struct rt2x00_field32 {
  */
 #define is_power_of_two(x)	( !((x) & ((x)-1)) )
 #define low_bit_mask(x)		( ((x)-1) & ~(x) )
-#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
-
+#define is_valid_mask(x)	is_power_of_two(1LU + (unsigned long)(x) + \
+					low_bit_mask((unsigned long)x))
 /*
  * Macro's to find first set bit in a variable.
  * These macro's behaves the same as the __ffs() function with
-- 1.5.6.rc1.5.gadf6 -- To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html Please read the FAQ at http://www.tux.org/lkml/ 

