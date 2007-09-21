Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbXIUPMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbXIUPMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbXIUPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:11:56 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52024 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762AbXIUPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:11:55 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921145356.GA16379@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 15:53:56 +0100)
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu> <20070921131409.GA9988@infradead.org> <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu> <20070921143338.GA14577@infradead.org> <E1IYjoQ-0001kT-00@dorka.pomaz.szeredi.hu> <20070921145356.GA16379@infradead.org>
Message-Id: <E1IYkAN-0001mh-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 17:11:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 21, 2007 at 04:48:58PM +0200, Miklos Szeredi wrote:
> > Ah, OK.  Well, that's what fuse would do with the above change.  So
> > you are basically saying, the change is OK, but we want proper
> > unprivileged mounts first.
> 
> Yes, that and that it should be a mount flag, not a file_system_type
> flag.
> 
> > I'm sure we don't want it by default.
> > 
> > For example if user bind mounts / onto /home/user/myroot (with 'nodev'
> > of couse), we still don't want mknod to work on that mount, for
> > obvious reasons.
> 
> True, we'll have to deny it if there is any non-privilegued mount of
> the backing device possible.   At this point it's getting rather nasty
> and I wonder whether it's really worth it..

I think the assumption, that we want this as a generic service is
false.

We want this as a special service for a few filesystems, such as the
unprivileged userspace loopback mounting I was talking about.

So my thinking is: if an unprivileged filesystem explicitly asks for
this, then it should be allowed.  It could be a per-superblock flag
instead of a per fs-type flag, if that sounds better.

My fuse implementation would have been exactly the same: the ->mknod()
implementation would check a per filesystem flag, and if it's not set,
check the permissions as normal mknod() would.  Here's the relevant
patch snippet:

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-21 13:45:23.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-21 13:45:25.000000000 +0200
@@ -486,7 +486,13 @@ static int fuse_mknod(struct inode *dir,
 {
 	struct fuse_mknod_in inarg;
 	struct fuse_conn *fc = get_fuse_conn(dir);
-	struct fuse_req *req = fuse_get_req(fc);
+	struct fuse_req *req;
+
+	if (!fc->mknod_nocheck &&
+	    ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD)))
+		return -EPERM;
+
+	req = fuse_get_req(fc);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 

