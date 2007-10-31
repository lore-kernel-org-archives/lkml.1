Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbXJaP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbXJaP2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbXJaPYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33569 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbXJaPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:52 -0400
Date: Wed, 31 Oct 2007 08:11:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 17/26] firewire: fix unloading of fw-ohci while devices are
	attached
Message-ID: <20071031151158.GR2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fix-unloading-of-fw-ohci-while-devices-are-attached.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Fix panic in run_timer_softirq right after "modprobe -r firewire-ohci"
if a FireWire disk was attached and firewire-sbp2 loaded.

Same as commit 8a2d9ed3210464d22fccb9834970629c1c36fa36.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-card.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -507,9 +507,11 @@ fw_core_remove_card(struct fw_card *card
 	/* Set up the dummy driver. */
 	card->driver = &dummy_driver;
 
-	fw_flush_transactions(card);
-
 	fw_destroy_nodes(card);
+	flush_scheduled_work();
+
+	fw_flush_transactions(card);
+	del_timer_sync(&card->flush_timer);
 
 	fw_card_put(card);
 }

-- 
