Return-Path: <linux-kernel-owner+w=401wt.eu-S966480AbXJSOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966480AbXJSOwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964999AbXJSOwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:52:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:51552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbXJSOwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:52:22 -0400
Date: Fri, 19 Oct 2007 16:52:20 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       kexec@lists.infradead.org
Subject: [PATCH] Use BOOTMEM_EXCLUSIVE for crashkernel reservation
Message-ID: <20071019145220.GA14691@suse.de>
Mail-Followup-To: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
	kexec@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the usage of BOOTMEM_EXCLUSIVE for crashkernel
reservation on other architectures. The only architecture that applies
is sh.

The patch is based on current git tree plus
kexec-introduce-bootmem_exclusive.patch from -mm tree.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/sh/kernel/setup.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -140,19 +140,26 @@ static void __init reserve_crashkernel(v
 	ret = parse_crashkernel(boot_command_line, free_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(free_mem >> 20));
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(free_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
 	}
 }
 #else
