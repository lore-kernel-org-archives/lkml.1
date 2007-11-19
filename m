Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbXKSSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbXKSSab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXKSSWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49411 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXKSSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:50 -0500
Date: Mon, 19 Nov 2007 10:19:35 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 25/26] i2c/eeprom: Hide Sony Vaio serial numbers
Message-ID: <20071119181935.GZ15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-eeprom-hide-sony-vaio-serial-numbers.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

patch 0f2cbd38aa377e30df3b7602abed69464d1970aa in mainline.

The sysfs interface to DMI data takes care to not make the system
serial number and UUID world-readable, presumably due to privacy
concerns. For consistency, we should not let the eeprom driver
export these same strings to the world on Sony Vaio laptops.
Instead, only make them readable by root, as we already do for BIOS
passwords.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/chips/eeprom.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/i2c/chips/eeprom.c
+++ b/drivers/i2c/chips/eeprom.c
@@ -125,13 +125,20 @@ static ssize_t eeprom_read(struct kobjec
 	for (slice = off >> 5; slice <= (off + count - 1) >> 5; slice++)
 		eeprom_update_client(client, slice);
 
-	/* Hide Vaio security settings to regular users (16 first bytes) */
-	if (data->nature == VAIO && off < 16 && !capable(CAP_SYS_ADMIN)) {
-		size_t in_row1 = 16 - off;
-		in_row1 = min(in_row1, count);
-		memset(buf, 0, in_row1);
-		if (count - in_row1 > 0)
-			memcpy(buf + in_row1, &data->data[16], count - in_row1);
+	/* Hide Vaio private settings to regular users:
+	   - BIOS passwords: bytes 0x00 to 0x0f
+	   - UUID: bytes 0x10 to 0x1f
+	   - Serial number: 0xc0 to 0xdf */
+	if (data->nature == VAIO && !capable(CAP_SYS_ADMIN)) {
+		int i;
+
+		for (i = 0; i < count; i++) {
+			if ((off + i <= 0x1f) ||
+			    (off + i >= 0xc0 && off + i <= 0xdf))
+				buf[i] = 0;
+			else
+				buf[i] = data->data[off + i];
+		}
 	} else {
 		memcpy(buf, &data->data[off], count);
 	}
@@ -202,7 +209,7 @@ static int eeprom_detect(struct i2c_adap
 		 && i2c_smbus_read_byte(new_client) == 'G'
 		 && i2c_smbus_read_byte(new_client) == '-') {
 			dev_info(&new_client->dev, "Vaio EEPROM detected, "
-				"enabling password protection\n");
+				 "enabling privacy protection\n");
 			data->nature = VAIO;
 		}
 	}

-- 
