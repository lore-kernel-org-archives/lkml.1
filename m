Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYBRSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYBRSpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYBRSpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:45:23 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40340 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbYBRSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:45:22 -0500
Date: Mon, 18 Feb 2008 13:45:04 -0500
From: Theodore Tso <tytso@mit.edu>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218184504.GH25098@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Andi Kleen <andi@firstfloor.org>,
	LKML <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47B99E0C.8020706@wpkg.org> <20080218151632.GD25098@mit.edu> <47B9AF77.9040702@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B9AF77.9040702@wpkg.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:16:55PM +0100, Tomasz Chmielewski wrote:
> Theodore Tso schrieb:
>
>> I'd really need to know exactly what kind of operations you were
>> trying to do that were causing problems before I could say for sure.
>> Yes, you said you were removing unneeded files, but how were you doing
>> it?  With rm -r of old hard-linked directories?
>
> Yes, with rm -r.

You should definitely try the spd_readdir hack; that will help reduce
the seek times.  This will probably help on any block group oriented
filesystems, including XFS, etc.

>> How big are the
>> average files involved?  Etc.
>
> It's hard to estimate the average size of a file. I'd say there are not 
> many files bigger than 50 MB.

Well, Ext4 will help for files bigger than 48k.

The other thing that might help for you is using an external journal
on a separate hard drive (either for ext3 or ext4).  That will help
alleviate some of the seek storms going on, since the journal is
written to only sequentially, and putting it on a separate hard drive
will help remove some of the contention on the hard drive.  

I assume that your 1.2 TB filesystem is located on a RAID array; did
you use the mke2fs -E stride option to make sure all of the bitmaps
don't get concentrated on one hard drive spindle?  One of the failure
modes which can happen is if you use a 4+1 raid 5 setup, that all of
the block and inode bitmaps can end up getting laid out on a single
hard drive, so it becomes a bottleneck for bitmap intensive workloads
--- including "rm -rf".  So that's another thing that might be going
on.  If you do a "dumpe2fs", and look at the block numbers for the
block and inode allocation bitmaps, and you find that they are are all
landing on the same physical hard drive, then that's very clearly the
biggest problem given an "rm -rf" workload.  You should be able to see
this as well visually; if one hard drive has its hard drive light
almost constantly on, and the other ones don't have much activity,
that's probably what is happening.

						- Ted
