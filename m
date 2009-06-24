Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbZFXARj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbZFXARj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbZFXARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:17:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56277
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbZFXARb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:17:31 -0400
Date: Tue, 23 Jun 2009 17:17:35 -0700 (PDT)
Message-Id: <20090623.171735.154729801.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090622.022752.219499742.davem@davemloft.net>
References: <20090622.002722.53993293.davem@davemloft.net>
	<87bpog3clx.fsf@basil.nowhere.org>
	<20090622.022752.219499742.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 22 Jun 2009 02:27:52 -0700 (PDT)

> I think something else is afoot, because while using "nohz=off" makes
> the problem go away, simply adding a NMI watchdog touch after the
> schedule() call in cpu_idle() does not make the problem go away.
> 
> Also, the cpu that gets the NMI watchdog is different from the cpu
> running the qla2xxx driver init.   That basically destroys the bulk
> of my theory :-)

Ok, I think I know what's happening now.

CPU 0 is in the driver init and looping submitting mailbox
commands to load the firmware, then waiting for completion.

CPU 1 is receiving the device interrupts.  CPU 1 is where the
NMI watchdog triggers.

CPU 0 is submitting mailbox commands fast enough that by the
time CPU 1 returns from the device interrupt handler, a new
one is pending.  This sequence runs for more than 5 seconds.

The problematic case is CPU 1's timer interrupt running when
the barrage of device interrupts begin.  Then we have:

	timer interrupt
	return for softirq checking
	pending, thus enable interrupts

		 qla2xxx interrupt
		 return
		 qla2xxx interrupt
		 return
		 ... 5+ seconds pass
		 final qla2xxx interrupt for fw load
		 return

	run timer softirq
	return

At some point in the multi-second qla2xxx interrupt storm we trigger
the NMI watchdog on CPU 1 from the NMI interrupt handler.

The timer softirq, once we get back to running it, is smart enough to
run the timer work enough times to make up for the missed timer
interrupts.

However, the NMI watchdogs (both x86 and sparc) use the timer
interrupt count to notice the cpu is wedged.  But in the above
scenerio we'll receive only one such timer interrupt even if we
last all the way back to running the timer softirq.

I'm not exactly sure what to do about this.
