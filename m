Return-Path: <linux-kernel-owner+w=401wt.eu-S935448AbYD1PNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448AbYD1PNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbYD1PM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:12:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49925 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684AbYD1PM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:12:57 -0400
To: jblunck@suse.de
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <fv425u$n77$1@ger.gmane.org> (message from Jan Blunck on Mon, 28
	Apr 2008 08:34:06 +0000 (UTC))
Subject: Re: [patch 3/5] fuse: fix race in llseek
References: <20080425175520.735386844@szeredi.hu>
	<20080425175657.912755144@szeredi.hu> <fv425u$n77$1@ger.gmane.org>
Message-Id: <E1JqV2D-0004vS-Ny@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Apr 2008 17:12:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Fuse doesn't use i_mutex to protect setting i_size, and so
> > generic_file_llseek() can be racy: it doesn't use i_size_read().
> > 
> > So do a fuse specific llseek method, which does use i_size_read().
> > 
> 
> Is there any specific reason why we don't use i_size_read() in 
> generic_file_llseek()?

Just to save some cycles on 32bit archs.  Considering that
lseek(SEEK_END) isn't a very performance sensitive operation...

> If no, why don't you fix it instead?

...we could do that.  Does anybody object?

Miklos
----


Some filesystems (e.g. fuse) don't use i_mutex to protect setting
i_size, and so generic_file_llseek() can be racy.

Since lseek(SEEK_END) isn't a very performance sensitive operation, do
this in generic_file_llseek(), instead of requiring such filesystems
to duplicate this function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/read_write.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/fs/read_write.c
===================================================================
--- linux.orig/fs/read_write.c	2008-04-17 04:49:44.000000000 +0200
+++ linux/fs/read_write.c	2008-04-28 17:08:25.000000000 +0200
@@ -39,7 +39,11 @@ loff_t generic_file_llseek(struct file *
 	mutex_lock(&inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
-			offset += inode->i_size;
+			/*
+			 * Some filesystems use a different lock as i_mutex
+			 * to protect writing i_size
+			 */
+			offset += i_size_read(inode);
 			break;
 		case SEEK_CUR:
 			offset += file->f_pos;
