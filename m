Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYAQR7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYAQR7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYAQR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:58:46 -0500
Received: from waste.org ([66.93.16.53]:59382 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbYAQR6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:58:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 3] slob: fix free block merging at head of subpage
X-Mercurial-Node: 771a5ab2c6b7347df5d7b3a6e44210e3959cb56f
Message-Id: <771a5ab2c6b7347df5d7.1200592639@cinder.waste.org>
In-Reply-To: <patchbomb.1200592638@cinder.waste.org>
Date: Thu, 17 Jan 2008 11:57:19 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <apkm@linux-foundation.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We weren't merging freed blocks at the beginning of the free list.
Fixing this showed a 2.5% efficiency improvement in a userspace test
harness.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 408d4beddb6c -r 771a5ab2c6b7 mm/slob.c
--- a/mm/slob.c	Wed Jan 16 19:00:27 2008 +0000
+++ b/mm/slob.c	Wed Jan 16 18:14:29 2008 -0600
@@ -398,6 +398,10 @@
 	sp->units += units;
 
 	if (b < sp->free) {
+		if (b + units == sp->free) {
+			units += slob_units(sp->free);
+			sp->free = slob_next(sp->free);
+		}
 		set_slob(b, units, sp->free);
 		sp->free = b;
 	} else {
