Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZFPWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZFPWAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZFPWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:00:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:34778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbZFPWAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:00:07 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
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
Content-Type: text/plain
Date: Wed, 17 Jun 2009 07:58:29 +1000
Message-Id: <1245189509.14036.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 12:10 -0700, Linus Torvalds wrote:
> 
> All the recent init ordering changes should mean that the slab allocator 
> is available _much_ earlier - to the point that hopefully any code that 
> runs before slab is initialized should know very deep down that it's 
> special, and uses the bootmem allocator without doing any conditionals 
> what-so-ever.

I would normally agree ... but we still have some stuff in setup_arch()
that will need that :-( IE, we need to allow ioremap very early on
powerpc (and possibly various other archs that don't have magic PIO to
whack their chipset without the need for a mapping), so we have tricks
to allocate page tables using LMB, bootmem or slab depending on what's
available that still rely on slab_is_available().

Same goes with some PCI PHB related data structures that we are
allocating in setup_arch() as well, though that's something I do intend
to move to normal initcalls asap (there's a few skeletons hiding in some
corners there so it's not totally trivial).

In fact, I would love to be able to call the SLAB init myself from
somewhere in setup_arch() ... basically instead of init_bootmem() and be
done with it :-) I know it's a chicken-and-egg problem with allocating
the memmap etc... but heh. Which brings me back to my point, we do have
some kind of very very very early allocator on powerpc and sparc
(lib/lmb.), and I think x86 has one too (i820 or whatever it's called)
right ? Maybe we can wrap a common API on top of these things and avoid
bootmem alltogether ? Or that's just not realistic ?

> If that isn't true yet, then we should make it more true.

I agree.

> IOW, we should strive for not having any code that is at all confused 
> about whether it can do slab allocations or not.

Cheers,
Ben.


