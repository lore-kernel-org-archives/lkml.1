Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYI3Tj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYI3Tj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYI3TjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:39:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbYI3TjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:39:16 -0400
Date: Tue, 30 Sep 2008 21:38:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
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
Message-ID: <20080930193819.GA29860@elte.hu>
References: <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Dang.
> 
> I guess we'll have to bite the bullet some day and actually create 
> some explicit topological ordering of initcalls rather than depend on 
> the initcall levels and link order. That is one particular complexity 
> I've tried to avoid. But the subtlety of the current ordering is 
> certainly not at all good either.

incidentally, i've been talking to Arjan about this recently in context 
of the CONFIG_FASTBOOT feature. Because, as a side-effect, in the long 
run, once the dependencies between initcalls fan out in a more natural 
way, with explicit initcall ordering we'll also be able to boot a bit 
faster and a bit more parallel.

 [ but performance is far less important than robustness, so this idea 
   was on the backburner. ]

and i think on the conceptual level initcall levels and implicit 
ordering are bad in the same way SPL and IPL based locking is worse than 
real, explicit spinlocks.

i think the topological ordering should not be just an extension of the 
current hardcoded initcall levels, but it should be symbol space based: 
i.e. an initcall should depend not on some kind of artificial enum, but 
it should depend on _another initcall_. (a list of initcalls more 
generally)

so instead of the current hardcoded levels:

  core_initcall(sysctl_init);

we could have natural constructs like:

  initcall_depends_on(sysctl_init, securityfs_init);
  initcall_depends_on(sock_init, sysctl_init)

where we create explicit dependencies between actual initcalls just by 
listing their dependencies. In many cases we could express dependencies 
in a natural way:

  initcall_depends_on(some_subsys_init, kmem_cache_init);
  initcall_depends_on(some_subsys_init, sched_init);

which would express the fact that some_subsys_init() must execute after 
kmem_cache_init() and after sched_init().

Each initcall is associated with an 'initcall descriptor', which shows 
which other initcalls this initcall depend on, and whether the initcall 
has been executed already.

during bootup the initcall engine would parse the graph and would 
execute all the 'leaf' initcalls, and would complete the graph 
gradually.

( More details: we'd have a number of compatibility and convenience 
  symbols as well - well-known initialization stages for various 
  customary phases of bootup.

  And at link time we could detect circular dependencies. )

So ... this scheme looks elegant to me, but maybe it is overdesigned?

	Ingo
