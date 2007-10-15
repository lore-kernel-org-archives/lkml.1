Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbXJOUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbXJOUGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbXJOUGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:06:08 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:49569 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXJOUGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:06:04 -0400
Message-ID: <4713C82C.7020609@free.fr>
Date: Mon, 15 Oct 2007 22:06:04 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr> <20071015084052.GA21870@infradead.org> <4713B1E7.2010504@suse.com>
In-Reply-To: <4713B1E7.2010504@suse.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15.10.2007 20:31, Jeff Mahoney a écrit :
> Christoph Hellwig wrote:
>> On Mon, Oct 15, 2007 at 12:34:58AM +0200, Laurent Riffard wrote:
>>> reiserfs_delete_xattrs
>>> reiserfs_delete_inode
>>> generic_delete_inode
>>> generic_drop_inode
>>> iput
>>> do_unlinkat
>>> sys_unlink
>>> sys_enter_past_esp
>>>
>>> I reported a similar BUG in 2.6.22-rc8-mm2 (see
>>> http://lkml.org/lkml/2007/9/27/235). Dave Hansen sent a patch for it, I
>>> tested it and it was OK for 2.6.22-rc8-mm2.
>>>
>>> I tried this patch on 2.6.23-mm1, and it fixed the BUGs here too.
>> The delete path is a similar case as the one Dave fixed, also cause by
>> a NULL vfsmount passed to dentry_open, but through a different code-path.
>>
>> Untested fix for this problem below:
> 
> Here's a patch I worked up the other night that kills off struct file
> completely from the xattr code. I've tested it locally.

Sorry Jeff, your patch does not apply on 2.6.23-mm1. The 'struct file'
removal from reiserfs_xattr_ function is already in -mm
(make-reiserfs-stop-using-struct-file-for-internal.patch).

The Dave's patch I was refering to is this one: 

==== BEGIN =====
The bug is caused by reiserfs creating a special 'struct file' with a
NULL vfsmount.  

/* Opens a file pointer to the attribute associated with inode */
static struct file *open_xa_file(const struct inode *inode, const char
*name,
                                 int flags)
{
...
        fp = dentry_open(xafile, NULL, O_RDWR);
        /* dentry_open dputs the dentry if it fails */


As Christoph just said, this is somewhat of a bandaid.  But, it
shouldn't hurt anything.

---

 lxc-dave/fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/open.c~fix-reiserfs-oops fs/open.c
diff -puN fs/file_table.c~fix-reiserfs-oops fs/file_table.c
--- lxc/fs/file_table.c~fix-reiserfs-oops	2007-09-27 13:32:20.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-09-27 13:33:11.000000000 -0700
@@ -236,7 +236,7 @@ void fastcall __fput(struct file *file)
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
+		if (!special_file(inode->i_mode) && mnt)
 			mnt_drop_write(mnt);
 	}
 	put_pid(file->f_owner.pid);
diff -puN include/linux/mount.h~fix-reiserfs-oops include/linux/mount.h
==== END ====

Dave sent it privately to me... I guess this "bandaid" is no longer
needed now, is it?

~~
laurent

