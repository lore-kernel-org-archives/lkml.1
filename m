Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbXCFUCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbXCFUCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXCFUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:02:43 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:26648 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751141AbXCFUCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:02:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M5v5cxJs6aRIryrLe7pDUfQtklJj4w+Xpg232YMZy91FAl2rUrgfgdi3KZ2h3FBbLCBqJIbBgLpOk0/IPiwI3hh8GsHMWjhkfsszAqvI3n+Qo9R5D2awmiKZv+R/QM3zU4bTB+Rgk8EJ7IuBNyODsnnC9uVASVCZNCz9J7Yw6iQ=  ;
X-YMail-OSG: CvmJIIYVM1nEwZfX7DhjG5HjlgmEygdfw38Ysl7W9R3BkKeJo0pq4vC42JFbUJbkji0gaGl2a9I8qkJ93vUFqB_KwY.QBWdDr7F0HjXWx54pYIKcVhprBtGBZ8y9XSow.yfIpY7nA_guzRc9.VfAne8PTOIzF_1clw--
From: David Brownell <david-b@pacbell.net>
To: rol@as2917.net
Subject: Re: 2.6.21-rc2 : Oops in rtc_cmos...
Date: Tue, 6 Mar 2007 11:32:28 -0800
User-Agent: KMail/1.7.1
Cc: "'Adrian Bunk'" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it, rtc-linux@googlegroups.com
References: <01b901c75fc1$2295d4c0$4b00a8c0@donald>
In-Reply-To: <01b901c75fc1$2295d4c0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061132.29331.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 11:29 pm, Paul Rolland wrote:
> Hello Adrian,
> 
> > does the patch in http://lkml.org/lkml/2007/2/23/184 fix your problem?
> 
> Yes, it does, so it's a Good One (tm),

And points out that $SUBJECT is misleading; the root cause of
the oops isn't rtc_cmos.  Workaround, don't enable the legacy
driver for this hardware.


> but I don't understand what's going 
> on then... My dmesg says, related to rtc :
> 
> ...
> rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0

I think the RTC core shouldn't emit this message; I'll send
a patch.  It's just confusing on error paths; and on success
paths it's less informative than a message from the driver
itself could be.

One of the good things about getting rtc-cmos merged:  it
exposes this new RTC framework to new mistakes, which helps
fix some of the remaining rough spots.  


> pnp: Device 00:03 does not support disabling.

Blame the PNP stack for that particular useless message.
I'l send a fix for that one too.


> rtc_cmos: probe of 00:03 failed with error -16

That's the first message that makes any sense to emit!

In this case, "-16" ("-EBUSY") means that a resource
was in use by the legacy RTC driver.


> ...
> and then later :
> ...
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

Because probing 00:03 failed, was never fully usable.
So then rtc0 couldn't be found.  You'd get the same
message if, say, the RTC was loaded as a module.


> ...
> 
> What does this all mean ? I thought an RTC Cmos was always there on a
> standard PC motherboard... (that's why I had activated the option in the
> first time).

You enabled CONFIG_RTC (under char drivers, "Enhanced Real Time Clock Support")
so that driver has claimed the CMOS RTC instead of "rtc-cmos.c".  Disable it.
Then you'll be able to use this driver with no little surprises.


It's odd the way that code registered the RTC before grabbing the resources
it would use.  Normally I wouldn't code it like that.  I think that probably
had to do with wanting to make sure resources got associated with "rtc0"
(or whatever) rather than some generic name.  Obviously that can only happen
if the RTC was registered (and thus named) before claiming resources.

- Dave
