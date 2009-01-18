Return-Path: <linux-kernel-owner+w=401wt.eu-S934797AbZARSSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797AbZARSSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbZARSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:17:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934157AbZARSR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:17:57 -0500
Date: Sun, 18 Jan 2009 19:17:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian Gerst <brgerst@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86/Voyager
Message-ID: <20090118181748.GA24570@elte.hu>
References: <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <4972B8AB.8040001@kernel.org> <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com> <4972C53C.5050509@kernel.org> <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com> <20090118071427.GA29613@elte.hu> <1232296885.3247.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232296885.3247.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2009-01-18 at 08:14 +0100, Ingo Molnar wrote:
> > * Brian Gerst <brgerst@gmail.com> wrote:
> > 
> > > On Sun, Jan 18, 2009 at 12:59 AM, Tejun Heo <tj@kernel.org> wrote:
> > > > Brian Gerst wrote:
> > > >> On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
> > > >>> Hello,
> > > >>>
> > > >>>> --- a/arch/x86/kernel/setup_percpu.c
> > > >>>> +++ b/arch/x86/kernel/setup_percpu.c
> > > >>>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
> > > >>>>  #endif
> > > >>>>  EXPORT_SYMBOL(__per_cpu_offset);
> > > >>>>
> > > >>>> +DEFINE_PER_CPU(int, cpu_number);
> > > >>>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
> > > >>> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
> > > >>> be unhappy with this change.
> > > >>
> > > >> Is there any specific reason Voyager doesn't use the x86
> > > >> setup_per_cpu_areas() function?  I don't see anything on a quick
> > > >> glance that would not work.  The x86 code is pretty much a superset of
> > > >> the default code in init/main.c.
> > > >
> > > > I have no idea at all.  Given that not many people can test it, I
> > > > figured just leaving it alone would be the best course but if it can
> > > > be merged, all the better.
> > > 
> > > Unfortunately Voyager doesn't compile currently for unrelated reasons.
> > >  I'll take a look at incorporating it into these patches, but I can't 
> > > even do a compile test right now.
> 
> What are "unrelated reasons"?, 2.6.28 compiles and boots for me, except
> some of the compile fixes (which are regressions, by the way) aren't
> included in spite of being sent several times.
>
> I've put them up here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/voyager-2.6.git

These are not complete as you did not implement the cleanups that we 
suggested - and hence they are not acceptable (i.e. consider this a NAK). 
They just prolongue the pain of subarchitectures.

Your previous round of fixes were problematic: i remember them breaking 
the normal x86 build at least twice - showing the collateral cost of 
subarchitectures. If we had the x86/Voyager complications isolated in a 
single arch/x86/kernel/voyager_quicks.c module, via a qx86_quirks and 
similar mechanisms the end result would be far more maintainable.

> I haven't included the cpumask fixes (so it won't compile on 2.6.29-rc2 
> yet) because I'll have to try to polish them to fit in with whatever's 
> going on.  Plus there's some type of initramfs boot failure that I need 
> to investigate.  However, usually I wait until the x86 churn is 
> finished, which is a lot later into the -rc cycle than this before 
> fixing up all the breakage.
> 
> > Peter/James, what's the current status of x86/Voyager cleanups?
> 
> The only outstanding problem I can see in 2.6.29 is a cpumask screw up 
> caused by Mike Travis ... it looks easily fixable, he just forgot to 
> convert voyager.
> 
> I have to say that putting the SMP CPU definitions in cpu/common.c 
> hedged around with ifdefs for type looks really to be the wrong thing to 
> do.  We already have compile selected files with these types, the 
> definition should be in there.
> 
> > A couple of months ago i made a few suggestions about how to convert 
> > Voyager to the cleaner x86_quirks 'quirks HAL' (from the current 
> > fragile and hard and expensive to maintain 'compile time HAL'), but it 
> > didnt seem to go anywhere. See the discussion of this timeframe:
> > 
> >     http://lkml.org/lkml/2008/11/3/53
> > 
> > The VisWS subarch (which was a similarly excentric design that was 
> > only a PC in terms of having Intel CPUs) has been converted to 
> > CONFIG_X86_VISWS already, with arch/x86/kernel/visws_quirks.c holding 
> > the optional quirk handlers.
> > 
> > The desired end result would be to have a CONFIG_X86_VOYAGER=y build 
> > mode that adds the quirk handlers to an otherwise generic kernel, with 
> > most of the quirks concentrated into a single 
> > arch/x86/kernel/voyager_quirks.c file - instead of having a full 
> > subarch for x86/Voyager. Both arch/x86/mach-voyager/ and 
> > arch/x86/include/asm/mach-voyager/ would go away in the end - because 
> > all functionality is merged into the generic code and the quirks would 
> > be in voyager_quirks.c.
> 
> You appear to have forgotten that we already had this discussion here:
> 
> http://marc.info/?t=122539020300002

Why would i have forgotten that? We asked you to do those cleanups and 
offered help. AFAICS you have not submitted patches to that effect and you 
did not address the review feedback we gave you on your patches. If you 
have sent patches that implement my x86_quirks suggestions then please 
show me the URIs.

> But to precis, the bottom line is that I'm concerned about the damage to 
> mainline x86 this would cause because voyager is a vastly different 
> beast.  We'd be doubling at least the number of function pointer 
> indirections, plus the current quirk stuff is inadequate: voyager needs 
> boot time separation to handle the unique SUS maps and other things, so 
> there'd be a big intrusion into the boot system as well.
> 
> > I'd be glad to lend a helping hand both with the patches and with testing 
> > on non-Voyager - especially the SMP bits probably need extensions on the 
> > x86_quirks side. (And i'm sure the other x86 maintainers would we glad to 
> > help out with this process too.)
> > 
> > x86/Voyager is the last holdout in this area, and with an active kernel 
> > developer like James behind it it ought to be fixable - should James have 
> > the time/interest.
> 
> But no-one's yet made any argument for why it's a worthwhile thing to be 
> doing.

Because the sub-arch code is butt-ugly.

x86 subarchitectures are a hack that should never have gone upstream - and 
we are now reversing that braindamage, step by step. Subarchitectures are 
a compile-time "HAL", but a highly non-transparent one at that. They 
complicates the x86 architecture in a couple of key structures and very 
fundamentally so - and that results in continued complications in critical 
areas of the x86 code.

One example where this shows up in full force in the Kconfig space. For 
example in arch/x86/Kconfig we have _more than 20_ VOYAGER quirks:

	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
	select HAVE_ARCH_KGDB if !X86_VOYAGER
	def_bool X86_64_SMP || (X86_SMP && !X86_VOYAGER)
	depends on !SMP || !X86_VOYAGER
	depends on !X86_VOYAGER
	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
	depends on (X86_32 && !X86_VOYAGER) || X86_64
	depends on !X86_VOYAGER
	depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
	depends on X86_VOYAGER
	depends on X86_MPPARSE || X86_VOYAGER
	depends on X86_32 && PCI && !X86_VOYAGER && X86_MPPARSE && PCI_GODIRECT
	depends on !X86_VOYAGER
	depends on !X86_VOYAGER
	depends on !X86_VOYAGER
	depends on !X86_VOYAGER
	depends on X86_32 && !SMP && !(X86_VOYAGER || X86_GENERICARCH)
	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
	depends on !X86_VOYAGER
	depends on SMP && HOTPLUG && !X86_VOYAGER
	depends on !X86_VOYAGER
	depends on !X86_VOYAGER
	bool "MCA support" if !X86_VOYAGER
	default y if X86_VOYAGER
	depends on !X86_VOYAGER

The VISWS code was in a similar situation not so long ago. It was a quirky 
subarchitecture similar to Voyager: it had no standard PC compatibility at 
all, other than the use of Intel CPUs.

VISWS had about 20 quirks in arch/x86/Kconfig that needlessly complicated 
the picture there. It caused a number of build breakages and complicated 
development for many cycles.

After we merged the VISWS subarch into the generic code its quirk count in 
arch/x86/Kconfig went down to _one_ only. The whole VISWS impact has 
dwindled down to almost zero. The difference is significant, and we'd like 
to see the same kind of cleanup happen with x86/Voyager too.

There's countless of other areas where the elimination of subarchitectures 
simplifies the code and shrinks x86 maintenance costs.

> > If there's no time/interest in that then we can temporarily mark 
> > Voyager CONFIG_BROKEN until cleanup/fix patches arrive.
> 
> It's not broken and I've already sent you the cleanup/fix patches ... I 
> can send them directly to Linus as voyager maintainer if you prefer.

Well, i'm NAK-ing those patches in their current form - x86/Voyager should 
be restructured like the other ex subarchitectures were done - or we'll 
have to mark it CONFIG_BROKEN until the right kind of patches arrive. 

Please send patches to the x86 maintainers and implement the cleanups we 
have asked for - or let us know if you dont have time/interest in doing 
so.

Thanks,

	Ingo
