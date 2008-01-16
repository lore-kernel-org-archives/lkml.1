Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYAPTtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYAPTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYAPTsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:48:53 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:39877 "EHLO
	thinix-laptop.local.rdi1.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752327AbYAPTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:48:52 -0500
Subject: Re: unionfs, cow, and whiteout
From: Paul Albrecht <albrecht@rdi1.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200801161713.m0GHDRUN023917@agora.fsl.cs.sunysb.edu>
References: <200801161713.m0GHDRUN023917@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 13:48:46 -0600
Message-Id: <1200512926.12092.33.camel@thinix-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-16 at 12:13 -0500, Erez Zadok wrote: 
> In message <1200500833.11000.0.camel@thinix-laptop>, Paul Albrecht writes:
> > Hi,
> > 
> > I have a question about how unionfs handles file deletion when a write
> > enabled file system is union mounted over a read only file system. For
> > example, I do something like the following:
> > 
> > mount -t unionfs -o dirs=/cow=rw:/rofs=ro unionfs /mnt
> > 
> > If I create and delete a file in /mnt which is not present in /rofs it
> > persists as whiteout in the cow file system which is not what I would
> > have expected.
> 
> Paul, the alternative is to scan all branches (there could be many) to
> ensure that the file may not exist by that name anywhere else, and if so,
> try to delete all instances of it.  This was deemed too expensive and
> complex.
> 

I'm not sure we're talking about the same problem. What I do is union
mount a write enabled file system like tmpfs over a read only file
system like squashfs.

There's no way to create, modify, or delete files in a squashed file
system; they can be copied up when they're modified; or, they can be
whited out when they're deleted.

Whenever a file is created in the union mount, it necessarily gets
created in tmpfs. When that file gets deleted, it gets whited out which
doesn't make sense because it doesn't exist in the other layer.

This is a problem because over time as files are created, modified, and
deleted whiteout cruft accumulates in the cow layer of the union mount.

Fixing the problem doesn't seem that complex and shouldn't require
searching all the layers of the union mount.

If the union file system simply took note of whether a file was created
in the cow layer because it's new or because it's been modified and
copied up from the read only file system, then it would simply delete
the file in the former case and and use whiteout in the latter.

> Another possible problem is that if you choose to insert a new branch in the
> middle, and you didn't have the whiteout, you may re-expose the file name
> unintentionally.
> 

I don't see how the a "deleted" file in a read only file system could be
re-exposed unless its whiteout in the cow layer was deleted, but that's
really not the issue.

What I'm objecting to is creating the whiteout in the cow layer when the
file didn't get there via a copy up from a read only file system. In
this case there's no worry about re-exposing the deleted file because
it's really deleted.

> You might want to take a look at our unionfs-odf version: it places
> whiteouts in a separate persistent store outside the branches, not as .wh.*
> files in individual branches.
> 
> > Why does the deleted file persist as whiteout in the /cow file system of
> > the union mount?
> > 
> > Please cc me in your response as I'm not subscribed to the lkml.
> > 
> > -- 
> > 
> > Paul Albrecht
> 
> Cheers,
> Erez.
-- 

Paul Albrecht
