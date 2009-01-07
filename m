Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbZAGW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbZAGW33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762431AbZAGWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:27 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39238 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762415AbZAGWXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:25 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4GUG-01-K3Z-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 14/18] oprofile: remove backtrace code for ibs
Date: Wed, 7 Jan 2009 23:17:31 +0100
Message-ID: <1231366655-17837-15-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0538 (UTC) FILETIME=[7F477B20:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is broken since a TRACE_BEGIN_CODE is never sent to the
daemon. The data becomes corrupt since the backtrace is interpreted as
ibs sample.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    2 --
 drivers/oprofile/cpu_buffer.c  |   10 ++--------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 7415d2e..e61e25f 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -557,11 +557,9 @@ void sync_buffer(int cpu)
 				break;
 #ifdef CONFIG_OPROFILE_IBS
 			case IBS_FETCH_BEGIN:
-				state = sb_bt_start;
 				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
 				break;
 			case IBS_OP_BEGIN:
-				state = sb_bt_start;
 				add_ibs_begin(cpu, IBS_OP_CODE, mm);
 				break;
 #endif
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 8ae37c9..92bf8c0 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -347,17 +347,11 @@ void oprofile_add_ibs_sample(struct pt_regs * const regs,
 		fail = fail || add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
-	if (fail)
-		goto fail;
-
-	if (oprofile_backtrace_depth)
-		oprofile_ops.backtrace(regs, oprofile_backtrace_depth);
-
-	return;
+	if (!fail)
+		return;
 
 fail:
 	cpu_buf->sample_lost_overflow++;
-	return;
 }
 
 #endif
-- 
1.6.0.1


