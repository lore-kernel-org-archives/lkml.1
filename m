Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZG3BGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZG3BGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 21:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZG3BGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 21:06:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:27258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbZG3BGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 21:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,290,1246863600"; 
   d="scan'208";a="170369277"
Date: Thu, 30 Jul 2009 09:06:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
Message-ID: <20090730010630.GA7326@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com> <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com> <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com> <20090729114322.GA9335@localhost> <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:11:10PM +0800, Martin Bligh wrote:
> > --- mm.orig/fs/fs-writeback.c
> > +++ mm/fs/fs-writeback.c
> > @@ -325,7 +325,8 @@ __sync_single_inode(struct inode *inode,
> >                                 * soon as the queue becomes uncongested.
> >                                 */
> >                                inode->i_state |= I_DIRTY_PAGES;
> > -                               if (wbc->nr_to_write <= 0) {
> > +                               if (wbc->nr_to_write <= 0 ||
> > +                                   wbc->encountered_congestion) {
> >                                        /*
> >                                         * slice used up: queue for next turn
> >                                         */
> >
> 
> That's not sufficient - it only the problem in the wb_kupdate path. If you want
> to be more conservative, how about we do this?

I agree on the unification of kupdate and sync paths. In fact I had a
patch for doing this. And I'd recommend to do it in two patches:
one to fix the congestion case, another to do the code unification.

The sync path don't care whether requeue_io() or redirty_tail() is
used, because they disregard the time stamps totally - only order of
inodes matters (ie. starvation), which is same for requeue_io()/redirty_tail().

Thanks,
Fengguang

> --- linux-2.6.30/fs/fs-writeback.c.old  2009-07-29 00:08:29.000000000 -0700
> +++ linux-2.6.30/fs/fs-writeback.c      2009-07-29 07:08:48.000000000 -0700
> @@ -323,43 +323,14 @@ __sync_single_inode(struct inode *inode,
>                          * We didn't write back all the pages.  nfs_writepages(
> )
>                          * sometimes bales out without doing anything. Redirty
>                          * the inode; Move it from s_io onto s_more_io/s_dirty.
> +                        * It may well have just encountered congestion
>                          */
> -                       /*
> -                        * akpm: if the caller was the kupdate function we put
> -                        * this inode at the head of s_dirty so it gets first
> -                        * consideration.  Otherwise, move it to the tail, for
> -                        * the reasons described there.  I'm not really sure
> -                        * how much sense this makes.  Presumably I had a good
> -                        * reasons for doing it this way, and I'd rather not
> -                        * muck with it at present.
> -                        */
> -                       if (wbc->for_kupdate) {
> -                               /*
> -                                * For the kupdate function we move the inode
> -                                * to s_more_io so it will get more writeout as
> -                                * soon as the queue becomes uncongested.
> -                                */
> -                               inode->i_state |= I_DIRTY_PAGES;
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
> -                               }
> -                       } else {
> -                               /*
> -                                * Otherwise fully redirty the inode so that
> -                                * other inodes on this superblock will get som
> e
> -                                * writeout.  Otherwise heavy writing to one
> -                                * file would indefinitely suspend writeout of
> -                                * all the other files.
> -                                */
> -                               inode->i_state |= I_DIRTY_PAGES;
> +                       inode->i_state |= I_DIRTY_PAGES;
> +                       if (wbc->nr_to_write <= 0 ||     /* sliced used up */
> +                            wbc->encountered_congestion)
> +                               requeue_io(inode);
> +                       else {
> +                               /* somehow blocked: retry later */
>                                 redirty_tail(inode);
>                         }
>                 } else if (inode->i_state & I_DIRTY) {
