Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYJIPjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYJIPjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYJIPjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:39:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbYJIPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:39:38 -0400
Date: Thu, 9 Oct 2008 08:37:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
In-Reply-To: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Oct 2008, Miklos Szeredi wrote:
>
> While looking at the f_pos corruption thing, I found that splice() to
> a regular file totally ignores O_APPEND.  Which allows users to bypass
> the append-only restriction.  Bad...
> 
> The only question is how this should be solved?  Should splice()
> respect O_APPEND and ignore the offset?  Or should it just return
> -EINVAL?

Good catch. sendfile() has the same issue, but I don't think we ever did 
sendpage() for any filesystems, so it won't ever be relevant, and this is 
probably just a splice issue.

EINVAL seems the simplest thing. Should check S_IMMUTABLE too for that 
matter. Possible patch appended.

I do wonder if we shouldn't just do this in rw_verify_area(). The whole 
reason for that function is that we used to have all those flock checks 
etc spread out all over, and some path would inevitably just miss one 
check or another. It's kind of stupid to expect low-level filesystems to 
do the IS_APPEND/IS_IMMUTABLE checks.

Comments?

		Linus

---
 fs/splice.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 1bbc6f4..769b2d3 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -891,6 +891,7 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 			   loff_t *ppos, size_t len, unsigned int flags)
 {
 	int ret;
+	struct inode *inode;
 
 	if (unlikely(!out->f_op || !out->f_op->splice_write))
 		return -EINVAL;
@@ -898,6 +899,12 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	inode = out->f_dentry->d_inode;
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (IS_APPEND(inode))
+		return -EINVAL;
+
 	ret = rw_verify_area(WRITE, out, ppos, len);
 	if (unlikely(ret < 0))
 		return ret;
