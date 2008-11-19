Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKSJT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKSJT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYKSJTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:19:08 -0500
Received: from www.tglx.de ([62.245.132.106]:44314 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYKSJTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:19:04 -0500
Date: Wed, 19 Nov 2008 10:18:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Message-ID: <20081119091853.GA26629@www.tglx.de>
References: <1227000131-19145-1-git-send-email-cooloney@kernel.org> <49229E64.2010907@linutronix.de> <8A42379416420646B9BFAC9682273B6D06966B66@limkexm3.ad.analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D06966B66@limkexm3.ad.analog.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hennerich, Michael | 2008-11-18 15:41:01 [-0000]:

>Sebastian,
Michael,

>It's not just that single spot.
>I've seen unaligned pointers with count > 3 coming from various drivers.
>
>Here just two examples:
>
>1) The generic Bluetooth USB driver: CONFIG_BT_HCIUSB  
>Bluez-utils: hcitool scan:
>
>priv_write_copy: src = 00efaa09, dst = 203c1200, len = 13
>
>Full trace attached.
The trace is missing the kernel stack isn't it?

>
>2) RTL8150 based USB Ethernet adapter: CONFIG_USB_RTL8150
>dhcpcd:
>
>priv_read_copy: src = 00ea4812, dst = 203d8000, len = 64
0x00ea4812 doesn't feel right. Unless I'm missing something, this is
comming from rtl8150_open() while it was calling set_registers() to set
the mac address. So I assume the buffer is the mac address. This is
hardly possible because the MAC address itself is 6 bytes long and the
accompanying control packet has 8 bytes while this comment says that the
transfer legth is 64bytes. And since this is a control message, we
should not receive any response from the device.
Anyway with with WirelesEXT & NETPOLL in 32bit mode the offset from
begin of netdev to the mac address is 0x013c bytes and should be fine
for 32bit access. So either the netdev struct isn't properly aligned or
this a different transfer.

>I wonder if it's only us (NOMMU) seeing these odd aligned buffers?

Not sure. The only problem I have with this patch is that you might
cover bugs in drivers and you don't notice it anymore since you choose
"voluntary" the slow path.

>-Michael

Sebastian
