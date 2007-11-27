Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbXK0C3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbXK0C3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbXK0C3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:29:39 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2769 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754118AbXK0C3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:29:38 -0500
Date: Mon, 26 Nov 2007 21:29:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: greg@kroah.com, <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kobjects: drop child->parent ref at unregistration
In-Reply-To: <20071126145810.eb848f23.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0711262124090.22315-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Andrew Morton wrote:

> On Mon, 19 Nov 2007 10:53:40 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > This patch (as1015) reverts changes that were made to the driver core
> > about four years ago.  The intent back then was to avoid certain kinds
> > of invalid memory accesses by leaving kernel objects allocated as long
> > as any of their children were still allocated.  The original and
> > correct approach was to wait only as long as any children were still
> > _registered_; that's what this patch reinstates.
> 
> What happened with this?

As far as I know, it's on Greg's queue.

> > This fixes a problem in the SCSI core made visible by the class_device
> > to regular device conversion: A reference loop (scsi_device holds
> > reference to request_queue, which is the child of a gendisk, which is
> > the child of the scsi_device) prevents the data structures from being
> > released, even though they are deregistered okay.
> > 
> > It's possible that this change will cause a few bugs to surface,
> > things that have been hidden for several years.  They can be fixed
> > easily enough by having the child device take an explicit reference to
> > the parent whenever needed.
> > 
> 
> How will such bugs manifest?  Ideally via a nice printk and a stack trace
> followed by damage avoidance.

They will manifest in the same way as any other use-after-free bug: an 
oops message and either death of the current process or a system hang.

Obviously I'm not aware of any such bugs -- if I were, I'd fix them.  
Greg has expressed concern that some USB serial drivers might have this 
problem.  I'll do what testing I can (not much because I don't have any 
USB serial devices).

> If it's via a mysterious crash or something similarly obscure then can we
> improve that?

I can't think of anything offhand.  Maybe someone else can.

Alan Stern

