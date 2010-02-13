Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0BMQuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:50:20 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:45897 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab0BMQuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:50:18 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B76D8AE.7040102@jic23.retrosnub.co.uk>
Date: Sat, 13 Feb 2010 16:51:58 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: arjun rath <rath.arjun@gmail.com>, spi-devel-general@lists.sourceforge.net,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [spi-devel-general] SPI-ADC
References: <dc6d3181002122148v6451ebffka164de288738485d@mail.gmail.com> <63386a3d1002130548y7c839072y85097a9bcdf66cad@mail.gmail.com>
In-Reply-To: <63386a3d1002130548y7c839072y85097a9bcdf66cad@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjun and Linus,
> 
>> can anybody share how to start a spi based ADC linux driver.I am having a
>> MAXIM 1242 ADC chip.
> 
> The ḱernel does not contain any generic ADC subsystem abstraction (I
> think it would be good if it did), instead most drivers using ADC have
> their ADC portions stored inside a driver for something else, e.g.
> drivers/hwmon for ADCs used in temperature monitoring, or
> drivers/power for ADCs used in monitoring of currents and voltages
> for power supplies/batteries.
That's not entirely true.  These are covered by the IIO subsystem which
is admittedly currently in staging as some elements still need cleaning up.

As a quick summary of IIO.  Except for a few bits of management code, basic
drivers look pretty much like hwmon.  An example in tree is the tsl2563 driver
(under drivers/staging/iio/light) though that one is moving out to ALS when
Amit has a chance to sort out the relevant patch.

For more advanced drivers (only add support if you have a use as it is a fair
bit more complex) we have support for hardware and software ring buffers, an
events interface which is more or less the equivalent of input without cross
device aggregation.

ADC drivers are under drivers/staging/iio/adc.

I think in mainline we still only have a max1363 driver which covers a lot
of the i2c maxim parts (more to add after testing).  There are a couple
more iio using adc drivers in a blackfin tree at:

http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/
(Note these are very much under development!)  Though from a quick look
all of them are i2c based.  For an spi equivalent, take a look at
drivers/staging/iio/accel/ where we have the kxsd9 driver (which is another
simple example of an IIO driver) + lis3l02dq and sca3000 which are on the
heavy side (probably not a good place to start). 

For a general list of devices people are working on, or at least have and
intend to work on, take a look at:

https://sourceforge.net/apps/mediawiki/iioutils/index.php?title=Device_List

Just for reference, the big up coming change in IIO is a new userspace ABI
to clean things up before we get too many drivers using the somewhat messy
old version.

It will still be a little while before we have cleaned up the more controversial
issues in the core (none of which touch on the simpler drivers) but with a
steady increase in active developers things are speeding up.

So in conclusion, if your use of the driver doesn't fall neatly under hwmon
or elsewhere, and you don't mind writing for a subsystem which isn't entirely
polished and may change, then IIO might be what you are looking for.

Currently all discussions take place on LKML, but we are working on a more
focused alternative list which I'll announce once it is sorted out.

Just taking a quick and dirty look at the datasheet for the MAX1242:

* You might have fun getting the required conversion delay before a read.
 (Chip select must be enabled for 7.5 microsecs before the clock starts)

* Otherwise it is a nice simple chip with no actual control of anything.

Perhaps you can supply some information on your application to guide
an continuation of this discussion?

Thanks,



Jonathan Cameron
> 
> This is a bit bad for driving a generic ADC like this using spidev and,
> even if it was to be accessed from userspace only, having it under
> drivers/spi is rather counterintuitive, what happens when the next ADC
> using I2C turns up? drivers/i2c/chips?
> 
> I would suggest creating subsystem drivers/adc if you have time and
> energy, other ideas?
> 
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

