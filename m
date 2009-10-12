Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZJLP1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZJLP1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZJLP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbZJLP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:27:34 -0400
Date: Mon, 12 Oct 2009 08:24:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <david.woodhouse@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
In-Reply-To: <1255342738.24732.265.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>  <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain> <1255342738.24732.265.camel@macbook.infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, David Woodhouse wrote:
> 
> Well, according to the design, the IOMMU code is doing the right thing¹.
> 
> The theory is that the BIOS _tells_

There is no "theory". There is only crap BIOSes. Stop living in a dream 
world, and stop making arguments that are only relevant in that dream 
world.

> The only viable solution (short of an open source BIOS written by sober
> people)

Again, you're living in that dream world. Wake up, sheeple.

BIOS writers write crap, because it's a crap job. It's that simple. Yes, 
they're probably drunk or drugged up, but they need it to deal with the 
hand they have been dealt.

There are absolutely _zero_ incentives to write good firmware for any 
particular device (and nothing else matters), because the projects are all 
(a) largely "throw-over-the-fence-and-forget-about-it" for any particular 
machine (ie any fixes are mostly relevant for the _next_ generation of 
machines), and (b) they have no actual user incentives or feedback, since 
nobody really "runs" the firmware anyway - it's supposed to be invisible 
by design and just sets things up.

So outside of the testing that it gets (_before_ it ever hits any users 
hands) there is never _ever_ going to be any QA.  Once it is in user 
hands, it is what it is. Almost nobody upgrades their firmware in 
practice. Yeah, geeks may do. Normal people? Not so much.

And that would _not_ change even with an open source BIOS. Why? Because 
the _code_ generally isn't the problem. The problem tends to be all the 
localization for any particular machine.

Even if the code was open source and perfect, we'd still have trouble with 
firmware - because 99% of it is driven by tables that by design have to be 
changed for each machine (yes, yes, a BIOS is easily a megabyte of 
compressed code too, but a lot of it is the nice GUI for setup etc - the 
actual code that runs on _bootup_ is rather small, and is all about those 
tables).

We might have a few _fewer_ problems if the code was perfect, and maybe 
we'd have missed this particular issue (but I doubt it, it's still a 
localized table). But it wouldn't really change any of the fundamentals in 
the issue.

BTW, in this case, it's not even necessarily the firmware people who are 
to blame. It's a combination of (a) USB is crazy polled DMA and (b) IOMMU 
is a whole new thing and (c) ACPI is too f*cking complex so nobody will 
_ever_ get it right anyway, even if the firmware people didn't have 
everything against them.

So your arguments about RMRR tables and "should do" are POINTLESS. Just 
give it up.

The sane thing to do is to have a legacy IOMMU mapping until all devices 
are initialized, so that things work _despite_ the inevitable BIOS 
crapola. End of story.

So stop blaming the BIOS. We _know_ firmware is crap - there is no point 
in blaming it. The response to "firmware bug" should be "oh, of course - 
and our code was too fragile, since it didn't take that into account".

And stop saying these problems would magically go away with open-source 
firmware. That just shows that you don't understand the realities of the 
situation. Even an open-source bios would end up having buggy tables, and 
even with an opensource bios, users generally wouldn't upgrade it.

"If wishes were horses, beggars would ride"

> was to quiesce the USB controllers before enabling the IOMMU.

The other solution would be to just _enable_ (and do all the setup) of the 
IOMMU early. And then just leave a legacy mapping for the IOMMU, and then 
_after_all_devices_are_set_up_ can you then remove the legacy mapping.

I don't much care. Just as long as the DMA works for the whole bus setup.

> The final PCI quirks are currently run from pci_init() which is a
> device_initcall(), which is too late -- in fact, it could actually be
> _after_ some of the real device drivers have taken control of the same
> hardware.

Now, this I can certainly agree 100% with. We can and should move the 
final quirks up a bit. And yes, I absolutely think we should at least 
_guarantee_ that those quirks are run before any other device_initcalls, 
regardless of any IOMMU issues (ie now it looks like it depends on link 
ordering whether a built-in driver might run before or after pci_init()).

So I agree that we may well be able to fix this by changing the ordering. 
What I disagree with is your continual "I wish things were different". 
I've seen you make that "open source firmware" argument before. It's 
pointless. Stop doing it.

But your patch looks fine.

That said, I think your choice of initcall is odd, even if it is 
understandable. Right now we have, at least on x86:

	fs_initcall(pcibios_assign_resources);

and I assume you picked fs_initcall_sync() so that it happens after that 
one. No?

Which makes sense, but at the same time, it all looks just random. And 
different architectures actually do it in different places (some seem to 
do it inside pcibios_init() at subsys_initcall time). So I'm not even sure 
fs_initcall_sync() will do it for other architectures, although it looks 
like most others do their final PCI setup _earlier_ rather than later.

I'm wondering if we should not get _rid_ of that whole pci_init() (you 
renamed it, and I agree - it's clearly not really "pci_init()"), and move 
it to just be the last thing that pci_subsys_init() does, or perhaps all 
the way into pcibios_resource_survey().

But I guess there could be random ACPI initcalls etc involved too, and 
subtle ordering constraints with _those_. And we have way too many 
arch-specific details here. So your patch may be the simplest one, but I 
wish we could also make some of this be less of a jungle of different 
initcalls.

Basically, it seems silly to have this kind of subtlety for just the final 
quirk, when the _other_ quirks are all handled by generic code in very 
well-defined places.

For example, one of the effects of this mess is that as far as I can tell, 
PCI hotplug (or cardbus, which is a special case of PCI hotplug) will 
never run the pci_fixup_late fixups at all, even though it _will_ run the 
pci_fixup_header/early/enable ones (because those are done by generic 
code: pci_setup_device(), pci_device_add() and pci_enable_device()).

			Linus
