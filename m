Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYGCBDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYGCBDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 21:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYGCBDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 21:03:04 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:25222 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbYGCBDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:03:03 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 1/5] spi: Change modalias from a pointer to a character
	array
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com, david-b@pacbell.net
Date: Wed, 02 Jul 2008 19:02:58 -0600
Message-ID: <20080703010257.26187.29589.stgit@trillian.secretlab.ca>
In-Reply-To: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Currently, 'modalias' in the spi_device structure is a 'const char *'.
The spi_new_device() function fills in the modalias value from a passed
in spi_board_info data block.  Since it is a pointer copy, the new
spi_device remains dependent on the spi_board_info structure after the
new spi_device is registered (no other fields in spi_device directly
depend on the spi_board_info structure; all of the other data is copied).

This causes a problem when dynamically propulating the list of attached
SPI devices.  For example, in arch/powerpc, the list of SPI devices can
be populated from data in the device tree.  With the current code, the
device tree adapter must kmalloc() a new spi_board_info structure for
each new SPI device it finds in the device tree, and there is no simple
mechanism in place for keeping track of these allocations.

This patch changes modalias from a 'const char *' to a fixed char array.
By copying the modalias string instead of referencing it, the dependency
on the spi_board_info structure is eliminated and an outside caller does
not need to maintain a separate spi_board_info allocation for each device.

If searched through the code to the best of my ability for any references
to modalias which may be affected by this change and haven't found anything.
It has been tested with the lite5200b platform in arch/powerpc.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/spi/spi.c       |    4 +++-
 include/linux/spi/spi.h |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1ad12af..32b7a42 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -218,6 +218,8 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	if (!spi_master_get(master))
 		return NULL;
 
+	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
+
 	proxy = kzalloc(sizeof *proxy, GFP_KERNEL);
 	if (!proxy) {
 		dev_err(dev, "can't alloc dev for cs%d\n",
@@ -229,7 +231,7 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
-	proxy->modalias = chip->modalias;
+	strlcpy(proxy->modalias, chip->modalias, sizeof(proxy->modalias));
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
 			"%s.%u", master->dev.bus_id,
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 387e428..b55910b 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -82,7 +82,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	const char		*modalias;
+	char			modalias[32];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how

