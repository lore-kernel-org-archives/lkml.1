Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYJAI13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYJAI13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJAI1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:27:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYJAI1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:27:18 -0400
Date: Wed, 1 Oct 2008 10:26:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20081001082603.GA31009@elte.hu>
References: <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu> <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org> <20081001061328.GD7348@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001061328.GD7348@colo.lackof.org>
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


* Grant Grundler <grundler@parisc-linux.org> wrote:

> On Tue, Sep 30, 2008 at 12:51:07PM -0700, Linus Torvalds wrote:
> ....
> > But I think we could add a separate notion of a dependancy point, and have 
> > a setup where we describe "initcall X needs to happen before point A" and 
> > "initcall Z needs to happen after point A".
> > 
> > And then we can create a separate set of these dependency points, so that 
> > X and Y don't have to know about each other, they just have to have some 
> > knowledge about some common synchronization point - one that exists 
> > regardless of whether X or Y are even compiled in!
> 
> We already do this today. :)
> Definitions are in include/linux/init.h.
> Point A would be "early" ("run before initialing SMP")
> The rest could use better definitions and AFAICT aren't that much better
> than being named "Point B".

the structural problem with the current level-based initcall design is 
that the current dependencies are implicit (not spelled out clearly 
anywhere in the source code), and bugs in them are often fixed by 
experimenting around (seeing whether it breaks), not by design.

Changing it is a ton of work, and the risks of touching that code might 
eclipse any (often marginal) advantages a new scheme has. Today boot 
code runs only once and it is one of the most under-tested pieces of 
kernel code. Boot code's quality and robustness is at least 1 order of 
magnitude worse than regular kernel code.

But to play the devil's advocate: users have so many problems with weird 
races in boot code today _already_, wouldnt it be better to expose boot 
code to more variations, to put it under environmental pressure that 
ultimately improves its quality?

Init code is often reused during suspend/resume, so by introducing more 
flexibility into initcalls maybe we create enough pressure to fix them 
when it's far easier to fix them. (after bootup - fixing after-resume 
bugs is much harder because often the console is turned off and no 
significant BIOS code ran.)

Today moving an initcall to another level has unknown effects and 
nothing warns about broken dependencies but a bootup crash (often only 
triggering under a specific .config), or a non-working device or some 
other regression.

That is rather fragile and i doubt anyone can argue the opposite.

The question of whether explicit dependencies are better is another 
question and up to debate:

in the long run it is _IMHO_ more robust to express explicit 
dependencies close to the init functions, in the source code:

  initcall_depends_on(this_driver, memory_init);
  initcall_depends_on(this_driver, io_resources_init);

than to rely on the implicit (and undocumented and often forgotten) 
dependencies we have currently.

For example ordering an initcall to after PNP init would be trivial, 
we'd add this to the init dependency list:

  initcall_depends_on(this_driver, pnp_init);

With the current scheme we have to find some other integer 'level' and 
hope that moving this initcall to that new level does not break other, 
implicit dependencies.

And note that once we start doing explicit dependencies, we could 
automate much of it: if a piece of .o uses a set of symbols that makes 
it rather clear which subsystems it has to rely on. Say it uses 
kmalloc() then it should depend on memory_init() done.

	Ingo
