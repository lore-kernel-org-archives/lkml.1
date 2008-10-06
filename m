Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYJFFe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYJFFe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYJFFer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:34:47 -0400
Received: from colo.lackof.org ([198.49.126.79]:46892 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYJFFep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:34:45 -0400
Date: Sun, 5 Oct 2008 23:34:32 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
	in quirk_system_pci_resources()
Message-ID: <20081006053432.GA30274@colo.lackof.org>
References: <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu> <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org> <20081001061328.GD7348@colo.lackof.org> <20081001082603.GA31009@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001082603.GA31009@elte.hu>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 10:26:03AM +0200, Ingo Molnar wrote:
...
> > Definitions are in include/linux/init.h.
> > Point A would be "early" ("run before initialing SMP")
> > The rest could use better definitions and AFAICT aren't that much better
> > than being named "Point B".
> 
> the structural problem with the current level-based initcall design is 
> that the current dependencies are implicit (not spelled out clearly 
> anywhere in the source code), and bugs in them are often fixed by 
> experimenting around (seeing whether it breaks), not by design.

Ingo,
I totally agree with you and liked yours/Arjan's suggestion to make
the dependency explicit. Since linus pointed out explicit dependencies
would be a disaster to maintain, I don't know where to go next. I agree
with him issues will come up. But frobbing the current scheme by increasing
the number of "init points" from 8 to 50 (or more likely a 100 or 200)
feels like it's not making the dependencies explicit either.

We currently make the subsystem/driver dependencies explicit in the
Kconfig files. We hide the lack of a subsystem with null macros
(e.g. "#define foo() {}" ). I'm wondering if this would be one
step making your original suggestion palatable.

I'm also wondering if we should be using the dependency graph
that is effectively coded in Kconfig files to generate the
init calls somehow. Any university students looking for a
very cool and pratical project this year that will make you
famous and pay for your trip to a linux conference next year?

> Changing it is a ton of work, and the risks of touching that code might 
> eclipse any (often marginal) advantages a new scheme has. Today boot 
> code runs only once and it is one of the most under-tested pieces of 
> kernel code. Boot code's quality and robustness is at least 1 order of 
> magnitude worse than regular kernel code.

Agreed as long as the conversation is about subsystem initialization.

> But to play the devil's advocate: users have so many problems with weird 
> races in boot code today _already_, wouldnt it be better to expose boot 
> code to more variations, to put it under environmental pressure that 
> ultimately improves its quality?

Yes. A DEBUG mechanism to record and dump the order when each init
call is started and completed might be one step to satisfy Linus' fear
of not being able to debug the problems.

> Init code is often reused during suspend/resume, so by introducing more 
> flexibility into initcalls maybe we create enough pressure to fix them 
> when it's far easier to fix them. (after bootup - fixing after-resume 
> bugs is much harder because often the console is turned off and no 
> significant BIOS code ran.)
> 
> Today moving an initcall to another level has unknown effects and 
> nothing warns about broken dependencies but a bootup crash (often only 
> triggering under a specific .config), or a non-working device or some 
> other regression.
> 
> That is rather fragile and i doubt anyone can argue the opposite.
> 
> The question of whether explicit dependencies are better is another 
> question and up to debate:

I'm pretty comfortable that explicit dependencies are better.
The question is how to deal with the issues Linus raised and any
other issues folks find in a sane way.

> 
> in the long run it is _IMHO_ more robust to express explicit 
> dependencies close to the init functions, in the source code:
> 
>   initcall_depends_on(this_driver, memory_init);
>   initcall_depends_on(this_driver, io_resources_init);

We just need the "memory_init" function to export a stub in
case it's not actually enabled in the .config file.

> 
> than to rely on the implicit (and undocumented and often forgotten) 
> dependencies we have currently.
> 
> For example ordering an initcall to after PNP init would be trivial, 
> we'd add this to the init dependency list:
> 
>   initcall_depends_on(this_driver, pnp_init);
> 
> With the current scheme we have to find some other integer 'level' and 
> hope that moving this initcall to that new level does not break other, 
> implicit dependencies.
> 
> And note that once we start doing explicit dependencies, we could 
> automate much of it: if a piece of .o uses a set of symbols that makes 
> it rather clear which subsystems it has to rely on. Say it uses 
> kmalloc() then it should depend on memory_init() done.

*nod*. I think all of it has be automated. Where automation gets
the dependency info from will be the key to making this work.

hth,
grant

> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
