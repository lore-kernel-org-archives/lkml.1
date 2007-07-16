Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXGPPMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXGPPMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765479AbXGPPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:12:27 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:65330 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765394AbXGPPMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:12:25 -0400
Date: Mon, 16 Jul 2007 11:12:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 1/8] Kprobes - do not use kprobes mutex in arch code
Message-ID: <20070716151220.GA23133@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org> <20070714192002.GK6975@Krystal> <20070716102738.GA4276@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070716102738.GA4276@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:08:51 up 9 days,  5:14,  3 users,  load average: 1.22, 0.76, 0.49
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Sat, Jul 14, 2007 at 03:20:02PM -0400, Mathieu Desnoyers wrote:
> > * Christoph Hellwig (hch@infradead.org) wrote:
> > > On Fri, Jul 13, 2007 at 09:21:34PM -0400, Mathieu Desnoyers wrote:
> > > > Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> > > > remove all use of this mutex in the architecture specific code, replacing it by
> > > > a proper mutex lock/unlock in the architecture agnostic code.
> > > 
> > > This is not very nice for avr32/sparc64 which have a noop arch_remove_kprobe
> > > and now need to take a mutex to do nothing.  Maybe you can find a nice
> > > way to avoid that?
> > > 
> > > Except for this issue making kprobes_mutex static to kprobes.c sounds like
> > > a good improvement.
> > > 
> > 
> > Since only unregister_kprobe() calls arch_remove_kprobe(), and only
> > after having removed the struct kprobe from the kprobes list (while the
> > kprobes mutex is held), I wonder if there is any need to hold the
> > kprobes mutex at all when calling arch_remove_kprobe(). It turns out
> > that only get_insn_slot()/free_insn_slot() (which is in
> > kernel/kprobes.c, but called from arch specific code) seems to really
> > use protection of this mutex.
> 
> Right.
> 
> > Would it make sense to protect the kprobe_insn_pages list with a
> > new kprobe_insn_mutex, nestable in the kprobe_mutex ?
> 
> Do you think it is required after your change to make kprobe_mutex
> static? But yes, for architectures that don't need a arch_remove_kprobe,
> the situation is a bit odd... a mutex to do nothing. IIRC, that was the
> primary reason why we made the mutex visible outside of kernel/kprobes.c
> 

After making the kprobe_mutex static, the only alternative we have is to
protect the arch_remove_kprobe (empty on some architectures) call with
kprobe_mutex, which, as Christoph pointed out, is not so great. Besides,
I think the kprobe_insn_mutex would make more sense than taking a mutex
in the arch-specific arch_remove_kprobe() for a resource that is not
clearly identified.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
