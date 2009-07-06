Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZGFNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZGFNtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZGFNte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:49:34 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46272 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZGFNtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:49:33 -0400
Date: Mon, 6 Jul 2009 14:49:30 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/10] writeback: support > 1 flusher thread per bdi
Message-ID: <20090706134930.GA4987@shareable.org>
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-6-git-send-email-jens.axboe@oracle.com> <4A51FE33.3070702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A51FE33.3070702@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Jens Axboe wrote:
> >+static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work 
> >*work)
> >+{
> >+	if (work) {
> >+		work->seen = bdi->wb_mask;
> >+		BUG_ON(!work->seen);
> >+		atomic_set(&work->pending, bdi->wb_cnt);
> >+		BUG_ON(!bdi->wb_cnt);
> >+
> >+		/*
> >+		 * Make sure stores are seen before it appears on the list
> >+		 */
> >+		smp_mb();
> >+
> >+		spin_lock(&bdi->wb_lock);
> >+		list_add_tail_rcu(&work->list, &bdi->work_list);
> >+		spin_unlock(&bdi->wb_lock);
> >+	}
> 
> Doesn't spin_lock() include an implicit memory barrier?
> After &bdi->wb_lock is acquired, it is guaranteed that all
> memory operations are finished.

I'm pretty sure spin_lock() is an "acquire" barrier, which just guarantees
loads/stores after the spin_lock() are done after taking the lock.

It doesn't guarantee anything about loads/stores before the spin_lock().

-- Jamie
