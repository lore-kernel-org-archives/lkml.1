Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZCGR5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZCGR5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 12:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCGR4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 12:56:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZCGR4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 12:56:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Sat, 7 Mar 2009 18:56:35 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <Pine.LNX.4.44L0.0903071143340.5732-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0903071143340.5732-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071856.36230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 March 2009, Alan Stern wrote:
> On Sat, 7 Mar 2009, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce two helper functions allowing us to prevent device drivers
> > from getting any interrupts (without disabling interrupts on the CPU)
> > during suspend (or hibernation) and to make them start to receive
> > interrupts again during the subsequent resume, respectively.  These
> > functions make it possible to keep timer interrupts enabled while the
> > "late" suspend and "early" resume callbacks provided by device
> > drivers are being executed.
> > 
> > Use these functions to rework the handling of interrupts during
> > suspend (hibernation) and resume.  Namely, interrupts will only be
> > disabled on the CPU right before suspending sysdevs, while device
> > drivers will be prevented from receiving interrupts, with the help of
> > the new helper function, before their "late" suspend callbacks run
> > (and analogously during resume).
> > 
> > In addition, since the device interrups are now disabled before the
> > CPU has turned all interrupts off and the CPU will ACK the interrupts
> > setting the IRQ_PENDING bit for them, check in sysdev_suspend() if
> > any wake-up interrupts are pending and abort suspend if that's the
> > case.
> 
> One thing about this isn't clear: the distinction between "wake-up" 
> interrupts and other interrupts.
> 
> In an ideal world, the only pending interrupts during sysdev_suspend
> would be wake-up interrupts, because drivers would have prevented their
> devices from generating any other kind of IRQ and would have done all
> the necessary synchronization as part of their suspend (_not_
> suspend_late) methods.  Thus there would be no need to distinguish
> between wake-up and non-wake-up interrupts.
> 
> So perhaps you're worried about drivers that aren't sufficiently
> clever.  Or is something deeper going on?

Some drivers leave interrupts enabled during suspend on purpose and mark
them as "wake-up interrupts" so that the platform can abort suspend if any
of them is pending at the time the "enter suspend" hook is called (this doesn't
happen on x86 AFAICS).

However, after the $subject patch the CPU will ACK those interrupts if they
happen between suspend_device_irqs() and local_irq_disable(), so the platform
won't see them as pending.  Instead, they will have IRQ_PENDING set in
desc->status, so we check if this is the case.

Thanks,
Rafael


