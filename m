Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZFETPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZFETPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZFETP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:15:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZFETP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:15:27 -0400
Date: Fri, 5 Jun 2009 21:15:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090605191528.GV11363@kernel.dk>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <20090604152040.GA6007@nowhere> <20090604120726.708a2211.akpm@linux-foundation.org> <20090604191309.GA4862@nowhere> <20090604195013.GB11363@kernel.dk> <20090604201012.GD11363@kernel.dk> <20090604223449.GA13780@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604223449.GA13780@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05 2009, Frederic Weisbecker wrote:
> On Thu, Jun 04, 2009 at 10:10:12PM +0200, Jens Axboe wrote:
> > On Thu, Jun 04 2009, Jens Axboe wrote:
> > > On Thu, Jun 04 2009, Frederic Weisbecker wrote:
> > > > On Thu, Jun 04, 2009 at 12:07:26PM -0700, Andrew Morton wrote:
> > > > > On Thu, 4 Jun 2009 17:20:44 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > 
> > > > > > I've just tested it on UP in a single disk.
> > > > > 
> > > > > I must say, I'm stunned at the amount of testing which people are
> > > > > performing on this patchset.  Normally when someone sends out a
> > > > > patchset it just sort of lands with a dull thud.
> > > > > 
> > > > > I'm not sure what Jens did right to make all this happen, but thanks!
> > > > 
> > > > 
> > > > I don't know how he did either. I was reading theses patches and *something*
> > > > pushed me to my testbox, and then I tested...
> > > > 
> > > > Jens, how do you do that?
> > > 
> > > Heh, not sure :-)
> > > 
> > > But indeed, thanks for the testing. It looks quite interesting. I'm
> > > guessing it probably has to do with who ends up doing the balancing and
> > > that the flusher threads block, it may change the picture a bit. So it
> > > may just be that it'll require a few vm tweaks. I'll definitely look
> > > into it and try and reproduce your results.
> > > 
> > > Did you run it a 2nd time on each drive and check if the results were
> > > (approximately) consistent on the two drives?
> > 
> > each partition... What IO scheduler did you use on hda?
> 
> 
> CFQ.
> 
>  
> > The main difference with this test case is that before we had two super
> > blocks, each with lists of dirty inodes. pdflush would attack those. Now
> > we have both the inodes from the two supers on a single set of lists on
> > the bdi. So either we have some ordering issue there (which is causing
> > the unfairness), or something else is.
> 
> 
> Yeah.
> But although these flushers are per-bdi, with a single list (well, three)
> of dirty inodes, it looks like the writeback is still performed per
> superblock, I mean the bdi work gives the concerned superblock
> and the bdi list is iterated in generic_sync_wb_inodes() which
> only processes the inodes for the given superblock. So there is
> a bit of a per superblock serialization there and....

But in most cases sb == NULL, which means that the writeback does not
care. It should only pass in a valid sb if someone explicitly wants to
sync that sb.

But the way that the lists are organized now does definitely open some
windows of unfairness for a test like yours. It's on the top of the
investigate list for monday.

> > So perhaps you can try with noop on hda to see if that changes the
> > picture?
> 
> 
> 
> The result with noop is even more impressive.
> 
> See: http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop.pdf
> 
> Also a comparison, noop with pdflush against noop with bdi writeback:
> 
> http://kernel.org/pub/linux/kernel/people/frederic/dbench-noop-cmp.pdf

OK, so things aren't exactly peachy here to begin with. It may not
actually BE an issue, or at least now a new one, but that doesn't mean
that we should not attempt to quantify the impact.

How are you starting these runs? With a test like this, even a small
difference in start time can make a huge difference.

-- 
Jens Axboe

