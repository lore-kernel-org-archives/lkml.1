Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221Ab0AEA41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0AEA41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002Ab0AEA4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:56:18 -0500
Received: from kroah.org ([198.145.64.141]:34094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab0AEAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/97] x86, cpuid: Add "volatile" to asm in native_cpuid()
Date: Mon,  4 Jan 2010 16:32:19 -0800
Message-Id: <1262651630-7354-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 45a94d7cd45ed991914011919e7d40eb6d2546d1 upstream.

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
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/processor.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c978648..13b1885 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -180,7 +180,7 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	asm("cpuid"
+	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
 	      "=c" (*ecx),
-- 
1.6.6

