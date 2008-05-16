Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYEPTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYEPTgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYEPTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:36:11 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24088 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYEPTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:36:08 -0400
Date: Fri, 16 May 2008 13:36:03 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/4] spi: Change modalias from a pointer to a character array
In-reply-to: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Message-id: <20080516193603.28030.51689.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
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

 drivers/spi/spi.c       |    2 +-
 include/linux/spi/spi.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1ad12af..bdf1b70 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -229,7 +229,7 @@ struct spi_device *spi_new_device(struct spi_master *master,
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
-	proxy->modalias = chip->modalias;
+	strncpy(proxy->modalias, chip->modalias, KOBJ_NAME_LEN);
 
 	snprintf(proxy->dev.bus_id, sizeof proxy->dev.bus_id,
 			"%s.%u", master->dev.bus_id,
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 387e428..38a080b 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -82,7 +82,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	const char		*modalias;
+	char			modalias[KOBJ_NAME_LEN];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how

