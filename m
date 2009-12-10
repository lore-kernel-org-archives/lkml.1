Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbZLJQvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbZLJQvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZLJQvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:51:42 -0500
Received: from smtp.nokia.com ([192.100.122.233]:42711 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZLJQvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:51:41 -0500
Date: Thu, 10 Dec 2009 18:51:06 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091210165106.GA21502@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
 <20091203110332.GO1361@nokia.com>
 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
 <20091210141830.GA10687@oksana.dev.rtsoft.ru>
 <20091210142127.GB12526@nokia.com>
 <20091210144411.GA13120@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091210144411.GA13120@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Dec 2009 16:51:16.0963 (UTC) FILETIME=[FDA14B30:01CA79B8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 10, 2009 at 03:44:11PM +0100, ext Anton Vorontsov wrote:
>Yep. The only thing I'm afraid of is that once the driver is in,
>then nobody will bother with improving it to do the right thing.
>But an imperfect driver is better than none.

I'm currently implementing the notifier part in a generic manner that 
would handle all transceivers (well, they would have to provide a some 
implementations for function pointers in struct otg_transceiver).

Then drivers like twl4030-bci and musb_hdrc could register for 
notifications from the transceiver. I was thinking of notifying the 
following events:

enum usb_xceiv_events {
	USB_EVENT_NONE,		/* no events or cable disconnected */
	USB_EVENT_VBUS,		/* vbus valid event */
	USB_EVENT_ID,		/* id was grounded */
	USB_EVENT_CHARGER,	/* usb dedicated charger */
	USB_EVENT_ENUMERATED,	/* gadget driver enumerated */
};

for the USB_EVENT_ENUMERATED we could also pass the bMaxPower (in mA) 
field of the struct usb_configuration, then BCI (or bq24xxx for that 
matter) can configure that as input current for charging.

USB_EVENT_ID is necessary because in most boards (at least the ones I've 
seen) the charging chip (bq24xxx) also plays the role as charge pump, 
sourcing vbus on OTG sessions.

USB_EVENT_VBUS and USB_EVENT_CHARGER aren't necessary on all cases, but 
boards like RX-51 where it has a different transceiver for charger 
detection, it's necessary to have those two separated.

If you guys have any comments already, please comment :-)

I'll try to finish a prototype by tomorrow and try to send it as RFC.
Will be sure to Cc you Anton.

-- 
balbi
