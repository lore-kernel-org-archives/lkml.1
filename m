Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYI3UGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYI3UGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYI3UGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:06:23 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:34637 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYI3UGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:06:21 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in quirk_system_pci_resources()
Date: Tue, 30 Sep 2008 22:05:44 +0200
User-Agent: KMail/1.9.10
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
References: <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu>
In-Reply-To: <20080930193819.GA29860@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1483641.zdhIWxlzK1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809302206.11391.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1483641.zdhIWxlzK1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > Dang.
> >
> > I guess we'll have to bite the bullet some day and actually create
> > some explicit topological ordering of initcalls rather than depend on
> > the initcall levels and link order. That is one particular complexity
> > I've tried to avoid. But the subtlety of the current ordering is
> > certainly not at all good either.
>
> incidentally, i've been talking to Arjan about this recently in context
> of the CONFIG_FASTBOOT feature. Because, as a side-effect, in the long
> run, once the dependencies between initcalls fan out in a more natural
> way, with explicit initcall ordering we'll also be able to boot a bit
> faster and a bit more parallel.
>
>  [ but performance is far less important than robustness, so this idea
>    was on the backburner. ]
>
> and i think on the conceptual level initcall levels and implicit
> ordering are bad in the same way SPL and IPL based locking is worse than
> real, explicit spinlocks.
>
> i think the topological ordering should not be just an extension of the
> current hardcoded initcall levels, but it should be symbol space based:
> i.e. an initcall should depend not on some kind of artificial enum, but
> it should depend on _another initcall_. (a list of initcalls more
> generally)
>
> so instead of the current hardcoded levels:
>
>   core_initcall(sysctl_init);
>
> we could have natural constructs like:
>
>   initcall_depends_on(sysctl_init, securityfs_init);
>   initcall_depends_on(sock_init, sysctl_init)
>
> where we create explicit dependencies between actual initcalls just by
> listing their dependencies. In many cases we could express dependencies
> in a natural way:
>
>   initcall_depends_on(some_subsys_init, kmem_cache_init);
>   initcall_depends_on(some_subsys_init, sched_init);
>
> which would express the fact that some_subsys_init() must execute after
> kmem_cache_init() and after sched_init().
>
> Each initcall is associated with an 'initcall descriptor', which shows
> which other initcalls this initcall depend on, and whether the initcall
> has been executed already.
>
> during bootup the initcall engine would parse the graph and would
> execute all the 'leaf' initcalls, and would complete the graph
> gradually.
>
> ( More details: we'd have a number of compatibility and convenience
>   symbols as well - well-known initialization stages for various
>   customary phases of bootup.
>
>   And at link time we could detect circular dependencies. )
>
> So ... this scheme looks elegant to me, but maybe it is overdesigned?

Why calculate this at boot time? Do you expect this to change between bootups?

Eike

--nextPart1483641.zdhIWxlzK1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjihrMACgkQXKSJPmm5/E4hFwCgoJl5F/jj3jHauCMm5g7LTBJz
bs8An3c5w2wTgQMyJokhsbsyG3pUFkSE
=Uxea
-----END PGP SIGNATURE-----

--nextPart1483641.zdhIWxlzK1--
