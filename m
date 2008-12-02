Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYLBWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYLBWXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYLBWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:23:09 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:47336 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYLBWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:23:08 -0500
X-BigFish: VPS-46(zz542N1432R9370P98dR1805M936fOzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4935B533.7060504@am.sony.com>
Date: Tue, 2 Dec 2008 14:22:43 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Marvin <marvin24@gmx.de>
CC: Fabiano Manoel de Andrade <fabianoma@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: RTC problem in PS3
References: <1226875490.6597.11.camel@lottar> <200811172102.12286.marvin24@gmx.de>
In-Reply-To: <200811172102.12286.marvin24@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2008 22:22:44.0689 (UTC) FILETIME=[7F8EB410:01C954CC]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marvin wrote:
> forward to a better place...
> 
> On Sunday 16 November 2008 23:44:50 Fabiano Manoel de Andrade wrote:
>> 	Hi I've compiled the latest version of linux kernel (2.6.27.6) in my
>> PS3 running debian and get a warning message listed here
>>
>> 	Setting the system clock.
>>   	Cannot access the Hardware Clock via any known method.
>>   	Use the --debug option to see the details of our search for an access
>> method. * Unable to set System Clock to: Sun Nov 16 20:33:06 UTC 2008
>>
>>
>> 	The problem can be reproduced with the commands
>>
>> 	# hwclock --debug
>>  	hwclock from util-linux-ng 2.13.1.1
>>   	hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
>>   	No usable clock interface found.
>>   	Cannot access the Hardware Clock via any known method.
>>   	# ls -l /dev/rtc*
>>   	ls: cannot access /dev/rtc*: No such file or directory
>>
>> 	Loading the rtc-ppc module solve the problem, but after restart
>> the system I still have the problem. Looking at kernel config I change the
>> rtc-ppc to be build into kernel and this solve totally the problem. So the
>> ps3_defconfig must set the rtc-ppc to be build into kernel.

This is do to a bug in the rtc-ppc driver.  It is not PS3 specific, but
will affect all powerpc machines that use the rtc-ppc driver and have it
built as a loadable module.

Normally, udev will automatically load drivers for the devices present in the
system.  The info udev uses to autoload the driver is not provided by the
rtc-ppc driver, so when it is build as a loadable module udev can't figure
out which driver to load.

Here is some discussion Geert and I had:

-------- Original Message --------
On Tue, 2 Dec 2008, Geert Uytterhoeven wrote:
> On Mon, 1 Dec 2008, Geoff Levand wrote:
> > There is a similar problem when the new generic ppc-rtc driver is
> > built as a module and the startup scripts try to access the RTC.
> 
> Add it to /etc/modules? But then it'll be loaded on all platforms. But as it
> uses the ppc_md infrastructure, that may actually be the right thing to do on
> all PPC platforms.
> 
> However, ppc-rtc looks like a strange driver: it creates a platform_device, but
> doesn't contain the corresponding platform_driver.
> Ah, it creates the platform_device just to be able to pass a struct device to
> rtc_device_register().
> 
> But as all of this is done from module_init(), there's no opportunity for
> autoloading....

It can be solved...

If the creation of the "ppc-rtc" platform device would be moved to builtin
core code (e.g. arch/powerpc/kernel/setup-common.c?), and drivers/rtc/rtc-ppc.c
would become a real platform driver that binds to the "ppc-rtc" platform
device, then it would be autoloaded by udev.

-Geoff

