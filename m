Return-Path: <linux-kernel-owner+w=401wt.eu-S1766993AbXDEOJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766993AbXDEOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766998AbXDEOJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:09:14 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:52443 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766993AbXDEOJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:09:12 -0400
Message-ID: <045101c7778b$e45406e0$84163e05@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Li Yu" <raise.sail@gmail.com>, <yanghong@ccoss.com.cn>,
       "linux-usb-devel" <linux-usb-devel@lists.sourceforge.net>,
       <hongzhiyi@ccoss.com.cn>, "Marcel Holtmann" <marcel@holtmann.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <1175516515.5815.347.camel@violet> <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz> <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com> <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz> <02f801c7770d$3eafb050$84163e05@kroptech.com> <Pine.LNX.4.64.0704050109500.4173@jikos.suse.cz> <036401c77711$cee286d0$84163e05@kroptech.com> <Pine.LNX.4.64.0704051034100.4173@jikos.suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Thu, 5 Apr 2007 10:08:31 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 4 Apr 2007, Adam Kropelin wrote:
>> On Apcupsd we've recently introduced a libusb-based driver that does
>> all HID parsing in userspace. Not only does that free us from
>> hiddev, it also frees us from the umpteen other proprietary HID
>> interfaces across various platforms. Although the hiddev-based
>> driver is still the default for Linux platforms, I plan to change
>> that in the next major release and thus begin migrating folks off of
>> hiddev.
>
> Great. Do you use libusb to obtain raw hid events?

We do, along with libusbhid from *BSD to handle report descriptor 
parsing and report field extraction/insertion.

> Could you by any
> chance look at current implementation of hidraw (it's in -mm or I can
> send it to you as a separate patch) and check whether you have any
> comments on this?

I pulled down 2.6.21-rc5-mm4 and took a look at hidraw. I like the 
simplicity of it for sure. One feature that seems to be missing is the 
ability to force an input report to be fetched via a control transfer. 
Several APC UPSes have the unfortunate tendency to change report values 
without sending an interrupt report to notify you, so you have to poll 
them occasionally. Also, how does one fetch string descriptors via 
hidraw?

> It would be good if you could use hidraw rather
> than reading raw usb data through libusb.

I have to admit I don't see much value in switching Apcupsd to hidraw 
rather than libusb. (I see lots of value switching it away from hiddev, 
though :) We need a HID engine in userspace to handle descriptor parsing 
with any non-hiddev solution. Plus, APC UPSes tend to have buggy HID 
implementations that require a bit of care to communicate with properly. 
Having an "intelligent" kernel layer in the middle tends to just get in 
the way (see the truncated report handling patch for hid-core I just 
sent).
But honestly, the deal-breaker is that with libusb I can hit Linux, all 
the *BSDs, Darwin, Solaris, and even Windows with a single userspace 
driver. That's just too valuable to ignore.

--Adam

