Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXJPQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXJPQyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXJPQyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:54:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:61228 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363AbXJPQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:54:32 -0400
Subject: Re: [RT] seqlocks: use of PICK_FUNCTION breaks kernel compile when
	CONFIG_GENERIC_TIME is NOT set
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <3efb10970710160135q31fd3982h17fa23768960186d@mail.gmail.com>
References: <3efb10970710160135q31fd3982h17fa23768960186d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 09:52:46 -0700
Message-Id: <1192553566.17527.114.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 10:35 +0200, Remy Bohmer wrote:
> Hello Daniel and Ingo,
> 
> I use 2.6.23-rt1 and the patch of Daniel below which seems to be in
> there breaks the compilation of the RT-kernel when CONFIG_GENERIC_TIME
> is NOT set.
> 
> It breaks in the do_gettimeofday(struct timeval *tv) code in the
> architecture specific code
> where there is a call to: seq = read_seqbegin_irqsave(&xtime_lock, flags);
> The PICK_FUNCTION implementation does not return anything, so the
> compile breaks here.
> 
> I am figuring out how to solve this problem nicely, but I have not
> found a nice solution yet. Attached I have put my hack to make it
> compile on ARM again, but maybe one of you can do a better proposal to
> fix this.

Here's another fix for this. I compile tested for ARM (!GENERIC_TIME) ,
but I didn't boot test .. Could you boot test this patch?

---

Move the read_seqbegin() call up in the chain so the value 
can be returned

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/seqlock.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.23/include/linux/seqlock.h
===================================================================
--- linux-2.6.23.orig/include/linux/seqlock.h
+++ linux-2.6.23/include/linux/seqlock.h
@@ -285,21 +285,20 @@ unsigned long __read_seqbegin_irqsave_ra
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__read_seqbegin_raw(sl);
 	return flags;
 }
 
 static __always_inline unsigned long __read_seqbegin_irqsave(seqlock_t *sl)
 {
-	__read_seqbegin(sl);
 	return 0;
 }
 
 #define read_seqbegin_irqsave(lock, flags)			\
-do {								\
+({								\
 	flags = PICK_SEQ_OP_RET(__read_seqbegin_irqsave_raw,	\
 		__read_seqbegin_irqsave, lock);			\
-} while (0)
+	read_seqbegin(lock);					\
+})
 
 static __always_inline int
 __read_seqretry_irqrestore(seqlock_t *sl, unsigned iv, unsigned long flags)


