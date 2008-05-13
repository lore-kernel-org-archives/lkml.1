Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYEMMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYEMMFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYEMMFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:05:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22150 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEMMFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:05:34 -0400
Date: Tue, 13 May 2008 14:04:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] RTC: SMBus support for the M41T80, etc. driver (#2)
Message-ID: <20080513140444.49d7a044@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805130254420.535@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130254420.535@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Tue, 13 May 2008 04:27:30 +0100 (BST), Maciej W. Rozycki wrote:
>  The BCM1250A SOC which is used on the SWARM board utilising an M41T81
> chip only supports pure I2C in the raw bit-banged mode.  Nobody sane
> really wants to use it unless absolutely necessary and the M41T80, etc.  
> chips work just fine with an SMBus adapter which is what the standard mode
> of operation of the BCM1250A.  The only drawback of byte accesses with the
> M41T80 is the chip only latches clock data registers for the duration of
> an I2C transaction which works fine with a block transfers, but not
> byte-wise accesses.
> 
>  The driver currently requires an I2C adapter providing both SMBus and raw
> I2C access.  This is a set of changes to make it work with any SMBus
> adapter providing at least read byte and write byte protocols.  
> Additionally, if a given SMBus adapter supports I2C block read and/or
> write protocols (a common extension beyond the SMBus spec), they are used
> as well.  The problem of unlatched clock data if SMBus byte transactions
> are used is resolved in the standard way.  For raw I2C controllers this
> functionality is provided by the I2C core as SMBus emulation in a
> transparent way.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

The I2C part of the changes look OK to me. With one comment below:

> +static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
> +{
> +	u8 buf[M41T80_DATETIME_REG_SIZE];
> +	int loops = 2;
> +	int sec0, sec1;
> +
> +	/*
> +	 * Time registers are latched by this chip if an I2C block
> +	 * transfer is used, but with SMBus-style byte accesses
> +	 * this is not the case, so check seconds for a wraparound.
> +	 */
> +	do {
> +		if (m41t80_read_block_data(client, M41T80_REG_SEC,
> +					   M41T80_DATETIME_REG_SIZE -
> +					   M41T80_REG_SEC,
> +					   buf + M41T80_REG_SEC) < 0) {
> +			dev_err(&client->dev, "read error\n");
> +			return -EIO;
> +		}
> +		sec0 = buf[M41T80_REG_SEC];
>  
> -	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
> +		sec1 = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
> +		if (sec1 < 0) {
> +			dev_err(&client->dev, "read error\n");
> +			return -EIO;
> +		}
> +
> +		sec0 = BCD2BIN(sec0 & 0x7f);
> +		sec1 = BCD2BIN(sec1 & 0x7f);
> +	} while (sec1 < sec0 && --loops);

You will do this even if all the registers were read as a block and the
RTC latched the register values so they have to be correct. Isn't it a
bit unfair / inefficient? If client->adapter has the
I2C_FUNC_SMBUS_READ_I2C_BLOCK functionality you can skip the comparison
and retry mechanism completely, saving some time and CPU cycles.

-- 
Jean Delvare
