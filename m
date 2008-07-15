Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYGOR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYGOR5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYGOR5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:57:42 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12986 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYGOR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:57:41 -0400
Date: Tue, 15 Jul 2008 11:57:40 -0600
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
Message-ID: <20080715175740.GB10919@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023349.2528.9423.stgit@blender.achiang> <20080715031512.GF14894@parisc-linux.org> <87wsjnxy4w.fsf@basil.nowhere.org> <20080715102130.GA22866@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715102130.GA22866@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk+lkml@arm.linux.org.uk>:
> On Tue, Jul 15, 2008 at 12:03:27PM +0200, Andi Kleen wrote:
> > Matthew Wilcox <matthew@wil.cx> writes:
> > >
> > > I don't understand why we want to know about these CPUs.
> > > Surely they should be 'possible', but not 'present'?  What
> > > useful thing can Linux do with them?
> > 
> > He explained it in the intro, near the end (I nearly
> > complained about this too when I hadn't finished reading it
> > completely :):
> > 
> > |The big picture implication is that we can allow userspace
> > |to interact with disabled CPUs. In this particular example,
> > |we provide a knob that lets a sysadmin schedule any present
> > |CPU for firmware deconfiguration or enablement.
> > 
> > The reason sounds pretty exotic, but ok.
> 
> I don't see why this needs to be cross architecture then -
> shouldn't the generic kernel only be concerning itself with
> things that are possible, present and/or online?

I suppose that's a fair statement. Touching all the archs for
something 'exotic' like this does seem to be a bit of an
overkill.

My thought was that big SMP systems like ia64, possibly sparc and
ppc, and increasingly, x86, might find something like this
useful, as systems get larger and larger, and vendors are going
to want to do RAS-ish features, like the ability to keep CPUs in
firmware across reboots until told otherwise by the sysadmin.

Right now, a 'present' CPU strongly implies 'online' as well,
since we're calling cpu_up() for all 'present' CPUs in
smp_init(). But this hurts if:

	- you don't actually want to bring up all 'present' CPUs
	- you still want to interact with these weirdo zombie
	  CPUs that are 'present' but not 'online'

That second item refers to creating a sysfs interface for each
'present' CPU in topology_init().

This feature puts a tax on smaller archs like arm, but maybe I
could be smarter about it by using a 

#define cpu_enabled_mask cpu_online_mask

Hrm?

> If you have an interface which allows you to change the
> machines configuration in a machine specific way, shouldn't
> that be something for that machine to support and forced upon
> the entire kernel?

I think that the generic kernel would be the appropriate place to
create a place for these zombie CPUs, and give the vendor specific
stuff a way to hook in.

I'd be interested in learning if any of the other 'big' archs
would have a use for something like this.

Thanks.

/ac

