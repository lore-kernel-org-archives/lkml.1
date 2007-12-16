Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXLPLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXLPLpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761081AbXLPLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:45:34 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36888 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbXLPLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:45:33 -0500
Message-ID: <47650FBD.2060209@cosmosbay.com>
Date: Sun, 16 Dec 2007 12:45:01 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: [RANDOM] Move two variables to read_mostly section to save memory
Content-Type: multipart/mixed;
 boundary="------------050805010102040204070906"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 16 Dec 2007 12:45:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050805010102040204070906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While examining vmlinux namelist on i686, I noticed :

c0581300 D random_table
c0581480 d input_pool
c0581580 d random_read_wakeup_thresh
c0581584 d random_write_wakeup_thresh
c0581600 d blocking_pool

That means that the two integers random_read_wakeup_thresh and 
random_write_wakeup_thresh use a full cache entry (128 bytes).

Moving them to read_mostly section can shrinks vmlinux by 120 bytes.

# size vmlinux*
    text    data     bss     dec     hex filename
4835553  450210  610304 5896067  59f783 vmlinux.after_patch
4835553  450330  610304 5896187  59f7fb vmlinux.before_patch

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------050805010102040204070906
Content-Type: text/plain;
 name="random_read_mostly.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="random_read_mostly.patch"

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..af48e86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -256,14 +256,14 @@
  * The minimum number of bits of entropy before we wake up a read on
  * /dev/random.  Should be enough to do a significant reseed.
  */
-static int random_read_wakeup_thresh = 64;
+static int random_read_wakeup_thresh __read_mostly = 64;
 
 /*
  * If the entropy count falls under this number of bits, then we
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_thresh = 128;
+static int random_write_wakeup_thresh __read_mostly = 128;
 
 /*
  * When the input pool goes over trickle_thresh, start dropping most

--------------050805010102040204070906--
