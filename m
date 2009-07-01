Return-Path: <linux-kernel-owner+w=401wt.eu-S1764824AbZGAA60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764824AbZGAA60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbZGAAeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:46 -0400
Received: from kroah.org ([198.145.64.141]:60333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761387AbZGAAep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:26 2009
Message-Id: <20090701002426.050559424@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yinghai@kernel.org>, xiyou.wangcong@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 042/108] x86: memtest: remove 64-bit division
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-memtest-remove-64-bit-division.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit c9690998ef48ffefeccb91c70a7739eebdea57f9 upstream.

Using gcc 3.3.5 a "make allmodconfig" + "CONFIG_KVM=n"
triggers a build error:

 arch/x86/mm/built-in.o(.init.text+0x43f7): In function `__change_page_attr':
 arch/x86/mm/pageattr.c:114: undefined reference to `__udivdi3'
 make: *** [.tmp_vmlinux1] Error 1

The culprit turned out to be a division in arch/x86/mm/memtest.c
For more info see this thread:

  http://marc.info/?l=linux-kernel&m=124416232620683

The patch entirely removes the division that caused the build
error.

[ Impact: build fix with certain GCC versions ]

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: xiyou.wangcong@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090608170939.GB12431@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/memtest.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -40,23 +40,23 @@ static void __init reserve_bad_mem(u64 p
 
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


