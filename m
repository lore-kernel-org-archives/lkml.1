Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYFDHXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYFDHXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFDHXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:23:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYFDHXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:23:39 -0400
Date: Wed, 4 Jun 2008 09:23:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Patrick McManus <mcmanus@ducksong.com>
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
	v2.6.26-rc3+
Message-ID: <20080604072311.GA32491@elte.hu>
References: <20080529112257.GA18130@elte.hu> <20080530181839.GA31915@elte.hu> <20080531060947.GA26441@elte.hu> <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi> <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi> <20080531125428.GA22111@elte.hu> <Pine.LNX.4.64.0805311555570.2329@wrl-59.cs.helsinki.fi> <20080531163501.GB22607@elte.hu> <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
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


* Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> > > i'll queue up your reverts for testing in -tip.
> > 
> > update: your 3 reverts in tip/out-of-tree [commit dad98991c] definitely 
> > fixed the hangs!
> 
> ...It wasn't exactly out-of-tree, Evgeniy fixed a problem that was 
> found in "TCP_DEFER_ACCEPT updates - process as established", perhaps 
> it just wasn't in your testing tree yet.

out of the -tip tree :-) The -tip tree has 75+ topic branches at the 
moment, but TCP topics are not in its scope - so any TCP change is "out 
of tree" for the -tip tree.

People got confused in the past when they saw similar test patches show 
up in sched.git and x86.git before, so we wanted to make it very clear 
in -tip (with is the successor of sched.git, x86.git and a couple of 
other git trees) that these are commits we dont want to push anywhere. 

Commits in tip/out-of-tree dont get propagated into the tip/auto-*-next 
topic branches that linux-next and -mm picks up, they are purely a 
courtesy to help the testing/fixing of bugs in subsystems that are 
maintained in other git trees.

See attached below the current shortlog of the tip/out-of-tree topic 
branch - it contains changes all around the tree for various things that 
we triggered in -tip and are not yet upstream or are in flight somewhere 
in another git tree.

> > Here is the testing i did:
> > 
> > first i ran about 500+ successful iterations on the affected 
> > testboxes with your revert patch applied, on multiple systems.
> 
> Are you sure this is enough to conclude the results? Seems quite small 
> number to me to rule out luck. Especially considering that it was some 
> amount of time in the tree already until you noticed it for the first 
> time.

a full day of testing on a testsystem with 500 random kernel builds and 
bootups (the kernel build done on the testsystem utilizing distcc and 
make -j100, so it's rather heavy and parallel TCP traffic per iteration) 
with no hang, compared to the same system with your reverts not applied 
that hung after an hour with 20-30 iterations.

And that count increased to 1000 successful test iterations since 
yesterday.

So i think yes, it seems rather conclusive, given the circumstances ;-) 

These random kernel boots found many 'impossible to trigger' bugs and 
races in the past. The reason for its race finding capability is the 
timing randomness of the resulting random kernel image: the delays 
caused by random combination of debugging facilities, build variants, 
kernel subsystem variants we have. This -tip qa method - as a 
side-effect of its coverage testing - simulates timing variantions that 
are otherwise only observable via hardware variations.

I.e. this is not the same kernel booted up a 1000 times - that would be 
a very narrow test. This is 1000 _different_ kernels built and booted 
up. Each kernel having subtly different timings and ordering. And it's 
more than just externally injected random kernel: the test-system itself 
builds its "next version" (and uses the network for that as well), so 
it's a self-hosting recursive random test in essence.

This method is also amazingly good at finding compiler/linker trouble: 
it found 3-4 real gcc bugs so far. (For example i triggered an ancient 
bug in gcc 4.0.2 just yesterday. For the record, the testsystem with the 
TCP hang utilizes gcc-4.2.2.)

> > so i hereby conclude that your revert works :) I've repeated the 
> > commit below that resolves this nasty regression.
> 
> ...I couldn't immediately find anything obviously wrong with those 
> changes but the patch below might be worth of a try (without the 
> revert of course). If it ever spits out that WARN_ON for you, we were 
> playing with fire too much and it's better to return on the safe side 
> there...

i'll queue it up for testing, but no promises about speedy action here - 
the test cycle is really long with this bug.

	Ingo

------{ tip/out-of-tree shortlog: }----------->

Alexander van Heukelum (1):
      uml: cleanup: use def_bool in Kconfig files

Bjorn Helgaas (1):
      PNPACPI: use _CRS IRQ descriptor length for _SRS

Ilpo Järvinen (1):
      tcp: revert DEFER_ACCEPT modifications

Ingo Molnar (7):
      video/dvb: fix MEDIA_TUNER && FW_LOADER build error
      dvb: input layer dependencies fixes
      drivers/media/video build fix for modular builds
      drivers/watchdog/geodewdt.c: build fix
      USB: fix build bug in USB_ISIGHTFW
      acpi-acpi_numa_init-build-fix
      acpi: fix drivers/acpi/glue.c build error

Michael Krufky (1):
      dib7000p: fix dib7000p_attach when !CONFIG_DVB_DIB7000P

Russ Anderson (1):
      acpi: fix boot breakage on Altix

Yinghai Lu (2):
      net: use numa_node in net_devcice->dev instead of parent
      ide: use dev_to_node instead of pcibus_to_node

