Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZDSWfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZDSWfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 18:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZDSWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 18:35:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54913 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZDSWfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 18:35:32 -0400
Date: Mon, 20 Apr 2009 00:35:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
Message-ID: <20090419223519.GA27706@elte.hu>
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain> <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu> <49EB9F59.4080904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EB9F59.4080904@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > Look at the drivers that define their own wrappers:
> > 
> > #ifndef readq
> > static inline unsigned long long readq(void __iomem *addr)
> > {
> >         return readl(addr) | (((unsigned long long)readl(addr + 4)) << 32LL);
> > }
> > #endif
> > 
> > ... it's the obvious 32-bit semantics for reading a 64-bit value 
> > from an mmio address. We made that available on 32-bit too.
> > 
> > It's being used ... and has been in use for some time. Where's 
> > the problem? readl is serializing on all default-ioremap mmio 
> > targets on x86 so there's no ambiguity in ordering.
> 
> I think his point is that they're not atomic. [...]

Ok - i didnt really consider atomicity, because that's not really 
feasible for a number of reasons anyway:

> [...] For what it's worth, atomic readq()/writeq() *are* possible 
> with any x86-32 CPU which supports MMX, but it is very costly to 
> do in the kernel since it involves touching the FPU state.
> 
> For the vast number of users, a non-atomic primitive which is 
> available for both 32- and 64-bit x86 is a win.  For a small 
> number of users, it'll be confusing, and for a very small minority 
> it's going to be desirable to have the atomic primitive.
> 
> The reason the non-atomic is generally fine is because most device 
> drivers are inherently single-threaded on a per-hardware device 
> basis.

Also, atomicity might not be possible to guarantee on the bus level: 
say the device sits on a 32-bit PCI bus. (No matter what instruction 
the CPU gets, a readq/writeq there has to be done as two 32-bit bus 
accesses.)

(Also, even a genuine 64-bit device might be bridged over 32-bit 
pathways so a driver cannot really assume atomicity on that level.)

	Ingo
