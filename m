Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbYJPXFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbYJPXFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYJPXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:05:30 -0400
Received: from xenotime.net ([66.160.160.81]:36389 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757621AbYJPXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:05:29 -0400
Date: Thu, 16 Oct 2008 16:05:25 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: mmotm 2008-10-16-00-52 uploaded (HID)
In-Reply-To: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810161558341.14604@shark.he.net>
References: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-10-16-00-52 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27:

mmotm has several various build failures when
HID=y and USB=n
or
HID=y and USB_HID=m.

These are (mostly) caused by drivers/hid/Kconfig doing lots of "select"s
when EMBEDDED=n, such as

config HID
	tristate "Generic HID support"
	depends on INPUT
	default y
        select HID_A4TECH if !EMBEDDED
        select HID_APPLE if !EMBEDDED
        select HID_BELKIN if !EMBEDDED
        select HID_BRIGHT if !EMBEDDED

and HID_BRIGHT (just to pick one of them) says:

config HID_BRIGHT
	tristate "Bright"
	default m
	depends on USB_HID

but that "depends on USB_HID" isn't being "honored" because "select"
doesn't honor (or care) about dependencies.

I think that you already know about this, but drivers/hid/Kconfig
does need fixing.


Build failure examples:

9168:
HID=y, USB=n
hid-bright.c:(.text+0x1013f0): undefined reference to `usbhid_set_leds'
hid-dell.c:(.text+0x1019bc): undefined reference to `usbhid_set_leds'
hid-lg.c:(.text+0x102310): undefined reference to `usbhid_set_leds'
hid-lgff.c:(.text+0x102509): undefined reference to `usbhid_submit_report'
hid-lgff.c:(.text+0x102566): undefined reference to `usbhid_submit_report'
hid-pl.c:(.text+0x102bbb): undefined reference to `usbhid_submit_report'
hid-pl.c:(.text+0x102ddf): undefined reference to `usbhid_submit_report'
hid-sony.c:(.text+0x103339): undefined reference to `usb_control_msg'

9170:
HID=y, USB_HID=m
hid-bright.c:(.text+0xa9d2e): undefined reference to `usbhid_set_leds'
hid-dell.c:(.text+0xaa332): undefined reference to `usbhid_set_leds'
hid-lg.c:(.text+0xaa7e8): undefined reference to `usbhid_set_leds'
hid-pl.c:(.text+0xab669): undefined reference to `usbhid_submit_report'
hid-pl.c:(.text+0xab88d): undefined reference to `usbhid_submit_report'

9174:
HID=y, USB=n
hid-bright.c:(.text+0x1b4cf2): undefined reference to `usbhid_set_leds'
hid-dell.c:(.text+0x1b52e2): undefined reference to `usbhid_set_leds'
hid-lg.c:(.text+0x1b5790): undefined reference to `usbhid_set_leds'
hid-lg2ff.c:(.text+0x1b6077): undefined reference to `usbhid_submit_report'
(.text+0x1b61d2): undefined reference to `usbhid_submit_report'
hid-sony.c:(.text+0x1b6db7): undefined reference to `usb_control_msg'

-- 
~Randy
