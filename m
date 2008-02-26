Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYBZCJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYBZCJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYBZCJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:09:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:31350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYBZCJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=Pq4Ubv/9BTFoqRU4/fsmLuCeI+yJoHM6bm/Rq9pGI40SXpJYRnWTRsqiqX/V7exp9ARJDs1ygbwyucRDOSDtPGAhrsC0F1M0dX6ZceQHSuKsdVBu1mbugtYeS78zdshEe0GqoJ49QkQieyPzbbmA6eUj4YdfA4lB/0Mis4xF47k=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Date: Tue, 26 Feb 2008 03:09:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Rafael Wysocki <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>
References: <200802231341.02597.fzu@wemgehoertderstaat.de> <200802241638.15902.fzu@wemgehoertderstaat.de> <20080224182800.GA10194@linux.vnet.ibm.com>
In-Reply-To: <20080224182800.GA10194@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802260309.36360.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 24. Februar 2008 schrieb Paul E. McKenney:
> On Sun, Feb 24, 2008 at 04:38:15PM +0100, Karsten Wiese wrote:
> > Am Samstag, 23. Februar 2008 schrieb Karsten Wiese:
> > > Am Samstag, 23. Februar 2008 schrieb Paul E. McKenney:
> > > > On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> > > > > Hi,
> > > > > 
> > > > > This appeared in dmesg after
> > > > > 	$ echo core > /sys/power/pm_test
> > > > > followed by 3 cycles of
> > > > > 	$ echo mem > /sys/power/state
> > > > > . .config attached.
> > > > > 
> > > > > dmesg excerpt (, full ~1MByte available):
> > > > 
> > > > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> > > 
> > > Yes. This tree was linus' git head as of yesterday or the day before.
> > 
> > Updated to git-head of today, same test and .config, different symptoms
> > like in this thread: http://lkml.org/lkml/2008/2/23/260
> > Later in this thread, Alan Cox said it looked like irq problems.
> > Maybe also the rcupreemt related WARN_ON I saw are caused by irq problems.
> 
> Might be, but am taking a closer look at the interaction between irq,
> dynticks, and rcupreempt in any case.

[Added Rafael, Thomas and Steven to CC]

The "different symptoms" above are indeed unrelated and solved by reverting
	"commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
    	 power_state: get rid of write-only variable in SATA"

The cpu_hotplug code used by suspend together with hr_timer and nohz looks
suspicious:
	$ echo 0 > /sys/devices/system/cpu/cpu1/online
	$ echo 1 > /sys/devices/system/cpu/cpu1/online
	(repeat until dmesg|tail shows WARNs; here it took 2 iterations)
causes symptoms like in 1st message of this thread again.

Thanks,
      Karsten
