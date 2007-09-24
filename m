Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXIXQbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXIXQbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXIXQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47376 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760273AbXIXQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:55 -0400
Date: Mon, 24 Sep 2007 09:20:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [18/50] splice: fix direct splice error handling
Message-ID: <20070924162057.GS13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="splice-fix-direct-splice-error-handling.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

This is a splice patch for 2.6.22 and 2.6.21 (and earlier, I did not
check. Let me know if you still maintain older stable trees!). It fixes
an infinite loop in do_splice_direct(), when there's either nothing to
read or nothing to write and blocking doesn't help. It could be things
like running out of disk space. We need to exit both for failure and
zero return, or we could be going around forever.

This got fixed in 2.6.23-git with commit 51a92c0f6ce8fa85fa0e18ecda1d847e606e8066

Herbert Poetzl <herbert@13thfloor.at> noticed this bug in 2.6.22, and
has verified that this minimal fix works.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1011,7 +1011,7 @@ long do_splice_direct(struct file *in, l
 		max_read_len = min(len, (size_t)(PIPE_BUFFERS*PAGE_SIZE));
 
 		ret = do_splice_to(in, ppos, pipe, max_read_len, flags);
-		if (unlikely(ret < 0))
+		if (unlikely(ret <= 0))
 			goto out_release;
 
 		read_len = ret;
@@ -1023,7 +1023,7 @@ long do_splice_direct(struct file *in, l
 		 */
 		ret = do_splice_from(pipe, out, &out_off, read_len,
 				     flags & ~SPLICE_F_NONBLOCK);
-		if (unlikely(ret < 0))
+		if (unlikely(ret <= 0))
 			goto out_release;
 
 		bytes += ret;

-- 
