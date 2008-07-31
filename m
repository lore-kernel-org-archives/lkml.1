Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYGaCsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYGaCsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYGaCsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:48:43 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60525 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYGaCsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:48:43 -0400
Date: Wed, 30 Jul 2008 21:48:08 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/30] W1: abort search early on on exit
Message-ID: <20080731024808.GC12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:48:09 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early abort if the master driver or the hardware goes away in the
middle of a bus search operation.  The alternative is to spam the
print buffer up to 64*64 times with read errors in the case of USB.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 25640f6..aac03f1 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -772,6 +772,11 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			/* extract the direction taken & update the device number */
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
+
+			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				return;
+			}
 		}
 
 		if ( (triplet_ret & 0x03) != 0x03 ) {
-- 
1.4.4.4
