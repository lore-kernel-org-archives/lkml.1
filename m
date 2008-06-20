Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYFTP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYFTP4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbYFTP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:56:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:56875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbYFTP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:24 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Date: Fri, 20 Jun 2008 17:57:00 +0200
Message-Id: <1213977420-1555-4-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213977420-1555-1-git-send-email-bwalle@suse.de>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings back limiting of the E820 map when a user-defined
E820 map is specified. While the behaviour of i386 (32 bit) was to limit
the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
limit.

That patch limits the E820 map again for both x86 architectures.

Code was tested for compilation and booting on a 32 bit and 64 bit system.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/e820.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index f5b1736..2e7d385 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -934,6 +934,33 @@ static void early_panic(char *msg)
 	panic(msg);
 }
 
+void __init e820_limit_regions(unsigned long long size)
+{
+	unsigned long long current_addr;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		current_addr = e820.map[i].addr + e820.map[i].size;
+		if (current_addr < size)
+			continue;
+
+		if (e820.map[i].type != E820_RAM)
+			continue;
+
+		if (e820.map[i].addr >= size) {
+			/*
+			 * This region starts past the end of the
+			 * requested size, skip it completely.
+			 */
+			e820.nr_map = i;
+		} else {
+			e820.nr_map = i + 1;
+			e820.map[i].size -= current_addr - size;
+		}
+		return;
+	}
+}
+
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
@@ -951,6 +978,8 @@ static int __init parse_memopt(char *p)
 
 	mem_size = memparse(p, &p);
 	end_user_pfn = mem_size>>PAGE_SHIFT;
+	e820_limit_regions(mem_size);
+
 	return 0;
 }
 early_param("mem", parse_memopt);
@@ -995,6 +1024,7 @@ static int __init parse_memmap_opt(char *p)
 		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
+		e820_limit_regions(mem_size);
 	}
 	return *p == '\0' ? 0 : -EINVAL;
 }
-- 
1.5.4.5

