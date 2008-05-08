Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYEHFLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYEHFLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYEHFLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:11:42 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:42938 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbYEHFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:11:40 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 01:11:39 EDT
Date: Thu, 08 May 2008 13:38:47 +0900 (JST)
Message-Id: <20080508.133847.74565891.nemoto@toshiba-tops.co.jp>
To: macro@linux-mips.org
Cc: a.zummo@towertech.it, khali@linux-fr.org, ralf@linux-mips.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, ab@mycable.de,
       mgreer@mvista.com
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80, etc. driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805070102460.16173@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070102460.16173@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CC to authers of the driver.

On Wed, 7 May 2008 01:40:41 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>  The BCM1250A SOC which is used on the SWARM board utilising an M41T81
> chip only supports pure I2C in the raw bit-banged mode.  Nobody sane
> really wants to use it unless absolutely necessary and the M41T80, etc.  
> chips work just fine with an SMBus controller which is what the standard
> mode of operation of the BCM1250A.  The only drawback of byte accesses
> with the M41T80 is the chip only latches clock data registers for the
> duration of an I2C transaction which works fine with a block transfers,
> but not byte-wise accesses.
> 
>  The driver currently requires an I2C controller providing both SMBus and
> pure I2C access.  This is a set of changes to make it work with either,
> with a preference to pure I2C.  The problem of unlatched clock data if
> SMBus transactions are used is resolved in the standard way.
> 
>  Whether a choice between SMBus and pure I2C access is possible is 
> obviously device dependent.  If the code proved useful for other I2C 
> devices, then it could be moved to a more generic place.  It is a code
> simplification regardless -- similar I2C packet definitions are not 
> scattered throughout the driver anymore.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  Please note I have no means to test these changes with a pure I2C 
> controller -- anybody interested, please help.

I tested this with i2c-gpio.  It needs some fix.  Detailed below.

> -static int m41t80_get_datetime(struct i2c_client *client,
> -			       struct rtc_time *tm)
> +
> +static int m41t80_i2c_transfer(struct i2c_client *client, int write,
> +			       u8 reg, u8 num, u8 *buf)
>  {
> -	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
>  	struct i2c_msg msgs[] = {
>  		{
>  			.addr	= client->addr,
>  			.flags	= 0,
>  			.len	= 1,
> -			.buf	= dt_addr,
> +			.buf	= &reg,
>  		},
>  		{
>  			.addr	= client->addr,
> -			.flags	= I2C_M_RD,
> -			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
> -			.buf	= buf + M41T80_REG_SEC,
> +			.flags	= write ? 0 : I2C_M_RD,
> +			.len	= num,
> +			.buf	= buf,
>  		},
>  	};
>  
> -	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
> -		dev_err(&client->dev, "read error\n");
> -		return -EIO;
> +	return i2c_transfer(client->adapter, msgs, 2);
> +}

For write transfer, you must use only one i2c_msg.  If two i2c_msg
were used, the slave address is inserted between register number and
first data.  This chip cannot accept such sequence.

> +static int m41t80_transfer(struct i2c_client *client, int write,
> +			   u8 reg, u8 num, u8 *buf)
> +{
> +	int i, rc;
> +
> +	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
> +		return m41t80_i2c_transfer(client, write, reg, num, buf);

On success, m41t80_i2c_transfer() returns positive value, but
m41t80_transfer() should return 0.


Here is a proposed fix on top of your patch.

--- drivers/rtc/rtc-m41t80.c.orig	2008-05-08 11:08:57.000000000 +0900
+++ drivers/rtc/rtc-m41t80.c	2008-05-08 12:30:49.000000000 +0900
@@ -83,8 +83,8 @@ struct m41t80_data {
 };
 
 
-static int m41t80_i2c_transfer(struct i2c_client *client, int write,
-			       u8 reg, u8 num, u8 *buf)
+static int m41t80_i2c_read_transfer(struct i2c_client *client,
+				    u8 reg, u8 num, u8 *buf)
 {
 	struct i2c_msg msgs[] = {
 		{
@@ -95,7 +95,7 @@ static int m41t80_i2c_transfer(struct i2
 		},
 		{
 			.addr	= client->addr,
-			.flags	= write ? 0 : I2C_M_RD,
+			.flags	= I2C_M_RD,
 			.len	= num,
 			.buf	= buf,
 		},
@@ -104,13 +104,29 @@ static int m41t80_i2c_transfer(struct i2
 	return i2c_transfer(client->adapter, msgs, 2);
 }
 
+static int m41t80_i2c_write_transfer(struct i2c_client *client,
+				     u8 reg, u8 num, u8 *buf)
+{
+	u8 wbuf[M41T80_DATETIME_REG_SIZE + 1];
+	struct i2c_msg msg = {
+		.addr	= client->addr,
+		.flags	= 0,
+		.len	= num + 1,
+		.buf	= wbuf,
+	};
+
+	wbuf[0] = reg;
+	memcpy(wbuf + 1, buf, num);
+	return i2c_transfer(client->adapter, &msg, 1);
+}
+
 static int m41t80_read_byte_data(struct i2c_client *client, u8 reg)
 {
 	int rc;
 	u8 val;
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		rc = m41t80_i2c_transfer(client, 0, reg, 1, &val);
+		rc = m41t80_i2c_read_transfer(client, reg, 1, &val);
 		if (rc < 0)
 			return rc;
 		else
@@ -122,7 +138,7 @@ static int m41t80_read_byte_data(struct 
 static int m41t80_write_byte_data(struct i2c_client *client, u8 reg, u8 val)
 {
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return m41t80_i2c_transfer(client, 1, reg, 1, &val);
+		return m41t80_i2c_write_transfer(client, reg, 1, &val);
 	else
 		return i2c_smbus_write_byte_data(client, reg, val);
 }
@@ -132,16 +148,20 @@ static int m41t80_transfer(struct i2c_cl
 {
 	int i, rc;
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return m41t80_i2c_transfer(client, write, reg, num, buf);
-	else if (write) {
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		if (write)
+			rc = m41t80_i2c_write_transfer(client, reg, num, buf);
+		else
+			rc = m41t80_i2c_read_transfer(client, reg, num, buf);
+		if (rc < 0)
+			return rc;
+	} else if (write) {
 		for (i = 0; i < num; i++) {
 			rc = i2c_smbus_write_byte_data(client, reg + i,
 						       buf[i]);
 			if (rc < 0)
 				return rc;
 		}
-		return 0;
 	} else {
 		for (i = 0; i < num; i++) {
 			rc = i2c_smbus_read_byte_data(client, reg + i);
@@ -149,8 +169,8 @@ static int m41t80_transfer(struct i2c_cl
 				return rc;
 			buf[i] = rc;
 		}
-		return 0;
 	}
+	return 0;
 }
 
 static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
