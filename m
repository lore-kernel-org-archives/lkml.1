Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYEIVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYEIVAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYEIU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:59:55 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62371 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757884AbYEIU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:59:54 -0400
Date: Fri, 9 May 2008 21:55:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: David Brownell <david-b@pacbell.net>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [i2c] [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
In-Reply-To: <20080509100841.151eabcd@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805092127410.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
 <Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
 <200805071625.20430.david-b@pacbell.net> <Pine.LNX.4.55.0805080306080.32613@cliff.in.clinika.pl>
 <20080509100841.151eabcd@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Maybe you shouldn't have included 4 different mailing lists to start
> with, especially for a patch which is rather hardware-specific and not
> overly important.

 Well, there is more interest in these changes on the linux-mips mailing
list than on any other one -- I seriously doubt there is any user of
hardware based around the BCM1250A SOC on either of the i2c and rtc-linux
lists.  And the LKML is to be cc-ed on all patch submissions.

> > @@ -78,31 +83,104 @@ struct m41t80_data {
> >  	struct rtc_device *rtc;
> >  };
> >  
> > -static int m41t80_get_datetime(struct i2c_client *client,
> > -			       struct rtc_time *tm)
> > +
> > +static int m41t80_i2c_write(struct i2c_client *client, u8 reg, u8 num, u8 *buf)
> > +{
> > +	u8 wbuf[num + 1];
> > +	struct i2c_msg msgs[] = {
> > +		{
> > +			.addr	= client->addr,
> > +			.flags	= 0,
> > +			.len	= num + 1,
> > +			.buf	= wbuf,
> > +		},
> > +	};
> > +
> > +	wbuf[0] = reg;
> > +	memcpy(wbuf + 1, buf, num);
> > +	return i2c_transfer(client->adapter, msgs, 1);
> > +}
> 
> This is reimplementing i2c_smbus_write_i2c_block_data().

 Where does it come from?  I fail to see this type of transfer being 
defined anywhere in the SMBus spec.  I checked the spec before I referred 
to the implementation in our I2C core and I hope you agree I may not have 
expected any extensions beyond what the SMBus spec defines.

 That written, you are of course correct WRT the reimplementation and I am 
eager to remove it -- thanks for the point.  I'll skip all your other 
comments related as obviously implied by this change.

 Given the function and friends make use of apparently a non-standard
SMBus transfer, I think they should be called differently, perhaps
i2c_smbusext_write_i2c_block_data(), etc. or suchlike.

> Mixing code cleanups with functional changes is a Bad Idea (TM).

 I am happy to bother you with a separate patch including style fixes.  I
can even create a handful of them, grouping functionally consistent
changes.

> >  	dev_info(&client->dev,
> > -		 "chip found, driver version " DRV_VERSION "\n");
> > +		 "%s chip found, driver version " DRV_VERSION "\n",
> > +		 client->name);
> 
> Incorrect change, dev_info() already includes the chip name.

 My system must be a notable exception then, as this change modifies 
output:

rtc-m41t80 1-0068: chip found, driver version 0.05

to:

rtc-m41t80 1-0068: m41t81 chip found, driver version 0.05

here.

> I'm not the one who will take your patch, I'll leave it to Alessandro
> to tell you what he wants, but one thing for sure: it would be much
> easier to review and validate your patches if you were not mixing
> functional changes and code cleanups.

 You seem to have your boundary set differently to me and a few other
people.  This is perfectly fine, as the line is thin here and each of the
subsystems follows slightly different rules.  You cannot always satisfy
everybody and if something makes your life easier and does not make mine
more difficult, I see no problem with adapting myself. :-)

> > @@ -803,6 +786,7 @@ static int m41t80_probe(struct i2c_clien
> >  
> >  #ifdef CONFIG_RTC_DRV_M41T80_WDT
> >  	if (clientdata->features & M41T80_FEATURE_HT) {
> > +		save_client = client;
> >  		rc = misc_register(&wdt_dev);
> >  		if (rc)
> >  			goto exit;
> > @@ -811,7 +795,6 @@ static int m41t80_probe(struct i2c_clien
> >  			misc_deregister(&wdt_dev);
> >  			goto exit;
> >  		}
> > -		save_client = client;
> >  	}
> >  #endif
> >  	return 0;
> 
> This one deserves a patch on its own IMHO.

 No problem.

  Maciej
