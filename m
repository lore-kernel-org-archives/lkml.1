Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZDTKxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZDTKxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZDTKxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:53:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZDTKxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:53:14 -0400
Date: Mon, 20 Apr 2009 12:53:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
Message-ID: <20090420105304.GC6670@elte.hu>
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain> <adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu> <adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EBCDC0.1020001@zytor.com>
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

> Roland Dreier wrote:
> > 
> > Notice that it reads from addr+4 *before* it reads from addr, rather
> > than after as in your example (and in fact your example depends on
> > undefined compiler semantics, since there is no sequence point between
> > the two operands of the | operator).  Now, I don't know that hardware,
> > so I don't know if it makes a difference, but the niu example I gave in
> > my original email shows that given hardware with clear-on-read
> > registers, the order does very much matter.
> > 
> 
> At least for x86, the order should be low-high, because that is the
> order that those two transactions would be seen on a 32-bit bus
> downstream from the CPU if the CPU issued a 64-bit transaction.
> 
> The only sane way to handle this as something other than per-driver
> hacks would be something like:
> 
> #include <linux/io64.h>		/* Any 64-bit I/O OK */
> 
> #include <linux/io64lh.h>	/* Low-high splitting OK */
> 
> #include <linux/io64hl.h>	/* High-low splitting OK */
> 
> #include <linux/io64atomic.h>	/* 64-bit I/O must be atomic */
> 
> ... i.e. letting the driver choose what fallback method it will accept.

Yeah - with the default being the natural low-high order.

The other argument is that if a driver really wants some rare, oddly 
different order it should better define its own method that is not 
named in the same (or in a similar) way as an existing generic API. 
Otherwise, confusion will ensue.

	Ingo
