Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYJIQTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYJIQTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYJIQTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:19:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbYJIQTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:19:37 -0400
Date: Thu, 9 Oct 2008 09:17:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
In-Reply-To: <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Oct 2008, Miklos Szeredi wrote:
> 
> Your patch still ignores O_APPEND, is that what we want?  It sounds
> sort of strange.  pwrite() for example honors O_APPEND and ignores the
> position, AFAICS.

You're right. We can (and should) just check O_APPEND, because it must be 
set if IS_APPEND() is set on the inode.

And yeah, IS_IMMUTABLE is checked at open too. So no worries.

And it turns out that handling O_APPEND is actually pretty easy, so 
instead of doing -EINVAL, we can just implement it. Something like this 
(untested, of course).

Does this look better?

		Linus

---
 fs/splice.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 1bbc6f4..8aca87b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1120,11 +1120,17 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
+			if (out->f_flags & O_APPEND)
+				return -EINVAL;
 			if (out->f_op->llseek == no_llseek)
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
 			off = &offset;
+		} else if (out->f_flags & O_APPEND) {
+			struct inode *inode = out->f_dentry->d_inode;
+			offset = i_size_read(inode);
+			off = &offset;
 		} else
 			off = &out->f_pos;
 
