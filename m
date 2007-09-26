Return-Path: <linux-kernel-owner+w=401wt.eu-S1763203AbXIZVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203AbXIZVe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbXIZVek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:34:40 -0400
Received: from www.osadl.org ([213.239.205.134]:56257 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758818AbXIZVej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:34:39 -0400
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and
	-rc6-mm1: boot failure on HP nx6325, related to clockevents)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709262300.28336.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <1190832665.23376.38.camel@chaos> <200709262149.54732.rjw@sisk.pl>
	 <200709262300.28336.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 23:34:36 +0200
Message-Id: <1190842476.23376.57.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Wed, 2007-09-26 at 23:00 +0200, Rafael J. Wysocki wrote:
> > > > First, with the "x86-64: Disable local APIC timer use on AMD systems with C1E"
> > > > patch and my collection of suspend patches applied, the box doesn't boot
> > > > (the suspend patches don't even thouch the boot code, so they should be
> > > > irrelevant here).  However, it boots if patch-2.6.23-rc7-hrt1.patch (adjusted
> > > > for 2.6.23-rc8) is applied in addition.  Is this expected?
> > > 
> > > No. That's odd. It is nothing else than adding "noapictimer" to the
> > > kernel command line.
> > 
> > Seems to be reproducible, though.  I'll investigate further.
> 
> So far, the results are the following:
> 
> 1) current Linus' tree doesn't boot with any command line (regression)
> 
> [  Linus, please revert commit e66485d747505e9d960b864fc6c37f8b2afafaf0
> 
>    x86-64: Disable local APIC timer use on AMD systems with C1E
> 
>    It's not necessary for 2.6.23 and actually kills the box that it's supposed to fix. ]
> 
> 2) 2.6.23-rc8 w/ the "x86-64: Disable local APIC timer use on AMD systems with C1E"
>    patch applied behaves like the current -git
> 
> 3) 2.6.23-rc8 w/o this patch doesn't boot with either "noapictimer" _or_

OK, this explains 2) and 3). I just looked into the code and the logic
vs. noapictimer on SMP is completely broken.

On i386 the noapictimer option not only disables the local APIC timer,
it also registers the CPUs for broadcasting via IPI on SMP systems. 

The x8664 code uses the broadcast only when the local apic timer is
active, i.e. "noapictimer" is not on the command line. This defeats the
whole purpose of "noapictimer". It should be there to make boxen work,
where the local APIC timer actually has a hardware problem, e.g. the
nx6325.

The current implementation of x86_64 only fixes the ACPI c-states
related problem where the APIC timer stops in C3(2), nothing else.

On nx6325 and other AMD X2 equipped systems which have the C1E enabled
we run into the following:

PIT keeps jiffies (and the system) running, but the local APIC timer
interrupts can get out of sync due to this C1E effect. 

I don't think this is a critical problem, but it is wrong nevertheless.

I think it's safe to revert the C1E patch and postpone the fix to the
clock events conversion.

>   "apicmaintimer"

on your box is not going to work. See the C1E patch. "apicmaintimer"
switches off PIT and then waits for ever for the local APIC timer
interrupts.

> 4) 2.6.22 behaves like 2.6.23-rc8

No surprise

> 5) 2.6.23-rc8 with (adjusted) patch-2.6.23-rc7-hrt1.patch boots only with
>    "noapictimer"
> 
> 6) 2.6.23-rc8 with (adjusted) patch-2.6.23-rc7-hrt1.patch and with the
>    "x86-64: Disable local APIC timer use on AMD systems with C1E" patch boots
>    without any extra command line options

That's consistent behaviour.

> Tested for a couple of times with each kernel, the results seem to be
> reproducible 100% of the time.

Thanks for going through this debug marathon.

	tglx


