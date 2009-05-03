Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZECNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZECNIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 09:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZECNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 09:08:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55018 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZECNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 09:08:19 -0400
Date: Sun, 3 May 2009 14:07:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Matthew Wilcox <matthew@wil.cx>
cc: Matthew Wilcox <willy@linux.intel.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
In-Reply-To: <20090503071619.GP8822@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
 <20090503071619.GP8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Matthew Wilcox wrote:
> On Sat, May 02, 2009 at 11:11:50PM -0700, Matthew Wilcox wrote:
> > > blkdev_issue_discard() and blk_ioctl_discard() has half a page
> > > of common (and changing) code, could be done to use a common
> > > helper that sets policy about bio allocation sizes and such.
> > > 
> > > Just my $0.017
> > 
> > Yes, that works nicely.  Thanks for the suggestion.
> 
> I've pushed out a new git tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090502

I'm glad to see this coming alive again, thank you.

I notice OCZ hope to have updated Vertex firmware mid-May,
such that their TRIM support matches up with (y)ours.

One comment below...

> 
> Changes since the last version:
> 
>  - Based on 2.6.30-rc4.
>  - Dropped the three patches which were already merged.
>  - Shuffled 'Make DISCARD_BARRIER and DISCARD_NOBARRIER writes instead of
>    reads' to the front of the queue since it's not controversial and could
>    be merged earlier.
>  - Inserted 'Unify blk_ioctl_discard and blkdev_issue_discard' as patch two.
>  - Updated 'ide: Add support for TRIM' to compile with new IDE code.
> 
> Still to do:
>  - Understand all the changes Bart made to the IDE code; I didn't make all
>    the changes that he did.  I just made it compile for now.
>  - Dave had some objections to the description of 'Make DISCARD_BARRIER and
>    DISCARD_NOBARRIER writes instead of reads', but didn't propose replacement
>    text.
>  - Figure out what to do about memory allocation.

You have GFP_KERNEL allocations in your discard_fn()s.  I believe that
allocations down at that level will need to be GFP_NOIO - the bio mempool
might be empty by this point, you don't want memory allocation to get into
submitting even more I/O to satisfy your discard_fn().  Does it need its
own mempool of reserve pages?  My guess is that you can get away without
that, since a failed discard, though regrettable, loses no data.

Hugh

>  - Handle error returns from discard_prep.
>  - Test the new code still works.
>  - Delve into the latest SCSI spec and see if anything changed in UNMAP
> 
> Given the extensive length of the todo list, I shan't send out the mailbomb.
