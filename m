Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYC2AOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYC2AOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYC2AOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:14:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYC2AOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:14:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/4] set_restore_sigmask TIF_SIGPENDING
In-Reply-To: Roland McGrath's message of  Friday, 28 March 2008 17:12:30 -0700 <20080329001230.D013726FA1D@magilla.localdomain>
References: <20080329001230.D013726FA1D@magilla.localdomain>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20080329001341.7F93826FA1D@magilla.localdomain>
Date: Fri, 28 Mar 2008 17:13:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set TIF_SIGPENDING in set_restore_sigmask.  This lets arch code take
TIF_RESTORE_SIGMASK out of the set of bits that will be noticed on
return to user mode.  On some machines those bits are scarce, and we
can free this unneeded one up for other uses.

It is probably the case that TIF_SIGPENDING is always set anyway
everywhere set_restore_sigmask() is used.  But this is some cheap
paranoia in case there is an arcane case where it might not be.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/thread_info.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index d82c073..4a89477 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -85,11 +85,17 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
  * set_restore_sigmask() - make sure saved_sigmask processing gets done
  *
  * This sets TIF_RESTORE_SIGMASK and ensures that the arch signal code
- * will run before returning to user mode, to process the flag.
+ * will run before returning to user mode, to process the flag.  For
+ * all callers, TIF_SIGPENDING is already set or it's no harm to set
+ * it.  TIF_RESTORE_SIGMASK need not be in the set of bits that the
+ * arch code will notice on return to user mode, in case those bits
+ * are scarce.  We set TIF_SIGPENDING here to ensure that the arch
+ * signal code always gets run when TIF_RESTORE_SIGMASK is set.
  */
 static inline void set_restore_sigmask(void)
 {
 	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_thread_flag(TIF_SIGPENDING);
 }
 #endif	/* TIF_RESTORE_SIGMASK */
 
