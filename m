Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXJHSZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXJHSZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbXJHSZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:25:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48551 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbXJHSZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:25:01 -0400
Date: Mon, 8 Oct 2007 11:06:25 -0700
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
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 07/12] i2c-algo-bit: Read block data bugfix
Message-ID: <20071008180625.GH7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-algo-bit-read-block-data-bugfix.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Brownell <david-b@pacbell.net>

In Linus tree already:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=939bc4943d0483961edc45b63a7d27b4ffe547e3

This fixes a bug in the way i2c-algo-bit handles I2C_M_RECV_LEN,
used to implement i2c_smbus_read_block_data().  Previously, in the
absence of PEC (rarely used!) it would NAK the "length" byte:

	S addr Rd [A] [length] NA

That prevents the subsequent data bytes from being read:

	S addr Rd [A] [length] { A [data] }* NA

The primary fix just reorders two code blocks, so the length used
in the "should I NAK now?" check incorporates the data which it
just read from the slave device.

However, that move also highlighted other fault handling glitches.
This fixes those by abstracting the RX path ack/nak logic, so it
can be used in more than one location.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/algos/i2c-algo-bit.c |   52 ++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 20 deletions(-)

--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -357,13 +357,29 @@ static int sendbytes(struct i2c_adapter 
 	return wrcount;
 }
 
+static int acknak(struct i2c_adapter *i2c_adap, int is_ack)
+{
+	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
+
+	/* assert: sda is high */
+	if (is_ack)		/* send ack */
+		setsda(adap, 0);
+	udelay((adap->udelay + 1) / 2);
+	if (sclhi(adap) < 0) {	/* timeout */
+		dev_err(&i2c_adap->dev, "readbytes: ack/nak timeout\n");
+		return -ETIMEDOUT;
+	}
+	scllo(adap);
+	return 0;
+}
+
 static int readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msg)
 {
 	int inval;
 	int rdcount=0;   	/* counts bytes read */
-	struct i2c_algo_bit_data *adap = i2c_adap->algo_data;
 	unsigned char *temp = msg->buf;
 	int count = msg->len;
+	const unsigned flags = msg->flags;
 
 	while (count > 0) {
 		inval = i2c_inb(i2c_adap);
@@ -377,28 +393,12 @@ static int readbytes(struct i2c_adapter 
 		temp++;
 		count--;
 
-		if (msg->flags & I2C_M_NO_RD_ACK) {
-			bit_dbg(2, &i2c_adap->dev, "i2c_inb: 0x%02x\n",
-				inval);
-			continue;
-		}
-
-		/* assert: sda is high */
-		if (count)		/* send ack */
-			setsda(adap, 0);
-		udelay((adap->udelay + 1) / 2);
-		bit_dbg(2, &i2c_adap->dev, "i2c_inb: 0x%02x %s\n", inval,
-			count ? "A" : "NA");
-		if (sclhi(adap)<0) {	/* timeout */
-			dev_err(&i2c_adap->dev, "readbytes: timeout at ack\n");
-			return -ETIMEDOUT;
-		};
-		scllo(adap);
-
 		/* Some SMBus transactions require that we receive the
 		   transaction length as the first read byte. */
-		if (rdcount == 1 && (msg->flags & I2C_M_RECV_LEN)) {
+		if (rdcount == 1 && (flags & I2C_M_RECV_LEN)) {
 			if (inval <= 0 || inval > I2C_SMBUS_BLOCK_MAX) {
+				if (!(flags & I2C_M_NO_RD_ACK))
+					acknak(i2c_adap, 0);
 				dev_err(&i2c_adap->dev, "readbytes: invalid "
 					"block length (%d)\n", inval);
 				return -EREMOTEIO;
@@ -409,6 +409,18 @@ static int readbytes(struct i2c_adapter 
 			count += inval;
 			msg->len += inval;
 		}
+
+		bit_dbg(2, &i2c_adap->dev, "readbytes: 0x%02x %s\n",
+			inval,
+			(flags & I2C_M_NO_RD_ACK)
+				? "(no ack/nak)"
+				: (count ? "A" : "NA"));
+
+		if (!(flags & I2C_M_NO_RD_ACK)) {
+			inval = acknak(i2c_adap, count);
+			if (inval < 0)
+				return inval;
+		}
 	}
 	return rdcount;
 }

-- 
