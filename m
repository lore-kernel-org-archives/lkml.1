Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYDKLrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYDKLrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbYDKLq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:46:59 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:39546 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbYDKLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:46:58 -0400
Date: Fri, 11 Apr 2008 13:46:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] Fix compile breakage caused by asmlinkage_protect
Message-ID: <20080411114654.GA12270@osiris.boeblingen.de.ibm.com>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410223738.80A8326F992@magilla.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit 54a015104136974262afa4b8ddd943ea70dec8a2
"asmlinkage_protect replaces prevent_tail_call" causes this build failure
on s390:

  AS      arch/s390/kernel/entry64.o
In file included from arch/s390/kernel/entry64.S:14:
include/linux/linkage.h:34: error: syntax error in macro parameter list
make[1]: *** [arch/s390/kernel/entry64.o] Error 1
make: *** [arch/s390/kernel] Error 2

So just surround the new define with an #ifndef __ASSEMBLY__ to prevent
any side effects on asm code.

Cc: Roland McGrath <roland@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/linkage.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/include/linux/linkage.h
===================================================================
--- linux-2.6.orig/include/linux/linkage.h
+++ linux-2.6/include/linux/linkage.h
@@ -30,9 +30,11 @@
  * protection to work (ie no more work that the compiler might
  * end up needing stack temporaries for).
  */
+#ifndef __ASSEMBLY__
 #ifndef asmlinkage_protect
 # define asmlinkage_protect(n, ret, args...)	do { } while (0)
 #endif
+#endif
 
 #ifndef __ALIGN
 #define __ALIGN		.align 4,0x90
