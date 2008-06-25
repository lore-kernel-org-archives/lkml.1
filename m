Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYFYMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYFYMC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYFYMBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:01:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:34707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbYFYMBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:01:45 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Date: Wed, 25 Jun 2008 14:02:22 +0200
Message-Id: <1214395342-20375-4-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1214395342-20375-1-git-send-email-bwalle@suse.de>
References: <1214395342-20375-1-git-send-email-bwalle@suse.de>
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
 arch/x86/kernel/e820.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7d1109b..19b7f05 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -979,6 +979,8 @@ static int __init parse_memopt(char *p)
 
 	mem_size = memparse(p, &p);
 	end_user_pfn = mem_size>>PAGE_SHIFT;
+	e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
+
 	return 0;
 }
 early_param("mem", parse_memopt);
@@ -1023,6 +1025,7 @@ static int __init parse_memmap_opt(char *p)
 		e820_add_region(start_at, mem_size, E820_RESERVED);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
+		e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
 	}
 	return *p == '\0' ? 0 : -EINVAL;
 }
-- 
1.5.4.5

