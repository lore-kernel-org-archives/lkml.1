Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZDUIqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZDUIqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZDUIps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:45:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZDUIpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:45:47 -0400
Date: Tue, 21 Apr 2009 10:45:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
Message-ID: <20090421084521.GA20459@elte.hu>
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain> <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu> <adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com> <20090420105304.GC6670@elte.hu> <a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com> <20090420160332.GB9689@elte.hu> <a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
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


* Hitoshi Mitake <h.mitake@gmail.com> wrote:

> On Tue, Apr 21, 2009 at 01:03, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> >
> >> On Mon, Apr 20, 2009 at 19:53, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >> >
> >> >> Roland Dreier wrote:
> >> >> >
> >> >> > Notice that it reads from addr+4 *before* it reads from addr, rather
> >> >> > than after as in your example (and in fact your example depends on
> >> >> > undefined compiler semantics, since there is no sequence point between
> >> >> > the two operands of the | operator).  Now, I don't know that hardware,
> >> >> > so I don't know if it makes a difference, but the niu example I gave in
> >> >> > my original email shows that given hardware with clear-on-read
> >> >> > registers, the order does very much matter.
> >> >> >
> >> >>
> >> >> At least for x86, the order should be low-high, because that is the
> >> >> order that those two transactions would be seen on a 32-bit bus
> >> >> downstream from the CPU if the CPU issued a 64-bit transaction.
> >> >>
> >> >> The only sane way to handle this as something other than per-driver
> >> >> hacks would be something like:
> >> >>
> >> >> #include <linux/io64.h>               /* Any 64-bit I/O OK */
> >> >>
> >> >> #include <linux/io64lh.h>     /* Low-high splitting OK */
> >> >>
> >> >> #include <linux/io64hl.h>     /* High-low splitting OK */
> >> >>
> >> >> #include <linux/io64atomic.h> /* 64-bit I/O must be atomic */
> >> >>
> >> >> ... i.e. letting the driver choose what fallback method it will accept.
> >> >
> >> > Yeah - with the default being the natural low-high order.
> >> >
> >> > The other argument is that if a driver really wants some rare, oddly
> >> > different order it should better define its own method that is not
> >> > named in the same (or in a similar) way as an existing generic API.
> >> > Otherwise, confusion will ensue.
> >> I think this is a good way.
> >> readq/writeq are already in Linus's tree, removing these is not a good idea.
> >>
> >> And I've sent the patch to fix a little problem of Kconfig about
> >> readq/writeq to you.
> >> http://marc.info/?l=linux-kernel&m=123521109218008&w=2
> >> Did you notice?
> >>
> >> Adding cautions about accessing order or non-atomic to Kconfig's help
> >> part may be benefit.
> >
> > It's better to add add such non-interactive help text as Makefile
> > comments:
> >
> > #
> > # This option ...
> > #
> >
> > and they should be invisible in make menuconfig. This is a facility
> > provided by architectures.
> I'll move the help text from Kconfig to Makefile.
> (My original patch also doesn't make help text visible in make menuconfig.)

sorry i meant the Kconfig file - you can put comments in there too. 
help text is really meant for things that are interactive.

	Ingo
