Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYLKOn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYLKOn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 09:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbYLKOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 09:43:45 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:26176 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbYLKOno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 09:43:44 -0500
Subject: Re: Btrfs trees for linux-next
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20081210200604.8e190b0d.akpm@linux-foundation.org>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 09:43:16 -0500
Message-Id: <1229006596.22236.46.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49412709.0008:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 20:06 -0800, Andrew Morton wrote:
> On Thu, 11 Dec 2008 14:14:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > On Wed, 10 Dec 2008 21:34:56 -0500 Chris Mason <chris.mason@oracle.com> wrote:
> > >
> > > Just an update, while I still have a long todo list and plenty of things
> > > to fix in the code, these src trees have been updated with a disk format
> > > I hope to maintain compatibility with from here on.  There are still
> > > format changes planned, but should go in through the compat mechanisms
> > > in the sources now.
> > > 
> > > The btrfs trees are still at 2.6.28-rc5, but I just tested against
> > > linux-next without problems.
> > 
> > Do you think this is ready to be added to the end of linux-next, yet?  Or
> > is this more -mm material?
> 
> I'd prefer that it go into linux-next in the usual fashion.  But the
> first step is review..

I'm updating the various docs on the btrfs wiki.  From a kernel impact
point of view, btrfs only changes fs/Kconfig and fs/Makefile.

Some of the most visible problems in the code are:

No support for fs blocksizes other than the page size.  This includes
data blocks and btree leaves/nodes.  In both cases, the infrastructure
to do it is about 1/2 there, but some ugly problems remain.

btrfs_file_write should just be removed in favor of write_begin/end.
Right now, the main thing btrfs_file_write does is the dance to setup
delalloc, so this should be fairly easy.

The multi-device code uses a very simple brute force scan from userland
to populate the list of devices that belong to a given FS.  Kay Sievers
has some ideas on hotplug magic to make this less dumb.  (The scan isn't
required for single device filesystems).

extent_io.c should be split up into two files, one for the extent_buffer
code and one for the state bit code.

struct-funcs.c needs a big flashing neon sign about what it does and
why.  The extent_buffer interface needs much clearer documentation
around why it is there and how it works.

There are too many worker threads.  At least some of them should be
shared between filesystems instead of started for each FS.  Each pool of
worker thread represents some operation that would end up deadlocking if
it shared threads with another pool.

There are too many memory allocations on the IO submission path.  It
needs mempools and other steps to limit the amount of ram used to write
a single block.

The IO submission path is generally twisty, with helper threads and
lookup functions.  There is quite a bit going on here in terms of
asynchronous checksumming and compression and it needs better
documentation.

ENOSPC == BUG()

The extent allocation tree is what records which extents are allocated
on disk, and tree blocks for the extent allocation tree allocated from
the extent allocation tree.  This recursion is controlled by deferring
some operations for later processing, and the resulting complexity needs
better documentation.

-chris


