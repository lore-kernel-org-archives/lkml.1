Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXIXTsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXIXTsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXIXTrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:47:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104AbXIXTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:47:55 -0400
Date: Mon, 24 Sep 2007 12:42:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-Id: <20070924124233.9197d6b6.akpm@linux-foundation.org>
In-Reply-To: <1190662091.26982.246.camel@localhost>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
	<20070924175411.GA2314@infradead.org>
	<1190662091.26982.246.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:28:11 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> On Mon, 2007-09-24 at 18:54 +0100, Christoph Hellwig wrote:
> > As we already say in various messages the percpu counters in here
> > look rather fishy.  I'd recomment to take a look at the per-cpu
> > superblock counters in XFS as they've been debugged quite well
> > now and could probably be lifted into a generic library for this
> > kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> > can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> > 
> > It also handles cases like hotplug cpu nicely that this code
> > seems to work around by always iterating over all possible cpus
> > which might not be nice on a dual core laptop with a distro kernel
> > that also has to support big iron.
> 
> I'll take a look at xfs to see what I can get out of it.

And at include/linux/percpu_counter.h, please.

> There are basically two times when you have to do this
> for_each_possible_cpu() stuff:
> 1. when doing a r/w->r/o transition, which is rare, and
>    certainly not a fast path
> 2. Where the per-cpu writer count underflows.  This requires
>    a _minimum_ of 1<<16 file opens (configurable) each of which
>    is closed on a different cpu than it was opened on.  Even
>    if you were trying, I'm not sure you'd notice the overhead.
> 

Sounds like what you're doing is more akin to the local_t-based module
refcounting.  `grep local_ kernel/module.c'.

That code should be converted from NR_CPUS to for_each_possible_cpu()..
