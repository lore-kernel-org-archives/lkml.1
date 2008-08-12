Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYHLVEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYHLVEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYHLVE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:04:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYHLVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:04:28 -0400
Date: Tue, 12 Aug 2008 14:04:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812203808.GV28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
 <20080812203808.GV28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Al Viro wrote:
> 
> 	Would you care to grep for vfs_readdir() in the tree?  It's not just
> sys_getdents(); for better of worse the thing had become a general-purpose
> iterator.  And I'm not suggesting to pass the damn thing to caller of
> sys_getdents().  At all.

Umm. What does that matter wrt what I said?

What does that matter wrt your bogus argument about EIO (which we do 
_wrong_ right now, exactly because we return EIO too eagerly, instead of 
returning the partial data we got)?

vfs_readdir() itself would not change AT ALL. The change I talked about 
was in the caller. Which you should realize, since I actually _called_ 
vfs_readdir() in that example code.

Here's a patch to get the _semantics_ I talked about, to make the thing 
more obvious.

But the actual _change_ I talked about would be to try to avoid using 
"buf.error" entirely, and just make all the (many, I know) filesystem 
readdir() functions return the callback value instead of 0. Which would 
mean that most of the users would be able to drop their "buf.error" use 
entirely, along with the ugly

	if (error >= 0)
		error = buf.error;

that I have in this patch.

(Side note: the "if (error >= 0)" approach is what old_readdir() already 
does, so that function actually gets the EIO case _correct_: it's only 
the newer sys_getdents() that is buggy)

			Linus

---
 fs/readdir.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 4e026e5..e4ded16 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -205,9 +205,8 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 	buf.error = 0;
 
 	error = vfs_readdir(file, filldir, &buf);
-	if (error < 0)
-		goto out_putf;
-	error = buf.error;
+	if (error >= 0)
+		error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		if (put_user(file->f_pos, &lastdirent->d_off))
@@ -216,7 +215,6 @@ asmlinkage long sys_getdents(unsigned int fd, struct linux_dirent __user * diren
 			error = count - buf.count;
 	}
 
-out_putf:
 	fput(file);
 out:
 	return error;
