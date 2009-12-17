Return-Path: <linux-kernel-owner+w=401wt.eu-S1763561AbZLQBBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561AbZLQBBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763530AbZLQBBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:01:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:35279 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763556AbZLQBBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:01:25 -0500
Date: Thu, 17 Dec 2009 01:01:12 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1261009542.2745.55.camel@sbs-t61.sc.intel.com>
References: <1261009542.2745.55.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpuid: Add "volatile" to asm in native_cpuid()
Message-ID: <tip-45a94d7cd45ed991914011919e7d40eb6d2546d1@git.kernel.org>
Git-Commit-ID: 45a94d7cd45ed991914011919e7d40eb6d2546d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45a94d7cd45ed991914011919e7d40eb6d2546d1
Gitweb:     http://git.kernel.org/tip/45a94d7cd45ed991914011919e7d40eb6d2546d1
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 16 Dec 2009 16:25:42 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 16 Dec 2009 16:30:57 -0800

x86, cpuid: Add "volatile" to asm in native_cpuid()

xsave_cntxt_init() does something like:

	cpuid(0xd, ..);	// find out what features FP/SSE/.. etc are supported

	xsetbv();	// enable the features known to OS

	cpuid(0xd, ..);	// find out the size of the context for features enabled

Depending on what features get enabled in xsetbv(), value of the
cpuid.eax=0xd.ecx=0.ebx changes correspondingly (representing the
size of the context that is enabled).

As we don't have volatile keyword for native_cpuid(), gcc 4.1.2
optimizes away the second cpuid and the kernel continues to use
the cpuid information obtained before xsetbv(), ultimately leading to kernel
crash on processors supporting more state than the legacy FP/SSE.

Add "volatile" for native_cpuid().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1261009542.2745.55.camel@sbs-t61.sc.intel.com>
Cc: stable@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/processor.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6f8ec1c..fc801ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -181,7 +181,7 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	asm("cpuid"
+	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
 	      "=c" (*ecx),
