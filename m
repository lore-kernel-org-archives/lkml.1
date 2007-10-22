Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbXJVS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbXJVS43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXJVS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:56:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:8511 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbXJVS4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:56:20 -0400
Subject: Re: [RT] seqlocks: use of PICK_FUNCTION breaks kernel compile when
	CONFIG_GENERIC_TIME is NOT set
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Remy Bohmer <linux@bohmer.net>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0710171133490.26554@gandalf.stny.rr.com>
References: <1192632502.17527.129.camel@imap.mvista.com>
	 <1192633836.8265.6.camel@localhost.localdomain>
	 <1192634645.17527.134.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0710171133490.26554@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 11:53:03 -0700
Message-Id: <1193079183.5028.65.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 11:34 -0400, Steven Rostedt wrote:

> 
> Hmm, what about a __seq_irqsave_raw and __seq_nop?
> 
> That way it spells out that irqs are NOT touched if it is not a raw lock.

I took out the nop , and just did a save flags which makes sense.. There
is still more cleanup to do in that regard.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/seqlock.h |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

Index: linux-2.6.23/include/linux/seqlock.h
===================================================================
--- linux-2.6.23.orig/include/linux/seqlock.h
+++ linux-2.6.23/include/linux/seqlock.h
@@ -92,8 +92,11 @@ static inline void __write_seqlock(seqlo
 
 static __always_inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
 {
+	unsigned long flags;
+
+	local_save_flags(flags);
 	__write_seqlock(sl);
-	return 0;
+	return flags;
 }
 
 static inline void __write_sequnlock(seqlock_t *sl)
@@ -280,26 +283,27 @@ do {								\
 	PICK_SEQ_OP(__write_sequnlock_irq_raw, __write_sequnlock, lock)
 
 static __always_inline
-unsigned long __read_seqbegin_irqsave_raw(raw_seqlock_t *sl)
+unsigned long __seq_irqsave_raw(raw_seqlock_t *sl)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__read_seqbegin_raw(sl);
 	return flags;
 }
 
-static __always_inline unsigned long __read_seqbegin_irqsave(seqlock_t *sl)
+static __always_inline unsigned long __seq_irqsave(seqlock_t *sl)
 {
-	__read_seqbegin(sl);
-	return 0;
+	unsigned long flags;
+
+	local_save_flags(flags);
+	return flags;
 }
 
-#define read_seqbegin_irqsave(lock, flags)			\
-do {								\
-	flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,	\
-		__read_seqbegin_irqsave, lock);			\
-} while (0)
+#define read_seqbegin_irqsave(lock, flags)				\
+({									\
+	flags = PICK_SEQ_OP_RET(__seq_irqsave_raw, __seq_irqsave, lock);\
+	read_seqbegin(lock);						\
+})
 
 static __always_inline int
 __read_seqretry_irqrestore(seqlock_t *sl, unsigned iv, unsigned long flags)


