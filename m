Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYFQDkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYFQDkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 23:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYFQDkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 23:40:46 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:49475 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753642AbYFQDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 23:40:45 -0400
Message-ID: <48573236.2060700@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2008 09:10:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] memcg: res counter set limit
References: <20080617123144.ce5a74fa.kamezawa.hiroyu@jp.fujitsu.com> <20080617123319.51e1f09d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080617123319.51e1f09d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Helper function of res_counter for reducing usage in subsys(memcg).
> 
> Changelog xxx -> v5.
>  - new file.
> 
> Background:
>  In v3, I was asked to implement generic ones to res_counter.
>  In v4. I was asked not to implement generic ones because memcg is only
>  controller which can reduce usage by the kernel. Okay, maybe make sense.
>  In this version, adds only necessary helpers to res_counter in 
>  not-invasive manner.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  include/linux/res_counter.h |    7 +++++++
>  kernel/res_counter.c        |   24 ++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> Index: mm-2.6.26-rc5-mm3/include/linux/res_counter.h
> ===================================================================
> --- mm-2.6.26-rc5-mm3.orig/include/linux/res_counter.h
> +++ mm-2.6.26-rc5-mm3/include/linux/res_counter.h
> @@ -136,6 +136,12 @@ static inline bool res_counter_check_und
>  	return ret;
>  }
> 
> +/*
> + * set new limit to the val. if usage > val, returns -EBUSY.
> + * returns 0 at success.
> + */
> +int res_counter_set_limit(struct res_counter *cnt, unsigned long long limit);
> +
>  static inline void res_counter_reset_max(struct res_counter *cnt)
>  {
>  	unsigned long flags;
> @@ -153,4 +159,5 @@ static inline void res_counter_reset_fai
>  	cnt->failcnt = 0;
>  	spin_unlock_irqrestore(&cnt->lock, flags);
>  }
> +

I don't understand this extra newline here

>  #endif
> Index: mm-2.6.26-rc5-mm3/kernel/res_counter.c
> ===================================================================
> --- mm-2.6.26-rc5-mm3.orig/kernel/res_counter.c
> +++ mm-2.6.26-rc5-mm3/kernel/res_counter.c
> @@ -143,3 +143,27 @@ out_free:
>  out:
>  	return ret;
>  }
> +
> +
> +/**
> + * res_counter_set_limit - set limit of res_counter.
> + * @cnt: the res_counter
> + * @limit: the new limit
> + *
> + * Note that res_coutner_write() allows the same kind of operation.
> + * But this returns -EBUSY when new limit < usage. If you want strict control
> + * of limit, please use this.
> + */
> +int res_counter_set_limit(struct res_counter *cnt, unsigned long long limit)
> +{
> +	unsigned long flags;
> +	int ret = -EBUSY;
> +
> +	spin_lock_irqsave(&cnt->lock, flags);
> +	if (cnt->usage <= limit) {
> +		cnt->limit = limit;
> +		ret = 0;
> +	}
> +	spin_unlock_irqrestore(&cnt->lock, flags);
> +	return ret;
> +}

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
