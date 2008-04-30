Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbYD3P1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbYD3P1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbYD3P1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:27:12 -0400
Received: from mail.queued.net ([207.210.101.209]:1678 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbYD3P1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:27:10 -0400
Date: Wed, 30 Apr 2008 11:30:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: ioremap ram check fix
Message-ID: <20080430113024.43aa3935@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

bdd3cee2e4b7279457139058615ced6c2b41e7de (x86: ioremap(), extend check
to all RAM pages) breaks OLPC's ioremap call.  The ioremap that OLPC uses is:

        romsig = ioremap(0xffffffc0, 16);

The commit that breaks it is basically:

-       for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
-            (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+       for (pfn = phys_addr >> PAGE_SHIFT;
+                               (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+

Previously, the 'pfn < max_pfn_mapped' check would've caused us to not
enter the loop.  Removing that check means we loop infinitely.  The
reason for that is because pfn is 0xfffff, and last_addr is 0xffffffcf.
The remaining check that is used to exit the loop is not sufficient;
when pfn<<PAGE_SHIFT is 0xfffff000, that is less than 0xffffffcf; when
we increment pfn and it overflows (pfn == 0x100000), pfn<<PAGE_SHIFT
ends up being 0.  That, of course, is less than last_addr.  In effect,
pfn<<PAGE_SHIFT is never lower than last_addr.

The simple fix for this is to limit the last_addr check to the PAGE_MASK;
a patch is below.




Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/mm/ioremap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 804de18..fb960f5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -149,7 +149,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
+				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
+				pfn++) {
 
 		int is_ram = page_is_ram(pfn);
 
-- 
1.5.5


