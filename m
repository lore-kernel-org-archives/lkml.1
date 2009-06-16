Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbZFPWwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbZFPWwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZFPWwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:52:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:54402 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZFPWwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:52:45 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.01.0906161505080.16802@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <1245101567.12400.38.camel@pasglop>
	 <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
	 <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
	 <1245189509.14036.28.camel@pasglop>
	 <alpine.LFD.2.01.0906161505080.16802@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 08:51:13 +1000
Message-Id: <1245192673.14036.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 15:06 -0700, Linus Torvalds wrote:
> Why do you need ioremap so early that it has to happen before even the 
> basic MM data is up? That sounds bogus, and like just a random 
> implementation issue for historical reasons.

ioremap is probably the -one- thing we constantly try to move
earlier ... sadly :-) But again, I agree and it's mostly historical
reason, coupled with the lack of good "generic" (rather than dedicated
like mem_init(), time_init(), init_IRQ() ...) archs hooks after
setup_arch() and before full blown initcalls.

The main user of it is debugging. We have debug options that can
initialize some kind of console output pretty much even before
setup_arch() is called :-) Most of that stuff isn't normally compiled in
a production kernel though.

Now, if we could do less things in setup_arch() we would have less need
to debug stuff in there, that's true :-) The worst offender is probably
ppc64 which currently does shitloads of stuff even before we call
start_kernel() and that is just plain wrong.

This stuff has been on my to-fix list for a long time, I want to move a
lot of it to later during the boot process and make it more common
between 32 and 64 bit etc... Just give me some time :-)

A few other users of that sort of early ioremap are some bits that
access chipset registers to fixup crap, most of it is in setup_arch()
because we don't actually have a good arch callback that comes later and
is still reasonably before anything important takes place. Maybe we
should introduce one just after the initialization of the allocators.

On ppc32, we also ioremap IO space from setup_arch() and on ppc64 we do
that but only for the legacy part of it. That also could be moved as we
move the PHB init later.

Oh, one big one too is access to the system controller registers (aka
Cuda or PMU on powermacs) which we also do very early.

None of that is unfixable, and in some case even hard to fix. But just
don't remove slab_is_available() -just-yet- :-)

Cheers,
Ben.

