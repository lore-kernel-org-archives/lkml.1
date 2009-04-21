Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZDUV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZDUV2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZDUV2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:28:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51325 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZDUV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PWKku2EDkSLXKg/gQNOBWyLC2n4bkMWmnAokPXnUN65Nu0JI491imKtU4jGA3S9nY/
         T3sJ6IqtKTyiUFJvFrK0y0zPmh70LCeGDpAjuxiaqn/1DC9lyLE+/rieYLLobv3VW4lq
         w34XqZpITgnQ1K4WXUphh2q5qfSMZcL+okGec=
Date: Tue, 21 Apr 2009 23:28:17 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Theodore Tso <tytso@mit.edu>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090421212816.GC5573@linux>
References: <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417173955.GF29086@redhat.com> <20090417231244.GB6972@linux> <20090419134201.GF8493@redhat.com> <20090419154717.GB5514@linux> <20090420212827.GA9080@redhat.com> <20090420220511.GA8740@linux> <20090421010846.GA15850@redhat.com> <20090421083702.GC8441@linux> <20090421142305.GB22619@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421142305.GB22619@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:23:05AM -0400, Vivek Goyal wrote:
> On Tue, Apr 21, 2009 at 10:37:03AM +0200, Andrea Righi wrote:
> > On Mon, Apr 20, 2009 at 09:08:46PM -0400, Vivek Goyal wrote:
> > > On Tue, Apr 21, 2009 at 12:05:12AM +0200, Andrea Righi wrote:
> > > 
> > > [..]
> > > > > > > Are we not already controlling submission of request (at crude level).
> > > > > > > If application is doing writeout at high rate, then it hits vm_dirty_ratio
> > > > > > > hits and this application is forced to do write out and hence it is slowed
> > > > > > > down and is not allowed to submit writes at high rate.
> > > > > > > 
> > > > > > > Just that it is not a very fair scheme right now as during right out
> > > > > > > a high prio/high weight cgroup application can start writing out some
> > > > > > > other cgroups' pages.
> > > > > > > 
> > > > > > > For this we probably need to have some combination of solutions like
> > > > > > > per cgroup upper limit on dirty pages. Secondly probably if an application
> > > > > > > is slowed down because of hitting vm_drity_ratio, it should try to
> > > > > > > write out the inode it is dirtying first instead of picking any random
> > > > > > > inode and associated pages. This will ensure that a high weight
> > > > > > > application can quickly get through the write outs and see higher
> > > > > > > throughput from the disk.
> > > > > > 
> > > > > > For the first, I submitted a patchset some months ago to provide this
> > > > > > feature in the memory controller:
> > > > > > 
> > > > > > https://lists.linux-foundation.org/pipermail/containers/2008-September/013140.html
> > > > > > 
> > > > > > We focused on the best interface to use for setting the dirty pages
> > > > > > limit, but we didn't finalize it. I can rework on that and repost an
> > > > > > updated version. Now that we have the dirty_ratio/dirty_bytes to set the
> > > > > > global limit I think we can use the same interface and the same semantic
> > > > > > within the cgroup fs, something like:
> > > > > > 
> > > > > >   memory.dirty_ratio
> > > > > >   memory.dirty_bytes
> > > > > > 
> > > > > > For the second point something like this should be enough to force tasks
> > > > > > to write out only the inode they're actually dirtying when they hit the
> > > > > > vm_dirty_ratio limit. But it should be tested carefully and may cause
> > > > > > heavy performance regressions.
> > > > > > 
> > > > > > Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> > > > > > ---
> > > > > >  mm/page-writeback.c |    2 +-
> > > > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > > > > index 2630937..1e07c9d 100644
> > > > > > --- a/mm/page-writeback.c
> > > > > > +++ b/mm/page-writeback.c
> > > > > > @@ -543,7 +543,7 @@ static void balance_dirty_pages(struct address_space *mapping)
> > > > > >  		 * been flushed to permanent storage.
> > > > > >  		 */
> > > > > >  		if (bdi_nr_reclaimable) {
> > > > > > -			writeback_inodes(&wbc);
> > > > > > +			sync_inode(mapping->host, &wbc);
> > > > > >  			pages_written += write_chunk - wbc.nr_to_write;
> > > > > >  			get_dirty_limits(&background_thresh, &dirty_thresh,
> > > > > >  				       &bdi_thresh, bdi);
> > > > > 
> > > > > This patch seems to be helping me a bit in getting more service
> > > > > differentiation between two writer dd of different weights. But strangely
> > > > > it is helping only for ext3 and not ext4. Debugging is on.
> > > > 
> > > > Are you explicitly mounting ext3 with data=ordered?
> > > 
> > > Yes. Still using 29-rc8 and data=ordered was the default then.
> > > 
> > > I got two partitions on same disk and created one ext3 filesystem on each
> > > partition (just to take journaling intereference out of two dd threads 
> > > for the time being).
> > > 
> > > Two dd threads doing writes to each partition. 
> > 
> > ...and if you're using data=writeback with ext4 sync_inode() should sync
> > the metadata only. If this is the case, could you check data=ordered
> > also for ext4?
> 
> No, even data=ordered mode with ext4 is also not helping. It has to be
> something else.

mmmh.. maybe you could try to also add a wbc.sync_mode=WB_SYNC_ALL in
the if below.

> 
> BTW, with the above patch, what happens if the address space being dirtied
> does not have sufficient dirty pages to write back (more than write_chunk).
> Will the process not be in loop until the number of dirty pages come down
> (hopefully due to writeout by pdflush or by other processes?)

Right! we could try something like this at the very least, stopping the
loop if the address space we've dirtied doesn't have enough dirty pages.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 mm/page-writeback.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 30351f0..e71a164 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -542,7 +542,17 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * been flushed to permanent storage.
 		 */
 		if (bdi_nr_reclaimable) {
-			writeback_inodes(&wbc);
+			wbc.more_io = 0;
+			wbc.encountered_congestion = 0;
+			sync_inode(mapping->host, &wbc);
+			if (wbc.nr_to_write <= 0)
+				break;
+			/*
+			 * Wrote less than expected, check if the inode has
+			 * enough dirty pages to write back
+			 */
+			if (!wbc.encountered_congestion && !wbc.more_io)
+					break;
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
