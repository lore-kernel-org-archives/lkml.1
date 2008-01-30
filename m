Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbYA3Nxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbYA3Nxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbYA3Nxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:53:34 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:54897 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbYA3Nxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:53:33 -0500
Date: Wed, 30 Jan 2008 08:53:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
In-Reply-To: <47A079BD.8020106@siemens.com>
Message-ID: <Pine.LNX.4.58.0801300845180.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org> <20080130031840.337019504@goodmis.org>
 <47A079BD.8020106@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jan 2008, Jan Kiszka wrote:

> Steven Rostedt wrote:
>
> > --- linux-mcount.git.orig/arch/x86/kernel/entry_32.S	2008-01-29 16:59:15.000000000 -0500
> > +++ linux-mcount.git/arch/x86/kernel/entry_32.S	2008-01-29 17:26:18.000000000 -0500
> > @@ -75,6 +75,31 @@ DF_MASK		= 0x00000400
> >  NT_MASK		= 0x00004000
> >  VM_MASK		= 0x00020000
> >
> > +#ifdef CONFIG_MCOUNT
> > +.globl mcount
> > +mcount:
> > +	/* unlikely(mcount_enabled) */
> > +	cmpl $0, mcount_enabled
> > +	jnz trace
> > +	ret
>
> (and the corresponding 64-bit version)
>
> Is the impact of this change on the (already expensive) mcount_enabled
> case negligible? I worried about use cases where we want to gain some
> (relative) worst-case numbers via these instrumentations.

The goal here was to limit the instruction cache hit that we take when
mcount_enabled = 0.
>
> In my personal priority scheme, CONFIG_MCOUNT=y && !mcount_enabled comes
> after mcount_enabled.

well, actually, I disagree. I only set mcount_enabled=1 when I'm about to
test something. You're right that we want the impact of the test least
affected, but when we have mcount_enabled=1 we usually also have a
function that's attached and in that case this change is negligible. But
on the normal case where mcount_enabled=0, this change may have a bigger
impact.

Remember CONFIG_MCOUNT=y && mcount_enabled=0 is (15% overhead)
         CONFIG_MCOUNT=y && mcount_enabled=1 dummy func (49% overhead)
         CONFIG_MCOUNT=y && mcount_enabled=1 trace func (500% overhead)

The trace func is the one that will be most likely used when analyzing. It
gives hackbench a 500% overhead, so I'm expecting this change to be
negligible in that case. But after I find what's wrong, I like to rebuild
the kernel without rebooting so I like to have mcount_enabled=0 have the
smallest impact ;-)

I'll put back the original code and run some new numbers.

-- Steve

