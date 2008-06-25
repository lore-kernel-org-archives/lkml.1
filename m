Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYFYTiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYFYTiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYFYTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:38:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:34247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYFYTij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:38:39 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       kexec@lists.infradead.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: Limit E820 map when a user-defined memory map is specified
Date: Wed, 25 Jun 2008 21:39:16 +0200
Message-Id: <1214422756-10923-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
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
 arch/x86/kernel/e820.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a1b0548..3771386 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -988,6 +988,9 @@ static int __init parse_memopt(char *p)
 
 	mem_size = memparse(p, &p);
 	end_user_pfn = mem_size>>PAGE_SHIFT;
+	e820_update_range(mem_size, ULLONG_MAX - mem_size,
+		E820_RAM, E820_RESERVED);
+
 	return 0;
 }
 early_param("mem", parse_memopt);
@@ -1032,6 +1035,8 @@ static int __init parse_memmap_opt(char *p)
 		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
+		e820_update_range(mem_size, ULLONG_MAX - mem_size,
+			E820_RAM, E820_RESERVED);
 	}
 	return *p == '\0' ? 0 : -EINVAL;
 }
-- 
1.5.4.5

