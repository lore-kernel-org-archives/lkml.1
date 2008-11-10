Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKJVf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKJVf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYKJVfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:35:07 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21309 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYKJVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:35:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 10 Nov 2008 16:34:54 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
In-reply-to: <20081109204256.89ab7925.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811101627510.13034@xanadu.home>
References: <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
 <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
 <20081109022549.GA18508@Krystal>
 <alpine.LFD.2.00.0811082143320.13034@xanadu.home>
 <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
 <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
 <20081109064855.GA23782@Krystal>
 <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
 <20081109162250.GB10181@Krystal>
 <alpine.LFD.2.00.0811092304300.13034@xanadu.home>
 <20081109204256.89ab7925.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Andrew Morton wrote:

> On Sun, 09 Nov 2008 23:20:00 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:
> 
> > On Sun, 9 Nov 2008, Mathieu Desnoyers wrote:
> > 
> > > * Nicolas Pitre (nico@cam.org) wrote:
> > > > Do you really have such instances where multiple call sites are needed?  
> > > > That sounds even more confusing to me than the current model.  Better 
> > > > encapsulate the usage of this macro within some function which has a 
> > > > stronger meaning, such as sched_clock(), and call _that_ from multiple 
> > > > sites instead.
> > > 
> > > I see a few reasons for it :
> > > 
> > > - If we want to inline the whole read function so we don't pay the extra
> > >   runtime cost of a function call, this would become required.
> > 
> > You can inline it as you want as long as it remains in the same .c file.  
> > The static variable is still shared amongst all call sites in that case.
> 
> Please don't rely upon deep compiler behaviour like that.  It is
> unobvious to the reader and it might break if someone uses it incorrectly,
> or if the compiler implementation changes, or if a non-gcc compiler is
> used, etc.

If a compiler doesn't reference the same storage for a static variable 
used by a function that gets inlined in the same compilation unit then 
it is utterly broken.

> It is far better to make the management of the state explicit and at
> the control of the caller.  Get the caller to allocate the state and
> pass its address into this function.  Simple, clear, explicit and
> robust.

Sigh...  What about this compromize then?

diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index 7605fdd..74ce767 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -32,8 +32,9 @@ union cnt32_to_63 {
 
 
 /**
- * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
+ * __cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
  * @cnt_lo: The low part of the counter
+ * @cnt_hi_p: Pointer to storage for the extended part of the counter
  *
  * Many hardware clock counters are only 32 bits wide and therefore have
  * a relatively short period making wrap-arounds rather frequent.  This
@@ -75,16 +76,31 @@ union cnt32_to_63 {
  * clear-bit instruction. Otherwise caller must remember to clear the top
  * bit explicitly.
  */
-#define cnt32_to_63(cnt_lo) \
+#define __cnt32_to_63(cnt_lo, cnt_hi_p) \
 ({ \
-	static u32 __m_cnt_hi; \
 	union cnt32_to_63 __x; \
-	__x.hi = __m_cnt_hi; \
+	__x.hi = *(cnt_hi_p); \
  	smp_rmb(); \
 	__x.lo = (cnt_lo); \
 	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
-		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
+		*(cnt_hi_p) = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
 	__x.val; \
 })
 
+/**
+ * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
+ * @cnt_lo: The low part of the counter
+ *
+ * This is the same as __cnt32_to_63() except that the storage for the
+ * extended part of the counter is implicit.  Because this uses a static
+ * variable, a user of this code must not be an inline function unless
+ * that function is contained in a single .c file for a given counter.
+ * All usage requirements for __cnt32_to_63() also apply here as well.
+ */
+#define cnt32_to_63(cnt_lo) \
+({ \
+	static u32 __m_cnt_hi; \
+	__cnt32_to_63(cnt_lo, &__m_cnt_hi); \
+})
+
 #endif

Nicolas
