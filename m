Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbYFFI3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbYFFI3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYFFI3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:29:00 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57484 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699AbYFFI25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:28:57 -0400
X-Sasl-enc: AvqhScivSNpjDFSO9FkuFapMYu/9cfHm+JJGQJ2ao/Ns 1212740936
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1212740486.3035.41.camel@raven.themaw.net>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212651099.3047.44.camel@raven.themaw.net>  <4848D7E7.60203@krogh.cc>
	 <1212740486.3035.41.camel@raven.themaw.net>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 16:25:19 +0800
Message-Id: <1212740720.3035.45.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-06 at 16:21 +0800, Ian Kent wrote:
> On Fri, 2008-06-06 at 08:23 +0200, Jesper Krogh wrote:
> > Hi.
> > 
> > This isn't a test of the proposed patch. I just got another variatioin 
> > of the problem in the log. (I've tried running the automount daemon both 
> > with and without the --ghost option) that is the only change I can see. 
> > Still 2.6.26-rc4..
> 
> Right.
> 
> Whether that would make a difference depends largely on your map
> configuration. If you have simple indirect or direct maps then then
> using the --ghost option (or just adding the "browse" option if you're
> using version 5) should prevent the code that turns the dentry negative
> from being executed at all. If you're using submounts in your map, or
> the "hosts" map or you have multi-mount entries in the maps then that
> code could still be executed.
> 

btw, I'm currently testing with these additional changes.
I don't think they will result in functional differences but it's best
we keep in sync.

autofs4 - leave rehash dentry positive fix

From: Ian Kent <raven@themaw.net>

Change ENOSPC to ENOMEM.
Make autofs4_init_ino() always set mode field.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/inode.c |    2 +-
 fs/autofs4/root.c  |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index ec9a641..3221506 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -45,7 +45,6 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 
 	if (!reinit) {
 		ino->flags = 0;
-		ino->mode = mode;
 		ino->inode = NULL;
 		ino->dentry = NULL;
 		ino->size = 0;
@@ -53,6 +52,7 @@ struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
 		atomic_set(&ino->count, 0);
 	}
 
+	ino->mode = mode;
 	ino->last_used = jiffies;
 
 	ino->sbi = sbi;
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 6ce603b..f438e6b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -713,13 +713,13 @@ static int autofs4_dir_symlink(struct inode *dir,
 
 	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
 	if (!ino)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
 	if (!cp) {
 		if (!dentry->d_fsdata)
 			kfree(ino);
-		return -ENOSPC;
+		return -ENOMEM;
 	}
 
 	strcpy(cp, symname);
@@ -733,7 +733,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 			kfree(cp);
 			if (!dentry->d_fsdata)
 				kfree(ino);
-			return -ENOSPC;
+			return -ENOMEM;
 		}
 
 		d_add(dentry, inode);
@@ -866,7 +866,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
 	if (!ino)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	inode = dentry->d_inode;
 	if (inode)
@@ -876,7 +876,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		if (!inode) {
 			if (!dentry->d_fsdata)
 				kfree(ino);
-			return -ENOSPC;
+			return -ENOMEM;
 		}
 
 		d_add(dentry, inode);


