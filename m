Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZG3Sb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZG3Sb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZG3SbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:31:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZG3SbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:31:24 -0400
Date: Thu, 30 Jul 2009 14:30:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use of flat
	elevator fair queuing
Message-ID: <20090730183014.GA6067@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-6-git-send-email-vgoyal@redhat.com> <4A71BF76.6040709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A71BF76.6040709@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 05:42:46PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > @@ -1616,11 +1234,12 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
> >  	struct cfq_data *cfqd = cic->key;
> >  	struct cfq_queue *cfqq;
> >  	unsigned long flags;
> > +	struct request_queue *q = cfqd->queue;
> 
> cfqd may be NULL here. We'd better test it before using it.
> 

Thanks Jerome. 

Actually I will drop this chage altogether. This is not required. I don't
know why did I change original code to introduce another local variable. 

Thanks
Vivek

> >  
> >  	if (unlikely(!cfqd))
> >  		return;
> >  
> > -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> > +	spin_lock_irqsave(q->queue_lock, flags);
> >  
> >  	cfqq = cic->cfqq[BLK_RW_ASYNC];
> >  	if (cfqq) {
> > @@ -1637,7 +1256,7 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
> >  	if (cfqq)
> >  		cfq_mark_cfqq_prio_changed(cfqq);
> >  
> > -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> >  }
> >  
> >  static void cfq_ioc_set_ioprio(struct io_context *ioc)
> 
> 
> --- block/cfq-iosched.c.orig	2009-07-29 10:22:08.000000000 +0200
> +++ block/cfq-iosched.c	2009-07-30 17:25:05.000000000 +0200
> @@ -1271,11 +1271,12 @@ static void changed_ioprio(struct io_con
>  	struct cfq_data *cfqd = cic->key;
>  	struct cfq_queue *cfqq;
>  	unsigned long flags;
> -	struct request_queue *q = cfqd->queue;
> +	struct request_queue *q;
>  
>  	if (unlikely(!cfqd))
>  		return;
>  
> +	q = cfqd->queue;
>  	spin_lock_irqsave(q->queue_lock, flags);
>  
>  	cfqq = cic->cfqq[BLK_RW_ASYNC];
