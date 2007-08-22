Return-Path: <linux-kernel-owner+w=401wt.eu-S1763869AbXHVJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763869AbXHVJLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXHVIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:53 -0400
Received: from 1wt.eu ([62.212.114.60]:2172 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851AbXHVIxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:48 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084039.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:34 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
       Matt Mackall <mpm@selenic.com>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.17 review 50/58] random: fix bound check ordering (CVE-2007-3105)
Content-Disposition: inline; filename=0050-random-fix-bound-check-ordering-CVE-2007-3105.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If root raised the default wakeup threshold over the size of the
output pool, the pool transfer function could overflow the stack with
RNG bytes, causing a DoS or potential privilege escalation.

(Bug reported by the PaX Team <pageexec@freemail.hu>)

Cc: Theodore Tso <tytso@mit.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 263e5e5..96561c8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -693,9 +693,14 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
-		int bytes = max_t(int, random_read_wakeup_thresh / 8,
-				min_t(int, nbytes, sizeof(tmp)));
+		/* If we're limited, always leave two wakeup worth's BITS */
 		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+		int bytes = nbytes;
+
+		/* pull at least as many as BYTES as wakeup BITS */
+		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+		/* but never more than the buffer size */
+		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)
",
-- 
1.5.2.5

-- 
