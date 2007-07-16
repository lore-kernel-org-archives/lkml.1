Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXGPSvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXGPSvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbXGPSvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:51:07 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:35786 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760282AbXGPSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:51:05 -0400
Message-ID: <469BBE0D.6080706@namesys.com>
Date: Mon, 16 Jul 2007 22:50:53 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>
CC: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [patch 1/3] reiser4: fix extent2tail
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: multipart/mixed;
 boundary="------------030808020305080705050805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030808020305080705050805
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit





--------------030808020305080705050805
Content-Type: text/x-patch;
 name="reiser4-fix-extent2tail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reiser4-fix-extent2tail.patch"

Fixed bug in extent2tail conversion.

Bug description:
when converting partially converted file
(with flag REISER4_PART_MIXED installed)
reiser4_cut_tree() starts to cut old metatada
from wrong offset. Result is data corruption.

Signed-off-by: Edward Shishkin <edward@namesys.com>
---
 linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c            |    7 -------
 linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c.orig
+++ linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/file.c
@@ -194,13 +194,6 @@
 	assert("vs-1164", level == LEAF_LEVEL || level == TWIG_LEVEL);
 
 	if (uf_info->container == UF_CONTAINER_UNKNOWN) {
-		/*
-		 * container is unknown, therefore conversion can not be in
-		 * progress
-		 */
-		assert("",
-		       !reiser4_inode_get_flag(unix_file_info_to_inode(uf_info),
-					       REISER4_PART_IN_CONV));
 		if (cbk_result == CBK_COORD_NOTFOUND)
 			uf_info->container = UF_CONTAINER_EMPTY;
 		else if (level == LEAF_LEVEL)
--- linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c.orig
+++ linux-2.6.22-rc6-mm1/fs/reiser4/plugin/file/tail_conversion.c
@@ -620,7 +620,7 @@
 		}
 
 		/* cut part of file we have read */
-		start_byte = (__u64) (i << PAGE_CACHE_SHIFT);
+		start_byte = (__u64) ((i + start_page) << PAGE_CACHE_SHIFT);
 		set_key_offset(&from, start_byte);
 		set_key_offset(&to, start_byte + PAGE_CACHE_SIZE - 1);
 		/*



--------------030808020305080705050805--
