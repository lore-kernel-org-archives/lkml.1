Return-Path: <linux-kernel-owner+w=401wt.eu-S1765508AbYEFTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765508AbYEFTN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYEFTNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:13:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6183 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbYEFTNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:13:16 -0400
Date: Tue, 6 May 2008 21:13:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with -git14
Message-ID: <20080506191309.GL329@kernel.dk>
References: <20080430015655.5a42f63d@werewolf.home> <Pine.LNX.4.64.0804301516580.30549@blonde.site> <20080501025043.5e8582f6@werewolf.home> <Pine.LNX.4.64.0805011304230.19626@blonde.site> <20080502014155.GG30768@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080502014155.GG30768@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02 2008, Nick Piggin wrote:
> On Thu, May 01, 2008 at 01:11:51PM +0100, Hugh Dickins wrote:
> > On Thu, 1 May 2008, J.A. Magallón wrote:
> > > On Wed, 30 Apr 2008 16:17:46 +0100 (BST), Hugh Dickins <hugh@veritas.com> wrote:
> > > > On Wed, 30 Apr 2008, J.A. Magallón wrote:
> > > > > 
> > > > > I have a couple problems with latest git (-14):
> > > > > 
> > > > > - It only recognises 2 processors out of 4 (dual Xeon HT)
> > > > > - It oopses on the swapper process just on boot...
> > > > > 
> > > > > Difference in dmesg is below. If full correct dmesg or config is
> > > > > needed, please ask for them. The kernel was built copying old
> > > > > 2.6.25 config to .config && make oldconfig. I filled the missing
> > > > > gaps like PAT and others...
> > ...
> > > > > +WARNING: at include/linux/blkdev.h:427 blk_queue_init_tags+0x110/0x11f()
> > > > 
> > > > I presume this warning and backtrace is what you report as an oops:
> > > > I think you'll find Linus included a fix for this one overnight, and
> > > > it should have gone away in 2.6.25-git15 (but I didn't see it myself).
> > > 
> > > -git16 plus your patch gives me my 4 cpus again.
> > 
> > I'm glad to hear this, thanks.
> > 
> > > But I still get the warning:
> > 
> > But sorry to hear this.  That warning has undergone several revisions
> > already: I expect yours is another false positive not to worry about,
> > but it still needs to be fixed.  I won't meddle in there, Cc'ed Jens
> > and Nick who will know what's appropriate.
> 
> Thanks for the heads up Hugh. I think we're OK at this point because
> we're running in allocation/setup code so there should be no concurrency
> on queue_flags. I remember following this call chain and making this
> conclusion (hopefully correct, Jens?)... however I don't know how I
> concluded that the warning would not fire.

That's USUALLY correct, but not always. If blk_queue_init_tags() is
called for resizing depth, then it's a running queue and we should not
use _unlocked() for that. So basically they can all be _unlocked() due
to lack of concurrency at init time, but not this one:

        } else if (q->queue_tags) {
                rc = blk_queue_resize_tags(q, depth);
                if (rc)
                        return rc;
                queue_flag_set(QUEUE_FLAG_QUEUED, q);
                return 0;
        } ...

So if a driver ever re-calls blk_queue_init_tags() with a tag map
already set, then it needs to hold the queue lock.

-- 
Jens Axboe

