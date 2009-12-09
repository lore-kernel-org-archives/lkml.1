Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZLISuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZLISuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZLISuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:50:37 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49446 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZLISug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:50:36 -0500
Date: Wed, 9 Dec 2009 19:50:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jmoyer@redhat.com, linux-kernel@vger.kernel.org,
       guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 2/2] cfq-iosched: Take care of corner cases of group
	losing share due to deletion
Message-ID: <20091209185042.GX8742@kernel.dk>
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com> <1260312778-4725-2-git-send-email-vgoyal@redhat.com> <20091209135639.GW8742@kernel.dk> <20091209151723.GA8452@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209151723.GA8452@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09 2009, Vivek Goyal wrote:
> On Wed, Dec 09, 2009 at 02:56:39PM +0100, Jens Axboe wrote:
> > On Tue, Dec 08 2009, Vivek Goyal wrote:
> > > If there is a sequential reader running in a group, we wait for next request
> > > to come in that group after slice expiry and once new request is in, we expire
> > > the queue. Otherwise we delete the group from service tree and group looses
> > > its fair share.
> > > 
> > > So far I was marking a queue as wait_busy if it had consumed its slice and
> > > it was last queue in the group. But this condition did not cover following
> > > two cases.
> > > 
> > > 1.If a request completed and slice has not expired yet. Next request comes
> > >   in and is dispatched to disk. Now select_queue() hits and slice has expired.
> > >   This group will be deleted. Because request is still in the disk, this queue
> > >   will never get a chance to wait_busy.
> > > 
> > > 2.If request completed and slice has not expired yet. Before next request
> > >   comes in (delay due to think time), select_queue() hits and expires the
> > >   queue hence group. This queue never got a chance to wait busy.
> > > 
> > > Gui was hitting the boundary condition 1 and not getting fairness numbers
> > > proportional to weight.
> > > 
> > > This patch puts the checks for above two conditions and improves the fairness
> > > numbers for sequential workload on rotational media. Check in select_queue()
> > > takes care of case 1 and additional check in should_wait_busy() takes care
> > > of case 2.
> > 
> > I think this (and 1/2) look fine, just one minor comment:
> > 
> > > @@ -3250,6 +3264,36 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
> > >  		cfqd->hw_tag = 0;
> > >  }
> > >  
> > > +static inline bool
> > > +cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > > +{
> > 
> > That's too large to inline.
> 
> Hi Jens,
> 
> Please find below the new version of patch. I have removed inline from
> cfq_should_wait_busy().
> 
> Please let me know if you prefer a seprate posting in new mail thread.

No problem, actually I just hand-edited your previous patch when
applying it. Sorry, should have said so!

-- 
Jens Axboe

