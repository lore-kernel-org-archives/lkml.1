Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYHOQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYHOQEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYHOQE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:04:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYHOQE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:04:27 -0400
Date: Fri, 15 Aug 2008 18:03:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Lokier <jamie@shareable.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
	64b context switch optimization?
Message-ID: <20080815160338.GI27955@elte.hu>
References: <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com> <20080813160218.GB18037@elte.hu> <20080815155457.GA5210@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815155457.GA5210@shareable.org>
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


* Jamie Lokier <jamie@shareable.org> wrote:

> > how about this then?
> 
> > +#define MAP_64BIT_STACK 0x20000         /* give out 32bit addresses on old CPUs */
> 
> I think the flag makes sense but it's name is confusing - 64BIT for a 
> flag which means "maybe request 32-bit stack"!  Suggest:
> 
> +#define MAP_STACK       0x20000         /* 31bit or 64bit address for stack, */
> +                                        /* whichever is faster on this CPU */

ok. I've applied the patch below to tip/x86/urgent.

> Also, is this _only_ useful for thread stacks, or are there other 
> memory allocations where 31-bitness affects execution speed on old 
> P4s?

just about anything i guess - but since those CPUs do not really matter 
anymore in terms of bleeding-edge performance, what we care about is the 
intended current use of this flag: thread stacks.

	Ingo

-------------------->
>From 4812c2fddc7f5a3a4480d541a4cb2b7e4ec21dcb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Aug 2008 18:02:18 +0200
Subject: [PATCH] x86: add MAP_STACK mmap flag

as per this discussion:

   http://lkml.org/lkml/2008/8/12/423

Pardo reported that 64-bit threaded apps, if their stacks exceed the
combined size of ~4GB, slow down drastically in pthread_create() - because
glibc uses MAP_32BIT to allocate the stacks. The use of MAP_32BIT is
a legacy hack - to speed up context switching on certain early model
64-bit P4 CPUs.

So introduce a new flag to be used by glibc instead, to not constrain
64-bit apps like this.

glibc can switch to this new flag straight away - it will be ignored
by the kernel. If those old CPUs ever matter to anyone, support for
it can be implemented.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/mman.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/mman.h b/include/asm-x86/mman.h
index c1682b5..e5852b5 100644
--- a/include/asm-x86/mman.h
+++ b/include/asm-x86/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out 32bit stack addresses on old CPUs */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
