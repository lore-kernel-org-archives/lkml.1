Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYGLMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYGLMts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGLMtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:49:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49839 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYGLMtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:49:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:49:19 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 1/4] firewire: fix race of bus reset with request transmission
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
Message-ID: <tkrat.58323b2455660591@s5r6.in-berlin.de>
References: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Jay Fenlason:  A bus reset tasklet may call
fw_flush_transactions and touch transactions (call their callback which
will free them) while the context which submitted the transaction is
still inserting it into the transmission queue.

A simple solution to this problem is to _not_ "flush" the transactions
because of a bus reset (complete the transcations as 'cancelled').  They
will now simply time out (completed as 'cancelled' by the split-timeout
timer).

Jay Fenlason thought of this fix too but I was quicker to type it out.
:-)

Background:
Contexts which access an instance of struct fw_transaction are:
 1. the submitter, until it inserted the packet which is embedded in the
    transaction into the AT req DMA,
 2. the AsReqTrContext tasklet when the request packet was acked by the
    responder node or transmission to the responder failed,
 3. the AsRspRcvContext tasklet when it found a request which matched
    an incoming response,
 4. the card->flush_timer when it picks up timed-out transactions to
    cancel them,
 5. the bus reset tasklet when it cancels transactions (this access is
    eliminated by this patch),
 6. a process which shuts down an fw_card (unregisters it from fw-core
    when the controller is unbound from fw-ohci) --- although in this
    case there shouldn't really be any transactions anymore because we
    wait until all card users finished their business with the card.

All of these contexts run concurrently (except for the 6th, presumably).
The 1st is safe against the 2nd and 3rd because of the way how a request
packet is carefully submitted to the hardware.  A race between 2nd and
3rd has been fixed a while ago (bug 9617).  The 4th is almost safe
against 1st, 2nd, 3rd;  there are issues with it if huge scheduling
latencies occur, to be fixed separately.  The 5th looks safe against
2nd, 3rd, and 4th but is unsafe against 1st.  Maybe this could be fixed
with an explicit state variable in struct fw_transaction.  But this
would require fw_transaction to be rewritten as only dynamically
allocatable object with reference counting --- not a good solution if we
also can simply kill this 5th accessing context (replace it by the 4th).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -510,8 +510,6 @@ fw_core_handle_bus_reset(struct fw_card 
 	struct fw_node *local_node;
 	unsigned long flags;
 
-	fw_flush_transactions(card);
-
 	/*
 	 * If the selfID buffer is not the immediate successor of the
 	 * previously processed one, we cannot reliably compare the

-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

