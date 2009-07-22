Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbZGVOOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbZGVOOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZGVOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:14:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbZGVOOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:14:04 -0400
Subject: Re: [PATCH] fix offset checks in do_sendfile to use unsigned values
From: Jeff Layton <jlayton@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       smfrench@gmail.com, hch@infradead.org
In-Reply-To: <20090722135110.GA3091@cmpxchg.org>
References: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
	 <1248262099-12514-2-git-send-email-jlayton@redhat.com>
	 <20090722125945.GA2834@cmpxchg.org>
	 <1248269879.4534.12.camel@tlielax.poochiereds.net>
	 <20090722135110.GA3091@cmpxchg.org>
Content-Type: multipart/mixed; boundary="=-F43uCi3SlHVZxYj2YkbQ"
Date: Wed, 22 Jul 2009 10:13:52 -0400
Message-Id: <1248272032.4534.27.camel@tlielax.poochiereds.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F43uCi3SlHVZxYj2YkbQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2009-07-22 at 15:51 +0200, Johannes Weiner wrote:

> > Any of these patches will fix the immediate problem, but I think this
> > code in do_sendfile should still account for the possibility that
> > someone can set the value larger than MAX_LFS_FILESIZE. An alternative
> > is to consider a WARN at mount time when filesystems set s_maxbytes
> > larger than that value (that might help catch out of tree filesystems
> > that get this wrong and prevent this sort of silent bug in the future).
> 
> Isn't MAX_LFS_FILESIZE by definition the maximum sensible value for
> s_maxbytes?
> 

Pretty much, but nothing seems to enforce it or let you know when you've
exceeded it. It sort of seems like s_maxbytes ought to be loff_t or
something instead of an unsigned long long. A negative value there
wouldn't make much sense, but no one would be as tempted to set it
higher than MAX_LFS_FILESIZE.

> > Either way, the patch I posted for this isn't sufficient since there are
> > some checks that need to be done against the signed values (the
> > (pos < 0) check, for instance). I'll post a respun patch in a bit that
> > should fix up those problems.
> 
> That is already handled in rw_verify_area(), I think, so we should be
> able to drop it completely.

If we get rid of those checks altogether, then "max" will become unused.
Is that really OK here?

For discussion purposes, I've attached a replacement patch that I'm
working with now.
-- 
Jeff Layton <jlayton@redhat.com>

--=-F43uCi3SlHVZxYj2YkbQ
Content-Disposition: attachment; filename*0=0001-fix-offset-checks-in-do_sendfile-to-use-unsigned-val.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-fix-offset-checks-in-do_sendfile-to-use-unsigned-val.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 00a22f2f1e34ba0765ca49120499e681477a265a Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 22 Jul 2009 08:36:22 -0400
Subject: [PATCH] fix offset checks in do_sendfile to use unsigned values (try #2)

This is the second version of this patch. Some of the checks do need
to use signed values. This patch should be more correct in that regard.
This also adds a check to make sure that "pos + count" doesn't
overflow.

If do_sendfile is called with a "max" value of 0, it grabs the lesser
s_maxbytes value of the two superblocks to use instead. There's a
problem here however. s_maxbytes is an unsigned long long and it gets
cast to a signed value. If both s_maxbytes values are large enough, max
will end up being negative and the comparisons in this code won't work
correctly.

Change do_sendfile to use unsigned values internally for the offset
checks against "max".

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/read_write.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..2c5b402 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -788,11 +788,11 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 }
 
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
-			   size_t count, loff_t max)
+			   size_t count, unsigned long long max)
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
-	loff_t pos;
+	unsigned long long pos, newpos;
 	ssize_t retval;
 	int fput_needed_in, fput_needed_out, fl;
 
@@ -835,14 +835,16 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		goto fput_out;
 	count = retval;
 
-	if (!max)
-		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
-
-	pos = *ppos;
 	retval = -EINVAL;
-	if (unlikely(pos < 0))
+	if (unlikely(*ppos < 0))
 		goto fput_out;
-	if (unlikely(pos + count > max)) {
+
+	if (!max)
+		max = min(in_inode->i_sb->s_maxbytes,
+			  out_inode->i_sb->s_maxbytes);
+	pos = (unsigned long long) *ppos;
+	newpos = pos + count;
+	if (unlikely(newpos > max || newpos < count)) {
 		retval = -EOVERFLOW;
 		if (pos >= max)
 			goto fput_out;
@@ -869,7 +871,8 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 
 	inc_syscr(current);
 	inc_syscw(current);
-	if (*ppos > max)
+	pos = (unsigned long long) *ppos;
+	if (pos > max)
 		retval = -EOVERFLOW;
 
 fput_out:
-- 
1.6.2.5


--=-F43uCi3SlHVZxYj2YkbQ--

