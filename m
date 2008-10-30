Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYJ3Ubn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYJ3Ubn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYJ3Ubg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:31:36 -0400
Received: from xes-mad.com ([216.165.139.214]:33764 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYJ3Ubf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:31:35 -0400
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810301006.01689.david-b@pacbell.net>
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
	 <200810300116.33131.david-b@pacbell.net>
	 <1225379144.27415.111.camel@localhost.localdomain>
	 <200810301006.01689.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 15:31:31 -0500
Message-Id: <1225398691.27415.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 10:06 -0700, David Brownell wrote:
> You'r sure that the m41t00 oscillator keeps going in this odd
> state you're defending against, and it wouldn't suffice to have
> the time and date registers initialized when restarting the
> oscillator?

I'm fairly certain.  I just went back and double-checked, and here is
what happened:

1) I modified rtc-ds1307.c to not do my register resets, left in the
exit-bad-on-bogus-register case, and changed the dev_dbg() call to
dev_warn() in that case so that I could see when the driver was bailing
out.

2) Powered down board, drained supercap so that Vbat is no longer
powering the M41T00.

3) Booted into Linux, and saw the following in the boot log:

     rtc-ds1307 0-0068: bogus register: 11 00 41 09 40 e1 01
     [snip]
     drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

   Already to me this shows the problem.  The driver bailed out,
   but I never see the "SET TIME!" message that would have been
   shown if the driver detected that the oscillator was not running
   and started it manually.
 
4) Just to be sure, I ran some checks once I booted up:

   # Shows that the 'seconds' register is incrementing as expected,
   # indicating that the oscillator is running.
   $ i2cget -f -y 0 0x68 0 b ; sleep 10 ; i2cget -f -y 0 0x68 0 b
   0x31
   0x41

   # Shows that a bogus value is present in the 'months' register
   $ i2cget -f -y 0 0x68 5 b
   0xe1

We use this chip on a lot of different boards here, and I've seen the
problem on multiple designs/platforms ever since we made the switch from
the old m41t00 driver to rtc-ds1307.

It could be that the boot loader is doing something to get the chip into
this state, but FWIW I've seen this happen with 2 or 3 different boot
loaders.

I'll go ahead and re-spin the patch.

-- 
Nate Case <ncase@xes-inc.com>

