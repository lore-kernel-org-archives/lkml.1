Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXGNEWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXGNEWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 00:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXGNEV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 00:21:57 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:59346 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXGNEVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 00:21:55 -0400
X-Greylist: delayed 2089 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 00:21:55 EDT
Date: Fri, 13 Jul 2007 10:12:33 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kalpak Shah <kalpak@clusterfs.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support features in larger inode
Message-ID: <20070713161233.GH5880@schatzie.adilger.int>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Kalpak Shah <kalpak@clusterfs.com>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org> <20070713020529.1486491f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713020529.1486491f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 13, 2007  02:05 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 16:32:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +	brelse(bh);
> > > +	up_write(&EXT4_I(inode)->xattr_sem);
> > > +	return error;
> > > +}
> > > +
> > 
> > We're doing GFP_KERNEL memory allocations while holding xattr_sem.  This
> > can cause the VM to reenter the filesystem, perhaps taking i_mutex and/or
> > i_truncate_sem and/or journal_start() (I forget whether this still
> > happens).  Have we checked whether this can occur and if so, whether we are
> > OK from a lock ranking POV?  Bear in mind that journalled-data mode is more
> > complex in this regard.
> 
> I notice that everyone carefully avoided addressing this ;)
> 
> Oh well, hopefully people are testing with lockdep enabled.  As long
> as the fs is put under extreme memory pressure, most bugs should be reported.

I have no objection to changing these to GFP_NOFS or GFP_ATOMIC, because
the number of times this function is called is really quite small (only
for existing inodes when the size of the fixed fields in the inode is
increasing) and the buffers are freed immediately so this won't put any
undue strain on the atomic memory pools.

That said, there is also a GFP_KERNEL allocations in ext3_xattr_block_set()
under xattr_sem, so the same problem would exist there.

I also just noticed that "buffer" and "b_entry_name" are leaked in
ext4_expand_extra_isize() if the while loop is run more than one time
(again a relatively rare event).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

