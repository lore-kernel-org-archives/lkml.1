Return-Path: <linux-kernel-owner+w=401wt.eu-S933791AbXLMWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbXLMWCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761085AbXLMWCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:02:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54772 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbXLMWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:02:31 -0500
Date: Thu, 13 Dec 2007 15:02:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Cc: Mark Lord <liml@rtr.ca>, Mark Lord <lkml@rtr.ca>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: VM allocates pages in reverse order again
Message-ID: <20071213220230.GR26334@parisc-linux.org>
References: <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk> <4761883A.7050908@rtr.ca> <476188C4.9030802@rtr.ca> <20071213193937.GG10104@kernel.dk> <47618B0B.8020203@rtr.ca> <20071213195350.GH10104@kernel.dk> <20071213200219.GI10104@kernel.dk> <476190BE.9010405@rtr.ca> <20071213200958.GK10104@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213200958.GK10104@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:09:59PM +0100, Jens Axboe wrote:
> > >diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > >index e30b1a4..1e34b6f 100644
> > >--- a/block/ll_rw_blk.c
> > >+++ b/block/ll_rw_blk.c
> > >@@ -1349,6 +1351,8 @@ new_segment:
> > > 				sg = sg_next(sg);
> > > 			}
> > > 
> > >+			if (bvprv && (page_address(bvprv->bv_page) + 
> > >bvprv->bv_len == page_address(bvec->bv_page)))
> > >+				printk("missed merge\n");
> > > 			sg_set_page(sg, bvec->bv_page, nbytes, 
> > > 			bvec->bv_offset);
> > > 			nsegs++;
> > > 		}
> > >
> > ..
> > 
> > Yeah, the first part is similar to my own hack.
> > 
> > For testing, try "dd if=/dev/sda of=/dev/null bs=4096k".
> > That *really* should end up using contiguous pages on most systems.
> > 
> > I figured out the git thing, and am now building some in-between kernels to 
> > try.
> 
> OK, it's a vm issue, I have tens of thousand "backward" pages after a
> boot - IOW, bvec->bv_page is the page before bvprv->bv_page, not
> reverse. So it looks like that bug got reintroduced.

Perhaps we should ask the -mm folks if they happen to have an idea what
caused it ...

Background: we're seeing pages allocated in reverse order after boot.
This causes IO performance problems on machines without IOMMUs as we
can't merge pages when they're allocated in the wrong order.  This is
something that went wrong between 2.6.23 and 2.6.24-rc5.

Bill Irwin had a patch that fixed this; it was merged months ago, but
the effects of it seem to have been undone.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
