Return-Path: <linux-kernel-owner+w=401wt.eu-S1759281AbZBTB56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbZBTB56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZBTB5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:57:49 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51177 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZBTB5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:57:48 -0500
Date: Thu, 19 Feb 2009 17:57:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: compudj@krystal.dyndns.org, bert.wesarg@googlemail.com, bob@watson.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [[PATCH URCU formal]] Restructure urcu_updater() to more
	accurately reflect actual failure scenario.
Message-ID: <20090220015747.GA19488@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure urcu_updater() to more accurately reflect actual failure
scenario.

This allows an easier transformation to force failure -- simple #ifdef
out the second counter flip out of urcu_updater()'s model of
"current synchronize_rcu()".

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 formal-model/urcu.spin |   41 +++++++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
index eea18e8..3e18457 100644
--- a/formal-model/urcu.spin
+++ b/formal-model/urcu.spin
@@ -187,10 +187,38 @@ proctype urcu_reader()
 
 proctype urcu_updater()
 {
+	/* prior synchronize_rcu(), second counter flip. */
+	need_mb = 1;
+	do
+	:: need_mb == 1 -> skip;
+	:: need_mb == 0 -> break;
+	od;
+	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
+	need_mb = 1;
+	do
+	:: need_mb == 1 -> skip;
+	:: need_mb == 0 -> break;
+	od;
+	do
+	:: 1 ->
+		if
+		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
+		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
+		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
+			skip;
+		:: else -> break;
+		fi;
+	od;
+	need_mb = 1;
+	do
+	:: need_mb == 1 -> skip;
+	:: need_mb == 0 -> break;
+	od;
+
 	/* Removal statement, e.g., list_del_rcu(). */
 	removed = 1;
 
-	/* synchronize_rcu(), first counter flip. */
+	/* current synchronize_rcu(), first counter flip. */
 	need_mb = 1;
 	do
 	:: need_mb == 1 -> skip;
@@ -204,15 +232,13 @@ proctype urcu_updater()
 	od;
 	do
 	:: 1 ->
-		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
-		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
 		if
 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
 			skip;
 		:: else -> break;
-		fi
+		fi;
 	od;
 	need_mb = 1;
 	do
@@ -220,10 +246,7 @@ proctype urcu_updater()
 	:: need_mb == 0 -> break;
 	od;
 
-	/* Erroneous removal statement, e.g., list_del_rcu(). */
-	/* removed = 1; */
-
-	/* synchronize_rcu(), second counter flip. */
+	/* current synchronize_rcu(), second counter flip. */
 	need_mb = 1;
 	do
 	:: need_mb == 1 -> skip;
@@ -237,8 +260,6 @@ proctype urcu_updater()
 	od;
 	do
 	:: 1 ->
-		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
-		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
 		if
 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
-- 
1.5.2.5

