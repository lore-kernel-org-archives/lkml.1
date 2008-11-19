Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYKSKbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYKSKbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYKSKbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:31:00 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:61035 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYKSKa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:30:59 -0500
X-IronPort-AV: E=Sophos;i="4.33,630,1220241600"; 
   d="scan'208";a="62763623"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Date: Wed, 19 Nov 2008 10:30:56 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D069B15C2@limkexm3.ad.analog.com>
In-Reply-To: <20081119091853.GA26629@www.tglx.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Thread-Index: AclKJ+8G10x5evnITE6W/eZyjoijkgAAZ+LA
References: <1227000131-19145-1-git-send-email-cooloney@kernel.org> <49229E64.2010907@linutronix.de> <8A42379416420646B9BFAC9682273B6D06966B66@limkexm3.ad.analog.com> <20081119091853.GA26629@www.tglx.de>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: "Bryan Wu" <cooloney@kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>
X-OriginalArrivalTime: 19 Nov 2008 10:30:57.0486 (UTC) FILETIME=[E8B5EEE0:01C94A31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
>Sent: Wednesday, November 19, 2008 10:19 AM
>To: Hennerich, Michael
>Cc: Bryan Wu; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] USB/ISP1760: Fix for unaligned exceptions
>
>* Hennerich, Michael | 2008-11-18 15:41:01 [-0000]:
>
>>Sebastian,
>Michael,
>
>>It's not just that single spot.
>>I've seen unaligned pointers with count > 3 coming from various
drivers.
>>
>>Here just two examples:
>>
>>1) The generic Bluetooth USB driver: CONFIG_BT_HCIUSB
>>Bluez-utils: hcitool scan:
>>
>>priv_write_copy: src = 00efaa09, dst = 203c1200, len = 13
>>
>>Full trace attached.
>The trace is missing the kernel stack isn't it?

Well in that particular case - this doesn't look right.
Need to check the way we print the kernel stack in the dump.

>
>>
>>2) RTL8150 based USB Ethernet adapter: CONFIG_USB_RTL8150
>>dhcpcd:
>>
>>priv_read_copy: src = 00ea4812, dst = 203d8000, len = 64
>0x00ea4812 doesn't feel right. Unless I'm missing something, this is
>comming from rtl8150_open() while it was calling set_registers() to set
>the mac address. So I assume the buffer is the mac address. This is
>hardly possible because the MAC address itself is 6 bytes long and the
>accompanying control packet has 8 bytes while this comment says that
the
>transfer legth is 64bytes. And since this is a control message, we
>should not receive any response from the device.
>Anyway with with WirelesEXT & NETPOLL in 32bit mode the offset from
>begin of netdev to the mac address is 0x013c bytes and should be fine
>for 32bit access. So either the netdev struct isn't properly aligned or
>this a different transfer.

I know the issue is originated in either RTL8150 set_registers or
get_registers. We get some unaligned address from the stack to the
ISP1760 priv_read/wite_copy.

The RTL8150 driver does something like this:

	u8 data[3], tmp;

	data[0] = phy;
	data[1] = data[2] = 0;
	tmp = indx | PHY_READ | PHY_GO;
	i = 0;

	set_registers(dev, PHYADD, sizeof(data), data);

With gcc-3.x this never used to be a problem because u8 data[] always
used to be aligned 4. However compiling this with gcc-4.x u8 data[] can
be odd aligned.


>
>>I wonder if it's only us (NOMMU) seeing these odd aligned buffers?
>
>Not sure. The only problem I have with this patch is that you might
>cover bugs in drivers and you don't notice it anymore since you choose
>"voluntary" the slow path.

Well here I disagree, but I agree with the fact that there are buggy
drivers.

Since most processors running Linux do have unaligned access handling,
this issue goes unnoticed for all of them. Believe me the penalty taken
by any Processor doing this automatically and unnoticed is typically
much higher than using get/put_unaligned.

I'm tiered fixing all unaligned issues in drivers. It's a hassle getting
them merged, since most people don't care. Having a workaround in a
single place, the hcd driver is much easier.
 
>
>>-Michael
>
>Sebastian
