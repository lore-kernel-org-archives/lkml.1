Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYHMQDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYHMQDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYHMQC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:02:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYHMQCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:02:55 -0400
Date: Wed, 13 Aug 2008 18:02:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
	64b context switch optimization?
Message-ID: <20080813160218.GB18037@elte.hu>
References: <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A303EE.8070002@redhat.com>
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


* Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Ingo Molnar wrote:
> > Btw., can you see any problems with option #1: simply removing MAP_32BIT 
> > from 64-bit stack allocations in glibc unconditionally?
> 
> Yes, as we both agree, there are still such machines out there.
> 
> The real problem is: what to do if somebody complains?  If we would 
> have the extra flag such people could be accommodated.  If there is no 
> such flag then distributions cannot just add the flag (it's part of 
> the kernel API) and they would be caught between a rock and a hard 
> place. Option #2 provides the biggest flexibility.
> 
> I upstream kernel truly doesn't care about such machines anymore there
> are two options:
> 
> - - really do nothing at all

do nothing at all is not an option - thread creation can take 10 msecs 
on top-of-the-line hardware.

> - - at least reserve a flag in case somebody wants/has to implement option
>   #2

yeah, i already had a patch for that when i wrote my first mail 
[attached below] and listed it as option #4 - then erased the comment 
figuring that we'd want to do #1 ;-)

As unimplemented flags just get ignored by the kernel, if this flag goes 
into v2.6.27 as-is and is ignored by the kernel (i.e. we just use a 
plain old 64-bit [47-bit] allocation), then you could do the glibc 
change straight away, correct? So then if people complain we can fix it 
in the kernel purely.

how about this then?

	Ingo

--------------------->
Subject: mmap: add MAP_64BIT_STACK
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Aug 13 12:41:54 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/mman.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-x86/mman.h
===================================================================
--- linux.orig/include/asm-x86/mman.h
+++ linux/include/asm-x86/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_64BIT_STACK	0x20000		/* give out 32bit addresses on old CPUs */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */

