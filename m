Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYICRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYICRif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYICRhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:37:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:55734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbYICRh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:37:29 -0400
Date: Wed, 3 Sep 2008 10:25:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matt Mackall <mpm@selenic.com>
Subject: [patch 16/42] drivers/char/random.c: fix a race which can lead to
	a bogus BUG()
Message-ID: <20080903172550.GQ7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-char-random.c-fix-a-race-which-can-lead-to-a-bogus-bug.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 8b76f46a2db29407fed66cf4aca19d61b3dcb3e1 upstream

Fix a bug reported by and diagnosed by Aaron Straus.

This is a regression intruduced into 2.6.26 by

    commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
    Author: Matt Mackall <mpm@selenic.com>
    Date:   Tue Apr 29 01:03:07 2008 -0700

        random: simplify and rename credit_entropy_store

credit_entropy_bits() does:

	spin_lock_irqsave(&r->lock, flags);
	...
	if (r->entropy_count > r->poolinfo->POOLBITS)
		r->entropy_count = r->poolinfo->POOLBITS;

so there is a time window in which this BUG_ON():

static size_t account(struct entropy_store *r, size_t nbytes, int min,
		      int reserved)
{
	unsigned long flags;

	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);

	/* Hold lock while accounting */
	spin_lock_irqsave(&r->lock, flags);

can trigger.

We could fix this by moving the assertion inside the lock, but it seems
safer and saner to revert to the old behaviour wherein
entropy_store.entropy_count at no time exceeds
entropy_store.poolinfo->POOLBITS.

Reported-by: Aaron Straus <aaron@merfinllc.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -406,7 +406,7 @@ struct entropy_store {
 	/* read-write data: */
 	spinlock_t lock;
 	unsigned add_ptr;
-	int entropy_count;
+	int entropy_count;	/* Must at no time exceed ->POOLBITS! */
 	int input_rotate;
 };
 
@@ -519,6 +519,7 @@ static void mix_pool_bytes(struct entrop
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	unsigned long flags;
+	int entropy_count;
 
 	if (!nbits)
 		return;
@@ -526,20 +527,20 @@ static void credit_entropy_bits(struct e
 	spin_lock_irqsave(&r->lock, flags);
 
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
-	r->entropy_count += nbits;
-	if (r->entropy_count < 0) {
+	entropy_count = r->entropy_count;
+	entropy_count += nbits;
+	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
-		r->entropy_count = 0;
-	} else if (r->entropy_count > r->poolinfo->POOLBITS)
-		r->entropy_count = r->poolinfo->POOLBITS;
+		entropy_count = 0;
+	} else if (entropy_count > r->poolinfo->POOLBITS)
+		entropy_count = r->poolinfo->POOLBITS;
+	r->entropy_count = entropy_count;
 
 	/* should we wake readers? */
-	if (r == &input_pool &&
-	    r->entropy_count >= random_read_wakeup_thresh) {
+	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
-
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 

-- 
