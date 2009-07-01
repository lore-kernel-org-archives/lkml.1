Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZGAJ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZGAJ31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZGAJ3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:29:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62671 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZGAJ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:29:19 -0400
Message-ID: <4A4B2C3D.7090800@cn.fujitsu.com>
Date: Wed, 01 Jul 2009 17:28:29 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
 cfq_find_alloc_queue()
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1246007120-24034-3-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe said:
> Setup an emergency fallback cfqq that we allocate at IO scheduler init
> time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> never fails without having to ensure free memory.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  
> @@ -1740,11 +1745,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
>  		cfqq = *async_cfqq;
>  	}
>  
> -	if (!cfqq) {
> +	if (!cfqq)
>  		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
> -		if (!cfqq)
> -			return NULL;
> -	}

I jsut reviewed the code and found that the check of cfqq is also redundant
after doing cfq_get_queue() in cfq_set_request.

The patch is based on Linus's main tree. 

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 block/cfq-iosched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 833ec18..c373237 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2307,10 +2307,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
-
-		if (!cfqq)
-			goto queue_fail;
-
 		cic_set_cfqq(cic, cfqq, is_sync);
 	}
 
