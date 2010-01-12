Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924Ab0ALJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0ALJrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641Ab0ALJrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:47:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39075 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0ALJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:47:19 -0500
Date: Tue, 12 Jan 2010 10:46:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
Message-ID: <20100112094624.GA24987@elte.hu>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 11 Jan 2010, Yinghai Lu wrote:
> >
> > some systems that have disable cpus entries because same
> >   BIOS will support 2 sockets and 4 sockets and more at
> >   same time, BIOS just leave some disable entries, but
> >   those system do not support cpu hotplug. we don't need
> >   treat disabled_cpus as hotplug cpus.
> >
> > so we can make nr_cpu_ids smaller and save more space
> >   (pcpu data allocations), and could make some systems run
> >   with logical flat instead of physical flat apic mode
> 
> .. but this one I detest.
> 
> We can't play games that depend on us always filling in some DMI table 
> correctly. Things need to "just work".
> 
> So while 1/4 looks fine, 2/4 looks fundamentally unacceptable.
> 
> Is the flat APIC mode really so important?

it's not important at all. When it's proven safe it's fine but it's clearly 
not unconditionally safe ...

> I would suggest a few alternatives:
> 
> Truly static:
> 
>  - only use that flat apic mode when you _know_ that you absolutely will 
>    never have more than 8 cpu's. Ie when CONFIG_NR_CPUS <= 8 (or, with 
>    1/3, when nr_cpu_ids <= 8) and/or when <= 8 CPU's were detected, and 
>    CPU hotplug is disabled entirely.
> 
> Slightly more intelligent:
> 
>  - Look at the ACPI socket count, and hey, if it says it might have more 
>    sockets - whether they are really hotplug or not, don't use flat mode, 
>    because we simply don't know. But do _not_ do some kind of DMI table to 
>    say one way or the other.
> 
> And if it's _really_ important:
> 
>  - if flat mode is so important that you want to enable it whenever 
>    possible, what about enabling/disabling it dynamically at CPU hotplug 
>    time? That does sound _very_ painful, but it's still better than having 
>    to maintain some list of all systems that can ever hot-plug. 
> 
> Hmm?

I'd go for #1. If the (modest) micro-performance advantages of flat delivery 
matter to a hardware vendor the system/BIOS can be built in a way to trigger 
the optimization. But even single socket systems are quickly running out of 
the space of 8 APIC ids so the relevance is dwindling ...

	Ingo
