Return-Path: <linux-kernel-owner+w=401wt.eu-S1763894AbXGJS34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763894AbXGJS34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbXGJS3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:29:48 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:48267 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751011AbXGJS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:29:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2Sz5xROGNkiusdh4mDGe3qdKi/Z6/UjhE6bNm+Tdgb31l601kfKVIY7XhFiolOZOzS2sbTtmhVLFgEgMwW4qAsvbUSC9TTWP0/KOad4DajO9Ablaf5wbhe3XQn43sb85iaVT1Wd4dCbK1n3o2r5EI9EHCPqxel2i7h+ptvGuy4M=  ;
X-YMail-OSG: 7xoERHoVM1n0vXhJagHFi3KxF3M.aFEjPGYdGe_zyt6WH7CM1roSkpeRYwCVseyxt40I8gAT_Q--
From: David Brownell <david-b@pacbell.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [RFC] disabling RTC irq during release
Date: Tue, 10 Jul 2007 11:29:45 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070704170753.GO10397@enneenne.com>
In-Reply-To: <20070704170753.GO10397@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101129.45456.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007, Rodolfo Giometti wrote:
> Hello,
> 
> Looking at other rtc drivers I noticed that during the release()
> method we should disable IRQs as follow:
> 
> static void ds1307_release(struct device *dev)
> {
>         struct ds1307   *ds1307 = dev_get_drvdata(dev);
> 
>         if (ds1307->irq >= 0) {
>                 ds1307->irqen = 0;
>                 ds1307_update_alarm(ds1307);
>         }
> }

On the RTC list, the outcome of that discussion was that
the release() method -- not generally implemented at this
time, and only supporting the /dev/rtcN access mode -- should
only disable the IRQs enabled through that /dev/rtcN file.

Now, it turns out that of the three kinds of RTC IRQ (alarm,
once-per-second, and 2^N-per-second), two of those modes can
be accessed through in-kernel APIs outside /dev/rtcN calls:

 - 2^N-per-second "periodic" irqs, using rtc_irq_set_freq()
   and rtc_irq_set_state()

 - alarm irqs, using rtc_set_alarm()

So it would be incorrect to disable those IRQs, when some
other kernel activity had enabled them.  But for now it
would be correct to always disable once-per-second "update"
IRQs in a release() method.

There's a separate issue -- longstanding, not new to the
RTC framework -- of how several consumers of RTC IRQs ought
to share the different kinds of IRQ.


> But if I wish using RTC IRQ line to turn also the board ON, not just
> to put to sleep it, I should leave the IRQ line on!

That can be done with /sys/class/rtcN/device/power/wakealarm,
writing it to the time (in seconds) the RTC alarm should kick
the board's power-on circuitry.

- Dave
