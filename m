Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbZFHRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbZFHRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZFHRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:10:39 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:8163 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750715AbZFHRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:10:39 -0400
X-SpamScore: 19
X-BigFish: VPS19(zz936eN8b9dn7cf0izz1202hzz3198u327alz32i6bh17ch63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KKXJPC-02-KJY-01
Date: Mon, 8 Jun 2009 19:09:39 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: memtest: remove 64-bit division
Message-ID: <20090608170939.GB12431@alberich.amd.com>
References: <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org> <200906050339.n553d684048041@www262.sakura.ne.jp> <20090604205103.bbfe9af2.akpm@linux-foundation.org> <200906050400.n5540Sx0052981@www262.sakura.ne.jp> <20090604212018.b9e9f354.akpm@linux-foundation.org> <200906050651.n556p7Vo094549@www262.sakura.ne.jp> <20090605000310.a5b8fa56.akpm@linux-foundation.org> <20090605093725.GC23657@alberich.amd.com> <20090605102440.58a6e443.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090605102440.58a6e443.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 Jun 2009 17:10:28.0255 (UTC) FILETIME=[056EC2F0:01C9E85C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gcc 3.3.5 a "make allmodconfig" + "CONFIG_KVM=n"
triggers a build error:

 arch/x86/mm/built-in.o(.init.text+0x43f7): In function `__change_page_attr':
 arch/x86/mm/pageattr.c:114: undefined reference to `__udivdi3'
 make: *** [.tmp_vmlinux1] Error 1

The culprit turned out to be a division in arch/x86/mm/memtest.c
For more info see this thread
http://marc.info/?l=linux-kernel&m=124416232620683

The patch entirely removes the division that caused the build
error.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/memtest.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 605c8be..c0bedcd 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -40,23 +40,23 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 {
-	u64 i, count;
-	u64 *start;
+	u64 *p;
+	void *start, *end;
 	u64 start_bad, last_bad;
 	u64 start_phys_aligned;
 	size_t incr;
 
 	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
-	count = (size - (start_phys_aligned - start_phys))/incr;
 	start = __va(start_phys_aligned);
+	end = start + size - (start_phys_aligned - start_phys);
 	start_bad = 0;
 	last_bad = 0;
 
-	for (i = 0; i < count; i++)
-		start[i] = pattern;
-	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start == pattern)
+	for (p = start; p < end; p++)
+		*p = pattern;
+	for (p = start; p < end; p++, start_phys_aligned += incr) {
+		if (*p == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
-- 
1.6.3.1



