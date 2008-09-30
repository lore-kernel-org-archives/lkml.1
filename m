Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYI3TzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYI3TzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYI3Tyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:54:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbYI3Tyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:54:44 -0400
Date: Tue, 30 Sep 2008 12:51:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <20080930193819.GA29860@elte.hu>
Message-ID: <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org>
References: <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl>
 <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Ingo Molnar wrote:
> 
> incidentally, i've been talking to Arjan about this recently in context 
> of the CONFIG_FASTBOOT feature. Because, as a side-effect, in the long 
> run, once the dependencies between initcalls fan out in a more natural 
> way, with explicit initcall ordering we'll also be able to boot a bit 
> faster and a bit more parallel.

Hell no.

We do not want any implicit parallelism in the initcalls. That way lies 
madness.

The probe functions that explicitly know that they are slow (like USB 
detection and/or other individual drivers that have timeouts) should put 
themselves in the background. We should _not_ use the dependency chain to 
do so automatically, because for most cases drivers are totally 
independent, but we still want a _reliable_  and _repeatable_ ordering.

Which means that I will not accept stuff that makes for a parallel bootup 
as a general initcall notion. I want things like network devices to show 
up in the same order for the same kernel, thank you very much - even if 
there is absolutely _zero_ ordering constraints between two independent 
network drivers.

Anything else will inevitably cause just totally random and undebuggable 
problems.

> i think the topological ordering should not be just an extension of the 
> current hardcoded initcall levels, but it should be symbol space based: 
> i.e. an initcall should depend not on some kind of artificial enum, but 
> it should depend on _another initcall_. (a list of initcalls more 
> generally)

Yes, it should be explicit.

However, I don't agree with the notion of having initcalls point to other 
initcalls. One big _idea_ of initcalls is that you can put them anywhere 
in the source code, and that CONFIG_XYZ variables will automatically run 
them or not depending on whether the code was compiled in. Having 
something like:

> so instead of the current hardcoded levels:
> 
>   core_initcall(sysctl_init);
> 
> we could have natural constructs like:
> 
>   initcall_depends_on(sysctl_init, securityfs_init);
>   initcall_depends_on(sock_init, sysctl_init)

would be a TOTAL DISASTER, because if you do that, then you are 
essentially back to the insane situation where people need to know what 
other parts are enabled.

So no. No "one call depends on another" crap.

But I think we could add a separate notion of a dependancy point, and have 
a setup where we describe "initcall X needs to happen before point A" and 
"initcall Z needs to happen after point A".

And then we can create a separate set of these dependency points, so that 
X and Y don't have to know about each other, they just have to have some 
knowledge about some common synchronization point - one that exists 
regardless of whether X or Y are even compiled in!

			Linus
