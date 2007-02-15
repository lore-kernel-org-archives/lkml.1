Return-Path: <linux-kernel-owner+w=401wt.eu-S1030382AbXBOR6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382AbXBOR6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030383AbXBOR6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:58:07 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:5127 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030382AbXBOR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:58:06 -0500
X-IronPort-AV: i="4.14,176,1170662400"; 
   d="scan'208"; a="39738134:sNHT2562557922"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, hch@infradead.org, raisch@de.ibm.com,
       bos@patchscale.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by wait_for_completion()
X-Message-Flag: Warning: May contain useful information
References: <200702151709.45323.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 15 Feb 2007 09:57:48 -0800
In-Reply-To: <200702151709.45323.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Thu, 15 Feb 2007 17:09:44 +0100")
Message-ID: <adazm7fs3qb.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2007 17:57:50.0740 (UTC) FILETIME=[CF0A8D40:01C7512A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this one more time, I think it actually may be buggy:

 > @@ -147,6 +147,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 >  	spin_lock_init(&my_cq->spinlock);
 >  	spin_lock_init(&my_cq->cb_lock);
 >  	spin_lock_init(&my_cq->task_lock);
 > +	init_completion(&my_cq->zero_callbacks);

So you initialize the zero_callbacks completion once, at
ehca_create_cq().

But then 

 > @@ -612,11 +613,14 @@ static void run_comp_task(struct ehca_cp
 >  
 >  		spin_lock(&cq->task_lock);
 >  		cq->nr_callbacks--;
 > -		if (cq->nr_callbacks == 0) {
 > +		is_complete = (cq->nr_callbacks == 0);
 > +		if (is_complete) {
 >  			list_del_init(cct->cq_list.next);
 >  			cct->cq_jobs--;
 >  		}
 >  		spin_unlock(&cq->task_lock);
 > +		if (is_complete) /* wake up waiting destroy_cq() */
 > +			complete(&cq->zero_callbacks);
 >  	}

every time nr_callbacks drops to 0, you complete the zero_callbacks
completion.  So the first time a callback runs, you will complete
zero_callbacks, which will let wait_for_completion() finish even if
you later increment nr_callbacks again.

Also this

 > -	while (my_cq->nr_callbacks) {
 > +	if (my_cq->nr_callbacks) {
 >  		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 > -		yield();
 > +		wait_for_completion(&my_cq->zero_callbacks);
 >  		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 >  	}

looks rather unsafe -- I don't see any common locking protecting both
this test of nr_callbacks and the setting of nr_callbacks in the ehca
irq handling... so I don't see anything protecting you from seeing
nr_callbacks==0 and not going into the if() (or while() -- the old
code has the same problem I think) but then doing ++nr_callbacks
somewhere else.  In fact since you do the idr_remove() and
hipz_h_destroy_cq() *after* you make sure no callbacks are running,
this seems like it could happen easily.

So I'm holding off on applying this for now.  Please think it over and
either tell me the current patch is OK, or fix it up.  There's not
really too much urgency because a change like this is something I
would be comfortable merging between 2.6.21-rc1 and -rc2.

 - R.
