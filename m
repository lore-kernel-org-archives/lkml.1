Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZH3QTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZH3QTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZH3QTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 12:19:51 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:43682 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZH3QTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 12:19:51 -0400
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swap: Fix swap size in case of block devices
Date: Sun, 30 Aug 2009 21:49:10 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.29.6-217.2.16.fc11.x86_64; KDE/4.3.0; x86_64; ; )
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908302149.10981.ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During swapon, swap size is set to number of usable pages in the given
swap file/block device minus 1 (for header page). In case of block devices,
this size is incorrectly set as one page less than the actual due to an
off-by-one error. For regular files, this size is set correctly.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

 mm/swapfile.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8ffdc0d..3d37b97 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1951,9 +1951,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap;

+	/* excluding header page */
 	nr_good_pages = swap_header->info.last_page -
-			swap_header->info.nr_badpages -
-			1 /* header page */;
+			swap_header->info.nr_badpages;

 	if (nr_good_pages) {
 		swap_map[0] = SWAP_MAP_BAD;
