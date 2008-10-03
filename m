Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYJCK7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYJCK7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYJCK7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:59:13 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:58971 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYJCK7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:59:12 -0400
Message-Id: <20081003105752.247421935@de.ibm.com>
References: <20081003105632.357231142@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Oct 2008 12:56:33 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au, jens.axboe@oracle.com, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 1/4] stop_machine: atomic update for combined return value
Content-Disposition: inline; filename=stopmachine_atomic.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Using |= for updating a value which might be updated on several cpus
concurrently will not always work since we need to make sure that the
update happens atomically. So let's use a cmpxchg loop instead.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/stop_machine.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -65,6 +65,7 @@ static void ack_state(void)
 static int stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
+	int *frp, fnret, old;
 
 	/* Simple state machine */
 	do {
@@ -80,7 +81,11 @@ static int stop_cpu(struct stop_machine_
 			case STOPMACHINE_RUN:
 				/* |= allows error detection if functions on
 				 * multiple CPUs. */
-				smdata->fnret |= smdata->fn(smdata->data);
+				fnret = smdata->fn(smdata->data);
+				frp = &smdata->fnret;
+				do {
+					old = *frp;
+				} while (cmpxchg(frp, old, old | fnret) != old);
 				break;
 			default:
 				break;

-- 
