Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYAPUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYAPUS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYAPUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:18:51 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33880 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYAPUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:18:50 -0500
Date: Wed, 16 Jan 2008 15:18:41 -0500
Message-Id: <200801162018.m0GKIf1c004098@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, unionfs@filesystems.org
Subject: Re: unionfs, cow, and whiteout 
In-reply-to: Your message of "Wed, 16 Jan 2008 13:48:46 CST."
             <1200512926.12092.33.camel@thinix-laptop> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I recommend we direct future discussions in this thread to the unionfs
ML. -ezk]

In message <1200512926.12092.33.camel@thinix-laptop>, Paul Albrecht writes:
[...]
> I'm not sure we're talking about the same problem. What I do is union
> mount a write enabled file system like tmpfs over a read only file
> system like squashfs.
> 
> There's no way to create, modify, or delete files in a squashed file
> system; they can be copied up when they're modified; or, they can be
> whited out when they're deleted.
> 
> Whenever a file is created in the union mount, it necessarily gets
> created in tmpfs. When that file gets deleted, it gets whited out which
> doesn't make sense because it doesn't exist in the other layer.
> 
> This is a problem because over time as files are created, modified, and
> deleted whiteout cruft accumulates in the cow layer of the union mount.
> 
> Fixing the problem doesn't seem that complex and shouldn't require
> searching all the layers of the union mount.

Paul, you're looking into a specific 2-branch configuration where one branch
is r-o and the other is r-w.  Yes, in that specific case, one could argue
that a whiteout isn't needed.  But what if I have N branches, with a mix of
rw/ro branches, where a file or its whiteout could exist in any branch?  If
I don't create a whiteout, then I have to scan all N branches and remove the
same file from there (assuming the file doesn't exist on a r-o branch --
then I have to abort).

Note also that branches could be dynamically marked r-o or r-w over the
lifetime of the union: so a file which was deletable before may not be
deletable in the future.

We used to have several modes of operations, including one called
DELETE_ALL, which was similar to what you're asking for.  But it complicated
the code considerably and most users didn't use that mode.  So we opted for
simplicity and clarity of code, rather than having special cases for
different branch configurations.

If you're willing to open a feature-request report on
https://bugzilla.filesystems.org/, then we'll be happy to consider your
request and see how it can be incorporated while keeping the base code
devoid of special cases.  Thanks.

> If the union file system simply took note of whether a file was created
> in the cow layer because it's new or because it's been modified and
> copied up from the read only file system, then it would simply delete
> the file in the former case and and use whiteout in the latter.

Taking that "note" requires that the information survives a reboot; so I
can't store it in memory, but it has to be stored persistently.  That would
complicate the code and one might as well use unionfs-odf instead.

> > Another possible problem is that if you choose to insert a new branch in
> > the middle, and you didn't have the whiteout, you may re-expose the file
> > name unintentionally.
> > 
> 
> I don't see how the a "deleted" file in a read only file system could be
> re-exposed unless its whiteout in the cow layer was deleted, but that's
> really not the issue.

Suppose you have your two branches, you created a file X and deleted it.
Now, you insert a new branch in the *middle*, which has file X in it: do you
want that new file to show up in /bin/ls, or not?  If you didn't create a
whiteout in the /cow layer, then file X will re-appear after the user
supposedly deleted it.  (To be fair, the desired semantics here are not
clear -- some users may want it one way or another -- but I want to ensure a
*consistent* semantics that is simple to understand).

> What I'm objecting to is creating the whiteout in the cow layer when the
> file didn't get there via a copy up from a read only file system. In
> this case there's no worry about re-exposing the deleted file because
> it's really deleted.

Paul, it really looks to me that you'd prefer the unionfs-odf version: it
has a flavor of the older delete-all mode.  In unionfs-odf, we first try to
delete the file from all branches.  If we can't (b/c of r-o branches/media),
then we create a whiteout in the (small) /odf partition.  Therefore,
whiteouts are never stored in the main union'ed branches.

Cheers,
Erez.
