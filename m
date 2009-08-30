Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZH3DDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZH3DDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 23:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZH3DDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 23:03:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58102 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZH3DDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 23:03:43 -0400
Date: Sat, 29 Aug 2009 21:03:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com,
       dwmw2@infradead.org
Subject: Re: [PATCH 0/7] discard support revisited
Message-ID: <20090830030345.GF22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829233718.GD22870@parisc-linux.org> <20090830021534.GA14706@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090830021534.GA14706@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 10:15:34PM -0400, Christoph Hellwig wrote:
> On Sat, Aug 29, 2009 at 05:37:19PM -0600, Matthew Wilcox wrote:
> > I think we're going to need to figure out whether we should be sending
> > UNMAP or WRITE SAME ... probably need to dive back into the T10 poostorm
> > to see what's going on.
> 
> Good question.  Latest I had heard was that at least one array vendor
> prefers the WRITE SAME.  To me it looks like the much saner interface
> for the OS, so unless there are arrays that strongly prefer UNMAP or
> we need to make use of the multiple extends feature in it I'd go with
> WRITE SAME as first choice.

I think we're going to see a split in array vendors, tbh.  Many were
very upset at the thought of taking out multiple extents from the UNMAP
command.  Which I suggested, because frankly it's insane.

> > Jens had some objections to the block layer bits last time I posted
> > these.  I forget what they were now (this would have been around May
> > 2nd, I think).  What I've done instead in my current patchset (which
> > undoubtedly has bugs because it isn't tested, because I'm not supposed
> > to be working on the weekends) is to make sd_prep_fn() call a new method
> > in the scsi_host_template.  That should translate the discard request
> > into a BLOCK_PC ATA_16 command, and we'll all be happy.
> > 
> > It goes a little something like this:
> > http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090829
> > 
> > Right now, the test tool is telling me 'Operation not supported', and
> > I haven't tried to figure out why yet.
> 
> Queue flag and handling the discard in the prep function is much better
> than the prepare function, yes.  I don't like the prep_fn callout to the
> host a lot.

No, but I think we can make it more palatable.  Look at the ugly USB
hack for accessing near the end of the disc that we have in sd_prep_fn
right now.  If we can push that into the USB driver, I think that'll make
everybody happier.

This also gives us an interesting opportunity to experiment with
translating read/write commands directly into ATA_16 commands rather than
going through the SCSI translation first.  That should save a few cycles.

> If we go with WRITE SAME as prefered discard option for
> scsi translating it to TRIM should be relatively easy, it uses the same
> LBA/length encoding as the regular WRITE_16, except that the payload is
> just a single sector.  That should be not too hard to implement in the
> SAT layer.

It should avoid the difficulty in translating the command size, true.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
