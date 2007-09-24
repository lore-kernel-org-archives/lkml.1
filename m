Return-Path: <linux-kernel-owner+w=401wt.eu-S1763326AbXIXT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763326AbXIXT2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbXIXT2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:28:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50691 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbXIXT2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:28:14 -0400
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070924175411.GA2314@infradead.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195320.38C8E20D@kernel>  <20070924175411.GA2314@infradead.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 12:28:11 -0700
Message-Id: <1190662091.26982.246.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 18:54 +0100, Christoph Hellwig wrote:
> As we already say in various messages the percpu counters in here
> look rather fishy.  I'd recomment to take a look at the per-cpu
> superblock counters in XFS as they've been debugged quite well
> now and could probably be lifted into a generic library for this
> kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> 
> It also handles cases like hotplug cpu nicely that this code
> seems to work around by always iterating over all possible cpus
> which might not be nice on a dual core laptop with a distro kernel
> that also has to support big iron.

I'll take a look at xfs to see what I can get out of it.

There are basically two times when you have to do this
for_each_possible_cpu() stuff:
1. when doing a r/w->r/o transition, which is rare, and
   certainly not a fast path
2. Where the per-cpu writer count underflows.  This requires
   a _minimum_ of 1<<16 file opens (configurable) each of which
   is closed on a different cpu than it was opened on.  Even
   if you were trying, I'm not sure you'd notice the overhead.

-- Dave

