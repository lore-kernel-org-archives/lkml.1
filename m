Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZKXBNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZKXBNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZKXBNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:13:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:58991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZKXBNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:13:09 -0500
Date: Tue, 24 Nov 2009 01:12:46 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20091119202341.GA4420@sgi.com>
References: <20091119202341.GA4420@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Call is_untracked_pat_range() rather than is_ISA_range()
Message-ID: <tip-55a6ca25472ee01574bfc24d23b7f5fa09cc38cf@git.kernel.org>
Git-Commit-ID: 55a6ca25472ee01574bfc24d23b7f5fa09cc38cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55a6ca25472ee01574bfc24d23b7f5fa09cc38cf
Gitweb:     http://git.kernel.org/tip/55a6ca25472ee01574bfc24d23b7f5fa09cc38cf
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 23 Nov 2009 15:12:07 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 23 Nov 2009 17:09:59 -0800

x86, mm: Call is_untracked_pat_range() rather than is_ISA_range()

Checkin fd12a0d69aee6d90fa9b9890db24368a897f8423 made the PAT
untracked range a platform configurable, but missed on occurrence of
is_ISA_range() which still refers to PAT-untracked memory, and
therefore should be using the configurable.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20091119202341.GA4420@sgi.com>
---
 arch/x86/include/asm/pgtable.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index af6fd36..1de2094 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -16,6 +16,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/x86_init.h>
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
@@ -270,9 +272,9 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 					 unsigned long new_flags)
 {
 	/*
-	 * PAT type is always WB for ISA. So no need to check.
+	 * PAT type is always WB for untracked ranges, so no need to check.
 	 */
-	if (is_ISA_range(paddr, paddr + size - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + size - 1))
 		return 1;
 
 	/*
