Return-Path: <linux-kernel-owner+w=401wt.eu-S1764440AbXHWOwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764440AbXHWOwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbXHWOwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:52:34 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34915 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761522AbXHWOwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:52:33 -0400
Date: Thu, 23 Aug 2007 10:52:11 -0400
Message-Id: <200708231452.l7NEqBm5009674@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       moriai.satoshi@lab.ntt.co.jp, jsipek@ic.sunysb.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Ecryptfs-devel] [PATCH] eCryptfs: fix possible fault in ecryptfs_sync_page 
In-reply-to: Your message of "Thu, 23 Aug 2007 09:37:45 CDT."
             <20070823143745.GM22689@halcrow.austin.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070823143745.GM22689@halcrow.austin.ibm.com>, Michael Halcrow writes:
> On Thu, Aug 23, 2007 at 04:42:59PM +0900, Ryusuke Konishi wrote:
> > This will avoid a possible fault in ecryptfs_sync_page().
> 
> Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
> 
> Note that there are other outstanding issues with eCryptfs on NFS. For
> instance, prepare_write()/commit_write() have gone away in -mm,
> leading to an oops when eCryptfs tries to call them directly, which is
> well deserved, since eCryptfs really should not be doing that. Unionfs
> has just two places where it calls vfs_read() and vfs_write()
> respectively; eCryptfs is a bit more complex, with multiple write
> paths that end up writing encrypted data and updating metadata in the
> header. I am currently trying to find a way to convert everything over
> to vfs_read() and vfs_write() in eCryptfs, in a way that does not
> ultimately result in a kernel hang.

Mike, check the latest unionfs 2.1.2 code in
http://unionfs.filesystems.org/.  In the past couple of months I've already
gotten rid of direct calls to prepare/commit_write in favor of
vfs_read/write.  There were a number of reasons for that mostly having to do
with races, deadlocks/hangs, and memory-pressure conditions.  I also have a
number of additional mmap related fixes in fs/unionfs/mmap.c that you should
probably look at as they're applicable to stacking in general.

Lastly, to stack on nfs, at the very least you'll probably need my lower_nd
fixes from unionfs as well, or something like it.  As of 2.6.23-rc3, you
need to stack on the nameidata structure even for nfs2/nfs3.  My patches
take care of that for now (until such a day as the VFS will have a true,
stackable, small intent structure that can be passed to a lower f/s).

Cheers,
Erez.
