Return-Path: <linux-kernel-owner+w=401wt.eu-S1162205AbXECRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162205AbXECRia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162204AbXECRia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:38:30 -0400
Received: from mail.rialcom.ru ([80.71.245.247]:52716 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161509AbXECRi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:38:28 -0400
X-Spam-Flag: SKIP
X-Spam-Yversion: Spamooborona 1.6.1
Message-ID: <463A1E02.8020506@clusterfs.com>
Date: Thu, 03 May 2007 21:38:10 +0400
From: Alex Tomas <alex@clusterfs.com>
Organization: Cluster Filesystems, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070302 Fedora/1.5.0.10-1.fc6 pango-text Thunderbird/1.5.0.10 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andreas Dilger <adilger@clusterfs.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marat Buharov <marat.buharov@gmail.com>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net>	<20070427013350.d0d7ac38.akpm@linux-foundation.org>	<698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>	<alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>	<20070427193130.GD5967@schatzie.adilger.int> <20070427151837.f1439639.akpm@linux-foundation.org>
In-Reply-To: <20070427151837.f1439639.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> We can make great improvements here, and I've (twice) previously decribed
> how: hoist the entire ordered-mode data handling out of ext3, and out of
> the buffer_head layer and move it up into the VFS pagecache layer. 
> Basically, do ordered-data with a commit-time inode walk, calling
> do_sync_mapping_range().
> 
> Do it in the VFS.  Make reiserfs use it, remove reiserfs ordered-mode too. 
> Make XFS use it, fix the hey-my-files-are-all-full-of-zeroes problem there.

I'm not sure it's that easy.

if we move to pages, then we have to mark pages to be flushed holding
transaction open. now take delayed allocation into account: we need
to allocate number of blocks at once and then mark all pages mapped,
again within context of the same transaction. so, an implementation
would look like the following?

generic_writepages() {
	/* collect set of contig. dirty pages */
	foo_get_blocks() {
		foo_journal_start();
		foo_new_blocks();
		foo_attach_blocks_to_inode();
		generic_mark_pages_mapped();
		foo_journal_stop();
	}
}

another question is will it scale well given number of dirty inodes
can be much larger than number of inodes with dirty mapped blocks
(in delayed allocation case, for example) ?

thanks, Alex




