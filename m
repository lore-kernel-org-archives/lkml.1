Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZLFAsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZLFAsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZLFAs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:48:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbZLFAs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:48:27 -0500
Date: Sat, 5 Dec 2009 16:48:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912060055.36130.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl> <alpine.LFD.2.00.0912051334461.3649@localhost.localdomain> <alpine.LFD.2.00.0912051349000.3649@localhost.localdomain> <200912060055.36130.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> 
> The approach you're suggesting would require modifying individual drivers which
> I just wanted to avoid.

In the init path, we had the reverse worry - not wanting to make 
everything (where "everything" can be some subsystem like just the set of 
PCI drivers, of course - not really "everything" in an absolute sense) 
async, and then having to try to work out with the random driver that 
couldn't handle it.

And there were _lots_ of drivers that couldn't handle it, because they 
knew they got woken up serially. The ATA layer needed to know about 
asynchronous things, because sometimes those independent devices aren't so 
independent at all. Which is why I don't think your approach is safe.

Just to take an example of the whole "independent devices are not 
necessarily independent" thing - things like multi-port PCMCIA controllers 
generally show up as multiple PCI devices. But they are _not_ independent, 
and they actually share some registers. Resuming them asynchronously might 
well be ok, but maybe it's not. Who knows?

In contrast, a device driver can generally know that certain _parts_ of 
the initialization is safe. As an example of that, I think the libata 
layer does all the port enumeration synchronously, but then once the ports 
have been identified, it does the rest async. 

That's the kind of decision we can sanely make when we do the async part 
as a "drivers may choose to do certain parts asynchronously". Doing it at 
a higher level sounds like a problem to me.

> If you don't like that, we'll have to take the longer route, although 
> I'm afraid that will take lots of time and we won't be able to exploit 
> the entire possible parallelism this way.

Sure. But I'd rather do the safe thing. Especially since there are likely 
just a few cases that really take a long time.

> During suspend we actually know what the dependences between the devicces
> are and we can use that information to do more things in parallel.  For
> instance, in the majority of cases (I'm yet to find a counter example), the
> entire suspend callbacks of "leaf" PCI devices may be run in parallel with each
> other.

See above. That's simply not at all guaranteed to be true. 

And when it isn't true (ie different PCI leaf devices end up having subtle 
dependencies), now you need to start doing hacky things. 

I'd much rather have the individual drivers say "I can do this part in 
parallel", and not force it on them. Because it is definitely _not_ 
guaranteed that PCI devices can do parallel resume and suspend.

> Yes, we can do that, but I'm afraid that the majority of drivers won't use the
> new hooks (people generally seem to be to reluctant to modify their
> suspend/resume callbacks not to break things).

See above - I don't think this is a "majority" issue. I think it's a 
"let's figure out the problem spots, and fix _those_". IOW, get 2% of the 
coverage, and get 95% of the advantage.

> Disk spinup/spindown takes time, but also some ACPI devices resume slowly,

We actually saw that when we did async init. And it was horrible. There's 
nothing that says that the ACPI stuff necessarily even _can_ run in 
parallel. 

I think we currently only do the ACPI battery ops asynchronously.

				Linus
