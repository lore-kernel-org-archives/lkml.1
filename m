Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXBGKJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXBGKJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXBGKJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:09:05 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:42596 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161124AbXBGKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:09:03 -0500
Message-ID: <45C9A43F.2010401@hitachi.com>
Date: Wed, 07 Feb 2007 19:04:47 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       yuji.kakutani.uw@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: [BUG][PATCH] mm: Fix dirty page accounting per backing_dev
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

I found a suspicious bug of I/O accounting in 2.6.20-rc6-mm3.
The number of dirty pages per backing_dev available from
/sys/block/<dev>/queue/nr_dirty keeps growing when a file is
rapidly overwritten several times.

For example:
% cat /sys/block/sda/queue/nr_dirty
104
% for i in 1 2; do dd if=/dev/zero of=dummy bs=4096 count=1; done; sync
% cat /sys/block/sda/queue/nr_dirty
105
% for i in 1 2 3; do dd if=/dev/zero of=dummy bs=4096 count=1; done; sync
% cat /sys/block/sda/queue/nr_dirty
107

This patch fixes it.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
---
 mm/truncate.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.20-rc6-mm3/mm/truncate.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/mm/truncate.c
+++ linux-2.6.20-rc6-mm3/mm/truncate.c
@@ -70,6 +70,7 @@ void cancel_dirty_page(struct page *page
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			atomic_long_dec(&mapping->backing_dev_info->nr_dirty);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
