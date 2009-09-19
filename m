Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZISCVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZISCVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZISCVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:21:42 -0400
Received: from [65.98.92.6] ([65.98.92.6]:1694 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbZISCVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:21:41 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 18 Sep 2009 19:12:45 -0700
Subject: [PATCH] MIPS: Avoid destructive invalidation on partial L2 cachelines
Message-Id: <de70b67245e012ab0c11b520a721989b@localhost>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends commit a8ca8b64e3fdfec17679cba0ca5ce6e3ffed092d to cover
the board cache code.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/sc-mips.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index b55c2d1..5ab5fa8 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -32,6 +32,11 @@ static void mips_sc_wback_inv(unsigned long addr, unsigned long size)
  */
 static void mips_sc_inv(unsigned long addr, unsigned long size)
 {
+	unsigned long lsize = cpu_scache_line_size();
+	unsigned long almask = ~(lsize - 1);
+
+	cache_op(Hit_Writeback_Inv_SD, addr & almask);
+	cache_op(Hit_Writeback_Inv_SD, (addr + size - 1) & almask);
 	blast_inv_scache_range(addr, addr + size);
 }
 
-- 
1.6.3.1

