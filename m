Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXITNn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXITNn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXITNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:43:19 -0400
Received: from www.osadl.org ([213.239.205.134]:57122 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753479AbXITNnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:43:17 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <200709201529.24081.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709200206.20992.rjw@sisk.pl> <1190269128.3235.7.camel@chaos>
	 <200709201529.24081.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 15:43:15 +0200
Message-Id: <1190295795.3481.17.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 15:29 +0200, Rafael J. Wysocki wrote:
> > > I haven't had the time to check if any special command line arguments help.
> > > Will check tomorrow.
> > 
> > Can you please disable the patches, which I sent Linus wards:
> > 
> > timekeeping-access-rtc-outside-xtime-lock.patch
> > xtime-supsend-resume-fixup.patch
> > acpi-reevaluate-c-p-t-states.patch
> > clockevents-enforce-broadcast-on-resume.patch
> > clockevents-do-not-shutdown-broadcast-device-in-oneshot-mode.patch
> > clockevents-prevent-stale-tick-update-on-offline-cpu.patch
> 
> I have skipped all of them, but the resulting kernel behaves in the same
> way (ie. doesn't boot).
> 
> > Without those patches you get the state of rc4-mm1. It would be
> > interesting to know which one interferes with the acpi stuff.
> 
> It looks like something else went in between -rc4 and -rc6 that broke your
> patch.  I wonder what it might be ...

Hmm. Can you please go back in the -hrt project history:
http://tglx.de/projects/hrtimers/2.6.23-rc5/patch-2.6.23-rc5-hrt1.patches.tar.bz2
http://tglx.de/projects/hrtimers/2.6.23-rc4/patch-2.6.23-rc4-hrt1.patches.tar.bz2

Also, can you send me your .config file please ?

Vs. the suspend / resume wreckage of rc6-mm1 / rc6-hrt2: 

I'm still fishing in rather dark water. Depending on the added
instrumentation points the problem mutates up to the point where it
vanishes completely. The hang, which requires key strokes again, happens
consistently at the same place:

The notifier call in kernel/cpu.c::_cpu_up()

       ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
                                                        -1, &nr_calls);

does not return, but _all_ registered notifiers are called and reach
their return statement. This reminds me on:

http://lkml.org/lkml/2007/5/9/46

Sigh. I have no clue where to dig further.

	tglx


