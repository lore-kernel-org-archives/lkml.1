Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXEPTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXEPTRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbXEPTRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:17:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13199 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbXEPTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:17:30 -0400
Date: Wed, 16 May 2007 15:13:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-ID: <20070516191339.GA26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com> <464B2AC2.10206@redhat.com> <20070516171156.GY26766@think.oraclecorp.com> <20070516112515.b6f247b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516112515.b6f247b2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:25:15AM -0700, Andrew Morton wrote:
> On Wed, 16 May 2007 13:11:56 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
> 
> > At least on ext3, it may help to sort the blocks under io for
> > flushing...it may not.  A bigger log would definitely help, but I would
> > say the mkfs defaults should be reasonable for a workload this simple.
> > 
> > (data=writeback was used for my ext3 numbers).
> 
> When ext3 runs out of journal space it needs to sync lots of metadata out
> to the fs so that its space in the journal can be reclaimed.  That metadata
> is of course splattered all over the place so it's seekstorm time.
> 
> The filesystem does take some care to place the metadata blocks "close" to
> the data blocks.  But of course if we're writing all the pagecache and then
> we later separately go back and write the metadata then that would screw
> things up.

Just to clarify, in the initial stage where kernel trees are created,
benchmark doesn't call sync.  So all the writeback is through the normal
async mechanisms.

> 
> I put some code in there which will place indirect blocks under I/O at
> the same time as their data blocks, so everything _should_ go out in a
> nice slurp (see write_boundary_block()).  The first thing to do here
> is to check that write_boundary_block() didn't get broken.

write_boundary_block should get called from pdflush and the IO done by
pdflush seems to be pretty sequential.  But, in this phase the
vast majority of the files are small (95% are less than 46k).
> 
> If that's still working then the problem will _probably_ be directory
> writeout.  Possibly inodes, but they should be well-laid-out.
> 
> Were you using dir_index?  That might be screwing things up.

Yes, dir_index.  A quick test of mkfs.ext3 -O ^dir_index seems to still
have the problem.  Even though the inodes are well laid out, is the
order they get written sane?  Looks like ext3 is just walking a list of
bh/jh, maybe we can just sort the silly thing?

-chris

