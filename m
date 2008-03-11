Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYCKBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYCKBa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCKBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:30:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:50433 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYCKBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:30:16 -0400
Date: Tue, 11 Mar 2008 02:30:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH REPOST for 2.6.25] Use an own random generator for pageattr-test.c
Message-ID: <20080311013014.GA28682@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Mar 2008 01:23:43.0063 (UTC) FILETIME=[8B5BD670:01C88316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an own random generator for pageattr-test.c

[Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
candidate because it fixes a subtle bug]

pageattr-test attempts to be repeatable and uses srandom32 to get a 
repeatable random number sequence.

Using srandom32() wasn't a good idea for various reasons:
- it is per cpu and if the cpu changes on a preemptible kernel it gets lost
- networking and random32 puts in some own state
- srandom32() does not actually reset the state, but just adds bits to 
it

Instead use a very simple private standard rnd that gives repeatable
results. I took the reference rand() from ISO-C.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr-test.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr-test.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr-test.c
+++ linux/arch/x86/mm/pageattr-test.c
@@ -101,6 +101,14 @@ static int print_split(struct split_stat
 static unsigned long addr[NTEST];
 static unsigned int len[NTEST];
 
+static int next = 100;
+
+static unsigned my_rand(void)
+{
+	next = next * 1103515245 + 12345;
+	return next;
+}
+
 /* Change the global bit on random pages in the direct mapping */
 static int pageattr_test(void)
 {
@@ -123,10 +131,9 @@ static int pageattr_test(void)
 	memset(bm, 0, (max_pfn_mapped + 7) / 8);
 
 	failed += print_split(&sa);
-	srandom32(100);
 
 	for (i = 0; i < NTEST; i++) {
-		unsigned long pfn = random32() % max_pfn_mapped;
+		unsigned long pfn = my_rand() % max_pfn_mapped;
 
 		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
 		len[i] = random32() % 100;
