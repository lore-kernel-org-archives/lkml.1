Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYIKJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYIKJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYIKJxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:53:05 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:53503 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbYIKJxE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:53:04 -0400
From: Frans Pop <elendil@planet.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 11:52:56 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
References: <48C68507.6000609@suse.com> <1221088512.13621.58.camel@macbook.infradead.org> <200809111043.34847.elendil@planet.nl>
In-Reply-To: <200809111043.34847.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809111152.58187.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 09:53:00.0723 (UTC) FILETIME=[2D26B830:01C913F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, Frans Pop wrote:
> Possible solutions
> ==================
> There are two possible solutions to this.
>
> 1) Move the firmware files to a versioned directory
[...]
> 2) Move the firmware files into a separate package

As mentioned in my previous mail Debian currently uses 2) for its kernel 
packages up to and including 2.6.26. I expect the Debian kernel team to 
also use 2) for 2.6.27, but that's in the future. Debian is currently 
concentrating on 2.6.26 as that's the kernel targeted for the soon-to-be- 
released Lenny release.

>From what I understand from this list (I'm a Debian person and don't 
really follow Ubuntu), Ubuntu seems to have chosen 1).

There are pros and cons to both these solutions and given the different 
philosophies of Debian and Ubuntu those do help explain the different 
choices.

Solution 1:
a) keeps kernel, modules and firmware firmly together
b) ensures there will never be mismatches, even if a firmware file "ABI"
   changes without being properly versioned
c) makes system installation simple: firmware is always just "there"

Solution 2:
a) naturally allows firmware to be split between "free" and "non-free"
b) places a burden on the end-user to install/upgrade the firmware he
   needs separately from the kernel
c) makes system installation more complex as the right additional firmware
   package(s) need to be retrieved and installed
d) will break installed systems on upgrades (unless special measures are
   taken): users may need to install additional firmware packages on a
   kernel upgrade to keep a driver working

Ubuntu has a "things should just work" philosophy. Choosing 1) keeps 
things simple from a user PoV and is a logical choice from that 
perspective.

Debian has strict licencing rules and has never shirked from placing some 
responsibility in the hands of users. Especially 2a) makes 2) the more 
natural choice for Debian.


Note that with 2) you cannot just create one big "linux-firmware" package. 
You will need to package all firmware separately which means that users 
will need to somehow select the specific firmware packages they need for 
their hardware.
The reason for this is the possibility that a driver and its firmware may 
be dropped from the upstream kernel source.

Example
-------
linux-image-2.6.27_1_i386.deb contains:
/boot/vmlinuz-2.6.27
/lib/modules/2.6.27/kernel/net/a.ko
/lib/modules/2.6.27/kernel/net/b.ko

linux-firmware_2.6.27.1_i386.deb contains:
/lib/firmware/a.dat
/lib/firmware/b.dat

For 2.6.28 driver "a" is dropped, which would result in:
linux-image-2.6.28_1_i386.deb contains:
/boot/vmlinuz-2.6.28
/lib/modules/2.6.28/kernel/net/b.ko

linux-firmware_2.6.28.1_i386.deb contains:
/lib/firmware/b.dat

The user installs linux-image-2.6.28 alongside linux-image-2.6.27 and 
upgrades linux-firmware from version 2.6.27.1 to 2.6.28.1.
Oops! The upgrade of the linux-firmware package removed b.dat, which 
effectively means the still installed 2.6.27 kernel is now broken.

To avoid this you need separate packages which can be installed/removed 
independently:
a-firmware_<a-firmware-version>_i386.deb contains:
/lib/firmware/a.dat

b-firmware_<b-firmware-version>_i386.deb contains:
/lib/firmware/b.dat
