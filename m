Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYCTR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYCTR35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 13:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYCTR3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 13:29:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36812 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYCTR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:29:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 20 Mar 2008 18:28:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
Message-ID: <tkrat.2374baeb26921d92@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
 <tkrat.948f418ebe464164@s5r6.in-berlin.de>
 <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following update for the firewire subsystem.

 drivers/firewire/fw-transaction.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Stefan Richter (1):
      firewire: fix panic in handle_at_packet


commit 10a4c735515a5afc317abe4d697a4c95f6d9d764
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Mar 16 00:56:41 2008 +0100

    firewire: fix panic in handle_at_packet
    
    This fixes a use-after-free bug in the handling of split transactions.
    The AT DMA handler of the request was occasionally executed after the
    AR DMA handler of the response.  The AT DMA handler then accessed an
    already freed packet.
    
    Reported by Johannes Berg.
    http://bugzilla.kernel.org/show_bug.cgi?id=9617
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 99529e5..e6f1bda 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -736,6 +736,12 @@ fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 		break;
 	}
 
+	/*
+	 * The response handler may be executed while the request handler
+	 * is still pending.  Cancel the request handler.
+	 */
+	card->driver->cancel_packet(card, &t->packet);
+
 	t->callback(card, rcode, data, data_length, t->callback_data);
 }
 EXPORT_SYMBOL(fw_core_handle_response);


Thanks,
-- 
Stefan Richter
-=====-==--- --== =-=--
http://arcgraph.de/sr/

