Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZCMFhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZCMFhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZCMFhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:37:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:46001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbZCMFhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:37:09 -0400
Message-ID: <49B9F0C1.10402@kernel.org>
Date: Thu, 12 Mar 2009 22:36:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: jbeulich@novell.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make e820_update_range to handle small range update
References: <49B9E286.502@kernel.org> <tip-773e673de27297d07d852e7e9bfd1a695cae1da2@git.kernel.org>
In-Reply-To: <tip-773e673de27297d07d852e7e9bfd1a695cae1da2@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: enhance to handle more case.

try to handle new range could be covered by one entry.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -427,6 +427,7 @@ static u64 __init __e820_update_range(st
 					u64 size, unsigned old_type,
 					unsigned new_type)
 {
+	u64 end;
 	unsigned int i;
 	u64 real_updated_size = 0;
 
@@ -435,21 +436,35 @@ static u64 __init __e820_update_range(st
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
+	end = start + size;
 	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
 		u64 final_start, final_end;
+		u64 ei_end;
+
 		if (ei->type != old_type)
 			continue;
-		/* totally covered? */
-		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
+
+		ei_end = ei->addr + ei->size;
+		/* totally covered by new range? */
+		if (ei->addr >= start && ei_end <= end) {
 			ei->type = new_type;
 			real_updated_size += ei->size;
 			continue;
 		}
+
+		/* new range is totally covered? */
+		if (ei->addr < start && ei_end > end) {
+			__e820_add_region(e820x, start, size, new_type);
+			__e820_add_region(e820x, end, ei_end - end, ei->type);
+			ei->size = start - ei->addr;
+			real_updated_size += size;
+			continue;
+		}
+
 		/* partially covered */
 		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
+		final_end = min(end, ei_end);
 		if (final_start >= final_end)
 			continue;
 
