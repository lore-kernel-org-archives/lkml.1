Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936Ab0AZPdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0AZPdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536Ab0AZPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:33:07 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:30052 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752936Ab0AZPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:33:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QCeKten5+QU5vhECRAfpGdFlLGY9jmkY/XTy406ZR98hmHgijzyNoMqEBzdEl8LwVZ2RJVqjbStaHkimG1WTzihjvUU7cxBPNUPoEM4dGHHp3ueSQHcs+kxlxU6uOKn/xehvPQ/uaGn2V59xEkQ7J4RvtRc7fpRfcOaMwhwHu0A=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: fWYEF6UVM1kBmNnr95QLkNw31e0IT6_8Kylxy3kIV7aVWjdfPUskYWuHmvF2I9f02ReDJtzRPLbHHUhD1q7udYZLJCjPm.ZqIwn._SkQQGH8aVbqJ_x8e_GRBXOLOo0mNR6r4bKkEntRnv703DYbWLsWfKSmlPcle2IUc5oHI97C5LlqurD9tEPw.herHL6hnqmmXX052jvurtL.MiJ3ZqZErbxSM5ATFVVaeksWyc16QwIufSBbK3YWQJPTTvpx
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 07:33:01 -0800
User-Agent: KMail/1.9.10
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <20100126141016.GD10690@nokia.com> <20100126141935.GG10690@nokia.com>
In-Reply-To: <20100126141935.GG10690@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001260733.01628.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Felipe Balbi wrote:
> just remember of another problem which I couldn't solve yet:
> 
> if you boot the board with the usb cable already attached, then we miss 
> the first notification because when the notifier is called, usb 
> controller driver isn't probed yet.

That's part of why the OTG transceiver driver has methods
used by host and peripheral drivers to register themselves.

Standard init sequence there is to do nothing until both
drivers are fully initialized ... last step being to
register the drivers with the transceiver.  That way the
transceiver can know when its peer drivers are ready.

Example:  VBUS present from a host.  If the board runs
in OTG mode, as soon as both drivers are registered then
the B-Default state machine would start running ... and
that involves (see the OTG state machine!) issuing a VBBUS
event.

Same thing can be done with the power events.  As soon
as an event listener is registered, it could be fed any
events it missed.  (Just one approach; one must sort
out any other interdependencies too.  In this case, it
can make sense to consume 100mA current right away, and
then adjust the draw later if needed.)

- Dave
