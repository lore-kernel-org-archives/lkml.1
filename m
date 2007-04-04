Return-Path: <linux-kernel-owner+w=401wt.eu-S2992717AbXDDHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992717AbXDDHlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992716AbXDDHlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:41:18 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:43650 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992711AbXDDHlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:41:17 -0400
Date: Wed, 4 Apr 2007 11:48:24 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Recursive ->i_mutex lockdep complaint
Message-ID: <20070404074824.GA1635@localhost.sw.ru>
References: <200703270735.l2R7Zg9t010611@shell0.pdx.osdl.net> <20070403142143.GA6535@localhost.sw.ru> <1175612720.9736.7.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175612720.9736.7.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 05:05:20PM +0200, Miklos Szeredi wrote:
> On Tue, 2007-04-03 at 18:21 +0400, Alexey Dobriyan wrote:
> > On Mon, Mar 26, 2007 at 11:35:42PM -0800, akpm@linux-foundation.org wrote:
> > > The patch titled
> > >      add file position info to proc
> > > has been added to the -mm tree.  Its filename is
> > >      add-file-position-info-to-proc.patch
> >
> > I tried to stress-test it with the following program and script and
> > lockdep barfs on me reasonably quickly:
>
> Ugh.  As I see it, this is independent from the above patch, as the same
> can happen with /proc/PID/fd.  Or did I miss something?

Yeah, it's independent from /proc/*/fdinfo stuff.

> And it seems quite benign, one of the mutexes is for the proc inode, the
> other is for the pipe inode, and hopefully they haven't got anything
> else to do with each other.
>
> > It seems that lockdep is unhappy about ->i_mutex taken in
> > ->release/pipe_read_release()/pipe_read_fasync()
> > which is triggered from put_files_struct() in proc_readfd_common()
> >
> > Now checking if giving pipe's i_mutex its own lockdep class with fix
> > things.
>
> Should help.  Although I'm wondering if it's worth bothering with, as it
> doesn't seem to happen in real life for lockdep users.

The following patch makes lockdep happy but I wonder if it's correct
way.

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -908,6 +908,8 @@ static struct dentry_operations pipefs_d
 	.d_dname	= pipefs_dname,
 };
 
+static struct lock_class_key pipe_inode_imutex_key;
+
 static struct inode * get_pipe_inode(void)
 {
 	struct inode *inode = new_inode(pipe_mnt->mnt_sb);
@@ -936,6 +938,8 @@ static struct inode * get_pipe_inode(voi
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 
+	lockdep_set_class(&inode->i_mutex, &pipe_inode_imutex_key);
+
 	return inode;
 
 fail_iput:

