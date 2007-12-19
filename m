Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXLSDy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXLSDy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXLSDyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:54:49 -0500
Received: from rtr.ca ([76.10.145.34]:2513 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXLSDyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:54:49 -0500
Message-ID: <47689608.3030503@rtr.ca>
Date: Tue, 18 Dec 2007 22:54:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk>
In-Reply-To: <20071218231404.GG8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Dec 18, 2007 at 11:00:16PM +0000, Al Viro wrote:
>> On Tue, Dec 18, 2007 at 05:46:21PM -0500, Mark Lord wrote:
>>> Why does link(2) not support hard-linking across bind mount points
>>> of the same underlying filesystem ?
>> Because it gives you a security boundary around a subtree.
> 
> PS: that had been discussed quite a few times, but to avoid searches:
> consider e.g. mount --bind /tmp /tmp; now you've got a situation when
> users can't create links to elsewhere no root fs, even though they
> have /tmp writable to them.  Similar technics works for other isolation
> needs - basically, you can confine rename/link to given subtree.  IOW,
> it's a deliberate feature.  Note that you can bind a bunch of trees
> into chroot and get predictable restrictions regardless of how the
> stuff might get rearranged a year later in the main tree, etc.
..

Thanks, Al.  That makes sense for a multi-user system, so I'm happy.

But.. pity there's no mount flag override for smaller systems,
where bind mounts might be more useful with link(2) actually working.

The patch is simple enough when needed, though.

Cheers

--- old/fs/namei.c	2007-12-15 12:33:13.000000000 -0500
+++ linux/fs/namei.c	2007-12-18 22:41:19.000000000 -0500
@@ -2398,7 +2398,7 @@
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_nd.mnt != nd.mnt)
+	if (old_nd.mnt->mnt_sb != nd.mnt->mnt_sb)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
