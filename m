Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYDXXgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYDXXgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYDXXfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:35:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38150 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYDXXfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:35:51 -0400
Date: Thu, 24 Apr 2008 18:33:47 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <prussell@au1.ibm.com>
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424233347.GF18686@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080424201630.GC18686@localhost.austin.ibm.com> <200804242239.m3OMd7hO020968@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804242239.m3OMd7hO020968@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 06:39:07PM -0400, Erez Zadok wrote:
> In message <20080424201630.GC18686@localhost.austin.ibm.com>,
> Michael Halcrow writes:
> > I think the right way to do it will be to allow up to two persistent
> > files. If the user with read-only perms opens, then open the
> > persistent file RO. Then a user with write-only (but not read) perms
> > opens; open another persistent file WO. Allow subsequent reads or
> > writes by the various users to go through whichever persistent file
> > has the right access. Then a user with RW access opens the file; close
> > both the RO file and the WO file and open a new file RW. All the
> > while, make sure that ecryptfs_open() performs all the requisite perm
> > checks.
> 
> Correct me if I'm wrong, but what you call "persistent" file is
> simply (in my stacking-speek :-) the lower file, right?  If so, then
> calling it persistent may be confusing, b/c you could be stacked on
> top of a volatile f/s (e.g., tmpfs or even *gasp* another stackable
> f/s) -- yes, even if it may not make much sense from a security
> perspective.

So long as the eCryptfs inode is alive, it will have at least one open
file in the corresponding inode for the lower filesystem. This file is
"persistent" for the life of the eCryptfs inode.

> The comment above ecryptfs_init_persistent_file() states that you
> only ever keep a single open file for every lower inode.  Was this a
> security decision (say, to prevent different access modes to the
> same ciphertext?); or was that the attempt to workaround the
> limitation of the address_space_operations API (that ->writepage
> doesn't get a struct file, which you need to pass to vfs_write)?

I intend to use the persistent file as a means to use vfs_read() and
vfs_write() in readpage() and writepage().

> I'm unclear what you mean above wrt two open files: do you mean
> 
> 1. two struct file's, each pointing to a SEPARATE copy of the physical lower
>   file?
> 	or
> 2. two struct file's, BOTH pointing to the same lower physical file?

I intned two lower files, both opened against the same lower inode,
via any dentry that happened to be used to get to that inode.

> Option #1 may be racy and I'm not clear what happens if a data file
> gets 'forked' that way: do you then have to merge it later on?
> 
> Or, are you propsing to keep alternating b/t an open struct file for
> RO, and another open struct file for RW (or WO)?  If you alternate
> b/t the two, keeping only one open at a time, what happens if two
> threads want to access the same file: one reading and another
> writing the file.

I proposed two open files, one with RO access, and one with WO access,
in the circumstance that one process only had read access on open, and
the other process only had write access on open. A write-only
ecryptfs_open() would result in an eCryptfs file struct that only used
the WO persistent file, after the appropriate permission checks are
done.

> Does that mean that for every read(2) or write(2) you'll have to
> essentially release one open file and open another (could slow
> things down a lot)?

Not really; I was proposing to keep two lower files open to use for
write-only or read-only operations, and if I ever got RW permission on
a file linked to the lower inode, I would just get rid of both and
replace them with a single RW persistent file. All while maintaining
proper permission checks in ecryptfs_open(), so a RO ecryptfs_open()
would only ever be allowed to read from the RW persistent file.

Really, this business with possibly two lower persistent files is
probably too much of a game to play. Rusty suggested that perhaps I
should just create a root-owned kernel thread in eCryptfs that would
have the responsibility of acquiring a RW lower persistent file,
regardless of the euid and permissions of whatever process made the
initial syscall that brought the eCryptfs inode into existence. I am
tempted to go that route instead.

Mike
