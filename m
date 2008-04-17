Return-Path: <linux-kernel-owner+w=401wt.eu-S933802AbYDQBY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbYDQBY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbYDQBJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:03 -0400
Received: from sous-sol.org ([216.99.217.87]:58970 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760857AbYDQBJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:01 -0400
Message-Id: <20080417010402.909235872@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: PARISC fix signal trampoline cache flushing
Content-Disposition: inline; filename=fix-signal-trampoline-cache-flushing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kyle McMartin <kyle@mcmartin.ca>

upstream commit: cf39cc3b56bc4a562db6242d3069f65034ec7549

The signal trampolines were accidently flushing the kernel I$ instead of
the users.  Fix that up, and also add a missing user D$ flush while
we're at it.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/parisc/kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -534,7 +534,8 @@ insert_restart_trampoline(struct pt_regs
 		 * Flushing one cacheline is cheap.
 		 * "sync" on bigger (> 4 way) boxes is not.
 		 */
-		flush_icache_range(regs->gr[30], regs->gr[30] + 4);
+		flush_user_dcache_range(regs->gr[30], regs->gr[30] + 4);
+		flush_user_icache_range(regs->gr[30], regs->gr[30] + 4);
 
 		regs->gr[31] = regs->gr[30] + 8;
 		/* Preserve original r28. */

-- 
