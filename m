Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYJINkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYJINkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbYJINjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:39:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49605 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbYJINjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:39:52 -0400
To: matthew@wil.cx
CC: pavel@suse.cz, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       andi@firstfloor.org, hifumi.hisashi@oss.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu
In-reply-to: <20081009130131.GV25780@parisc-linux.org> (message from Matthew
	Wilcox on Thu, 9 Oct 2008 07:01:32 -0600)
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org> <20081009122319.GC1623@ucw.cz> <20081009130131.GV25780@parisc-linux.org>
Message-Id: <E1KnvjE-0003Jn-Tk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 15:38:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Matthew Wilcox wrote:
> On Thu, Oct 09, 2008 at 02:23:19PM +0200, Pavel Machek wrote:
> > On Tue 2008-10-07 20:52:09, Matthew Wilcox wrote:
> > > And it's worth saying that letter-of-the-standard arguments aren't
> > > necessarily enough.  Linux does not honour the POSIX guarantee that
> > > writes are atomic (if they cross page boundaries, it's not certain).
> > > This seems like even more of a corner case to me.
> > 
> > We have append-only files, and normal users should not be able to work
> > around that restriction.
> 
> Is it possible to work around this restriction by exploiting this?
> 
> IS_APPEND() forces the user to have O_APPEND in their flags.
> O_APPEND is only checked in generic_write_checks() where it sets '*pos'
> to i_size.
> 
> For the majority of filesystems, generic_write_checks() is called from 
> __generic_file_aio_write_nolock.  __generic_file_aio_write_nolock is
> only called from generic_file_aio_write_nolock (which passes the address
> of a kiocb->ki_pos) and generic_file_aio_write (same).
> 
> The filesystems that call generic_write_checks() directly are:
> XFS (xfs_write): Passes the address of a local variable
> OCFS2 (ocfs2_file_aio_write): Passes the address of a ki_pos
> CIFS (cifs_user_write): Not sure.
> NFS (nfs_file_direct_write): "Note that O_APPEND is not supported".
> NTFS (ntfs_file_aio_write_nolock): Address of a local variable
> FUSE (fuse_file_aio_write): Address of a local variable
> FUSE (fuse_direct_write): Not sure.
> 
> So the only two that might be affected are CIFS and FUSE (O_DIRECT?!) as
> far as I can tell.  I'm having a hard time believing this is a security
> problem.

And even in those cases it's actually a local variable, since
sys_write() does:

		loff_t pos = file_pos_read(file);
		ret = vfs_write(file, buf, count, &pos);
		file_pos_write(file, pos);

So there's no way to corrupt the starting position for an append mode
write, as that always comes from the file size.

Two append writes to the same file could corrupt f_pos, but that would
only matter for subsequent reads or non-append mode writes.

Miklos
