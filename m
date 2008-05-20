Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbYETXau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbYETXau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYETXai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:30:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46127 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752383AbYETXah (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:30:37 -0400
Date: Wed, 21 May 2008 09:30:15 +1000
From: David Chinner <dgc@sgi.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520233015.GY103491721@sgi.com>
References: <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru> <20080520232256.GA16105@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520232256.GA16105@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 03:22:56AM +0400, Evgeniy Polyakov wrote:
> On Wed, May 21, 2008 at 02:25:05AM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > > Oh, god no. Let's not put the inode_lock right at the top of
> > > the VM page cleaning path. We don't need to modify inode state,
> > > the superblock dirty lists, etc - all we need to do is write
> > > dirty pages on a given mapping in a more efficient manner.
> > 
> > I'm not advocating that, but having swap on reclaim does not hurt
> > anyone, this is essentially the same, but with different underlying
> > storage. System will do that anyway sooner or later during usual
> > writeback, which in turn can be a result of the same reclaim...
> 
> And actually having tiny operations under inode_lock is the last thing
> to worry about when we are about to start writing pages to disk because
> memory is so fragmented that we need to move things around.
> 
> That is the simplest from the typing viewpoint, one can also do
> something like that:
> 
> struct address_space *mapping = page->mapping;
> struct backing_dev_info *bdi = mapping->backing_dev_info;
> struct writeback_control wbc = {
> 	.bdi = bdi,
> 	.sync_mode = WB_SYNC_ALL, /* likly we want to wait... */
> 	.older_than_this = NULL,
> 	.nr_to_write = 13,
> 	.range_cyclic = 0,
> 	.range_start = start_index,
> 	.range_end = end_index
> };
> 
> do_writepages(mapping, &wbc);

Which is the exact implementation of

	filemap_fdatawrite_range(mapping, start, end);

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
