Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYDIS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYDIS6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYDIS5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:57:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYDIS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:57:53 -0400
Date: Wed, 9 Apr 2008 11:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Allard Hoeve <allard@byte.nl>,
       Neil Brown <neilb@suse.de>
Subject: Re: [patch] fix infinite loop in generic_file_splice_read()
Message-Id: <20080409115702.79737d7f.akpm@linux-foundation.org>
In-Reply-To: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2008 17:57:56 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> generic_file_splice_read() goes into an infinite loop if it races with
> truncation.  I've found this with fsx-linux on NFS over fuse.
> 
> Perhaps the whole while() loop is bogus, but I can't tell from a
> cursory glance at __generic_file_splice_read() if it will return zero
> only on EOF, or it can do that for other reasons as well.  In the
> latter case the loop is obviously needed.
> 
> This simplistic patch fixes the issue for me.
> 

We found suspicious-looking code in generic_file_splice_read() back in
February.  See http://lkml.org/lkml/2008/2/29/443.  I suspect that patch
(if it works) will address the truncate lockup as well - it zaps the loop
entirely.

Unfortunately Allard never got back to us (probably because he's running
2.6.24 which has a quite different generic_file_splice_read()) and the
patch didn't get anywhere.

Here it is again.

It needs a changelog.

Nobody has tested this at all, to my knowledge.

It's going to take some serious and sudden effort to get these bugs fixed
for 2.6.25.


 fs/splice.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff -puN fs/splice.c~generic_file_splice_read-fix-lockups fs/splice.c
--- a/fs/splice.c~generic_file_splice_read-fix-lockups
+++ a/fs/splice.c
@@ -370,8 +370,10 @@ __generic_file_splice_read(struct file *
 			 * for an in-flight io page
 			 */
 			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page))
+				if (TestSetPageLocked(page)) {
+					error = -EAGAIN;
 					break;
+				}
 			} else
 				lock_page(page);
 
@@ -479,9 +481,8 @@ ssize_t generic_file_splice_read(struct 
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
-	ssize_t spliced;
-	int ret;
 	loff_t isize, left;
+	int ret;
 
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
@@ -491,29 +492,9 @@ ssize_t generic_file_splice_read(struct 
 	if (unlikely(left < len))
 		len = left;
 
-	ret = 0;
-	spliced = 0;
-	while (len && !spliced) {
-		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
-
-		if (ret < 0)
-			break;
-		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
-				ret = -EAGAIN;
-				break;
-			}
-		}
-
+	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
+	if (ret > 0)
 		*ppos += ret;
-		len -= ret;
-		spliced += ret;
-	}
-
-	if (spliced)
-		return spliced;
 
 	return ret;
 }
_

