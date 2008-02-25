Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYBYT1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYBYT1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYBYT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:26:54 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44955 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYBYT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:26:53 -0500
Date: Mon, 25 Feb 2008 19:26:48 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Chris Dearman <chris@mips.com>, linux-mips@linux-mips.org
Subject: [PATCH] Try both endianess when checking for endianess.
Message-ID: <20080225192648.GA14357@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Dearman <chris@mips.com>

When checking for the swap header try byteswapping the endianess dependent
fields to allow the swap partition to be shared between big & little endian
systems.

Signed-off-by: Chris Dearman <chris@mips.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 mm/swapfile.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-queue/mm/swapfile.c
===================================================================
--- linux-queue.orig/mm/swapfile.c
+++ linux-queue/mm/swapfile.c
@@ -1551,6 +1551,14 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		goto bad_swap;
 	case 2:
+		/* swap partition endianess hack... */
+		if (swab32(swap_header->info.version) == 1) {
+			swab32s(&swap_header->info.version);
+			swab32s(&swap_header->info.last_page);
+			swab32s(&swap_header->info.nr_badpages);
+			for (i = 0; i < swap_header->info.nr_badpages; i++)
+				swab32s(&swap_header->info.badpages[i]);
+		}
 		/* Check the swap header's sub-version and the size of
                    the swap file and bad block lists */
 		if (swap_header->info.version != 1) {
