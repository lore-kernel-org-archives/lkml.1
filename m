Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZDOOMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZDOOMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZDOOMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:12:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZDOOMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:12:03 -0400
Date: Wed, 15 Apr 2009 16:09:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Message-ID: <20090415140959.GD12760@elte.hu>
References: <20090415120307.GB17775@elte.hu> <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com> <1488.1239801659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488.1239801659@redhat.com>
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


* David Howells <dhowells@redhat.com> wrote:

> > There's three too 'thick' headers: linux/percpu.h, 
> > linux/prefetch.h and asm/processor.h.
> 
> Yes, I noticed.
> 
> linux/percpu.h needs to be split three ways for instance: 
> definitions, access methods, and alocators.

yeah. Often a super-header has to be split into several basic 
headers or header pairs.

> linux/prefetch.h isn't too bad: what it needs is the prefetch 
> stuff splitting out of asm/processor.h into asm/prefetch.h.

yeah.

> > Please create include/linux/percpu_types.h for basic data types 
> > and simple, self-sufficient primitives. Also have an 
> > include/linux/percpu_api.h or include/linux/percpu.h include 
> > file for convenience/speedup inlines. The latter will only be 
> > included in .c files, where 'combination' of type spaces is not 
> > a problem.
> 
> Not so.  The problem is that various header files make use of 
> per-cpu variable accessors (asm/current.h and asm/thread_info.h to 
> name a couple) to build inline asm.

Hm, what portion did you mark with 'not so'?

inline asm is used in inline functions there, and that is what 
'instantiates' the types in a 'mixed' manner and way below their 
proper hierarchic level as well - creating both a mess and, as mess 
increases above a critical threshold an inevitable circular 
dependency as well.

> Anyway, here are a pair of patches on top of the one I've already 
> sent to Linus.  The second breaks a number of header files into 
> pieces and rearranges the percpu headers to put the DECLARE and 
> DEFINE macros together.
> 
> The first patch could potentially be applied immediately.  It adds 
> #inclusions and forward refs that are required to iron out compile 
> errors from the second patch.
> 
> Note that these only work for the configuration I routinely use on 
> my x86_64 test machine.  It will break all other arches and many 
> other i386 and x86_64 configurations.

I dont disagree, but i'd like to warn that such patches need _way_ 
more testing, these are never same-day obvious patches.

We have split up one big x86 header in this development cycle 
(asm/pgtable.h) and that alone was highly non-trivial and needed 
about a week to settle down, even with intense development and 
testing.

	Ingo
