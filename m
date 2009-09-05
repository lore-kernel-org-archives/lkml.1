Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZIELYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZIELYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 07:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZIELYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 07:24:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41401 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZIELYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 07:24:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 5 Sep 2009 13:23:49 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix crash in iso resource management
To: linux1394-devel@lists.sourceforge.net
cc: Jonathan Cameron <jic23@cam.ac.uk>, David Moore <dcm@acm.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1252116551.3383.26.camel@localhost.localdomain>
Message-ID: <tkrat.b2f248f55decb2dd@s5r6.in-berlin.de>
References: <4AA119A5.9000105@cam.ac.uk> 
 <tkrat.c6382d44c1c0be7c@s5r6.in-berlin.de> <4AA144D1.7030109@cam.ac.uk> 
 <tkrat.c508979b9af656c0@s5r6.in-berlin.de>
 <1252116551.3383.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression due to post 2.6.30 commit "firewire: core: do
not DMA-map stack addresses" 6fdc03709433ccc2005f0f593ae9d9dd04f7b485.

As David Moore noted, a previously correct sizeof() expression became
wrong since the commit changed its argument from an array to a pointer.
This resulted in an oops in ohci_cancel_packet in the shared workqueue
thread's context when an isochronous resource was to be freed.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |    2 ++
 drivers/firewire/core-iso.c  |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc7/drivers/firewire/core-iso.c
===================================================================
--- linux-2.6.31-rc7.orig/drivers/firewire/core-iso.c
+++ linux-2.6.31-rc7/drivers/firewire/core-iso.c
@@ -196,7 +196,7 @@ static int manage_bandwidth(struct fw_ca
 		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 				irm_id, generation, SCODE_100,
 				CSR_REGISTER_BASE + CSR_BANDWIDTH_AVAILABLE,
-				data, sizeof(data))) {
+				data, 8)) {
 		case RCODE_GENERATION:
 			/* A generation change frees all bandwidth. */
 			return allocate ? -EAGAIN : bandwidth;
@@ -233,7 +233,7 @@ static int manage_channel(struct fw_card
 		data[1] = old ^ c;
 		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 					   irm_id, generation, SCODE_100,
-					   offset, data, sizeof(data))) {
+					   offset, data, 8)) {
 		case RCODE_GENERATION:
 			/* A generation change frees all channels. */
 			return allocate ? -EAGAIN : i;

-- 
Stefan Richter
-=====-==--= =--= --=-=
http://arcgraph.de/sr/

