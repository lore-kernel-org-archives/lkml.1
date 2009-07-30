Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbZG3Pou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbZG3Pou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZG3Pot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:44:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZG3Pot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:44:49 -0400
Message-ID: <4A71BF76.6040709@redhat.com>
Date: Thu, 30 Jul 2009 17:42:46 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 05/24] io-controller: Modify cfq to make use of flat elevator
 fair queuing
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1248467274-32073-6-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> @@ -1616,11 +1234,12 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
>  	struct cfq_data *cfqd = cic->key;
>  	struct cfq_queue *cfqq;
>  	unsigned long flags;
> +	struct request_queue *q = cfqd->queue;

cfqd may be NULL here. We'd better test it before using it.

>  
>  	if (unlikely(!cfqd))
>  		return;
>  
> -	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
> +	spin_lock_irqsave(q->queue_lock, flags);
>  
>  	cfqq = cic->cfqq[BLK_RW_ASYNC];
>  	if (cfqq) {
> @@ -1637,7 +1256,7 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
>  	if (cfqq)
>  		cfq_mark_cfqq_prio_changed(cfqq);
>  
> -	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  
>  static void cfq_ioc_set_ioprio(struct io_context *ioc)


--- block/cfq-iosched.c.orig	2009-07-29 10:22:08.000000000 +0200
+++ block/cfq-iosched.c	2009-07-30 17:25:05.000000000 +0200
@@ -1271,11 +1271,12 @@ static void changed_ioprio(struct io_con
 	struct cfq_data *cfqd = cic->key;
 	struct cfq_queue *cfqq;
 	unsigned long flags;
-	struct request_queue *q = cfqd->queue;
+	struct request_queue *q;
 
 	if (unlikely(!cfqd))
 		return;
 
+	q = cfqd->queue;
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	cfqq = cic->cfqq[BLK_RW_ASYNC];
