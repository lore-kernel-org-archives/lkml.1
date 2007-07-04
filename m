Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXGDGDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXGDGDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXGDGC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:02:56 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:43081 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751331AbXGDGCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:02:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oLtWFLdpUYTBj8wIAHdYHBspGnkQLbuFaSn8VmUkM9rlWby+oNMV8gKa0vDs+J6UpNE8p0f2T73gAqLHcJndi7MpivhfoVcb3NCOcT2tJLljpsbW90MKwaYD1X4kLJOHk8+BPWRT/ElC4UN2sOsN+HMo3wYaLKfgX59eXPmUj+M=  ;
X-YMail-OSG: VCD_AkcVM1kywHuzIJcFPQLmiSBb51Zez2WMycKl1En.h4u_Gkz8xzSmK17QXrEPTWs53Ztd_w--
From: David Brownell <david-b@pacbell.net>
To: rtc-linux@googlegroups.com
Subject: Re: Does the kernel HPET support has problems or the hwclock from util-linux?
Date: Tue, 3 Jul 2007 23:02:52 -0700
User-Agent: KMail/1.9.6
Cc: Luca Tettamanti <kronos.it@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032302.52612.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not that I think it matters, but I understand that util-linux-ng
now has a 2.13-rc1 release out, so you're not using the latest
version of "hwclock".  That shouldn't affect HPET though.

That said, this situation is likely going to be a mess until
some new HPET support gets merged.  Issues include:

 - There are two drivers for the "cmos rtc" ... the legacy
   version (/dev/rtc), and the one using the new RTC framework
   ("rtc-cmos" driver, likely /dev/rtc0 on your system).

   To use the new one, you'll probably want the latest hwclock,
   which understands that not ever RTC uses /dev/rtc0.  (Or you
   can symlink /dev/rtc to /dev/rtc0 ...)

 - HPET itself has two modes.  I think of them as "break things
   mode" and "sane mode"; but I think they have official names
   that make the first one sound like it might be reasonable to
   use.  (Yet it isn't; and I suspect that's a big reason why
   HPET isn't enabled by default on most systems.)

   The difference is that the "break things" mode overrides
   the RTC interrupt line so the RTC can't use it, where the
   "sane" mode just routes HPET irqs like other IRQs.

 - Until the new HPET stuff gets merged (and I don't know what
   schedule that's on), Linux uses the "break things" mode.
   Which means that it breaks rtc-cmos ... but the legacy RTC
   driver has some fairly ugly hacks to cope with it.

   The new HPET stuff will among other things let HPET be used
   to provide per-CPU clockevent sources (assuming there are as
   many HPET instances as there are CPUs).  That's on top of
   other advantages, like "not breaking things".

So for the short term, I think there might be some set of config
options using the legacy (drivers/char/rtc.c) driver that will
let you enable HPET, with minimal breakage.  I don't know what
those options are, or what hwclock would need to do (or not do).

And longer term, the rtc framework version (rtc-cmos) will work
just fine with new HPET code, since Linux will be able to use
HPET in "sane mode" not "break things" mode.

- Dave

