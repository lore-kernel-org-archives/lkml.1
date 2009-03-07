Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZCGQvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZCGQvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZCGQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:51:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2627 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752334AbZCGQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:51:21 -0500
Date: Sat, 7 Mar 2009 11:51:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, <Arve@smtp1.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <200903071120.53901.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0903071143340.5732-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce two helper functions allowing us to prevent device drivers
> from getting any interrupts (without disabling interrupts on the CPU)
> during suspend (or hibernation) and to make them start to receive
> interrupts again during the subsequent resume, respectively.  These
> functions make it possible to keep timer interrupts enabled while the
> "late" suspend and "early" resume callbacks provided by device
> drivers are being executed.
> 
> Use these functions to rework the handling of interrupts during
> suspend (hibernation) and resume.  Namely, interrupts will only be
> disabled on the CPU right before suspending sysdevs, while device
> drivers will be prevented from receiving interrupts, with the help of
> the new helper function, before their "late" suspend callbacks run
> (and analogously during resume).
> 
> In addition, since the device interrups are now disabled before the
> CPU has turned all interrupts off and the CPU will ACK the interrupts
> setting the IRQ_PENDING bit for them, check in sysdev_suspend() if
> any wake-up interrupts are pending and abort suspend if that's the
> case.

One thing about this isn't clear: the distinction between "wake-up" 
interrupts and other interrupts.

In an ideal world, the only pending interrupts during sysdev_suspend
would be wake-up interrupts, because drivers would have prevented their
devices from generating any other kind of IRQ and would have done all
the necessary synchronization as part of their suspend (_not_
suspend_late) methods.  Thus there would be no need to distinguish
between wake-up and non-wake-up interrupts.

So perhaps you're worried about drivers that aren't sufficiently
clever.  Or is something deeper going on?

Alan Stern

