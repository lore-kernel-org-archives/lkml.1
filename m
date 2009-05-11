Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZEKSpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZEKSpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZEKSo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:44:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbZEKSo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:44:58 -0400
Date: Mon, 11 May 2009 11:40:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dup2: Fix return value with oldfd == newfd and invalid
 fd
In-Reply-To: <4A086D9E.60308@suse.com>
Message-ID: <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain>
References: <4A086D9E.60308@suse.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Jeff Mahoney wrote:
> 
>  The return value of dup2 when oldfd == newfd and the fd isn't valid is not
>  getting properly sign extended. We end up with 4294967287 instead of -EBADF.

Indeed.

>  This patch uses a signed int for the error value so it is properly extended.

However, I'd rather move the new variable into the block where it is used, 
and keep the whole corner-case thing self-contained.

So can you verify that this trivial variation on the patch is ok by you, 
and I'll commit it as yours with your message? (I realize it's really 
trivial, and I could just do this myself, but good to get the change 
ack'ed anyway).

		Linus

---
 fs/fcntl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index cc8e4de..1ad7031 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -117,11 +117,13 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
 {
 	if (unlikely(newfd == oldfd)) { /* corner case */
 		struct files_struct *files = current->files;
+		int retval = oldfd;
+
 		rcu_read_lock();
 		if (!fcheck_files(files, oldfd))
-			oldfd = -EBADF;
+			retval = -EBADF;
 		rcu_read_unlock();
-		return oldfd;
+		return retval;
 	}
 	return sys_dup3(oldfd, newfd, 0);
 }
