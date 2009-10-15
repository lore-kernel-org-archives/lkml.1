Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZJOI3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZJOI3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761630AbZJOI3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:29:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:38753 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675AbZJOI3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:29:41 -0400
Date: Thu, 15 Oct 2009 10:29:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [patch 2/6] fs: no games with DCACHE_UNHASHED
Message-ID: <20091015082903.GD4262@wotan.suse.de>
References: <20091015044026.319860788@suse.de> <20091015050048.165912589@suse.de> <4AD6D2E3.9050105@gmail.com> <20091015081343.GC4262@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015081343.GC4262@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 10:13:43AM +0200, Nick Piggin wrote:
> Now both sockets and pipes define a d_dname so they are OK, but anon_inodes
> does not. I think they should probably be made to just provide a d_dname
> anyway so we can have the familiar format of "pseudofs:[ino]" rather than
> "[pseudofs]" that we have now.
> 
> That should make this patch work for anon_inodes.c as well.

So what if we were to do this first? Are there any other reasons I've
missed? (btw. this changes the format the link if that is a problem.
Probably if we're going to do this change, we should change things like
[timerfd] to just timerfd while we're there to improve consistency
further.
--
Pipe and socket pseudo filesystems report their file descriptor link
paths as pipe:[ino] and socket:[ino]. anon_inodefs allows subsystems
to specify a name, but it does not report an associated inode number.

Implement this with anon_inodefs_dname in the same way pipefs and sockfs
are.

---
 fs/anon_inodes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -45,6 +45,15 @@ static int anon_inodefs_delete_dentry(st
 	return 1;
 }
 
+/*
+ * anon_inodefs_dname() is called from d_path().
+ */
+static char *anon_inodefs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
+				dentry->d_name.name, dentry->d_inode->i_ino);
+}
+
 static struct file_system_type anon_inode_fs_type = {
 	.name		= "anon_inodefs",
 	.get_sb		= anon_inodefs_get_sb,
@@ -52,6 +61,7 @@ static struct file_system_type anon_inod
 };
 static const struct dentry_operations anon_inodefs_dentry_operations = {
 	.d_delete	= anon_inodefs_delete_dentry,
+	.d_dname	= anon_inodefs_dname,
 };
 
 /*
