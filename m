Return-Path: <linux-kernel-owner+w=401wt.eu-S1031325AbXDZRCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031325AbXDZRCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXDZRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39737 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbXDZRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:21 -0400
Date: Thu, 26 Apr 2007 09:57:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>
Subject: [patch 29/33] hwmon/w83627ehf: Fix the fan5 clock divider write
Message-ID: <20070426165708.GD1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-w83627ehf-fix-the-fan5-clock-divider-write.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Users have been complaining about the w83627ehf driver flooding their
logs with debug messages like:

w83627ehf 9191-0a10: Increasing fan 4 clock divider from 64 to 128

or:

w83627ehf 9191-0290: Increasing fan 4 clock divider from 4 to 8

The reason is that we failed to actually write the LSB of the encoded
clock divider value for that fan, causing the next read to report the
same old value again and again.

Additionally, the fan number was improperly reported, making the bug
harder to find.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627ehf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -389,7 +389,7 @@ static void w83627ehf_write_fan_div(stru
 		break;
 	case 4:
 		reg = (w83627ehf_read_value(client, W83627EHF_REG_DIODE) & 0x73)
-		    | ((data->fan_div[4] & 0x03) << 3)
+		    | ((data->fan_div[4] & 0x03) << 2)
 		    | ((data->fan_div[4] & 0x04) << 5);
 		w83627ehf_write_value(client, W83627EHF_REG_DIODE, reg);
 		break;
@@ -453,9 +453,9 @@ static struct w83627ehf_data *w83627ehf_
 			   time */
 			if (data->fan[i] == 0xff
 			 && data->fan_div[i] < 0x07) {
-			 	dev_dbg(&client->dev, "Increasing fan %d "
+			 	dev_dbg(&client->dev, "Increasing fan%d "
 					"clock divider from %u to %u\n",
-					i, div_from_reg(data->fan_div[i]),
+					i + 1, div_from_reg(data->fan_div[i]),
 					div_from_reg(data->fan_div[i] + 1));
 				data->fan_div[i]++;
 				w83627ehf_write_fan_div(client, i);

-- 
