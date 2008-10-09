Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYJINBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYJINBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYJINBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:01:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38528 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbYJINBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:01:33 -0400
Date: Thu, 9 Oct 2008 07:01:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pavel Machek <pavel@suse.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Message-ID: <20081009130131.GV25780@parisc-linux.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org> <20081009122319.GC1623@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009122319.GC1623@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:23:19PM +0200, Pavel Machek wrote:
> On Tue 2008-10-07 20:52:09, Matthew Wilcox wrote:
> > And it's worth saying that letter-of-the-standard arguments aren't
> > necessarily enough.  Linux does not honour the POSIX guarantee that
> > writes are atomic (if they cross page boundaries, it's not certain).
> > This seems like even more of a corner case to me.
> 
> We have append-only files, and normal users should not be able to work
> around that restriction.

Is it possible to work around this restriction by exploiting this?

IS_APPEND() forces the user to have O_APPEND in their flags.
O_APPEND is only checked in generic_write_checks() where it sets '*pos'
to i_size.

For the majority of filesystems, generic_write_checks() is called from 
__generic_file_aio_write_nolock.  __generic_file_aio_write_nolock is
only called from generic_file_aio_write_nolock (which passes the address
of a kiocb->ki_pos) and generic_file_aio_write (same).

The filesystems that call generic_write_checks() directly are:
XFS (xfs_write): Passes the address of a local variable
OCFS2 (ocfs2_file_aio_write): Passes the address of a ki_pos
CIFS (cifs_user_write): Not sure.
NFS (nfs_file_direct_write): "Note that O_APPEND is not supported".
NTFS (ntfs_file_aio_write_nolock): Address of a local variable
FUSE (fuse_file_aio_write): Address of a local variable
FUSE (fuse_direct_write): Not sure.

So the only two that might be affected are CIFS and FUSE (O_DIRECT?!) as
far as I can tell.  I'm having a hard time believing this is a security
problem.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
