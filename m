Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXCLVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXCLVo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXCLVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:44:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33138 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932516AbXCLVo0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:44:26 -0400
Date: Tue, 13 Mar 2007 08:44:05 +1100
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
Message-ID: <20070312214405.GQ6095633@melbourne.sgi.com>
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:40:47PM +0100, Miklos Szeredi wrote:
> > > I have no idea how serious the scalability problems with this are.  If
> > > they are serious, different solutions can probably be found for the
> > > above, but this is certainly the simplest.
> > 
> > Atomic operations to a single per-backing device from all CPUs at once?
> > That's a pretty serious scalability issue and it will cause a major
> > performance regression for XFS.
> 
> OK.  How about just accounting writeback pages?  That should be much
> less of a problem, since normally writeback is started from
> pdflush/kupdate in large batches without any concurrency.

Except when you are throttling you bounce the cacheline around
each cpu as it triggers foreground writeback.....

> Or is it possible to export the state of the device queue to mm?
> E.g. could balance_dirty_pages() query the backing dev if there are
> any outstanding write requests?

Not directly - writeback_in_progress(bdi) is a coarse measure
indicating pdflush is active on this bdi, which implies outstanding
write requests).

> > I'd call this a showstopper right now - maybe you need to look at
> > something like the ZVC code that Christoph Lameter wrote, perhaps?
> 
> That's rather a heavyweight approach for this I think.

But if you want to use per-page accounting, you are going to
need a per-cpu or per-zone set of counters on each bdi to do
this without introducing regressions.

> The only info balance_dirty_pages() really needs is whether there are
> any dirty+writeback bound for the backing dev or not.

writeback bound (i.e. writing as fast as we can) is probably
indicated fairly reliably by bdi_congested(bdi).

Now all you need is the number of dirty pages....

> It knows about the diry pages, since it calls writeback_inodes() which
> scans the dirty pages for this backing dev looking for ones to write
> out.

It scans the dirty inode list for dirty inodes which indirectly finds
the dirty pages. It does not know about the number of dirty pages
directly...

> If after returning from writeback_inodes() wbc->nr_to_write
> didn't decrease and wbc->pages_skipped is zero then we know that there
> are no more dirty pages for the device.  Or at least there are no
> dirty pages which aren't already under writeback.

Sure, you can tell if there are _no_ dirty pages on the bdi, but
if there are dirty pages, you can't tell how many there are. Your
followup patches need to know how many dirty+writeback pages there
are on the bdi, so I don't really see any way you can solve the
deadlock in this manner without scalable bdi->nr_dirty accounting.

----

IIUC, your problem is that there's another bdi that holds all the
dirty pages, and this throttle loop never flushes pages from that
other bdi and we sleep instead. It seems to me that the fundamental
problem is that to clean the pages we need to flush both bdi's, not
just the bdi we are directly dirtying.

How about a "dependent bdi" link? i.e. if you have a loopback
filesystem, it has a direct bdi (the loopback device) and a
dependent bdi - the bdi that belongs to the underlying filesystem.

When we enter the throttle loop we flush from the direct bdi
and if we fail to flush all the pages we require, we flush
the dependent bdi (maybe even just kick pdflush for that bdi)
before we call congestion_wait() and go to sleep. This way
we are always making progress cleaning pages on the machine,
not just transferring dirty pages form one bdi to another.

Wouldn't that solve the deadlock without needing painful
accounting?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
