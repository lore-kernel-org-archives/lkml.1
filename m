Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYLNBiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYLNBiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYLNBiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:38:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbYLNBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:38:04 -0500
Date: Sat, 13 Dec 2008 17:37:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
cc: Matthew Wilcox <matthew@wil.cx>, Justin Chen <justin.chen@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: PCI BAR mem resource allocation "regression"
In-Reply-To: <20081214010534.GB22302@ldl.fc.hp.com>
Message-ID: <alpine.LFD.2.00.0812131708240.3340@localhost.localdomain>
References: <20081213000538.GC9947@ldl.fc.hp.com> <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain> <20081214010534.GB22302@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Dec 2008, Alex Chiang wrote:
> 
> Yeah, I knew I forgot to send the contents of /proc/iomem. I'll
> include them below.

Ok, this definitely shows that the commit in question generates a bogus 
resource tree:

> # (a) mainline /proc/iomem before hotplug
...
> e0000000-efffffff : PCI Bus 0000:50
>   e0000000-efffffff : PCI Bus 0000:4f
>     e0000000-efffffff : PCI Bus 0000:4e
>       e0000000-e7ffffff : PCI Bus 0000:52
>         e0000000-e7ffffff : PCI Bus 0000:51

This is _not_ the correct nesting. PCI bus 50 is inside 4f, which is 
inside 4e. Yet the resource tree has these reversed, and shows 4e inside 
4f inside 50 (and 51 inside 52). And yes, the reversal happens exactly 
when the size of the inner resource has the same size as the size of the 
outer one - and then the inner one has been inserted "too high" in the 
resource tree.

So this is very clearly the direct (and intended, but incorrect) result of 
that commit d33b6fba2c4350651f3f61ff2ab858a2f116e9a4. Reverting it (using 
my two-liner rather than your version, though) is almost certainly the 
right thing.

We have the exact same issue here:

> 80604000000-806ffffffff : PCI Bus 0000:4e
>   80680000000-806ffffffff : PCI Bus 0000:50
>     80680000000-806ffffffff : PCI Bus 0000:4f
>       80680000000-806bfffffff : PCI Bus 0000:52
>         80680000000-806bfffffff : PCI Bus 0000:51
>           80680000000-8069fffffff : PCI Bus 0000:53
>           806a0000000-806bfffffff : PCI Bus 0000:54

Again, the nesting is wrong, adn for the exact same reason, even if the 
pattern is slightly different (ie noe bus #4e is in the right spot in the 
hierarchy, because it has a different size).

Here's the relevant parts of the lspci that show the bus hierarchy 
(very aggressively snipped from your huge lspci output):

> 4e:00.0 PCI bridge: Hewlett-Packard Company PCIe Root Port (prog-if 00 [Normal decode])
> 	Bus: primary=4e, secondary=4f, subordinate=c1, sec-latency=0
> 
> 4f:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
> 	Bus: primary=4f, secondary=50, subordinate=c1, sec-latency=0
> 
> 50:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
> 	Bus: primary=50, secondary=51, subordinate=88, sec-latency=0
> 
> 50:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 801c (rev 04) (prog-if 00 [Normal decode])
> 	Bus: primary=50, secondary=89, subordinate=c1, sec-latency=0
> 
> 51:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
> 	Bus: primary=51, secondary=52, subordinate=54, sec-latency=0
> 
> 52:02.0 PCI bridge: Integrated Device Technology, Inc. Unknown device 8018 (rev 0e) (prog-if 00 [Normal decode])
> 	Bus: primary=52, secondary=53, subordinate=53, sec-latency=0

ie the bus number allocation really is that bus #53 is inside #52, which 
is inside #51, which is inside #50, inside #4f, inside #4e.. 

Your machine is an insane mess of PCI bridges, which is probably why you 
see this, while most other people probably never will. But I bet it 
happens on other machines, and I also bet it generally doesn't really 
result in any problems.

Because in practice, the fact that the resource tree has been nested the 
wrong way around probably almost never actually matters: especially as it 
happens only when the nesting resources are the same size, which also 
means that there can be no _other_ resources that would fit inside the 
true outer one.

So even if lots of other people see some of the same issues, it doesn't 
cause any other symptoms, and that in turn explains why we've had this 
going on for such a long time (since 2.6.16 or whatever).

> # (e) revert /proc/iomem before hotplug
...
> e0000000-efffffff : PCI Bus 0000:4e
>   e0000000-efffffff : PCI Bus 0000:4f
>     e0000000-efffffff : PCI Bus 0000:50
>       e0000000-e7ffffff : PCI Bus 0000:51
>         e0000000-e7ffffff : PCI Bus 0000:52
>           e0000000-e3ffffff : PCI Bus 0000:54
>           e0000000-e03fffff : 0000:54:00.1
>           e0400000-e07fffff : 0000:54:00.0
>           e0800000-e081ffff : 0000:54:00.1
>           e0820000-e083ffff : 0000:54:00.0
>           e4000000-e7ffffff : PCI Bus 0000:53
>           e4000000-e43fffff : 0000:53:00.1
>           e4400000-e47fffff : 0000:53:00.0
>           e4800000-e481ffff : 0000:53:00.1
>           e4820000-e483ffff : 0000:53:00.0
>       e8000000-efffffff : PCI Bus 0000:89
>         e8000000-e80fffff : 0000:89:00.0
>           e8000000-e80fffff : cciss
>         e8100000-e813ffff : 0000:89:00.0
>         e8140000-e8140fff : 0000:89:00.0
>           e8140000-e8140fff : cciss
...
> 80604000000-806ffffffff : PCI Bus 0000:4e
>   80680000000-806ffffffff : PCI Bus 0000:4f
>     80680000000-806ffffffff : PCI Bus 0000:50
>       80680000000-806bfffffff : PCI Bus 0000:51
>         80680000000-806bfffffff : PCI Bus 0000:52
>           80680000000-8069fffffff : PCI Bus 0000:53
>           806a0000000-806bfffffff : PCI Bus 0000:54
>       806c0000000-806ffffffff : PCI Bus 0000:89

And yes, now the resources nest the right way, and match the actual 
physical topology of the bus.

So yes, that commit really is causing problems. At the same time, I would 
worry about even the trivial two-liner removal before the release of 
2.6.28, because while we clearly need to do it, equally clearly this 
doesn't seem to be a _huge_ problem, and I worry that the brokenness of 
insert_resource() might have other subtler results.

So my inclination would be to prepare the appended patch for the 2.6.29 
merge window, but not commit it yet. At least as long as you can't 
actually show any real devices misbehaving (ie the resource tree is 
clearly not right, but since I suspect that everything _works_ despite 
that, this is not a high-priority issue and the unlikely but potential 
pain is thus much bigger than the negligible gain of fixing it at this 
point in the 2.6.28 release cycle).

Oh, and it would still be good to know why Matthew wanted it this way to 
begin with.

Jesse? Matthew?

			Linus

---
 kernel/resource.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..a464082 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -381,8 +381,6 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 
 		if ((first->start > new->start) || (first->end < new->end))
 			break;
-		if ((first->start == new->start) && (first->end == new->end))
-			break;
 	}
 
 	for (next = first; ; next = next->sibling) {
