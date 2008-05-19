Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbYESU01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbYESU01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYESU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:26:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbYESU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:26:15 -0400
Date: Mon, 19 May 2008 13:25:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: jack@suse.cz, pbadari@us.ibm.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] JBD: Fix DIO EIO error caused by race between free
 buffer and commit trasanction
Message-Id: <20080519132553.de9b78b0.akpm@linux-foundation.org>
In-Reply-To: <1211227158.3663.25.camel@localhost.localdomain>
References: <20080512155419.GD15856@duck.suse.cz>
	<1210639184.3661.43.camel@localhost.localdomain>
	<20080513145449.GC20806@duck.suse.cz>
	<1210717389.3638.24.camel@localhost.localdomain>
	<20080514170856.GH24363@duck.suse.cz>
	<1210786872.3657.48.camel@localhost.localdomain>
	<20080514181444.GI24363@duck.suse.cz>
	<1210947250.3608.18.camel@localhost.localdomain>
	<1210957976.4231.31.camel@badari-desktop>
	<1210971693.3608.46.camel@localhost.localdomain>
	<20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	<1211227158.3663.25.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 12:59:18 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> On Mon, 2008-05-19 at 00:37 +0200, Jan Kara wrote:
> >   Hi,
> > 
> > > This patch fixed a few races between direct IO and kjournald commit
> > > transaction.  An unexpected EIO error gets returned to direct IO
> > > caller when it failed to free those data buffers. This could be
> > > reproduced easily with parallel direct write and buffered write to the
> > > same file
> > > 
> > > More specific, those races could cause journal_try_to_free_buffers()
> > > fail to free the data buffers, when jbd is committing the transaction
> > > that has those data buffers on its t_syncdata_list or t_locked_list.
> > > journal_commit_transaction() still holds the reference to those
> > > buffers before data reach to disk and buffers are removed from the
> > > t_syncdata_list of t_locked_list. This prevent the concurrent
> > > journal_try_to_free_buffers() to free those buffers at the same time,
> > > but cause EIO error returns back to direct IO.
> > > 
> > > With this patch, in case of direct IO and when try_to_free_buffers() failed,
> > > let's waiting for journal_commit_transaction() to finish
> > > flushing the current committing transaction's data buffers to disk, 
> > > then try to free those buffers again.
> >   If Andrew or Christoph wouldn't beat you for "inventive use" of
> > gfp_mask, I'm fine with the patch as well ;). You can add
> >   Acked-by: Jan Kara <jack@suse.cz>
> > 
> 
> This is less intrusive way to fix this problem. The gfp_mask was marked
> as unused in try_to_free_page(). I looked at filesystems in the kernel,
> there is only a few defined releasepage() callback, and only xfs checks
> the flag(but not used). btrfs is actually using it though. I thought
> about the way you have suggested, i.e.clean up this gfp_mask and and
> replace with a flag.  I am not entirely sure if it we need to change the
> address_space_operations and fix all the filesystems for this matter.
> 
> Andrew, what do you think? Is this approach acceptable? 
> 

<wakes up>

Please ensure that the final patch is sufficiently well changelogged to
permit me to remain asleep ;)

The ->releasepage semantics are fairly ad-hoc and have grown over time.
It'd be nice to prevent them from becoming vaguer than they are.

It has been (approximately?) the case that code paths which really care
about having the page released will set __GFP_WAIT (via GFP_KERNEL)
whereas code paths which are happy with best-effort will clear
__GFP_WAIT (with a "0').  And that's reasonsable - __GFP_WAIT here
means "be synchronous" whereas !__GFP_WAIT means "be non-blocking".

Is that old convention not sufficient here as well?  Two problem areas
I see are mm/vmscan.c and fs/splice.c (there may be others).

In mm/vmscan.c we probably don't want your new synchronous behaviour
and it might well be deadlockable anyway.  No probs, that's what
__GFP_FS is for.

In fs/splice.c, reading the comment there I have a feeling that you've
found another bug, and that splice _does_ want your new synchronous
behaviour?
