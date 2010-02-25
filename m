Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab0BYDBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:01:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:55190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab0BYDBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:01:23 -0500
Message-ID: <4B85EA24.5020409@kernel.org>
Date: Thu, 25 Feb 2010 12:10:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: microoptimize set_wq_data()
References: <20100224202035.GA26991@redhat.com>
In-Reply-To: <20100224202035.GA26991@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 03:00:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2010 05:20 AM, Oleg Nesterov wrote:
> The comment correctly states that the _PENDING bit must be set and
> we even have the BUG_ON() check. But this means there is no need to
> set WORK_STRUCT_PENDING explicitely and load work_data_bits() twice,
> we can rely on WORK_STRUCT_FLAG_MASK which contains _PENDING.
> 
> Shaves 32 bytes from workqueue.o.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/workqueue.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> --- wq/kernel/workqueue.c~2_CLEANUP_SET_DATA	2010-02-24 20:55:53.000000000 +0100
> +++ wq/kernel/workqueue.c	2010-02-24 20:58:37.000000000 +0100
> @@ -220,12 +220,9 @@ struct cpu_workqueue_struct *wq_per_cpu(
>  static inline void set_wq_data(struct work_struct *work,
>  				struct cpu_workqueue_struct *cwq)
>  {
> -	unsigned long new;
> -
> -	BUG_ON(!work_pending(work));
> -
> -	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
> +	unsigned long new = (unsigned long)cwq;
>  	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
> +	BUG_ON(!(new & (1UL << WORK_STRUCT_PENDING)));
>  	atomic_long_set(&work->data, new);

Will apply under cmwq patches for the next merge window.

Thanks.

-- 
tejun
