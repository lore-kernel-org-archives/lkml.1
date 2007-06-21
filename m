Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbXFUT6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbXFUT6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXFUT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:57:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbXFUT54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:57:56 -0400
Date: Thu, 21 Jun 2007 21:56:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621195659.GA22303@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Umm. i386 spinlocks could and should be *one*byte*.
> 
> In fact, I don't even know why they are wasting four bytes right now: 
> the fact that somebody made them an "int" just wastes memory. All the 
> actual code uses "decb", so it's not even a question of safety. I 
> wonder why we have that 32-bit thing and the ugly casts.
> 
> Ingo, any memory of that?

no real reason that i can recall - i guess nobody dared to touch it 
because it used to have that 'volatile', indicating black voodoo ;-) Now 
that the bad stigma has been removed, we could try the patch below. It 
boots fine here, and we save 1K of kernel text size:

     text    data     bss     dec     hex filename
  6236003  611992  401408 7249403  6e9dfb vmlinux.before
  6235075  611992  401408 7248475  6e9a5b vmlinux.after

I can understand why no data is saved by this change: gcc is aligning 
the next field to a natural boundary anyway and we dont really have 
arrays of spinlocks (fortunately). [and we save no data even if using 
the ((packed)) attribute.] Perhaps some data structure that is never in 
the kernel image itself still got smaller? Any good way to determine 
that?

But why is the text size different? Ah: i think it's spin_lock_init() 
getting shorter :-)

but this is certainly not something for 2.6.22, it's an early 2.6.23 
matter i suspect.

	Ingo

------------------->
From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] spinlocks i386: change them to byte fields

all spinlock ops are on byte operands, so change the spinlock field to 
be unsigned char. This saves a bit of kernel text size:

   text    data     bss     dec     hex filename
6236003  611992  401408 7249403  6e9dfb vmlinux.before
6235075  611992  401408 7248475  6e9a5b vmlinux.after

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-i386/spinlock_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-i386/spinlock_types.h
===================================================================
--- linux.orig/include/asm-i386/spinlock_types.h
+++ linux/include/asm-i386/spinlock_types.h
@@ -6,7 +6,7 @@
 #endif
 
 typedef struct {
-	unsigned int slock;
+	unsigned char slock;
 } raw_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 1 }
