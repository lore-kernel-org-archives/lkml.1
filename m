Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038Ab0ANDnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0ANDnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809Ab0ANDny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:43:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:57456 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab0ANDny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:43:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232549826"
Date: Thu, 14 Jan 2010 11:43:51 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
 pending
Message-ID: <20100114034351.GB3922@sli10-desk.sh.intel.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
 <4B4E8590.8060403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E8590.8060403@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 10:46:40AM +0800, Gui Jianfeng wrote:
> Shaohua Li wrote:
> > My SSD speed of direct write is about 80m/s, while I test page writeback,
> > the speed can only go to 68m/s. Below patch fixes this.
> > It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> > means a queue should idle because it's seekless sync queue or it's the last queue,
> > which is to maintain service tree time slice. So it doesn't mean the
> > last queue is always a sync queue. If the last queue is asyn queue,
> > we definitely shouldn't stop dispatch requests because of pending async
> > requests.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 918c7fd..8198079 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >  	/*
> >  	 * Drain async requests before we start sync IO
> >  	 */
> > -	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> > +	if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
> > +		&& cfqd->rq_in_driver[BLK_RW_ASYNC])
> >  		return false;
> 
> It seems only sync queue could open the idle window, so i don't think we really need this.
the purpose here isn't to open idle window. with it, we could send more requests instead
of wait previous request finish. Vivek's mail explains the behavior correctly.

Thanks,
Shaohua
