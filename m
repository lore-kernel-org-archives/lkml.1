Return-Path: <linux-kernel-owner+w=401wt.eu-S935711AbZFOVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935711AbZFOVeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934528AbZFOVea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:34:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63320 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934479AbZFOVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:34:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAL9ZNkpMQWQl/2dsb2JhbACBT9NRhA0F
Date: Mon, 15 Jun 2009 17:34:29 -0400
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
Message-ID: <20090615213429.GD12919@Krystal>
References: <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu> <20090615211207.GB12919@Krystal> <20090615211605.GC27100@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615211605.GC27100@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:27:09 up 107 days, 17:53,  3 users,  load average: 0.30, 0.26,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Just for the sake of making NMI handlers less tricky, supporting 
> > page faults caused by faulting kernel instructions (rather than 
> > only supporting explicit faulting from get_user_pages_inatomic) 
> > would be rather nice design-wise if it only costs 2-3 cycles.
> > 
> > And I would not want to touch the page fault handler itself to 
> > write the saved cr2 value before the handler exits, because this 
> > would add a branch on a very hot path.
> 
> _That_ path is not hot at all - it's the 'we are in atomic section 
> and faulted' rare path (laced with an exception table search - which 
> is extremely slow compared to other bits of the pagefault path).
> 
> But ... it's not an issue: a check can be made in the NMI code too, 
> as we always know about pagefaults there, by virtue of getting 
> -EFAULT back from the attempted-user-copy.

As the maintainer of the out-of-tree LTTng tracer, which hooks in the
page fault handler with tracepoints, and which can build almost entirely
as modules, I am very tempted to argue that having the nmi-code entirely
robust wrt in-kernel page faults would be a very-nice-to-have feature.

Requiring that code to be either built-in or to call vmalloc_sync_all()
after any vmalloc or after module load is just painful and error-prone.
Plus, tracing is a feature that some users will only use in specific
occasions. I don't see why it should be built-into the kernel at all.
That's just a waste of memory in many cases. (I am not talking about
users who want to do continuous system tracing here, which is a totally
different scenario).

Mathieu


> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
