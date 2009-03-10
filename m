Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZCJQaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZCJQaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZCJQaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:30:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:55968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZCJQaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:30:07 -0400
Date: Tue, 10 Mar 2009 17:30:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090310163002.GC19352@wotan.suse.de>
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090310161247.GA19352@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 05:12:47PM +0100, Nick Piggin wrote:
> On Thu, Mar 05, 2009 at 01:12:25PM +0100, Jorge Boncompte [DTI2] wrote:
> > Jorge Boncompte [DTI2] escribió:
> > >Ok. I have modified the script to do...
> > >------------
> > >mount -no remount,ro /dev/ram0
> > >dd if=/dev/ram0 of=/tmp/config.bin bs=1k count=1000
> > >fsck.minix -fv /tmp/config.bin
> > >if [ $? != 0 ]; then
> > >    echo "FATAL: Filesystem is corrupted"
> > >    exit 2
> > >fi
> > >mount -no remount,rw /dev/ram0
> > >md5sum config.bin
> > >dd if=config.bin of=/dev/hda1
> > >echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
> > >------------
> > >... after some cycles of modifying files on the filesystem and trying to 
> > >save it to disk...
> > >------------------
> > >fsck.minix: BusyBox v1.8.2 (2008-12-03 14:24:56 CET)
> > >Forcing filesystem check on /tmp/config.bin
> > >Unused inode 198 is marked as 'used' in the bitmap.
> > >Zone 393 is marked 'in use', but no file uses it.
> > >Zone 394 is marked 'in use', but no file uses it.
> > >
> > >   198 inodes used (58%)
> > >   395 zones used (39%)
> > >
> > >   163 regular files
> > >    24 directories
> > >     0 character device files
> > >     0 block device files
> > >     0 links
> > >    10 symbolic links
> > >------
> > >   197 files
> > >FATAL: Filesystem is corrupted
> > >-------------------
> > >
> > 
> > 	If after getting the "FATAL: Filesystem is corrupted" message I do 
> > "echo 3 > /proc/sys/vm/drop_caches" and rerun the script the filesystem 
> > somehow got magically fixed (I mean fsck.minix does not report errors 
> > and the image gets written to disk well ;-)
> 
> OK, I can reproduce this. It really does seem to be due to buffercache
> going out of coherency for some reason, so the trick is that you have
> to fsck it while you have it mounted ro before remounting rw then modifying
> it then remounting ro and fscking again (the first fsck must bring in
> uptodate buffercache, and something is not being correctly invalidated).
> 
> It is also not brd or minix specific -- I reproduced it with loop driver
> and ext2 too, and probably regular disk driver will have the same problem
> (ie. it is something in the buffercache).
> 
> I don't know if this is the same problem as the ext3 issue -- the recipe
> for reproducing ext3 problem includes umount, which will invalidate all
> the buffercache unless something is holding the bdev open. But anyway I
> am making some progress with this problem so I will try solve it first.
> 
> I can't think of any good reason why buffercache should be going out of
> sync here...

Ah, of course, it would be due to directory-in-pagecache. You need
the following patch if you expect this to work.

And that confirms the ext3 problem is a different one because it
doesn't use directory in pagecache I think. Well, I'll look at
that one tomorrow.

Thanks,
Nick

---
 fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -644,6 +644,8 @@ int do_remount_sb(struct super_block *sb
 		acct_auto_close(sb);
 	shrink_dcache_sb(sb);
 	fsync_super(sb);
+	if (flags & MS_RDONLY)
+		invalidate_bdev(sb->s_bdev);
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */


