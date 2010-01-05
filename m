Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526Ab0AEUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0AEUMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518Ab0AEUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:12:00 -0500
Received: from kroah.org ([198.145.64.141]:49954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab0AEUGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.324921035@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [18/39] x86, cpuid: Add "volatile" to asm in native_cpuid()
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -179,7 +179,7 @@ static inline void native_cpuid(unsigned
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	asm("cpuid"
+	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
 	      "=c" (*ecx),


