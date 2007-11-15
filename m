Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXKOGwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXKOGwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbXKOGqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57827 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765674AbXKOGqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:44 -0500
Date: Wed, 14 Nov 2007 22:44:05 -0800
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
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 04/40] hwmon/w83627hf: Dont assume bank 0
Message-ID: <20071115064405.GE19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-w83627hf-don-t-assume-bank-0.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d58df9cd788e6fb4962e1c8d5ba7b8b95d639a44

The bank switching code assumes that the bank selector is set to 0
when the driver is loaded. This might not be the case. This is exactly
the same bug as was fixed in the w83627ehf driver two months ago:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0956895aa6f8dc6a33210967252fd7787652537d

In practice, this bug was causing the sensor thermal types to be
improperly reported for my W83627THF the first time I was loading the
w83627hf driver. From the driver history, I'd say that it has been
broken since September 2005 (when we stopped resetting the chip by
default at driver load.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627hf.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -1335,6 +1335,24 @@ static int __devexit w83627hf_remove(str
 }
 
 
+/* Registers 0x50-0x5f are banked */
+static inline void w83627hf_set_bank(struct w83627hf_data *data, u16 reg)
+{
+	if ((reg & 0x00f0) == 0x50) {
+		outb_p(W83781D_REG_BANK, data->addr + W83781D_ADDR_REG_OFFSET);
+		outb_p(reg >> 8, data->addr + W83781D_DATA_REG_OFFSET);
+	}
+}
+
+/* Not strictly necessary, but play it safe for now */
+static inline void w83627hf_reset_bank(struct w83627hf_data *data, u16 reg)
+{
+	if (reg & 0xff00) {
+		outb_p(W83781D_REG_BANK, data->addr + W83781D_ADDR_REG_OFFSET);
+		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
+	}
+}
+
 static int w83627hf_read_value(struct w83627hf_data *data, u16 reg)
 {
 	int res, word_sized;
@@ -1345,12 +1363,7 @@ static int w83627hf_read_value(struct w8
 		  && (((reg & 0x00ff) == 0x50)
 		   || ((reg & 0x00ff) == 0x53)
 		   || ((reg & 0x00ff) == 0x55));
-	if (reg & 0xff00) {
-		outb_p(W83781D_REG_BANK,
-		       data->addr + W83781D_ADDR_REG_OFFSET);
-		outb_p(reg >> 8,
-		       data->addr + W83781D_DATA_REG_OFFSET);
-	}
+	w83627hf_set_bank(data, reg);
 	outb_p(reg & 0xff, data->addr + W83781D_ADDR_REG_OFFSET);
 	res = inb_p(data->addr + W83781D_DATA_REG_OFFSET);
 	if (word_sized) {
@@ -1360,11 +1373,7 @@ static int w83627hf_read_value(struct w8
 		    (res << 8) + inb_p(data->addr +
 				       W83781D_DATA_REG_OFFSET);
 	}
-	if (reg & 0xff00) {
-		outb_p(W83781D_REG_BANK,
-		       data->addr + W83781D_ADDR_REG_OFFSET);
-		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
-	}
+	w83627hf_reset_bank(data, reg);
 	mutex_unlock(&data->lock);
 	return res;
 }
@@ -1435,12 +1444,7 @@ static int w83627hf_write_value(struct w
 		   || ((reg & 0xff00) == 0x200))
 		  && (((reg & 0x00ff) == 0x53)
 		   || ((reg & 0x00ff) == 0x55));
-	if (reg & 0xff00) {
-		outb_p(W83781D_REG_BANK,
-		       data->addr + W83781D_ADDR_REG_OFFSET);
-		outb_p(reg >> 8,
-		       data->addr + W83781D_DATA_REG_OFFSET);
-	}
+	w83627hf_set_bank(data, reg);
 	outb_p(reg & 0xff, data->addr + W83781D_ADDR_REG_OFFSET);
 	if (word_sized) {
 		outb_p(value >> 8,
@@ -1450,11 +1454,7 @@ static int w83627hf_write_value(struct w
 	}
 	outb_p(value & 0xff,
 	       data->addr + W83781D_DATA_REG_OFFSET);
-	if (reg & 0xff00) {
-		outb_p(W83781D_REG_BANK,
-		       data->addr + W83781D_ADDR_REG_OFFSET);
-		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
-	}
+	w83627hf_reset_bank(data, reg);
 	mutex_unlock(&data->lock);
 	return 0;
 }

-- 
