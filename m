Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZDUARW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZDUARW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZDUARL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:17:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36670 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZDUARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:17:10 -0400
Date: Tue, 21 Apr 2009 09:15:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] res_counter: introduce ratelimiting attributes
Message-Id: <20090421091534.971f676f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1240090712-1058-3-git-send-email-righi.andrea@gmail.com>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
	<1240090712-1058-3-git-send-email-righi.andrea@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 23:38:27 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> Introduce attributes and functions in res_counter to implement throttling-based
> cgroup subsystems.
> 
> The following attributes have been added to struct res_counter:
>  * @policy:     the limiting policy / algorithm
>  * @capacity:   the maximum capacity of the resource
>  * @timestamp:  timestamp of the last accounted resource request
> 
> Currently the available policies are: token-bucket and leaky-bucket and the
> attribute @capacity is only used by token-bucket policy (to represent the
> bucket size).
> 
> The following function has been implemented to return the amount of time a
> cgroup should sleep to remain within the defined resource limits.
> 
>   unsigned long long
>   res_counter_ratelimit_sleep(struct res_counter *res, ssize_t val);
> 
> [ Note: only the interfaces needed by the cgroup IO controller are implemented
> right now ]
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  include/linux/res_counter.h |   69 +++++++++++++++++++++++++++++++----------
>  kernel/res_counter.c        |   72 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 124 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 4c5bcf6..9bed6af 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -14,30 +14,36 @@
>   */
>  
>  #include <linux/cgroup.h>
> +#include <linux/jiffies.h>
>  
> -/*
> - * The core object. the cgroup that wishes to account for some
> - * resource may include this counter into its structures and use
> - * the helpers described beyond
> - */
> +/* The various policies that can be used for ratelimiting resources */
> +#define	RATELIMIT_LEAKY_BUCKET	0
> +#define	RATELIMIT_TOKEN_BUCKET	1
>  
> +/**
> + * struct res_counter - the core object to account cgroup resources
> + *
> + * @usage:	the current resource consumption level
> + * @max_usage:	the maximal value of the usage from the counter creation
> + * @limit:	the limit that usage cannot be exceeded
> + * @failcnt:	the number of unsuccessful attempts to consume the resource
> + * @policy:	the limiting policy / algorithm
> + * @capacity:	the maximum capacity of the resource
> + * @timestamp:	timestamp of the last accounted resource request
> + * @lock:	the lock to protect all of the above.
> + *		The routines below consider this to be IRQ-safe
> + *
> + * The cgroup that wishes to account for some resource may include this counter
> + * into its structures and use the helpers described beyond.
> + */
>  struct res_counter {
> -	/*
> -	 * the current resource consumption level
> -	 */
>  	unsigned long long usage;
> -	/*
> -	 * the maximal value of the usage from the counter creation
> -	 */
>  	unsigned long long max_usage;
> -	/*
> -	 * the limit that usage cannot exceed
> -	 */
>  	unsigned long long limit;
> -	/*
> -	 * the number of unsuccessful attempts to consume the resource
> -	 */
>  	unsigned long long failcnt;
> +	unsigned long long policy;
> +	unsigned long long capacity;
> +	unsigned long long timestamp;
>  
Andrea, sizeof(struct res_counter) is getting close to 128bytes. (maybe someone adds more)
Then, could you check "unsigned long or unsigned int" is allowed or not, again ?

It's very bad if cacheline of spinlock is different from data field, in future.

Thanks,
-Kame

