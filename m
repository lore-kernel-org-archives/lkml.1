Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYF3Gic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYF3Gic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYF3GiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:38:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:28098 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbYF3GiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:38:21 -0400
From: Jouni Hogander <jouni.hogander@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com
Subject: [PATCH] Do deferrable flag check also for timers in tv2-tv5
Date: Mon, 30 Jun 2008 09:38:09 +0300
Message-Id: <1214807889-11648-1-git-send-email-jouni.hogander@nokia.com>
X-Mailer: git-send-email 1.5.5
X-OriginalArrivalTime: 30 Jun 2008 06:38:09.0490 (UTC) FILETIME=[DC7A6320:01C8DA7B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently deferrable flag is checked only for timers in tv1. This
patch adds check for timers in tv2-tv5 also. This way
__next_timer_interrupt returns value earlier than timer_jiffies +
NEXT_TIMER_MAX_DELTA only if there is a non-deferrable timer
scheduled.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index ceacc66..929fb36 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -861,6 +861,8 @@ cascade:
 		index = slot = timer_jiffies & TVN_MASK;
 		do {
 			list_for_each_entry(nte, varp->vec + slot, entry) {
+				if (tbase_get_deferrable(nte->base))
+					continue;
 				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
-- 
