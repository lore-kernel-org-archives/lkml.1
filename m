Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326Ab0AYNTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0AYNTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890Ab0AYNTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:19:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34376 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0AYNTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:19:20 -0500
Date: Mon, 25 Jan 2010 14:19:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100125131915.GA7801@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124100815.GA2895@liondog.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Because this is one thing that has been bugging us for a long time. We
> don't have a centralized smart utility with lots of small subcommands
> like perf or git, if you like, which can dump you the whole or parts

PC configuration is all in dmidecode, CPU/node information in lscpu
these days (part of utils-linux)

The dmidecode information could be perhaps presented nicer, but 
I don't think we need any fundamental new tools.

> 1. We need to notify userspace, as you've said earlier, and not scan
> the syslog all the time. And EDAC, although decoding the correctable

mcelog never scanned the syslog all the time. This is just
EDAC misdesign.

But yes syslog is exactly the wrong interface for these kinds of errors.

> 2. Also another very good point you had is go into maintenance mode by
> throttling or even suspend all uspace processes and start a restricted
> maintenance shell after an MCE happens. This should be done based on the

When you have a unrecoverable MCE this is not safe because you
can't write anything to disk (and usually the system is unstable
and will crash soon) because there are uncontained errors somewhere
in the hardware. The most important thing to do in this situation
is to *NOT* write anything to disk (and that is the reason
why the hardware raised the unrecoverable MCE in the first place)
Having a shell without being able to write to disk doesn't make sense.

When you have a recoverable MCE with contained errors this is not needed, 
because it, well, just recovers.

> 3. All the hw events like correctable ECCs should be thresholded so that
> all errors exceeding a preset threshold (below that is normal operation

Agreed. Corrected errors without thresholds are useless (that is one 
of the main reasons why syslog is a bad idea for them)

See also my plumbers presentation on the topic:

http://halobates.de/plumbers-error.pdf

One key part is that for most interesting reactions to thresholds
you need user space, kernel space is too limited.

My current direction was implementing this in mcelog which
maintains threshold counters and already does a couple of direct (user 
based) threshold reactions, like offlining cores and pages and reporting
short user friendly error summaries when thresholds are exceeded.

Longer term I hope to move to a more generic (user) error infrastructure
that handles more kinds of errors. This needs some infrastructure
work, but not too much.

> 
> The current decoding needs more loving too since now it says something
> like the following:

Yes, see the slide set above on thoughts how a good error looks like.

The big problem with EDAC currently is that it neither gives
the information actually needed (like mainboard labels), but gives
a lot of irrelevant low level information. And since it's kernel
based it cannot do most of the interesting reactions. And it doesn't
have a usable interface to add user events.

And yes having all that crap in syslog is completely useless, unless
you're debugging code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
