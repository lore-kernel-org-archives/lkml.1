Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZBQEpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZBQEpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZBQEo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:44:58 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:3572 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047AbZBQEo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:44:57 -0500
Message-ID: <499A40C6.9070800@panasas.com>
Date: Tue, 17 Feb 2009 06:44:54 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitmap: Cleanup find_last_bit
References: <200812011848.31552.rusty@rustcorp.com.au> <1234789120-31543-1-git-send-email-bhalevy@panasas.com> <200902170940.59703.rusty@rustcorp.com.au>
In-Reply-To: <200902170940.59703.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2009 04:44:55.0596 (UTC) FILETIME=[7AD66EC0:01C990BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb. 17, 2009, 1:10 +0200, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Monday 16 February 2009 23:28:40 Benny Halevy wrote:
>> Fix cut & paste error in header comment.
>> Simplify implementation a bit.
> 
> Hi Benny,
> 
>   Nice catch!  But I disagree with one change:
> 
>>  	/* Partial final word? */
>> -	if (size & (BITS_PER_LONG-1)) {
>> -		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
>> -					 - (size & (BITS_PER_LONG-1)))));
>> +	tmp = size & (BITS_PER_LONG-1);
>> +	if (tmp) {
>> +		tmp = addr[words] & (~0UL >> (BITS_PER_LONG - tmp));
>>  		if (tmp)
>>  			goto found;
>>  	}
> 
> The overloading of tmp to the remainder size here is not really a cleanup: it
> makes it into a dual-use var.  I know it's called tmp, but that's a sign of
> poor code too :)
> 
> I'd prefer a new final_bits var: gcc will almost certainly just slap it in
> a register anyway, but it's clearer.
> 
> tmp could then be called something like... word?

Yeah, I like that too.
I'm about to go on a flight
so the following was just tested to compile...

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 6182913..886ebf0 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -142,7 +142,7 @@ extern unsigned long find_first_zero_bit(const unsigned long *addr,
  * @addr: The address to start the search at
  * @size: The maximum size to search
  *
- * Returns the bit number of the first set bit, or size.
+ * Returns the bit number of the last set bit, or size.
  */
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
diff --git a/lib/find_last_bit.c b/lib/find_last_bit.c
index 5d202e3..6a35783 100644
--- a/lib/find_last_bit.c
+++ b/lib/find_last_bit.c
@@ -17,29 +17,31 @@
 
 unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 {
+	unsigned long final_bits = size;
 	unsigned long words;
-	unsigned long tmp;
+	unsigned long word;
 
 	/* Start at final word. */
-	words = size / BITS_PER_LONG;
+	words = final_bits / BITS_PER_LONG;
 
 	/* Partial final word? */
-	if (size & (BITS_PER_LONG-1)) {
-		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
-					 - (size & (BITS_PER_LONG-1)))));
-		if (tmp)
+	size &= (BITS_PER_LONG-1);
+	if (size) {
+		word = addr[words] & (~0UL >> (BITS_PER_LONG - size));
+		if (word)
 			goto found;
 	}
 
 	while (words) {
-		tmp = addr[--words];
-		if (tmp) {
-found:
-			return words * BITS_PER_LONG + __fls(tmp);
-		}
+		word = addr[--words];
+		if (word)
+			goto found;
 	}
 
 	/* Not found */
-	return size;
+	return final_bits;
+
+found:
+	return words * BITS_PER_LONG + __fls(word);
 }
 EXPORT_SYMBOL(find_last_bit);
-- 
1.6.1.3


> 
> Thanks!
> Rusty.
