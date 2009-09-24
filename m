Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbZIXH32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbZIXH32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIXH31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:29:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:38838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZIXH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:29:26 -0400
Date: Thu, 24 Sep 2009 09:29:35 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924092935.428d42ae@infradead.org>
In-Reply-To: <20090924071415.GA20808@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com>
	<20090924071415.GA20808@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 15:14:15 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, Sep 24, 2009 at 02:54:20PM +0800, Li, Shaohua wrote:
> > __mark_inode_dirty adds inode to wb dirty list in random order. If
> > a disk has several partitions, writeback might keep spindle moving
> > between partitions. To reduce the move, better write big chunk of
> > one partition and then move to another. Inodes from one fs usually
> > are in one partion, so idealy move indoes from one fs together
> > should reduce spindle move. This patch tries to address this.
> > Before per-bdi writeback is added, the behavior is write indoes
> > from one fs first and then another, so the patch restores previous
> > behavior. The loop in the patch is a bit ugly, should we add a
> > dirty list for each superblock in bdi_writeback?
> > 
> > Test in a two partition disk with attached fio script shows about
> > 3% ~ 6% improvement.
> 
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Good idea! The optimization looks good to me, it addresses one
> weakness of per-bdi writeback.
> 
> But one problem is, Jan Kara and me are planning to remove b_io and
> hence this move_expired_inodes() function. Not sure how to do this
> optimization without b_io.
> 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 8e1e5e1..fc87730 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -324,13 +324,29 @@ static void move_expired_inodes(struct
> > list_head *delaying_queue, struct list_head *dispatch_queue,
> >  				unsigned long *older_than_this)
> >  {
> > +	LIST_HEAD(tmp);
> > +	struct list_head *pos, *node;
> > +	struct super_block *sb;
> > +	struct inode *inode;
> > +
> >  	while (!list_empty(delaying_queue)) {
> > -		struct inode *inode =
> > list_entry(delaying_queue->prev,
> > -						struct inode,
> > i_list);
> > +		inode = list_entry(delaying_queue->prev, struct
> > inode, i_list); if (older_than_this &&
> >  		    inode_dirtied_after(inode, *older_than_this))
> >  			break;
> > -		list_move(&inode->i_list, dispatch_queue);
> > +		list_move(&inode->i_list, &tmp);
> > +	}
> > +
> > +	/* Move indoes from one superblock together */
> > +	while (!list_empty(&tmp)) {
> > +		inode = list_entry(tmp.prev, struct inode, i_list);
> > +		sb = inode->i_sb;
> > +		list_for_each_prev_safe(pos, node, &tmp) {
> 
> We are in spin lock, so not necessary to use the safe version?
> 

safe is needed for list walks that remove entries from the list
has nothing to do with locking ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
