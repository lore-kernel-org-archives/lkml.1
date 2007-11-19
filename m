Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXKSSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXKSSau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXKSSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49431 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXKSSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:53 -0500
Date: Mon, 19 Nov 2007 10:19:38 -0800
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
Subject: [patch 26/26] i2c/eeprom: Recognize VGN as a valid Sony Vaio name
	prefix
Message-ID: <20071119181938.GA15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-eeprom-recognize-vgn-as-a-valid-sony-vaio-name-prefix.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

patch 8b925a3dd8a4d7451092cb9aa11da727ba69e0f0 in mainline.

Recent (i.e. 2005 and later) Sony Vaio laptops have names beginning
with VGN rather than PCG. Update the eeprom driver so that it
recognizes these.

Why this matters: the eeprom driver hides private data from the
EEPROMs it recognizes as Vaio EEPROMs (passwords, serial number...) so
if the driver fails to recognize a Vaio EEPROM as such, the private
data is exposed to the world.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/chips/eeprom.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/i2c/chips/eeprom.c
+++ b/drivers/i2c/chips/eeprom.c
@@ -202,12 +202,16 @@ static int eeprom_detect(struct i2c_adap
 		goto exit_kfree;
 
 	/* Detect the Vaio nature of EEPROMs.
-	   We use the "PCG-" prefix as the signature. */
+	   We use the "PCG-" or "VGN-" prefix as the signature. */
 	if (address == 0x57) {
-		if (i2c_smbus_read_byte_data(new_client, 0x80) == 'P'
-		 && i2c_smbus_read_byte(new_client) == 'C'
-		 && i2c_smbus_read_byte(new_client) == 'G'
-		 && i2c_smbus_read_byte(new_client) == '-') {
+		char name[4];
+
+		name[0] = i2c_smbus_read_byte_data(new_client, 0x80);
+		name[1] = i2c_smbus_read_byte(new_client);
+		name[2] = i2c_smbus_read_byte(new_client);
+		name[3] = i2c_smbus_read_byte(new_client);
+
+		if (!memcmp(name, "PCG-", 4) || !memcmp(name, "VGN-", 4)) {
 			dev_info(&new_client->dev, "Vaio EEPROM detected, "
 				 "enabling privacy protection\n");
 			data->nature = VAIO;

-- 
