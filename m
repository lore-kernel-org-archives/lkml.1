Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbXFMFbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbXFMFbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXFMFb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:31:26 -0400
Received: from waste.org ([66.93.16.53]:35817 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbXFMFbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:31:25 -0400
Date: Wed, 13 Jun 2007 00:29:51 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux@horizon.com, akpm@linux-foundation.org
Cc: bgilbert@cs.cmu.edu, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: [PATCH] random: fix folding
Message-ID: <20070613052951.GI11166@waste.org>
References: <466D9FDB.2010305@cs.cmu.edu> <20070612050544.23957.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612050544.23957.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 01:05:44AM -0400, linux@horizon.com wrote:
> I also noticed a glaring BUG in the folding at the end of extract_buf at
> drivers/char/random.c:797.  That should be:
> 
> 	/*
> 	 * In case the hash function has some recognizable
> 	 * output pattern, we fold it in half.
> 	 */
> 
> 	buf[0] ^= buf[4];
> 	buf[1] ^= buf[3];
> 	buf[2] ^= rol32(buf[2], 16);	// <--- Bug was here
> 	memcpy(out, buf, EXTRACT_SIZE);
> 	memset(buf, 0, sizeof(buf));
> 
> if the code is to match the comment.

Conveniently, the random.c maintainer is reading this thread. Good
spotting, not sure how I bungled that.

----
random: fix output buffer folding

(As reported by linux@horizon.com)

Folding is done to minimize the theoretical possibility of systematic
weakness in the particular bits of the SHA1 hash output. The result of
this bug is that 16 out of 80 bits are un-folded. Without a major new
vulnerability being found in SHA1, this is harmless, but still worth
fixing.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/drivers/char/random.c
===================================================================
--- mm.orig/drivers/char/random.c	2007-06-12 23:50:54.000000000 -0500
+++ mm/drivers/char/random.c	2007-06-12 23:51:51.000000000 -0500
@@ -794,7 +794,7 @@ static void extract_buf(struct entropy_s
 
 	buf[0] ^= buf[3];
 	buf[1] ^= buf[4];
-	buf[0] ^= rol32(buf[3], 16);
+	buf[2] ^= rol32(buf[2], 16);
 	memcpy(out, buf, EXTRACT_SIZE);
 	memset(buf, 0, sizeof(buf));
 }


-- 
Mathematics is the supreme nostalgia of our time.
