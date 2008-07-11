Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYGKNwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYGKNwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbYGKNsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:05 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34986 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759404AbYGKNrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:55 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 2/30] W1: abort search early on on exit
Date: Fri, 11 Jul 2008 17:51:17 +0400
Message-Id: <12157843052190-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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

