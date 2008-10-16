Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYJPWWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYJPWWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJPWWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:22:34 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:25461 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757315AbYJPWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:22:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E2EeOaBM1kv2PSPsVCsS2hiBA9piB0kzapSHEKg8ObjiHci2ZJM3X9m58Y4MIUuRSBY0l0fne9y3juVisi4qvrZfKe1vOfrda4BOtEWyYIrM3AVdwtJbFILBJDrkJsF8r5YI0hCsBN1rHSroFrQQaLmQOebaS3q3lPRYCEjN7PQ=  ;
X-YMail-OSG: 0WQMGTcVM1nwXDgE45iHh4JWmBjb3yJ4O65xOjGs9ChPgJkpuWFw8h2df4xGJzPsgF2pStFuTuu4TE.UPA4wmBPbrox4ZhYwYdEKpKpoZhvWaVDgaFzcHiGCAiHZ3TvBUpU_7wZUtIoNBOG3fRJdApOC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       =?iso-8859-1?q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
Subject: Re: [rtc-linux] Re: invalid default values in RTC chip
Date: Thu, 16 Oct 2008 15:22:25 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Rodolfo Giometti <giometti@linux.it>
References: <48F45FA5.6040308@liewenthal.ee> <20081016135846.8b06d9f8.akpm@linux-foundation.org> <20081016234108.1268f65c@i1501.lan.towertech.it>
In-Reply-To: <20081016234108.1268f65c@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810161522.26098.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Alessandro Zummo wrote:
> On Tue, 14 Oct 2008 12:00:21 +0300
> Jüri Reitel <juri.reitel@liewenthal.ee> wrote:
>
> > > My question relates to RTC driver linux/drivers/rtc/rtc-ds1307.c for 
> > > device m41t00. Driver probe function will fail if some of the chip's 
> > > registers contain invalid date time values i.e. if month register is 32 
> > > or minutes is 61.

This stuff?

        tmp = ds1307->regs[DS1307_REG_SECS];
        tmp = BCD2BIN(tmp & 0x7f);
        if (tmp > 60)
                goto exit_bad;
        tmp = BCD2BIN(ds1307->regs[DS1307_REG_MIN] & 0x7f);
        if (tmp > 60)
                goto exit_bad;

        tmp = BCD2BIN(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
        if (tmp == 0 || tmp > 31)
                goto exit_bad;

        tmp = BCD2BIN(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
        if (tmp == 0 || tmp > 12)
                goto exit_bad;


> > > Is this correct behavior? Probe function's purpose is  
> > > to check if the device is as was assumed (this time RTC and it is). The 
> > > chip's values are incorrect but the chip works, even the m41t00 chip 
> > > manual states that after initial powerup (RTC battery power applied) 
> > > internal registers will contain random data.
> > > 
> > > There are two solutions first is driver patch and another is i2c-dev and 
> > > i2cset tool to use from user space during bootup. Whitch one should be used?
> 
>  Given we transitioned to the new i2c model, which mandates
>  a platform device to be declared,

Actually "i2c_board_info", not a "platform_device" ...


>  there's no more the need 
>  to check for the device in the probing function.
> 
>  this should be fixed in the driver.

Right.  The code I snipped above dates from the old
drivers/i2c/chips/ds1337.c code, as I recall, which
was trying to defend against some random non-RTC chip
sitting at the relevant address.  As pretty much all
legacy I2C drivers needed to do.

With "new style" I2C drivers, no guessing is needed
and such defenses are superfluos.  It's fair to notice
that no chip is actually present ... but if there's
a chip there, it should be assumed to match the
declaration Linux was given.


>  however, a driver may still return a failure when reading
>  the time if there are inappropriate values in the registers.

In this driver, ds1307_get_time() already has a

        return rtc_valid_tm(t);

But in the just-merged alarm support, ds1307_read_alarm()
doesn't do that.  Actually that function should use a name
like ds1337_read_alarm(), since the 1307 has no alarm!


>  the solution is to patch the driver for detection and then
>  use a recent hwclock on bootup to write the time if required.

Exactly.  Feel free to submit a patch removing those
probe() checks, and fixing the code returning the alarm
setting too.

- Dave
