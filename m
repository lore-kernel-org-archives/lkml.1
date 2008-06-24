Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbYFXOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbYFXOfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760557AbYFXOeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:34:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:34897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbYFXOet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:34:49 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 2/3] e820_update_range(): Allow specifying ULLONG_MAX
Date: Tue, 24 Jun 2008 16:35:24 +0200
Message-Id: <1214318125-32619-3-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1214318125-32619-1-git-send-email-bwalle@suse.de>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the specifying of ULLONG_MAX to limit the whole E820 map from the
specified start to the end. Without the patch, there would be integer
overflows.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/e820.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e466073..7d1109b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -397,6 +397,9 @@ int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
 	return __copy_e820_map(biosmap, nr_map);
 }
 
+/*
+ * Pass size == ULLONG_MAX to update until the end.
+ */
 u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type)
 {
@@ -412,14 +415,18 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 			continue;
 		/* totally covered? */
 		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
+		    (((ei->addr + ei->size) <= (start + size)) ||
+			    (size == ULLONG_MAX))) {
 			ei->type = new_type;
 			real_updated_size += ei->size;
 			continue;
 		}
 		/* partially covered */
 		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
+		if (size == ULLONG_MAX)
+			final_end = ei->addr + ei->size;
+		else
+			final_end = min(start + size, ei->addr + ei->size);
 		if (final_start >= final_end)
 			continue;
 		ei->size -= final_end - final_start;
-- 
1.5.4.5

