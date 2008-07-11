Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbYGKN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbYGKN5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbYGKNsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:24 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34984 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759380AbYGKNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:54 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 17/30] W1: w1_io.c reset comments and msleep
Date: Fri, 11 Jul 2008 17:51:32 +0400
Message-Id: <12157843063356-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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
index a2f0d5f..dd2ecef 100644
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

