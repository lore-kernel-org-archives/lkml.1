Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0CJPvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:51:39 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:42654 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0CJPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:51:38 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Daniel Taylor <Daniel.Taylor@wdc.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com>
	<87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com>
	<87zl2j9muz.fsf@devron.myhome.or.jp>
	<87wrxkw52s.fsf_-_@devron.myhome.or.jp>
Date: Thu, 11 Mar 2010 00:51:35 +0900
In-Reply-To: <87wrxkw52s.fsf_-_@devron.myhome.or.jp> (OGAWA Hirofumi's message
	of "Thu, 11 Mar 2010 00:48:27 +0900")
Message-ID: <87sk88w4xk.fsf_-_@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can drop this patch, if we want to delay until someone notice this
and have some real requests to this.




Smaller size than a minimum blocksize can't be used, after all it's
handled like 0 size.

For extended partition itself, this makes sure to use bigger size than
one logical sector size at least.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/partitions/msdos.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/partitions/msdos.c~part-support-4k-block-fix fs/partitions/msdos.c
--- linux-2.6/fs/partitions/msdos.c~part-support-4k-block-fix	2010-03-08 20:11:39.000000000 +0900
+++ linux-2.6-hirofumi/fs/partitions/msdos.c	2010-03-08 20:32:19.000000000 +0900
@@ -492,9 +492,16 @@ int msdos_partition(struct parsed_partit
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
-			/* prevent someone doing mkfs or mkswap on an
-			   extended partition, but leave room for LILO */
-			put_partition(state, slot, start, size == 1 ? 1 : 2);
+			/*
+			 * prevent someone doing mkfs or mkswap on an
+			 * extended partition, but leave room for LILO
+			 * FIXME: this uses one logical sector for > 512b
+			 * sector, although it may not be enough/proper.
+			 */
+			sector_t n = 2;
+			n = min(size, max(sector_size, n));
+			put_partition(state, slot, start, n);
+
 			printk(" <");
 			parse_extended(state, bdev, start, size);
 			printk(" >");
_

--
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
