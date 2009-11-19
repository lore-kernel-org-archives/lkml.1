Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZKSNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZKSNLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKSNLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:11:38 -0500
Received: from www.tglx.de ([62.245.132.106]:44698 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZKSNLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:11:37 -0500
Date: Thu, 19 Nov 2009 14:11:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
In-Reply-To: <20091119130526.23a69b85@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0911191357490.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com> <20091107210147.3e754278@hyperion.delvare> <4AF7148C.9090706@thebigcorporation.com> <20091112211255.09cd884a@hyperion.delvare> <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
 <20091116155606.GC29479@sirena.org.uk> <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com> <20091118010520.4cd397d4@lxorguk.ukuu.org.uk> <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com> <20091118175202.490989d8@hyperion.delvare>
 <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain> <20091119130526.23a69b85@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Jean Delvare wrote:
> > That still does not explain why yield() is necessary _between_ the
> > transaction attempts.
> 
> It is not _necessary_. We are just trying to be fair to other kernel
> threads, because bit-banging is expensive and this is the only case
> where we know we can tolerate a delay.
> 
> Just to clarify things... does (or did) yield() have anything to do
> with CONFIG_PREEMPT_VOLUNTARY?

No.
 
> > That code is fully preemptible, otherwise you could not call
> > yield().
> 
> How does one know what code is preemtible and what code is not? The
> rest of the i2c-algo-bit code should definitely _not_ be preemtible, as
> it is highly timing sensitive.

Code is preemptible when preempt_count() == 0 and interrupts are
enabled. spin_lock() implicitely disables preemption.
 
> > And as I said before nobody even noticed that the yield()
> > default implementation was changed to a NOOP by default in the
> > scheduler.
> 
> Well, I guess only people monitoring system latency would notice, as
> this is the only thing yield() was supposed to help with in the first
> place.
> 
> You say "NOOP by default", does this imply there is a way to change
> this?

There is a sysctl: sysctl_sched_compat_yield
 
> Was yield() turned into NOOP by design, or was it a bug?

By design. The semantics of yield and the fairness approach of CFS are
not really working well together. Also yield() for SCHED_OTHER is not
really specified.

Thanks,

	tglx
