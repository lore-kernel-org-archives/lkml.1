Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0CFSlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:41:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50430 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab0CFSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:41:10 -0500
Date: Sat, 6 Mar 2010 18:41:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, walt <w41ter@gmail.com>
Subject: Re: "Switch !O_CREAT case to use of do_last()" causes segfault in
 glibc
Message-ID: <20100306184107.GH30031@ZenIV.linux.org.uk>
References: <4B92944E.8080209@gmail.com>
 <20100306175917.GD30031@ZenIV.linux.org.uk>
 <20100306180313.GE30031@ZenIV.linux.org.uk>
 <4B929CF9.8010506@gmail.com>
 <20100306183254.GG30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306183254.GG30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 06:32:54PM +0000, Al Viro wrote:
> On Sat, Mar 06, 2010 at 10:20:41AM -0800, walt wrote:
> > On 03/06/2010 10:03 AM, Al Viro wrote:
> > 
> > >_Really_ interesting; it doesn't look like an oops - smells like an attempt
> > >to do opendir() that fails for some reason, goes unnoticed and resulting
> > >FILE * (i.e. NULL) is fed to readdir()?
> > >
> > >What does it attempt to open?
> > 
> > Ah, this may help:
> > 
> > open("/usr/share/zoneinfo/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 47
> > open("/usr/share/zoneinfo/MST7MDT", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 48
> 
> Now that is interesting.  Looks like it has managed to lose O_DIRECTORY check
> in the open without trailing slash and (properly) barfed with / added.

OK, I can reproduce it.  Give me a few, I'll see...

AAARGH.

Fix a dumb typo - use of & instead of &&

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/fs/namei.c b/fs/namei.c
index 3d9d2f9..48e60a1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1656,7 +1656,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		if (path->dentry->d_inode->i_op->follow_link)
 			return NULL;
 		error = -ENOTDIR;
-		if (*want_dir & !path->dentry->d_inode->i_op->lookup)
+		if (*want_dir && !path->dentry->d_inode->i_op->lookup)
 			goto exit_dput;
 		path_to_nameidata(path, nd);
 		audit_inode(pathname, nd->path.dentry);
