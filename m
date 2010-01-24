Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852Ab0AXWkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0AXWkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793Ab0AXWkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:40:42 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:48031 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754774Ab0AXWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:40:41 -0500
Date: Mon, 25 Jan 2010 09:40:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fix filesystem_sync vs write race on rw=>ro remount
Message-ID: <20100124224035.GK25842@discord.disaster>
References: <87sk9vd92c.fsf@openvz.org> <20100124195309.GX19799@ZenIV.linux.org.uk> <87r5pfw6ew.fsf@openvz.org> <20100124213707.GY19799@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124213707.GY19799@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 09:37:07PM +0000, Al Viro wrote:
> On Mon, Jan 25, 2010 at 12:15:51AM +0300, Dmitry Monakhov wrote:
> 
> > > It's not a solution.  You get an _attempted_ remount ro making writes
> > > fail, even if it's going to be unsuccessful.  No go...
> > We have two options for new writers:
> > 1) Fail it via -EROFS
> >    Yes, remount may fail, but it is really unlikely.
> > 2) Defer(block) new writers on until we complete or fail remount
> >    for example like follows. Do you like second solution ?
> 
> Umm...  I wonder what the locking implications would be...  Frankly,
> I suspect that what we really want is this:
> 	* per-superblock write count of some kind, bumped when we decide
> that writeback is inevitable and dropped when we are done with it (the
> same thing goes for async part of unlink(), etc.)
> 	* fs_may_remount_ro() checking that write count
> So basically we try to push those short-term writers to completion and
> if new ones had come while we'd been doing that (or some are really
> stuck) we fail remount with -EBUSY.

Perhaps we could utilise the filesystem freeze infrastructure - it
already has hooks for intercepting new writers and modifcations,
and filesystems have to flush any current modifications before the freeze
completes. It sounds very similar to the requirements needed here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
