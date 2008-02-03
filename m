Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYBCXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYBCXIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYBCXIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:08:31 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:33370 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755318AbYBCXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:08:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=ScQomGtmFk/232fB4yKos5Xqurla9vc41KsXTXosE27vz65mOXDaKvF8RSIKs3qqS0bRtLwssTgJ9m7QUr2jkS8Ol5AAaZcTenULXi3M7x8+cXoK/AS+EDgXL5lZWSFQMrSkvgRu/EehU0WYpROT1m7f58gs9sIGPRVwJ/wERKg=  ;
X-YMail-OSG: 5NjqUFMVM1n.4gZxDV4KPPrtB9RXI_hhMVMJ0yP9PX.qgJBHGqSnozgnbKhqI5vEwG_PeXMLMg--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 03 Feb 2008 15:08:26 -0800
From: David Brownell <david-b@pacbell.net>
To: pavel@ucw.cz
Subject: Re: [linux-pm] sleepy linux self-test
Cc: rjw@sisk.pl, mingo@elte.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080130131748.GA3796@elf.ucw.cz>
 <200802031321.27828.rjw@sisk.pl>
 <20080203131636.4100828D3E1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200802032229.30576.rjw@sisk.pl>
 <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080203224831.GE2799@elf.ucw.cz>
In-Reply-To: <20080203224831.GE2799@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080203230826.C05AF9E4D0@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The changes look good to me.
> > 
> > They feel unfinished to me though.  :)
> > 
> > Like using "jiffies" instead of a clocksource, which makes trouble
> > since the timing covers periods with IRQs disabled.  And the test
> > mode parameter needs work.
>
> Well, I'd say that timing has bigger problem, right?
>
> It is
>
> set alarm
> 	suspend system
> | poweroff
> alarm expires
> 	system resumes
>
> ... so you are measuring resume time + sleep time, no? 

There's no "poweroff" step when entering STR or STANDBY!

But more specifically, I avoided that issue by comparing times between
  (a) start and end of the "suspend devices" steps;
  (b) start and end of the "resume devices" steps.

Example output, with the relevant lines highlighted by "*":

    PM: test RTC wakeup from 'mem' suspend
    PM: Syncing filesystems ... done.
    PM: Preparing system for mem sleep
    Freezing user space processes ... (elapsed 0.00 seconds) done.
    Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
    PM: Entering mem sleep
    Suspending console(s)
 *  PM: suspend devices took 0.000 seconds
    GPIO-A may wake for 00080000
    GPIO-C may wake for 00000008
    GPIO-D may wake for 00000020
    AT91: PM - wake mask 00000036, pm state 3
    AT91: PM - no slow clock mode yet ...
    AT91: PM - wakeup 00000002
 *  PM: resume devices took 0.132 seconds
    PM: Finishing wakeup.
    Restarting tasks ... done.

The underlying clocksource has resolution of 32 KiHz, while HZ=128;
the "suspend" more typically reports 7 msec.  And there should be a
few more wakeup GPIOs, except I seem to not have enabled gpio_keys.
That "wakeup 00000002" means the heavily-overloaded "system" IRQ
woke the system ... the RTC is on that IRQ line.

- Dave

