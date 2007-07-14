Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbXGNTZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbXGNTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760813AbXGNTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:25:17 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:32824 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760804AbXGNTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:25:15 -0400
Date: Sat, 14 Jul 2007 15:20:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 1/8] Kprobes - do not use kprobes mutex in arch code
Message-ID: <20070714192002.GK6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714104914.GB7358@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:14:45 up 7 days,  9:20,  2 users,  load average: 0.14, 0.25, 0.25
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Fri, Jul 13, 2007 at 09:21:34PM -0400, Mathieu Desnoyers wrote:
> > Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> > remove all use of this mutex in the architecture specific code, replacing it by
> > a proper mutex lock/unlock in the architecture agnostic code.
> 
> This is not very nice for avr32/sparc64 which have a noop arch_remove_kprobe
> and now need to take a mutex to do nothing.  Maybe you can find a nice
> way to avoid that?
> 
> Except for this issue making kprobes_mutex static to kprobes.c sounds like
> a good improvement.
> 

Since only unregister_kprobe() calls arch_remove_kprobe(), and only
after having removed the struct kprobe from the kprobes list (while the
kprobes mutex is held), I wonder if there is any need to hold the
kprobes mutex at all when calling arch_remove_kprobe(). It turns out
that only get_insn_slot()/free_insn_slot() (which is in
kernel/kprobes.c, but called from arch specific code) seems to really
use protection of this mutex.

Would it make sense to protect the kprobe_insn_pages list with a
new kprobe_insn_mutex, nestable in the kprobe_mutex ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
