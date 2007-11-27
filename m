Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbXK0XcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbXK0XcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXK0XcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:32:04 -0500
Received: from gw.goop.org ([64.81.55.164]:49832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbXK0XcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:32:02 -0500
Message-ID: <474CA8F2.2030809@goop.org>
Date: Tue, 27 Nov 2007 15:32:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <200711280002.00755.rjw@sisk.pl> <474C9EEE.4090904@goop.org> <DA9C1E3E-E7BD-4AC3-AD44-416FBD3871AF@mac.com>
In-Reply-To: <DA9C1E3E-E7BD-4AC3-AD44-416FBD3871AF@mac.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Nov 27, 2007, at 17:49:18, Jeremy Fitzhardinge wrote:
>> Rafael J. Wysocki wrote:
>>> Well, this is more-or-less how we all imagine that should be done
>>> eventually.
>>>
>>> The main problem is how to implement it without causing too much
>>> breakage.  Also, there are some dirty details that need to be taken
>>> into consideration.
>>
>> For Xen suspend/resume, I'd like to use the freezer to get all
>> threads into a known consistent state (where, specifically, they
>> don't have any outstanding pagetable updates pending).  In other
>> words, the freezer as it currently stands is what I want, modulo some
>> of these issues where it gets caught up unexpectedly.  If threads end
>> up getting frozen anywhere preempt isn't explicitly disabled, it
>> wouldn't work for me.
>
> The problem with "one freezer" is that "known consistent state" means
> something completely different to every single driver and subsystem.

Not really.  The freezer puts tasks into a particular well-understood
state: they're either in usermode, or in the kernel in the
refrigerator.  And since the places which call into the refrigerator are
explicit in the source, and not terribly numerous, its easy to audit
exactly what the state is at each call.

> Xen wants it to mean "No pending page table updates and no more
> updates from this point forward".  A network driver wants it to mean
> "All pending network packets DMAed out or in and the device shut down
> with all remaining packets queued.  A SATA controller wants it to mean
> "All DMA quiesced and no more commands", etc.

Well, those are somewhat different.  The existing suspend/resume driver
callbacks are sufficient for a device to be in that state.  What I want
for Xen is more global: I just want to make sure tasks are not preempted
in the middle of a state which can't be suspended.  The specific details
of the state I want are moderately complex, but short lived.  The
problem with other mechanisms - like stop_machine - is that they can
leave threads preempted in one of the states I can't handle, whereas the
the freezer is more deterministic.

> The only way to have that work is to put minimal definitions of what
> state you care about in the drivers themselves.  For Xen this means
> that you need to have an appropriately-timed suspend handler which
> hooks into Xen code very precisely to create and preserve the "No
> pending page table updates" state that you care about.  It will be
> more work in the short term but it's the only maintainable solution in
> the long term IMO.

No, that doesn't really work.  Aside from scattering hooks everywhere
there's pagetable updates, there's no real existing place to hook into. 
While I could put those hooks in, they would amount to changing the
kernel-internal pagetable update interface for everyone to deal with a
corner case of a fairly obscure user - I don't think its a good tradeoff.

The freezer is nice because the state it puts each task into is
well-defined, and is well-suited for Xen's use.  In fact, I would agree
with you that the use I want to put the freezer to better suits it than
its current use in suspend/resume.

    J
