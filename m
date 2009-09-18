Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZIRXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZIRXAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 19:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZIRXAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:00:13 -0400
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:42867 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752532AbZIRXAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:00:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [spi-devel-general] [PATCH 1/2] spi: new SPI bus lock/unlockfunctions
Date: Fri, 18 Sep 2009 19:00:13 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D41FB1@mi8nycmail19.Mi8.com>
In-Reply-To: <8bd0f97a0909171553s1b7ee725x728bbca2f49511a9@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH 1/2] spi: new SPI bus lock/unlockfunctions
Thread-Index: Aco36cpILHXb96L0QReGppJK6/ZQ+wAxrbGg
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> <BD79186B4FD85F4B8E60E381CAEE190901D41E44@mi8nycmail19.Mi8.com> <8bd0f97a0909171553s1b7ee725x728bbca2f49511a9@mail.gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: <spi-devel-general@lists.sourceforge.net>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Yi Li" <yi.li@analog.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Sep 2009 23:00:14.0095 (UTC) FILETIME=[C81A51F0:01CA38B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8IN0T16007989

On Thursday, September 17, 2009 3:54 PM, Mike Frysinger wrote:
>> I assume the spi master driver must supply the {lock/unlock}_bus methods
>> to properly support the locking.
>
> currently, yes.  a common solution would be nice.  ideas/patches welcome ;).
>
>>Â But, by returning 0 when the methods
>> are not supplied you are basically saying all the current master drivers
>> in mainline support bus locking. Â I think this is really only "true" if
>> spi->master->num_chipselect == 1.
>
> right, but that is no different from what we have today.  there is no
> way for a client to guarantee exclusive access, so you cant write code
> assuming it in the first place.  the only consumer thus far (mmc_spi)
> actually errors out if such conditions exist.
>
> in other words, we arent breaking anything.

Actually you are breaking the mmc_spi driver.

By returning 0 when the methods are not supplied you are saying that the
master driver supports and locked the bus.  At a minimum, I think spi_lock_bus()
should return an error code if locking is not supported.

Also, as Andrew Morton pointed out, calling spi_unlock_bus() without having
a valid lock by calling spi_lock_bus() is a bug.

In addition your patch to mmc_spi should check the return code from
spi_lock_bus().  If the driver "requires" that the bus be locked it should
trigger an error path if it cannot be locked.

>> Also, do you have a master driver that does have the {lock/unlock}_bus
>> methods? Â I would like to see how you handled it.
>
> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=cc54fa8ed63e11a000031bc650d41d57b441803d

Oiy... The lock/unlock functions are simple enough but the change needed
to bfin_spi_pump_messages() is a bit complicated.

What happens to next_msg if it is for other devices on the bus?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
