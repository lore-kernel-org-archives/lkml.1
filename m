Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYETXUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYETXUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYETXUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:20:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755456AbYETXUJ (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:20:09 -0400
Date: Wed, 21 May 2008 09:19:42 +1000
From: David Chinner <dgc@sgi.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520231942.GX103491721@sgi.com>
References: <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com> <20080520065622.GA13968@2ka.mipt.ru> <20080520214617.GU103491721@sgi.com> <20080520222505.GA23988@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520222505.GA23988@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 02:25:05AM +0400, Evgeniy Polyakov wrote:
> On Wed, May 21, 2008 at 07:46:17AM +1000, David Chinner (dgc@sgi.com) wrote:
> > Oh, god no. Let's not put the inode_lock right at the top of the VM page
> > cleaning path. We don't need to modify inode state, the superblock dirty
> > lists, etc - all we need to do is write dirty pages on a given mapping in
> > a more efficient manner.
> 
> I'm not advocating that, but having swap on reclaim does not hurt anyone,
> this is essentially the same, but with different underlying storage.

Sure. But my point is simply that sync_inode() is far too
heavy-weight to be used in a reclaim context. The fact that it holds
the inode_lock will interfere with normal writeback via pdflush and
that could potentially slow down writeback even more.

e.g. think of kswapd threads running on 20 nodes of a NUMA machine
all at once writing back dirty memory (yes, it happens). If we use
sync_inode() to write back dirty mappings we would then have at
least 20 CPUs serialising on the inode_lock trying to write back
pages. If we instead use a thin wrapper around ->writepages() then
they can all run in parallel through the filesystem(s), block
devices, etc rather than being serialised at the highest possible
layer....

> System
> will do that anyway sooner or later during usual writeback, which in turn
> can be a result of the same reclaim...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
