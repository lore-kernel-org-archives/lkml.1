Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbXCEODa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbXCEODa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXCEODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:03:30 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:38118 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXCEOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:03:29 -0500
Date: Mon, 5 Mar 2007 23:00:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>, "Wu, Bryan" <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Message-ID: <20070305140048.GA14149@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <45EC0DC7.8080504@t-online.de> <20070305123910.GA13684@linux-sh.org> <200703050826.56966.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703050826.56966.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 08:26:56AM -0500, Robin Getz wrote:
> On Mon 5 Mar 2007 07:39, Paul Mundt pondered:
> > On Mon, Mar 05, 2007 at 01:32:07PM +0100, Bernd Schmidt wrote:
> >  > This is done intentionally, because it's also possible for user code to
> >  > be loaded into L1 memory.?? We want to give users the option to avoid
> >  > filling it all up with kernel code.
> >
> >  So then why not make the userspace component of it optional and allow a
> > size cap for kernel usage that's configurable if it's enabled? This degree
> > of abstraction is almost worse than no abstraction.
> 
> I don't understand why you think lots of options are a bad thing??
> 
> For most embedded targets, people want/need easy knobs to turn to try and 
> optimise the system level performance. I would guess that SH users want to do 
> the same thing?
> 
> That is what this does - it is just a easy to use knob.
> 
This is hardly a knob, you're adding one config option per function to
relocate in to the L1 memory, leaving it up to the user to decide what's
best positioned there from the kernel point of view and what's left with
userspace to play with. This is simply _not_ how you want to do this sort
of interface, rather than making any sort of usability decisions, you've
pushed it all on the user under the label of flexibility.

What happens now if you suddenly start having other blocks of SRAM in
future parts that are either shared across CPUs or just more buffer space
for a single CPU? Do you start to repeat the config options for that
space, too?

There are things that will be a win to have located in on-chip SRAM, and
others that will be less important. If you're concerned about this, you
should simply pinpoint the hot paths that benefit the most from being
relocated and weight that against a build-time configuration of how much
room the user wants to play with. This way you can figure out all of your
limits directly at link time, as you're arguably looking at an
effectively static configuration anyways.

If you really want to break it down on priority, use something similar to
initcall levels. Start with the most critical bits, and stash as much as
possible in whatever on-chip memory you have available (while heeding the
user constraints) and then spill the rest to system memory.

Throwing this all at the user simply shows that the functions being
relocated haven't been profiled adequately with real workloads. You can't
seriously expect your users to define what's the most timing critical and
hope to get useful result.

These are simply not things the user should ever _care_ about. If a user
wants to use on-chip memory, presumably they have a target application in
mind, and they know how much space they need. Beyond that, they expect
the kernel to do the best it can with the space that's left over for it
to play with. If a user has to sit around profiling their workload to
figure out what config options to set to chew through the rest of the L1
memory, you've completely lost at intuitive design.

This is like taking the KDE approach to UI design and applying it to the
kernel, exposing every possible setting as a user-settable option and
avoiding setting any sort of sane default in the hope that user knows
best. This simply doesn't work.
