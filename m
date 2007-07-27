Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbXG0JEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbXG0JEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbXG0JD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:03:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760016AbXG0JDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:03:55 -0400
Date: Fri, 27 Jul 2007 02:02:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070727020232.883be5a8.akpm@linux-foundation.org>
In-Reply-To: <20070727085440.GT27237@ftp.linux.org.uk>
References: <46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
	<20070726023401.f6a2fbdf.akpm@linux-foundation.org>
	<20070726094024.GA15583@elte.hu>
	<20070726030902.02f5eab0.akpm@linux-foundation.org>
	<1185454019.6449.12.camel@Homer.simpson.net>
	<20070726110549.da3a7a0d.akpm@linux-foundation.org>
	<1185513177.6295.21.camel@Homer.simpson.net>
	<1185521021.6295.50.camel@Homer.simpson.net>
	<20070727014749.85370e77.akpm@linux-foundation.org>
	<20070727085440.GT27237@ftp.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 09:54:41 +0100 Al Viro <viro@ftp.linux.org.uk> wrote:

> On Fri, Jul 27, 2007 at 01:47:49AM -0700, Andrew Morton wrote:
> > What I think is killing us here is the blockdev pagecache: the pagecache
> > which backs those directory entries and inodes.  These pages get read
> > multiple times because they hold multiple directory entries and multiple
> > inodes.  These multiple touches will put those pages onto the active list
> > so they stick around for a long time and everything else gets evicted.
> 
> I wonder what happens if you try that on ext2.  There we'd get directory
> contents in per-directory page cache, so the picture might change...

afacit ext2 just forgets to run mark_page_accessed for directory pages
altogether, so it'll be equivalent to ext3 with that one-liner, I expect.

The directory pagecache on ext2 might get reclaimed faster because those
pages are eligible for reclaiming via the reclaim of their inodes, whereas
ext3's directories are in blockdev pagecache, for which the reclaim-via-inode
mechanism cannot happen.

I should do some testing with mmapped files.
