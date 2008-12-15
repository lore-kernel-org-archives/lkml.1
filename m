Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYLOUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYLOUEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYLOUEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:04:24 -0500
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:57727 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756642AbYLOUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:04:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=XHJjGeJLrSIPo+z31y8LKe0XMvdfnN1xpr6TBEYIZtSmqIL1wQ/Rvz8L4pmaRNsHoyrhSvZxoqk6LpqsAvK9/Eqa7HM//AL+znLauhDtMHkH4ZxPFICWur6F5szpoWeF;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI BAR mem resource allocation "regression"
Date: Mon, 15 Dec 2008 12:04:20 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Justin Chen <justin.chen@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081213000538.GC9947@ldl.fc.hp.com> <20081214010534.GB22302@ldl.fc.hp.com> <alpine.LFD.2.00.0812131708240.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812131708240.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151204.21089.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 13, 2008 5:37 pm Linus Torvalds wrote:
> On Sat, 13 Dec 2008, Alex Chiang wrote:
> > Yeah, I knew I forgot to send the contents of /proc/iomem. I'll
> > include them below.
>
> Ok, this definitely shows that the commit in question generates a bogus
>
> resource tree:
> > # (a) mainline /proc/iomem before hotplug
>
> ...
>
> > e0000000-efffffff : PCI Bus 0000:50
> >   e0000000-efffffff : PCI Bus 0000:4f
> >     e0000000-efffffff : PCI Bus 0000:4e
> >       e0000000-e7ffffff : PCI Bus 0000:52
> >         e0000000-e7ffffff : PCI Bus 0000:51
>
> This is _not_ the correct nesting. PCI bus 50 is inside 4f, which is
> inside 4e. Yet the resource tree has these reversed, and shows 4e inside
> 4f inside 50 (and 51 inside 52). And yes, the reversal happens exactly
> when the size of the inner resource has the same size as the size of the
> outer one - and then the inner one has been inserted "too high" in the
> resource tree.
>
> So this is very clearly the direct (and intended, but incorrect) result of
> that commit d33b6fba2c4350651f3f61ff2ab858a2f116e9a4. Reverting it (using
> my two-liner rather than your version, though) is almost certainly the
> right thing.
>
> We have the exact same issue here:
> > 80604000000-806ffffffff : PCI Bus 0000:4e
> >   80680000000-806ffffffff : PCI Bus 0000:50
> >     80680000000-806ffffffff : PCI Bus 0000:4f
> >       80680000000-806bfffffff : PCI Bus 0000:52
> >         80680000000-806bfffffff : PCI Bus 0000:51
> >           80680000000-8069fffffff : PCI Bus 0000:53
> >           806a0000000-806bfffffff : PCI Bus 0000:54
>
> Again, the nesting is wrong, adn for the exact same reason, even if the
> pattern is slightly different (ie noe bus #4e is in the right spot in the
> hierarchy, because it has a different size).
>
> Here's the relevant parts of the lspci that show the bus hierarchy
>
> (very aggressively snipped from your huge lspci output):
> > 4e:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00
> > [Normal decode]) Bus: primary=4e, secondary=4f, subordinate=c1,
> > sec-latency=0
> >
> > 4f:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
> > 801c (rev 04) (prog-if 00 [Normal decode]) Bus: primary=4f, secondary=50,
> > subordinate=c1, sec-latency=0
> >
> > 50:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
> > 801c (rev 04) (prog-if 00 [Normal decode]) Bus: primary=50, secondary=51,
> > subordinate=88, sec-latency=0
> >
> > 50:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
> > 801c (rev 04) (prog-if 00 [Normal decode]) Bus: primary=50, secondary=89,
> > subordinate=c1, sec-latency=0
> >
> > 51:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
> > 8018 (rev 0e) (prog-if 00 [Normal decode]) Bus: primary=51, secondary=52,
> > subordinate=54, sec-latency=0
> >
> > 52:02.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
> > 8018 (rev 0e) (prog-if 00 [Normal decode]) Bus: primary=52, secondary=53,
> > subordinate=53, sec-latency=0
>
> ie the bus number allocation really is that bus #53 is inside #52, which
> is inside #51, which is inside #50, inside #4f, inside #4e..
>
> Your machine is an insane mess of PCI bridges, which is probably why you
> see this, while most other people probably never will. But I bet it
> happens on other machines, and I also bet it generally doesn't really
> result in any problems.
>
> Because in practice, the fact that the resource tree has been nested the
> wrong way around probably almost never actually matters: especially as it
> happens only when the nesting resources are the same size, which also
> means that there can be no _other_ resources that would fit inside the
> true outer one.
>
> So even if lots of other people see some of the same issues, it doesn't
> cause any other symptoms, and that in turn explains why we've had this
> going on for such a long time (since 2.6.16 or whatever).
>
> > # (e) revert /proc/iomem before hotplug
>
> ...
>
> > e0000000-efffffff : PCI Bus 0000:4e
> >   e0000000-efffffff : PCI Bus 0000:4f
> >     e0000000-efffffff : PCI Bus 0000:50
> >       e0000000-e7ffffff : PCI Bus 0000:51
> >         e0000000-e7ffffff : PCI Bus 0000:52
> >           e0000000-e3ffffff : PCI Bus 0000:54
> >           e0000000-e03fffff : 0000:54:00.1
> >           e0400000-e07fffff : 0000:54:00.0
> >           e0800000-e081ffff : 0000:54:00.1
> >           e0820000-e083ffff : 0000:54:00.0
> >           e4000000-e7ffffff : PCI Bus 0000:53
> >           e4000000-e43fffff : 0000:53:00.1
> >           e4400000-e47fffff : 0000:53:00.0
> >           e4800000-e481ffff : 0000:53:00.1
> >           e4820000-e483ffff : 0000:53:00.0
> >       e8000000-efffffff : PCI Bus 0000:89
> >         e8000000-e80fffff : 0000:89:00.0
> >           e8000000-e80fffff : cciss
> >         e8100000-e813ffff : 0000:89:00.0
> >         e8140000-e8140fff : 0000:89:00.0
> >           e8140000-e8140fff : cciss
>
> ...
>
> > 80604000000-806ffffffff : PCI Bus 0000:4e
> >   80680000000-806ffffffff : PCI Bus 0000:4f
> >     80680000000-806ffffffff : PCI Bus 0000:50
> >       80680000000-806bfffffff : PCI Bus 0000:51
> >         80680000000-806bfffffff : PCI Bus 0000:52
> >           80680000000-8069fffffff : PCI Bus 0000:53
> >           806a0000000-806bfffffff : PCI Bus 0000:54
> >       806c0000000-806ffffffff : PCI Bus 0000:89
>
> And yes, now the resources nest the right way, and match the actual
> physical topology of the bus.
>
> So yes, that commit really is causing problems. At the same time, I would
> worry about even the trivial two-liner removal before the release of
> 2.6.28, because while we clearly need to do it, equally clearly this
> doesn't seem to be a _huge_ problem, and I worry that the brokenness of
> insert_resource() might have other subtler results.
>
> So my inclination would be to prepare the appended patch for the 2.6.29
> merge window, but not commit it yet. At least as long as you can't
> actually show any real devices misbehaving (ie the resource tree is
> clearly not right, but since I suspect that everything _works_ despite
> that, this is not a high-priority issue and the unlikely but potential
> pain is thus much bigger than the negligible gain of fixing it at this
> point in the 2.6.28 release cycle).
>
> Oh, and it would still be good to know why Matthew wanted it this way to
> begin with.
>
> Jesse? Matthew?

I'm not sure what motivated this change, it was pushed back in June of '06.  
/me digs through mailing list archives  Hm can't seem to find anything useful.  
Hopefully Matthew's memory will be more helpful.

I can put your patch in my -next branch if you think it would help (not that -
next gets a ton of testing, but hey)...

-- 
Jesse Barnes, Intel Open Source Technology Center

