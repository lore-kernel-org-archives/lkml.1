Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbYFXOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbYFXOfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbYFXOev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:34:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYFXOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:34:48 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 3/3] Limit E820 map when a user-defined memory map is specified
Date: Tue, 24 Jun 2008 16:35:25 +0200
Message-Id: <1214318125-32619-4-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1214318125-32619-1-git-send-email-bwalle@suse.de>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
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

