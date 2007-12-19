Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbXLSKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbXLSKqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXLSKqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:46:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbXLSKqF (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:46:05 -0500
Date: Wed, 19 Dec 2007 21:45:44 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Damien Wyart <damien.wyart@free.fr>, Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
Message-ID: <20071219104544.GC4612@sgi.com>
References: <20071218112804.GA3069@localhost.localdomain> <20071218122445.GJ4396912@sgi.com> <877ijckrco.fsf@free.fr> <20071218151946.GQ4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218151946.GQ4396912@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 02:19:47AM +1100, David Chinner wrote:
> On Tue, Dec 18, 2007 at 03:30:31PM +0100, Damien Wyart wrote:
> > * David Chinner <dgc@sgi.com> [071218 13:24]:
> > > Ok. I haven't noticed anything wrong with directories up to about
> > > 250,000 files in the last few days. The ls -l I just did on
> > > a directory with 15000 entries (btree format) used about 5MB of RAM.
> > > extent format directories appear to work fine as well (tested 500
> > > entries).
> > 
> > Ok, nice to know the problem is not so frequent.
> 
> .....
> 
> > I have put the files at http://damien.wyart.free.fr/xfs/
> > 
> > strace_xfs_problem.1.gz and strace_xfs_problem.2.gz have been created
> > with the problematic kernel, and are quite bigger than
> > strace_xfs_problem.normal.gz, which has been created with the vanilla
> > rc5-git5. There is also xfs_info.
> 
> Looks like several getdents() through the directory the getdents()
> call starts outputting the first files again. It gets to a certain
> point and always goes back to the beginning. However, it appears to
> get to the end eventually (without ever getting past the bad offset).

UML and a bunch of printk's to the rescue.

So we went back to double buffering, which then screwed up the d_off
of the dirents. I changed the temporary dirents to point to the current
offset so that filldir got what it expected when filling the user buffer.

Except it appears that it I didn't to initialise the current
offset for the first dirent read from the temporary buffer so filldir
occasionally got an uninitialised offset. Can someone pass me a
brown paper bag, please?

In my local testing, more often than not, that uninitialised offset
reads as zero which is where the looping comes from. Sometimes it
points off into wacko-land, which is probably how we eventually get
the looping terminating before you run out of memory.

That also explains why we haven't seen it - it requires the user buffer
to fill on the first entry of a backing buffer and so it is largely
dependent on the pattern of name lengths, page size and filesystem
block size aligning just right to trigger the problem.

Can you test this patch, Damien?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_file.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2007-12-19 00:26:40.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2007-12-19 21:26:38.701143555 +1100
@@ -348,6 +348,7 @@ xfs_file_readdir(
 
 		size = buf.used;
 		de = (struct hack_dirent *)buf.dirent;
+		curr_offset = de->offset /* & 0x7fffffff */;
 		while (size > 0) {
 			if (filldir(dirent, de->name, de->namlen,
 					curr_offset & 0x7fffffff,
