Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZFWDqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZFWDqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFWDp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:45:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53156 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZFWDp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:45:56 -0400
Date: Mon, 22 Jun 2009 23:45:45 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 1/5] power_supply: fix up olpc_battery's eeprom read
 function
Message-ID: <20090622234545.48afccf3@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The eeprom read function was placing values into the wrong place in
'buf'; we were starting from buf[off], rather than buf[0].

Also, the for loop that we were using was much uglier than it needed to
be.  This cleans it up a bit.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/olpc_battery.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 5fbca26..8f41733 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -334,21 +334,19 @@ static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
 		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
 {
 	uint8_t ec_byte;
-	int ret, end;
+	int ret, i;
 
 	if (off >= EEPROM_SIZE)
 		return 0;
 	if (off + count > EEPROM_SIZE)
 		count = EEPROM_SIZE - off;
 
-	end = EEPROM_START + off + count;
-	for (ec_byte = EEPROM_START + off; ec_byte < end; ec_byte++) {
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1,
-				&buf[ec_byte - EEPROM_START], 1);
+	for (i = 0; i < count; i++) {
+		ec_byte = EEPROM_START + off + i;
+		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &buf[i], 1);
 		if (ret) {
-			printk(KERN_ERR "olpc-battery:  EC command "
-					"EC_BAT_EEPROM @ 0x%x failed -"
-					" %d!\n", ec_byte, ret);
+			printk(KERN_ERR "olpc-battery:  EC_BAT_EEPROM cmd @ 0x%x failed - %d!\n",
+					ec_byte, ret);
 			return -EIO;
 		}
 	}
-- 
1.5.6.5

