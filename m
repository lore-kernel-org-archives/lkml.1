Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXL3VPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXL3VPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXL3VPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:15:33 -0500
Received: from [194.117.236.238] ([194.117.236.238]:57211 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXL3VPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:15:32 -0500
Date: Sun, 30 Dec 2007 23:12:08 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andi Kleen <andi@firstfloor.org>
Cc: pharon@gmail.com, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071230231208.0c766258@linux360.ro>
In-Reply-To: <p73ejd41bxy.fsf@bingen.suse.de>
References: <47765D11.2040903@reed.com>
	<1198967334.5049.3.camel@iamer-laptop>
	<4776F6A0.9010801@keyaccess.nl>
	<1198979361.11150.2.camel@iamer-laptop>
	<20071230121725.11d05099@linux360.ro>
	<p73ejd41bxy.fsf@bingen.suse.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 15:42:17 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:
> >
> > Other kernel developers, as discussed previously in this thread, are
> > working on a HPET-driven dynticks (as opposed to the current
> > LAPIC-driven one), but the change isn't that easy to make.
> 
> No, actually HPET based dyntick has been implemented for a long time
> (as long as APIC based dyntick). APIC based dyntick is preferred 
> because it is a little cheaper, but both are there.
> 
> The problem is just that many BIOSes don't tell the kernel about the
> HPET location (even when the chipset supports it) because that wasn't
> needed for older Windows versions.  And without the BIOS telling the
> kernel HPET it doesn't know where it is and can't use it when
> the APIC timer is not usable.
> 
> The ongoing work is to implement hpet=force code that knows
> about various chipsets and reads their hardware registers directly
> and then uses the HPET timer without BIOS support.

As far as I can see, the kernel doesn't behave as it would be, IMO,
normal. I do have HPETs and Linux detects them without any
need for hpet=force (HPET is registered for clockevents), but keeps
LAPIC as the only option for dynticks. It looks like timing devices are
rated and then only one of them is selected for dynticks. But when that
one (here LAPIC) fails to provide the required functionality for nohz,
Linux does not fallback to the next best timer, as dynticks is provided
with only one such device, hence the message "lapic is not functional"
is shown. In fact, this selection process should be fixed.

Before coding my patch, I tried fiddling with that rating algorithm,
but Linux kept locking up during boot. I'll try again, maybe my
approach wasn't correct, but please tell me: is HPET-driven dynticks
code working? (I'm quite confused, as HPET should wake the CPUs even
when in C1E.)

> > This way,
> > dynticks and C1E could be both enabled and thus save more power.
> 
> I would not expect too much over a HZ=100 kernel on current AMD. 

With my patch (the one that disables C1E), powertop shows at most 10-11
wakeups per second when idle (no X server running). Isn't it
reasonable to expect a significant improvement over HZ=100?

