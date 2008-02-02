Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbYBBXAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbYBBXAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763705AbYBBW7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:59:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:13166 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbYBBW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N3qpG94NRxSnH9pWzMPqYpu5GRzFIsWESeT7ieyfUNWTPTnWDJh7wuhTnnT6JYI1R/EDkUqmSww/oOQFCAMI2hiUsDMJa0HoaR0oOQDJcO5/ZRa27smAXMwSPfDTSeroHeTSontLq5FaYUxTicnG1419i1aKj3ZQyHtsdcKgqng=
Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dmitry.adamushko@gmail.com
Content-Type: text/plain
Date: Sat, 02 Feb 2008 23:59:31 +0100
Message-Id: <1201993171.12880.8.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: latencytop: optimize LT_BACKTRACEDEPTH loops a bit.

It looks like there is no need to loop any longer when 'same == 0'.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index b4e3c85..61f7da0 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -64,8 +64,8 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 		return;
 
 	for (i = 0; i < MAXLR; i++) {
-		int q;
-		int same = 1;
+		int q, same = 1;
+
 		/* Nothing stored: */
 		if (!latency_record[i].backtrace[0]) {
 			if (firstnonnull > i)
@@ -73,12 +73,12 @@ account_global_scheduler_latency(struct task_struct *tsk, struct latency_record
 			continue;
 		}
 		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
-			if (latency_record[i].backtrace[q] !=
-				lat->backtrace[q])
+			unsigned long record = lat->backtrace[q];
+
+			if (latency_record[i].backtrace[q] != record)
 				same = 0;
-			if (same && lat->backtrace[q] == 0)
-				break;
-			if (same && lat->backtrace[q] == ULONG_MAX)
+
+			if (!same || record == 0 || record == ULONG_MAX)
 				break;
 		}
 		if (same) {
@@ -143,14 +143,15 @@ account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	for (i = 0; i < LT_SAVECOUNT ; i++) {
 		struct latency_record *mylat;
 		int same = 1;
+
 		mylat = &tsk->latency_record[i];
 		for (q = 0 ; q < LT_BACKTRACEDEPTH ; q++) {
-			if (mylat->backtrace[q] !=
-				lat.backtrace[q])
+			unsigned long record = lat.backtrace[q];
+
+			if (mylat->backtrace[q] != record)
 				same = 0;
-			if (same && lat.backtrace[q] == 0)
-				break;
-			if (same && lat.backtrace[q] == ULONG_MAX)
+
+			if (!same || record == 0 || record == ULONG_MAX)
 				break;
 		}
 		if (same) {


