Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXJJCAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXJJCAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXJJCAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:00:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:37119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXJJCAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,251,1188802800"; 
   d="scan'208";a="295680058"
Date: Tue, 9 Oct 2007 18:59:22 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: ak@suse.de, akpm@linux-foundation.org
Cc: yanmin.zhang@intel.com, vgoyal@in.ibm.com, linux-kernel@vger.kernel.org
Subject: [patch] x86_64, vsyscall: fix the oops crash with __pa_vsymbol()
Message-ID: <20071010015922.GC30676@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Appended patch fixes an oops while changing the vsyscall sysctl.
I am sure no one tested this code before integrating into mainline :(

BTW, using ioremap() in vsyscall_sysctl_change() to get the virtual
address of a kernel symbol sounds like an over kill.. I wonder if we
can define a simple __va_vsymbol() which will return directly the
kernel direct mapping. comments in the code which says gcc has trouble
with __va(__pa()) sounds bogus to me. __pa() on a vsyscall address will
not work anyhow :(

And also, the whole nop out syscall in vsyscall page infrastructure
(vsyscall_sysctl_change()) is added to make some attacks difficult,
and yet I don't see this nop out being done by default. This area
requires more cleanups?

thanks,
suresh
---

Fix an oops with __pa_vsymbol(). VSYSCALL_FIRST_PAGE is a fixmap index.
We want the starting virtual address of the vsyscall page and not the index.

Reported-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 06c3494..9dfbad5 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -50,7 +50,7 @@
 	({unsigned long v;  		\
 	extern char __vsyscall_0; 	\
 	  asm("" : "=r" (v) : "0" (x)); \
-	  ((v - VSYSCALL_FIRST_PAGE) + __pa_symbol(&__vsyscall_0)); })
+	  ((v - VSYSCALL_START) + __pa_symbol(&__vsyscall_0)); })
 
 /*
  * vsyscall_gtod_data contains data that is :
