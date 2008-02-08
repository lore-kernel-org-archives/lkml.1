Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYBHQvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYBHQvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763227AbYBHQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:51:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54785 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763195AbYBHQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:51:17 -0500
Date: Fri, 8 Feb 2008 08:49:14 -0800
From: Greg KH <greg@kroah.com>
To: torvalds@linux-foundation.org
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, cliph@research.coseinc.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] splice: missing user pointer access verification
	(CVE-2008-0009/10)
Message-ID: <20080208164914.GB17072@kroah.com>
References: <0802051044200.29525@mjc.redhat.com> <20080205165301.1e0b8ad8.akpm@linux-foundation.org> <20080206095510.GA15220@kernel.dk> <20080207223146.GI19310@kroah.com> <20080208160203.GB23197@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208160203.GB23197@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

vmsplice_to_user() must always check the user pointer and length
with access_ok() before copying. Likewise, for the slow path of
copy_from_user_mmap_sem() we need to check that we may read from
the user region.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Wojciech Purczynski <cliph@research.coseinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

Linus, this fixes a security hole in splice that is now public.  I have
it queued up for the .23 and .24 -stable releases as well.

 fs/splice.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 4ee49e8..14e2262 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1179,6 +1179,9 @@ static int copy_from_user_mmap_sem(void *dst, const void __user *src, size_t n)
 {
 	int partial;
 
+	if (!access_ok(VERIFY_READ, src, n))
+		return -EFAULT;
+
 	pagefault_disable();
 	partial = __copy_from_user_inatomic(dst, src, n);
 	pagefault_enable();
@@ -1387,6 +1390,11 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
 			break;
 		}
 
+		if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
+			error = -EFAULT;
+			break;
+		}
+
 		sd.len = 0;
 		sd.total_len = len;
 		sd.flags = flags;
-- 
1.5.4.22.g7a20


-- 
Jens Axboe
