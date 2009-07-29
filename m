Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZG2Lnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZG2Lnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZG2Lny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:43:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:34317 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZG2Lny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,289,1246863600"; 
   d="scan'208";a="170096534"
Date: Wed, 29 Jul 2009 19:43:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@google.com>, sandeen@redhat.com,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090729114322.GA9335@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 12:15:48AM -0700, Martin Bligh wrote:
> On Tue, Jul 28, 2009 at 2:49 PM, Martin Bligh<mbligh@google.com> wrote:
> >> An interesting recent-ish change is "writeback: speed up writeback of
> >> big dirty files."  When I revert the change to __sync_single_inode the
> >> problem appears to go away and background writeout proceeds at disk
> >> speed.  Interestingly, that code is in the git commit [2], but not in
> >> the post to LKML. [3]  This is may not be the fix, but it makes this
> >> test behave better.
> >
> > I'm fairly sure this is not fixing the root cause - but putting it at the head
> > rather than the tail of the queue causes the error not to starve wb_kupdate
> > for nearly so long - as long as we keep the queue full, the bug is hidden.
> 
> OK, it seems this is the root cause - I wasn't clear why all the pages weren't
> being written back, and thought there was another bug. What happens is
> we go into write_cache_pages, and stuff the disk queue with as much as
> we can put into it, and then inevitably hit the congestion limit.
> 
> Then we back out to __sync_single_inode, who says "huh, you didn't manage
> to write your whole slice", and penalizes the poor blameless inode in question
> by putting it back into the penalty box for 30s.
> 
> This results in very lumpy I/O writeback at 5s intervals, and very
> poor throughput.

You are right, so let's fix the congestion case. Your analysis would
be perfect changelog :)

> Patch below is inline and probably text munged, but is for RFC only.
> I'll test it
> more thoroughly tomorrow. As for the comment about starving other writes,
> I believe requeue_io moves it from s_io to s_more_io which should at least
> allow some progress of other files.
> 
> --- linux-2.6.30/fs/fs-writeback.c.old  2009-07-29 00:08:29.000000000 -0700
> +++ linux-2.6.30/fs/fs-writeback.c      2009-07-29 00:11:28.000000000 -0700
> @@ -322,46 +322,11 @@ __sync_single_inode(struct inode *inode,
>                         /*
>                          * We didn't write back all the pages.  nfs_writepages()
>                          * sometimes bales out without doing anything. Redirty
[snip]
> -                               if (wbc->nr_to_write <= 0) {
> -                                       /*
> -                                        * slice used up: queue for next turn
> -                                        */
> -                                       requeue_io(inode);
> -                               } else {
> -                                       /*
> -                                        * somehow blocked: retry later
> -                                        */
> -                                       redirty_tail(inode);

Removing this line can be dangerous - we'll probably go into buzy
waiting (I have tried that long long ago).

Chad, can you try this small patch? Thank you.

Thanks,
Fengguang
---
 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mm.orig/fs/fs-writeback.c
+++ mm/fs/fs-writeback.c
@@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				if (wbc->nr_to_write <= 0) {
+				if (wbc->nr_to_write <= 0 ||
+				    wbc->encountered_congestion) {
 					/*
 					 * slice used up: queue for next turn
 					 */
