Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXG2JPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXG2JPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760707AbXG2JPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:15:36 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39510 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbXG2JPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:15:35 -0400
Date: Sun, 29 Jul 2007 11:17:10 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070729091709.GY9840@enneenne.com>
References: <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 02:17:24AM +0530, Satyam Sharma wrote:
> 
> I only glanced through the code, so could be wrong, but I noticed that
> the only global / shared data you have in there is a global "pps_source"
> array of pps_s structs. That's accessed / modified from the various
> syscalls introduced in the API exported to userspace, as well as the
> register/unregister/pps_event API exported to in-kernel client subsystems,
> yes? So it looks like you need to introduce proper locking for it, simply
> type-qualifying it as "volatile" is not enough.
> 
> However, I think you've introduced two locks for it. The syscalls (that
> run in process context, obviously) seem to use a pps_mutex and
> pps_event() seems to be using the pps_lock spinlock (because that
> gets executed from interrupt context) -- and from the looks of it, the
> register/unregister functions are using /both/ the mutex and spinlock (!)

This is right.

> This isn't quite right, (in fact there's nothing to protect pps_event from
> racing against a syscall), so you should use *only* the spinlock for
> synchronization -- the spin_lock_irqsave/restore() variants, in fact.

We can't use the spin_lock_irqsave/restore() variants since PPS
sources cannot manage IRQ enable/disable. For instance, the serial
source doesn't manage IRQs directly but just uses it to record PPS
events. The serial driver manages the IRQ enable/disable, not the PPS
source which only uses the IRQ handler to records events.

About using both mutex and spinlock I did it since (I think) I should
protect syscalls from each others and from pps_register/unregister(),
and pps_event() against pps_register/unregister().

> [ Also, have you considered making pps_source a list and not an array?
> It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
> kind of gymnastics in there, and you _can_ return a pointer to the
> corresponding pps source struct from the register() function to the in-kernel
> users, so that way you get to retain the O(1) access to the corresponding
> source when a client calls into pps_event(), similar to how you're using the
> array index presently. ]
> 
> I also noticed code like (from pps_event):
> 
> +	/* Try to grab the lock, if not we prefere loose the event... */
> +	if (!spin_trylock(&pps_lock))
> +		return;
> 
> which looks worrisome and unnecessary. That spinlock looks to be of
> fine enough granularity to me, do you think there'd be any contention
> on it? I /think/ you can simply make that a spin_lock().

This is due the fact I cannot manage IRQ enable/disable.

> Overall the code looks simple / straightforward enough to me (except for
> the parport / uart stuff that I have no clue about), and I'll also read up on
> the relevant RFC for this and would hopefully try and give you a more
> meaningful review over the weekend.

Thanks a lot for your help!

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
