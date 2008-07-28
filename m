Return-Path: <linux-kernel-owner+w=401wt.eu-S1762672AbYG1VVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762672AbYG1VVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbYG1VSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:18:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762182AbYG1VSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:18:07 -0400
Date: Mon, 28 Jul 2008 17:11:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Terry Loftin <terry.loftin@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/5] x86: Define elfcorehdr_addr in arch dependent section
Message-ID: <20080728211156.GB9985@redhat.com>
References: <20080727234529.GM6175@verge.net.au> <20080728015117.GA12055@verge.net.au> <20080728024526.GB3334@verge.net.au> <20080728034007.GA30450@verge.net.au> <20080728211025.GA9985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728211025.GA9985@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



o Move elfcorehdr_addr definition in arch dependent crash dump file. This is
  equivalent to defining elfcorehdr_addr under CONFIG_CRASH_DUMP instead of
  CONFIG_PROC_VMCORE. This is needed by is_kdump_kernel() which can be
  used irrespective of the fact whether CONFIG_PROC_VMCORE is enabled or
  not.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---

 arch/x86/kernel/crash_dump_32.c |    3 +++
 arch/x86/kernel/crash_dump_64.c |    3 +++
 arch/x86/kernel/setup.c         |    8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/setup.c~fix-elfcorehdr_addr-parsing-x86 arch/x86/kernel/setup.c
--- linux-2.6.27-pre-rc1/arch/x86/kernel/setup.c~fix-elfcorehdr_addr-parsing-x86	2008-07-28 12:01:35.000000000 -0400
+++ linux-2.6.27-pre-rc1-root/arch/x86/kernel/setup.c	2008-07-28 12:01:35.000000000 -0400
@@ -558,7 +558,13 @@ static void __init reserve_standard_io_r
 
 }
 
-#ifdef CONFIG_PROC_VMCORE
+/*
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence
+ * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+
+#ifdef CONFIG_CRASH_DUMP
 /* elfcorehdr= specifies the location of elf core header
  * stored by the crashed kernel. This option will be passed
  * by kexec loader to the capture kernel.
diff -puN arch/x86/kernel/crash_dump_32.c~fix-elfcorehdr_addr-parsing-x86 arch/x86/kernel/crash_dump_32.c
--- linux-2.6.27-pre-rc1/arch/x86/kernel/crash_dump_32.c~fix-elfcorehdr_addr-parsing-x86	2008-07-28 12:01:35.000000000 -0400
+++ linux-2.6.27-pre-rc1-root/arch/x86/kernel/crash_dump_32.c	2008-07-28 12:01:35.000000000 -0400
@@ -13,6 +13,9 @@
 
 static void *kdump_buf_page;
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
diff -puN arch/x86/kernel/crash_dump_64.c~fix-elfcorehdr_addr-parsing-x86 arch/x86/kernel/crash_dump_64.c
--- linux-2.6.27-pre-rc1/arch/x86/kernel/crash_dump_64.c~fix-elfcorehdr_addr-parsing-x86	2008-07-28 12:01:35.000000000 -0400
+++ linux-2.6.27-pre-rc1-root/arch/x86/kernel/crash_dump_64.c	2008-07-28 12:01:35.000000000 -0400
@@ -11,6 +11,9 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+/* Stores the physical address of elf header of crash image. */
+unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
+
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
_
