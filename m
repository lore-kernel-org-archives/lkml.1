Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbYGaCxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbYGaCxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbYGaCty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:49:54 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60564 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbYGaCtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:49:53 -0400
Date: Wed, 30 Jul 2008 21:49:47 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/30] W1: w1_io.c reset comments and msleep
Message-ID: <20080731024947.GR12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:49:48 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_reset_bus, added some comments about the timing and switched to
msleep for the later delay.  I don't have the hardware to test the
sleep after reset change.  The one wire doesn't have a timing
requirement between commands so it is fine.  I do have the USB
hardware and it would be in big trouble with 10ms interrupt transfers
to find that the reset completed.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1_io.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 97b338a..f4f82f1 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -293,12 +293,24 @@ int w1_reset_bus(struct w1_master *dev)
 		result = dev->bus_master->reset_bus(dev->bus_master->data) & 0x1;
 	else {
 		dev->bus_master->write_bit(dev->bus_master->data, 0);
+		/* minimum 480, max ? us
+		 * be nice and sleep, except 18b20 spec lists 960us maximum,
+		 * so until we can sleep with microsecond accuracy, spin.
+		 * Feel free to come up with some other way to give up the
+		 * cpu for such a short amount of time AND get it back in
+		 * the maximum amount of time.
+		 */
 		w1_delay(480);
 		dev->bus_master->write_bit(dev->bus_master->data, 1);
 		w1_delay(70);
 
 		result = dev->bus_master->read_bit(dev->bus_master->data) & 0x1;
-		w1_delay(410);
+		/* minmum 70 (above) + 410 = 480 us
+		 * There aren't any timing requirements between a reset and
+		 * the following transactions.  Sleeping is safe here.
+		 */
+		/* w1_delay(410); min required time */
+		msleep(1);
 	}
 
 	return result;
-- 
1.4.4.4
