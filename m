Return-Path: <linux-kernel-owner+w=401wt.eu-S935764AbXHGU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935764AbXHGU6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935485AbXHGUtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56227 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935492AbXHGUtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:52 -0400
Date: Tue, 7 Aug 2007 13:44:56 -0700
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
       Kristian H?gsberg <krh@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [2.6.22.2 review 25/84] firewire: fw-sbp2: set correct maximum
	payload (fixes CardBus adapters)
Message-ID: <20070807204456.GZ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-sbp2-set-correct-maximum-payload.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

As far as I know, all CardBus FireWire 400 adapters have a maximum
payload of 1024 bytes which is less than the speed-dependent limit of
2048 bytes.  Fw-sbp2 has to take the host adapter's limit into account.

This apparently fixes Juju's incompatibility with my CardBus cards, a
NEC based card and a VIA based card.

Backport of commit 25659f7183376c6b37661da6141d5eaa21479061.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-sbp2.c        |    5 ++++-
 drivers/firewire/fw-transaction.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -985,6 +985,7 @@ static int sbp2_scsi_queuecommand(struct
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
+	unsigned max_payload;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
@@ -1023,8 +1024,10 @@ static int sbp2_scsi_queuecommand(struct
 	 * specifies the max payload size as 2 ^ (max_payload + 2), so
 	 * if we set this to max_speed + 7, we get the right value.
 	 */
+	max_payload = device->node->max_speed + 7;
+	max_payload = min(max_payload, device->card->max_receive - 1);
 	orb->request.misc =
-		COMMAND_ORB_MAX_PAYLOAD(device->node->max_speed + 7) |
+		COMMAND_ORB_MAX_PAYLOAD(max_payload) |
 		COMMAND_ORB_SPEED(device->node->max_speed) |
 		COMMAND_ORB_NOTIFY;
 
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -228,7 +228,7 @@ struct fw_card {
 	unsigned long reset_jiffies;
 
 	unsigned long long guid;
-	int max_receive;
+	unsigned max_receive;
 	int link_speed;
 	int config_rom_generation;
 

-- 
