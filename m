Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbXKDMUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbXKDMUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXKDMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:20:14 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56095 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbXKDMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:20:12 -0500
Date: Sun, 4 Nov 2007 12:19:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Michael Marineau <mike@marineau.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH, RESEND] tmpfs: fix mounts when size is less than the
 page size
In-Reply-To: <11941336124117-git-send-email-mike@marineau.org>
Message-ID: <Pine.LNX.4.64.0711041202260.4631@blonde.wat.veritas.com>
References: <11941279021705-git-send-email-mike@marineau.org>
 <11941336124117-git-send-email-mike@marineau.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fair enough, that does match the documentation of "size=0" better.
Though either way, someone who typos is going to get one kind of surprise
or another.  Do you mind if we do it slightly differently, achieving the
same effect without a special case, by rounding up instead of down?


From: Michael Marineau <mike@marineau.org>

When tmpfs is mounted with a size less than one page, the number of blocks
is set to 0 which makes the tmpfs mount unlimited. This can lead to a quick
and surprising death if someone typos a tmpfs mount command and writes too
much.

tmpfs can still be mounted as unlimited if size or nr_blocks is exactly 0,
as Documentation/filesystems/tmpfs.txt says.

Hugh: do this by rounding size up instead of down in all cases: which
slightly expands other odd-sized tmpfs mounts, but in a consistent way.

Signed-off-by: Michael Marineau <mike@marineau.org>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.24-rc1-git/mm/shmem.c	2007-10-31 06:18:05.000000000 +0000
+++ linux/mm/shmem.c	2007-11-04 11:46:09.000000000 +0000
@@ -2137,7 +2137,7 @@ static int shmem_parse_options(char *opt
 			}
 			if (*rest)
 				goto bad_val;
-			*blocks = size >> PAGE_CACHE_SHIFT;
+			*blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
 		} else if (!strcmp(this_char,"nr_blocks")) {
 			*blocks = memparse(value,&rest);
 			if (*rest)
