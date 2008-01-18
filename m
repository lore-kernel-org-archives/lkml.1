Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbYARClg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbYARClg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbYARChc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:37:32 -0500
Received: from waste.org ([66.93.16.53]:40696 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760624AbYARCh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:37:29 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 12] random: simplify and rename credit_entropy_store
X-Mercurial-Node: 218e9dac90b1b81b167e74d6dbd2dc572c44bee0
Message-Id: <218e9dac90b1b81b167e.1200623634@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:54 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- emphasize bits in the name
- make zero bits lock-free
- simplify logic

diff -r a0689714301a -r 218e9dac90b1 drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 20:25:24 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:24 2008 -0600
@@ -441,7 +441,7 @@
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
- * credit_entropy_store if this is appropriate.
+ * credit_entropy_bits if this is appropriate.
  *
  * The pool is stirred with a primitive polynomial of the appropriate
  * degree, and then twisted.  We twist by three bits at a time because
@@ -515,24 +515,22 @@
 /*
  * Credit (or debit) the entropy store with n bits of entropy
  */
-static void credit_entropy_store(struct entropy_store *r, int nbits)
+static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
 
+	if (!nbits)
+		return;
+
 	spin_lock_irqsave(&r->lock, flags);
 
-	if (r->entropy_count + nbits < 0) {
-		DEBUG_ENT("negative entropy/overflow (%d+%d)\n",
-			  r->entropy_count, nbits);
+	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
+	r->entropy_count += nbits;
+	if (r->entropy_count < 0) {
+		DEBUG_ENT("negative entropy/overflow\n");
 		r->entropy_count = 0;
-	} else if (r->entropy_count + nbits > r->poolinfo->POOLBITS) {
+	} else if (r->entropy_count > r->poolinfo->POOLBITS)
 		r->entropy_count = r->poolinfo->POOLBITS;
-	} else {
-		r->entropy_count += nbits;
-		if (nbits)
-			DEBUG_ENT("added %d entropy credits to %s\n",
-				  nbits, r->name);
-	}
 
 	/* should we wake readers? */
 	if (r == &input_pool && r->entropy_count >= random_read_wakeup_thresh)
@@ -619,8 +617,8 @@
 		 * Round down by 1 bit on general principles,
 		 * and limit entropy entimate to 12 bits.
 		 */
-		credit_entropy_store(&input_pool,
-				     min_t(int, fls(delta>>1), 11));
+		credit_entropy_bits(&input_pool,
+				    min_t(int, fls(delta>>1), 11));
 	}
 out:
 	preempt_enable();
@@ -703,7 +701,7 @@
 		bytes = extract_entropy(r->pull, tmp, bytes,
 					random_read_wakeup_thresh / 8, rsvd);
 		mix_pool_bytes(r, tmp, bytes);
-		credit_entropy_store(r, bytes*8);
+		credit_entropy_bits(r, bytes*8);
 	}
 }
 
@@ -1074,7 +1072,7 @@
 			return -EPERM;
 		if (get_user(ent_count, p))
 			return -EFAULT;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDADDENTROPY:
 		if (!capable(CAP_SYS_ADMIN))
@@ -1089,7 +1087,7 @@
 				    size);
 		if (retval < 0)
 			return retval;
-		credit_entropy_store(&input_pool, ent_count);
+		credit_entropy_bits(&input_pool, ent_count);
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
