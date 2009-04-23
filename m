Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZDWR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZDWR1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZDWR1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:27:42 -0400
Received: from sous-sol.org ([216.99.217.87]:49639 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbZDWR1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:27:42 -0400
Date: Thu, 23 Apr 2009 10:21:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Message-ID: <20090423172138.GR3036@sequoia.sous-sol.org>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com> <49F09C35.1080006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F09C35.1080006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> OK, the good news is that its not a callee-save calling convention  
> problem, which is what I feared.  But it does sound pretty awkward to  
> fix.  Does __native_flush_tlb_global() have to use  
> raw_local_irq_save/restore?

Vaguely related...makes sense to do native_(read/write)_cr4 since it's
the native tlb flushing implementation, no?

looks ok from inspection, not tested yet...

thanks,
-chris
--

Subject: [PATCH] x86: use native register access for native tlb flushing

currently these are paravirtulaized, doesn't appear any callers rely on
this (no pv_ops backends are using native_tlb and overriding cr3/4
access).

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/include/asm/tlbflush.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 16a5c84..a5ecc9c 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,7 +17,7 @@
 
 static inline void __native_flush_tlb(void)
 {
-	write_cr3(read_cr3());
+	native_write_cr3(native_read_cr3());
 }
 
 static inline void __native_flush_tlb_global(void)
@@ -32,11 +32,11 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = read_cr4();
+	cr4 = native_read_cr4();
 	/* clear PGE */
-	write_cr4(cr4 & ~X86_CR4_PGE);
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
-	write_cr4(cr4);
+	native_write_cr4(cr4);
 
 	raw_local_irq_restore(flags);
 }
