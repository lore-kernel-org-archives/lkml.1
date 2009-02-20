Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZBTB5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZBTB5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZBTB4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:56:54 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52899 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZBTB4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:56:54 -0500
Date: Thu, 19 Feb 2009 17:56:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: compudj@krystal.dyndns.org, bert.wesarg@googlemail.com, bob@watson.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH URCU formal] Remove spurious read-side infinite loops.
Message-ID: <20090220015653.GA19434@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove spurious read-side infinite loops from urcu_reader() model.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 formal-model/urcu.spin |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
index 611464b..eea18e8 100644
--- a/formal-model/urcu.spin
+++ b/formal-model/urcu.spin
@@ -27,6 +27,10 @@ bit free = 0;     /* Has RCU reclamation happened, e.g., kfree()? */
 bit need_mb = 0;  /* =1 says need reader mb, =0 for reader response. */
 byte reader_progress[4];
 		  /* Count of read-side statement executions. */
+bit reader_done = 0;
+		  /* =0 says reader still running, =1 says done. */
+bit updater_done = 0;
+		  /* =0 says updater still running, =1 says done. */
 
 /* urcu definitions and variables, taken straight from the algorithm. */
 
@@ -50,7 +54,7 @@ proctype urcu_reader()
 	do
 	:: need_mb == 1 ->
 		need_mb = 0;
-	:: 1 -> skip;
+	:: !updater_done -> skip;
 	:: 1 -> break;
 	od;
 
@@ -92,7 +96,7 @@ proctype urcu_reader()
 				    reader_progress[2] +
 				    reader_progress[3] == 0) && need_mb == 1 ->
 					need_mb = 0;
-				:: 1 -> skip;
+				:: !updater_done -> skip;
 				:: 1 -> break;
 				od;
 				urcu_active_readers = tmp;
@@ -150,7 +154,7 @@ proctype urcu_reader()
 			do
 			:: need_mb == 1 ->
 				need_mb = 0;
-			:: 1 -> skip;
+			:: !updater_done -> skip;
 			:: 1 -> break;
 			od;
 		:: else -> skip;
@@ -167,11 +171,14 @@ proctype urcu_reader()
 	od;
 	assert((tmp_free == 0) || (tmp_removed == 1));
 
+	/* Reader has completed. */
+	reader_done = 1;
+
 	/* Process any late-arriving memory-barrier requests. */
 	do
 	:: need_mb == 1 ->
 		need_mb = 0;
-	:: 1 -> skip;
+	:: !updater_done -> skip;
 	:: 1 -> break;
 	od;
 }
@@ -248,6 +255,12 @@ proctype urcu_updater()
 
 	/* free-up step, e.g., kfree(). */
 	free = 1;
+
+	/*
+	 * Signal updater done, ending any otherwise-infinite loops
+	 * in the reading process.
+	 */
+	updater_done = 1;
 }
 
 /*
-- 
1.5.2.5

