Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbYDXWoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbYDXWoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbYDXWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:44:34 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34317 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYDXWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:44:33 -0400
Date: Thu, 24 Apr 2008 18:39:07 -0400
Message-Id: <200804242239.m3OMd7hO020968@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Al Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Thu, 24 Apr 2008 15:16:30 CDT."
             <20080424201630.GC18686@localhost.austin.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080424201630.GC18686@localhost.austin.ibm.com>, Michael Halcrow writes:
> On Thu, Apr 24, 2008 at 03:40:03PM -0400, Erez Zadok wrote:
> > Ah, I see.  Yes: ecryptfs_init_persistent_file does have this odd
> > "try to open readwrite and if that failed, try readonly" code there.
> > I can't really say why it's done that way: Mike?  Maybe it was a
> > workaround to not having the right permissions to open that
> > persistent file?
> 
> The notion was that of "best effort," and it is sloppy.
> 
> I think the right way to do it will be to allow up to two persistent
> files. If the user with read-only perms opens, then open the
> persistent file RO. Then a user with write-only (but not read) perms
> opens; open another persistent file WO. Allow subsequent reads or
> writes by the various users to go through whichever persistent file
> has the right access. Then a user with RW access opens the file; close
> both the RO file and the WO file and open a new file RW. All the
> while, make sure that ecryptfs_open() performs all the requisite perm
> checks.

Correct me if I'm wrong, but what you call "persistent" file is simply (in
my stacking-speek :-) the lower file, right?  If so, then calling it
persistent may be confusing, b/c you could be stacked on top of a volatile
f/s (e.g., tmpfs or even *gasp* another stackable f/s) -- yes, even if it
may not make much sense from a security perspective.

The comment above ecryptfs_init_persistent_file() states that you only ever
keep a single open file for every lower inode.  Was this a security decision
(say, to prevent different access modes to the same ciphertext?); or was
that the attempt to workaround the limitation of the
address_space_operations API (that ->writepage doesn't get a struct file,
which you need to pass to vfs_write)?

I'm unclear what you mean above wrt two open files: do you mean

1. two struct file's, each pointing to a SEPARATE copy of the physical lower
  file?
	or
2. two struct file's, BOTH pointing to the same lower physical file?

Option #1 may be racy and I'm not clear what happens if a data file gets
'forked' that way: do you then have to merge it later on?

Or, are you propsing to keep alternating b/t an open struct file for RO, and
another open struct file for RW (or WO)?  If you alternate b/t the two,
keeping only one open at a time, what happens if two threads want to access
the same file: one reading and another writing the file.  Does that mean
that for every read(2) or write(2) you'll have to essentially release one
open file and open another (could slow things down a lot)?

> If this sounds reasonable, I will get working on a patch to do this.
> 
> Mike

Cheers,
Erez.
