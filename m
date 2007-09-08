Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXIHAdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXIHAdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 20:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXIHAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 20:32:54 -0400
Received: from mail.vyatta.com ([216.93.170.194]:46786 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbXIHAcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 20:32:53 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 20:32:53 EDT
X-Spam-Score: -4.378
Date: Fri, 7 Sep 2007 17:09:17 -0700 (PDT)
From: Bob Gilligan <gilligan@vyatta.com>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Message-ID: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com>
Subject: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of
 page
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.0.197]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -- There appears to be a bug in the function blkcipher_get_spot(),
which resides in crypto/blkcipher.c.  This small function reads:

static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
{
        if (offset_in_page(start + len) < len)
                return (u8 *)((unsigned long)(start + len) & PAGE_MASK);
        return start;
}

This function is apparently attempting to detect the case where the
buffer pointed to by "start", of length "len" bytes, straddles a page
boundary.  In that case, it will return the address of the start of the
last page that the buffer resides on.  It works correctly in all cases
except when the buffer resides entirely within one page but is located
at the end of that page (i.e. the last byte of the buffer is at
address 0x.....fff).  In that one case, this function will return the
address of the start of the next page (i.e. one byte beyond the end of
the buffer), when it should return "start".

For example, say blkcipher_get_spot() is called with start=0xf7e71ff0,
and len=16.  The function returns 0xf7e72000.  The correct return
value should be 0xf7e71ff0.

This bug appears to be the cause of occasional crashes within the slab
allocator that we have seen testing ipsec with AES encryption.
Tracking the crashes down, we see occasions when the kmalloc() call in
blkcipher_next_slow() is being called with n=32, which is satisfied
out of the size-32 slab.  The kmalloc'ed buffer is passed to
blkcipher_get_spot() twice to generate two pointers into that buffer,
then scatterwalk_copychunks() copies into the second pointer.  In the
case when the buffer returned by kmalloc() occupies the last 32-byte
buffer on the page, the second call to blkcipher_get_spot() returns
the address of the start of the NEXT page, and scaterwalk_copychunks()
over-writes 16 bytes at that address.  Since the next page often holds
another slab, this stomps on the list_head in the slab struct, and the
system crashes when the slab allocator dereferences those pointers a
later point in time.  We've seen several crashes in free_block().

Proposed patch is below.  We found the problem and tested this fix in
2.6.20, but it looks like the relevant code in blkcipher.c is the same
in the latest tree.

Bob.




Correctly handle the case where the buffer passed into
blkcipher_get_spot() resides at the end of a page.

Signed-off-by: Bob Gilligan <gilligan@vyatta.com>
---

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 6e93004..3b6734e 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -60,8 +60,10 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk\
 *walk)

 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
-       if (offset_in_page(start + len) < len)
-               return (u8 *)((unsigned long)(start + len) & PAGE_MASK);
+       u8 *end = (start + len - 1);
+
+       if (offset_in_page(end) < (len - 1))
+               return (u8 *)((unsigned long)(end) & PAGE_MASK);
        return start;
 }


