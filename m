Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZCNLke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZCNLke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZCNLkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:40:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZCNLkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:40:03 -0400
Date: Sat, 14 Mar 2009 11:39:24 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B9F0C1.10402@kernel.org>
References: <49B9F0C1.10402@kernel.org>
Subject: [tip:x86/mm] x86: make e820_update_range() handle small range update
Message-ID: <tip-78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742@git.kernel.org>
Git-Commit-ID: 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 11:39:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Gitweb:     http://git.kernel.org/tip/78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 12 Mar 2009 22:36:01 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 12:20:07 +0100

x86: make e820_update_range() handle small range update

Impact: enhance e820 code to handle more cases

Try to handle new range which could be covered by one entry.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: jbeulich@novell.com
LKML-Reference: <49B9F0C1.10402@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 95b81c1..0c34ff4 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -427,6 +427,7 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 					u64 size, unsigned old_type,
 					unsigned new_type)
 {
+	u64 end;
 	unsigned int i;
 	u64 real_updated_size = 0;
 
@@ -435,21 +436,35 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
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
 
