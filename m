Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbXDKIxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbXDKIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXDKIxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:23 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1560 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXDKIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:21 -0400
Date: Wed, 11 Apr 2007 12:29:35 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ALPHA: "prctl" macros
Message-ID: <20070411122935.E17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

include/asm-alpha/thread_info.h

	Provide "prctl" macros for ALPHA.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/include/asm-alpha/thread_info.h b/include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/thread_info.h	2007-03-19 14:57:30.000000000 -0400
@@ -92,5 +92,27 @@ register struct thread_info *__current_t
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
 				 | _TIF_SYSCALL_TRACE)
 
+#define ALPHA_UAC_SHIFT		6
+#define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
+				 1 << TIF_UAC_SIGBUS)
+
+#define SET_UNALIGN_CTL(task,value)	({				     \
+	(task)->thread_info->flags = (((task)->thread_info->flags &	     \
+		~ALPHA_UAC_MASK)					     \
+		| (((value) << ALPHA_UAC_SHIFT)       & (1<<TIF_UAC_NOPRINT))\
+		| (((value) << (ALPHA_UAC_SHIFT + 1)) & (1<<TIF_UAC_SIGBUS)) \
+		| (((value) << (ALPHA_UAC_SHIFT - 1)) & (1<<TIF_UAC_NOFIX)));\
+	0; })
+
+#define GET_UNALIGN_CTL(task,value)	({				\
+	put_user(((task)->thread_info->flags & (1 << TIF_UAC_NOPRINT))	\
+		  >> ALPHA_UAC_SHIFT					\
+		 | ((task)->thread_info->flags & (1 << TIF_UAC_SIGBUS))	\
+		 >> (ALPHA_UAC_SHIFT + 1)				\
+		 | ((task)->thread_info->flags & (1 << TIF_UAC_NOFIX))	\
+		 >> (ALPHA_UAC_SHIFT - 1),				\
+		 (int __user *)(value));				\
+	})
+
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_THREAD_INFO_H */
