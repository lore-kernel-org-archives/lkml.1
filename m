Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYJAIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYJAIxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYJAIxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:53:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYJAIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:52:59 -0400
Date: Wed, 1 Oct 2008 10:52:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
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
Message-ID: <20081001085219.GB25009@elte.hu>
References: <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu> <200809302206.11391.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809302206.11391.eike-kernel@sf-tec.de>
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


* Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > Dang.
> > >
> > > I guess we'll have to bite the bullet some day and actually create
> > > some explicit topological ordering of initcalls rather than depend on
> > > the initcall levels and link order. That is one particular complexity
> > > I've tried to avoid. But the subtlety of the current ordering is
> > > certainly not at all good either.
> >
> > incidentally, i've been talking to Arjan about this recently in context
> > of the CONFIG_FASTBOOT feature. Because, as a side-effect, in the long
> > run, once the dependencies between initcalls fan out in a more natural
> > way, with explicit initcall ordering we'll also be able to boot a bit
> > faster and a bit more parallel.
> >
> >  [ but performance is far less important than robustness, so this idea
> >    was on the backburner. ]
> >
> > and i think on the conceptual level initcall levels and implicit
> > ordering are bad in the same way SPL and IPL based locking is worse than
> > real, explicit spinlocks.
> >
> > i think the topological ordering should not be just an extension of the
> > current hardcoded initcall levels, but it should be symbol space based:
> > i.e. an initcall should depend not on some kind of artificial enum, but
> > it should depend on _another initcall_. (a list of initcalls more
> > generally)
> >
> > so instead of the current hardcoded levels:
> >
> >   core_initcall(sysctl_init);
> >
> > we could have natural constructs like:
> >
> >   initcall_depends_on(sysctl_init, securityfs_init);
> >   initcall_depends_on(sock_init, sysctl_init)
> >
> > where we create explicit dependencies between actual initcalls just by
> > listing their dependencies. In many cases we could express dependencies
> > in a natural way:
> >
> >   initcall_depends_on(some_subsys_init, kmem_cache_init);
> >   initcall_depends_on(some_subsys_init, sched_init);
> >
> > which would express the fact that some_subsys_init() must execute after
> > kmem_cache_init() and after sched_init().
> >
> > Each initcall is associated with an 'initcall descriptor', which shows
> > which other initcalls this initcall depend on, and whether the initcall
> > has been executed already.
> >
> > during bootup the initcall engine would parse the graph and would
> > execute all the 'leaf' initcalls, and would complete the graph
> > gradually.
> >
> > ( More details: we'd have a number of compatibility and convenience
> >   symbols as well - well-known initialization stages for various
> >   customary phases of bootup.
> >
> >   And at link time we could detect circular dependencies. )
> >
> > So ... this scheme looks elegant to me, but maybe it is overdesigned?
> 
> Why calculate this at boot time? Do you expect this to change between 
> bootups?

yes, we could indeed map it statically to a single-threaded bootup 
sequence at build time. That is more reproducible, more deterministic, 
etc.

[ What i was thinking about the most generic long-run approach: each CPU 
  processing initcalls in parallel. Then the initcall graph is processed
  in parallel and the ordering and speed of execution (and the grade of
  completion) depends on the number of CPUs, their speed and other
  factors, etc.

  But it would be madness to combine such a facility with the current
  fragile single-threaded boot code. ]

	Ingo
