Return-Path: <linux-kernel-owner+w=401wt.eu-S1764826AbYBBA2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764826AbYBBA2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762750AbYBBAYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:55694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763335AbYBBAYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:42 -0500
Date: Fri, 1 Feb 2008 16:20:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/27] : Fix sparc64 cpu cross call hangs.
Message-ID: <20080202002036.GN8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc64-cpu-cross-call-hangs.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: "David S. Miller" <davem@davemloft.net>

[SPARC64]: Fix endless loop in cheetah_xcall_deliver().

[ Upsteam commit: 0de56d1ab83323d604d95ca193dcbd28388dbabb ]

We need to mask out the proper bits when testing the dispatch status
register else we can see unrelated NACK bits from previous cross call
sends.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/smp.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -403,7 +403,7 @@ static __inline__ void spitfire_xcall_de
  */
 static void cheetah_xcall_deliver(u64 data0, u64 data1, u64 data2, cpumask_t mask)
 {
-	u64 pstate, ver;
+	u64 pstate, ver, busy_mask;
 	int nack_busy_id, is_jbus, need_more;
 
 	if (cpus_empty(mask))
@@ -435,14 +435,20 @@ retry:
 			       "i" (ASI_INTR_W));
 
 	nack_busy_id = 0;
+	busy_mask = 0;
 	{
 		int i;
 
 		for_each_cpu_mask(i, mask) {
 			u64 target = (i << 14) | 0x70;
 
-			if (!is_jbus)
+			if (is_jbus) {
+				busy_mask |= (0x1UL << (i * 2));
+			} else {
 				target |= (nack_busy_id << 24);
+				busy_mask |= (0x1UL <<
+					      (nack_busy_id * 2));
+			}
 			__asm__ __volatile__(
 				"stxa	%%g0, [%0] %1\n\t"
 				"membar	#Sync\n\t"
@@ -458,15 +464,16 @@ retry:
 
 	/* Now, poll for completion. */
 	{
-		u64 dispatch_stat;
+		u64 dispatch_stat, nack_mask;
 		long stuck;
 
 		stuck = 100000 * nack_busy_id;
+		nack_mask = busy_mask << 1;
 		do {
 			__asm__ __volatile__("ldxa	[%%g0] %1, %0"
 					     : "=r" (dispatch_stat)
 					     : "i" (ASI_INTR_DISPATCH_STAT));
-			if (dispatch_stat == 0UL) {
+			if (!(dispatch_stat & (busy_mask | nack_mask))) {
 				__asm__ __volatile__("wrpr %0, 0x0, %%pstate"
 						     : : "r" (pstate));
 				if (unlikely(need_more)) {
@@ -483,12 +490,12 @@ retry:
 			}
 			if (!--stuck)
 				break;
-		} while (dispatch_stat & 0x5555555555555555UL);
+		} while (dispatch_stat & busy_mask);
 
 		__asm__ __volatile__("wrpr %0, 0x0, %%pstate"
 				     : : "r" (pstate));
 
-		if ((dispatch_stat & ~(0x5555555555555555UL)) == 0) {
+		if (dispatch_stat & busy_mask) {
 			/* Busy bits will not clear, continue instead
 			 * of freezing up on this cpu.
 			 */

-- 
