Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXIYGzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXIYGzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIYGzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:55:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:37659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXIYGza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:55:30 -0400
Date: Tue, 25 Sep 2007 08:55:29 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix CONFIG_NOHIGHMEM for extended crashkernel command line
Message-ID: <20070925065528.GA25783@suse.de>
Mail-Followup-To: akpm@linux-foundation.org,
	Laurent Riffard <laurent.riffard@free.fr>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build error with CONFIG_KEXEC=y and CONFIG_NOHIGHMEM=y.

linux-2.6-mm$ LANG=C make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      arch/i386/kernel/setup.o
arch/i386/kernel/setup.c: In function 'reserve_crashkernel':
arch/i386/kernel/setup.c:391: error: 'highend_pfn' undeclared (first use in this function)
arch/i386/kernel/setup.c:391: error: (Each undeclared identifier is reported only once
arch/i386/kernel/setup.c:391: error: for each function it appears in.)
arch/i386/kernel/setup.c:391: error: 'highstart_pfn' undeclared (first use in this function)
make[1]: *** [arch/i386/kernel/setup.o] Error 1
make: *** [arch/i386/kernel] Error 2


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/i386/kernel/setup.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -381,6 +381,20 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
+
+#ifdef CONFIG_HIGHMEM
+static inline unsigned long long get_total_mem(void)
+{
+	return (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+}
+#else
+static inline unsigned long long get_total_mem(void)
+{
+	return max_low_pfn << PAGE_SHIFT;
+}
+#endif
+
+
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
@@ -388,7 +402,7 @@ static void __init reserve_crashkernel(v
 	unsigned long long 	crash_size, crash_base;
 	int			ret;
 
-	free_mem = (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+	free_mem = get_total_mem();
 
 	ret = parse_crashkernel(boot_command_line, free_mem,
 			&crash_size, &crash_base);
