Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYAVEGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYAVEGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 23:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYAVEGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 23:06:03 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:62377 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYAVEGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 23:06:02 -0500
Date: Mon, 21 Jan 2008 22:05:56 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH] ARM: Ignore memory tags with invalid data
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: hvr@gnu.org, rmk@arm.linux.org.uk, nico@cam.org
Reply-to: minyard@acm.org
Message-id: <20080122040556.GA24515@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <minyard@acm.org>

The DNS-323 system has several bogus memory entries in the tag table,
and it caused the system to crash at startup.  Ignore tag entries that
are obviously bogus.

Signed-off-by: Corey Minyard <minyard@acm.org>
---
 arch/arm/kernel/setup.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index bf56eb3..dfdb469 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -630,7 +630,12 @@ __tagtable(ATAG_CORE, parse_tag_core);
 
 static int __init parse_tag_mem32(const struct tag *tag)
 {
-	if (meminfo.nr_banks >= NR_BANKS) {
+	/*
+	 * Make sure that the memory size is non-zero, page aligned,
+	 * and that it doesn't overflow the meminfo table.
+	 */
+	if (meminfo.nr_banks >= NR_BANKS || tag->u.mem.size & ~PAGE_MASK ||
+	    tag->u.mem.size == 0 || tag->u.mem.start & ~PAGE_MASK) {
 		printk(KERN_WARNING
 		       "Ignoring memory bank 0x%08x size %dKB\n",
 			tag->u.mem.start, tag->u.mem.size / 1024);
