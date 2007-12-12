Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXLLIXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXLLIXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbXLLIXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:23:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025AbXLLIXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:23:40 -0500
Date: Wed, 12 Dec 2007 00:23:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, timtimred@foonas.org
Subject: Re: [PATCH] Add support for the S-35390A RTC chip.
Message-Id: <20071212002333.dd4508dc.akpm@linux-foundation.org>
In-Reply-To: <1196979027-2589-1-git-send-email-byron.bbradley@gmail.com>
References: <1196979027-2589-1-git-send-email-byron.bbradley@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Dec 2007 22:10:27 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:

> This adds basic get/set time support for the Seiko Instruments
> S-35390A. This chip communicates using I2C and is used on the
> QNAP TS-109/TS-209 NAS devices.
> 

A nice looking little driver.

> +static inline char reverse(char x)
> +{
> +	x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
> +	x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
> +	return (x >> 4) | (x << 4);
> +}

Please take a peek in include/linux/bitrev.h ;)

(I worry about the handling of right-shift-of-negative-values
in your version, too).

Could you review and runtime test this please?

--- a/drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-fix
+++ a/drivers/rtc/rtc-s35390a.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/i2c.h>
+#include <linux/bitrev.h>
 #include <linux/bcd.h>
 
 #define S35390A_CMD_STATUS1	0
@@ -121,13 +122,6 @@ static int s35390a_reg2hr(struct s35390a
 	return hour;
 }
 
-static inline char reverse(char x)
-{
-	x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
-	x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
-	return (x >> 4) | (x << 4);
-}
-
 static int s35390a_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct s35390a	*s35390a = i2c_get_clientdata(client);
@@ -149,7 +143,7 @@ static int s35390a_set_datetime(struct i
 
 	/* This chip expects the bits of each byte to be in reverse order */
 	for (i = 0; i < 7; ++i)
-		buf[i] = reverse(buf[i]);
+		buf[i] = bitrev8(buf[i]);
 
 	err = s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
 
@@ -168,7 +162,7 @@ static int s35390a_get_datetime(struct i
 
 	/* This chip returns the bits of each byte in reverse order */
 	for (i = 0; i < 7; ++i)
-		buf[i] = reverse(buf[i]);
+		buf[i] = bitrev8(buf[i]);
 
 	tm->tm_sec = BCD2BIN(buf[S35390A_BYTE_SECS]);
 	tm->tm_min = BCD2BIN(buf[S35390A_BYTE_MINS]);
_

