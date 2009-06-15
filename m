Return-Path: <linux-kernel-owner+w=401wt.eu-S934666AbZFOVMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934666AbZFOVMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934568AbZFOVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:12:10 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:61542 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932232AbZFOVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:12:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAC9TNkpMQWQl/2dsb2JhbACBT9NshA0F
Date: Mon, 15 Jun 2009 17:12:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615211207.GB12919@Krystal>
References: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615210119.GD24554@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:05:36 up 107 days, 17:31,  3 users,  load average: 0.06, 0.14,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Mathieu Desnoyers wrote:
> > >>>
> > >> Writing control registers is serializing, so it's a lot more expensive
> > >> than writing a normal register; my *guess* is that it will be on the
> > >> order of 100-200 cycles.
> > >>
> > >> That is not based on any actual information.
> > >>
> > > 
> > > Then how about just writing to the cr2 register *if* it has changed
> > > while the NMI handler was running ?
> > > 
> > > if (unlikely(read_cr2() != saved_cr2)))
> > > 	write_cr2(saved_cr2)
> > > 
> > > Mathieu
> > > 
> > 
> > That works fine, obviously, and although it's probably overkill 
> > it's also a trivially cheap optimization.
> 
> Writing cr2 costs 84 cycles so it's not overkill at all - it's a 
> nice optimization!
> 
> Btw., we dont have to re-read it - we actually _know_ when we got a 
> fault (the fault handler gives us back an error code).
> 

Just for the sake of making NMI handlers less tricky, supporting page
faults caused by faulting kernel instructions (rather than only
supporting explicit faulting from get_user_pages_inatomic) would be
rather nice design-wise if it only costs 2-3 cycles.

And I would not want to touch the page fault handler itself to write the
saved cr2 value before the handler exits, because this would add a
branch on a very hot path.

Mathieu

> So we can do this common optimization and avoid the cr2 write 
> usually. We only need the cr2 read.
> 
> Hm, tempting ...
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
