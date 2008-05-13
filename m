Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYEMRAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYEMRAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYEMRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:00:18 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61087 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883AbYEMRAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:00:17 -0400
Date: Tue, 13 May 2008 17:57:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] RTC: SMBus support for the M41T80, etc. driver (#2)
In-Reply-To: <20080513140444.49d7a044@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805131752340.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130254420.535@cliff.in.clinika.pl>
 <20080513140444.49d7a044@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> The I2C part of the changes look OK to me. With one comment below:
> 
> > +static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
> > +{
> > +	u8 buf[M41T80_DATETIME_REG_SIZE];
> > +	int loops = 2;
> > +	int sec0, sec1;
> > +
> > +	/*
> > +	 * Time registers are latched by this chip if an I2C block
> > +	 * transfer is used, but with SMBus-style byte accesses
> > +	 * this is not the case, so check seconds for a wraparound.
> > +	 */
> > +	do {
> > +		if (m41t80_read_block_data(client, M41T80_REG_SEC,
> > +					   M41T80_DATETIME_REG_SIZE -
> > +					   M41T80_REG_SEC,
> > +					   buf + M41T80_REG_SEC) < 0) {
> > +			dev_err(&client->dev, "read error\n");
> > +			return -EIO;
> > +		}
> > +		sec0 = buf[M41T80_REG_SEC];
> >  
> > -	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
> > +		sec1 = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
> > +		if (sec1 < 0) {
> > +			dev_err(&client->dev, "read error\n");
> > +			return -EIO;
> > +		}
> > +
> > +		sec0 = BCD2BIN(sec0 & 0x7f);
> > +		sec1 = BCD2BIN(sec1 & 0x7f);
> > +	} while (sec1 < sec0 && --loops);
> 
> You will do this even if all the registers were read as a block and the
> RTC latched the register values so they have to be correct. Isn't it a
> bit unfair / inefficient? If client->adapter has the
> I2C_FUNC_SMBUS_READ_I2C_BLOCK functionality you can skip the comparison
> and retry mechanism completely, saving some time and CPU cycles.

 Well, actually there is a reason beyond that.  It may change if we
support subsecond resolution, but we currently do not.  The reason is if
we return the original timestamp and the seconds register changes while
the timestamp is being read, then effectively we return a value that is
off by one second.  This is why for seconds I decided to return the second
value read all the time.

  Maciej
