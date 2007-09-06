Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbXIFVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbXIFVxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932531AbXIFVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:53:12 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:41789 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbXIFVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:53:11 -0400
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 17:53:10 EDT
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: x86_64: Remove unnecessary cast in prefetch()
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Fri, 07 Sep 2007 01:27:02 +0400
Message-ID: <87tzq7cwnt.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is ok to call prefetch() function with NULL argument, as specifically
commented in include/linux/prefetch.h.  But in standard C, it is invalid to
dereference NULL pointer (see C99 standard 6.5.3.2 paragraph 4 and note #84).
Newer gcc versions (4.3 and above) will use that to conclude that "x"
argument is non-null and thus wreaking havok everywhere prefetch() was inlined.
Fixed by removing cast and changing asm constraint.

This can be fixed better by using gcc's __builtin_prefetch().

Signed-off-by: Serge Belyshev <belyshev@depni.sinp.msu.ru>

---
 include/asm-x86_64/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -373,7 +373,7 @@ static inline void sync_core(void)
 #define ARCH_HAS_PREFETCH
 static inline void prefetch(void *x) 
 { 
-	asm volatile("prefetcht0 %0" :: "m" (*(unsigned long *)x));
+	asm volatile("prefetcht0 (%0)" :: "r" (x));
 } 
 
 #define ARCH_HAS_PREFETCHW 1
