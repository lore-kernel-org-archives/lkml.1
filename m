Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXBJOoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXBJOoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXBJOoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:44:09 -0500
Received: from mail.parknet.jp ([210.171.160.80]:4248 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXBJOoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:44:08 -0500
X-AuthUser: hirofumi@parknet.jp
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] FAT: DIO-write fallback to normal buffered
References: <87sldenkg0.fsf@duaron.myhome.or.jp>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sat, 10 Feb 2007 23:44:01 +0900
In-Reply-To: <87sldenkg0.fsf@duaron.myhome.or.jp> (OGAWA Hirofumi's message of "Sat\, 10 Feb 2007 23\:42\:07 +0900")
Message-ID: <87ejoynkcu.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[RESEND: forget to add linux-kernel@vger.kernel.org]

If the DIO write on FAT is expanding the size, it will be fail by -EINVAL,
because FAT can't handle it now.

This patch fallback it to the normal buffered-write and would return
success.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat_direct-io-fallback fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_direct-io-fallback	2007-02-10 22:08:33.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2007-02-10 22:08:33.000000000 +0900
@@ -173,10 +173,12 @@ static ssize_t fat_direct_IO(int rw, str
 		 *
 		 * But we must fill the remaining area or hole by nul for
 		 * updating ->mmu_private.
+		 *
+		 * Return 0, and fallback to normal buffered write.
 		 */
 		loff_t size = offset + iov_length(iov, nr_segs);
 		if (MSDOS_I(inode)->mmu_private < size)
-			return -EINVAL;
+			return 0;
 	}
 
 	/*
_
