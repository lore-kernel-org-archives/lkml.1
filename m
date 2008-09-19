Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYISRO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYISRO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYISROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:14:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20290 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYISROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:14:19 -0400
Date: Fri, 19 Sep 2008 10:08:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/6] introduce struct res_counter_ratelimit
Message-Id: <20080919100832.e188460a.randy.dunlap@oracle.com>
In-Reply-To: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com>
References: <1221649528-8519-3-git-send-email-righi.andrea@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 13:05:24 +0200 Andrea Righi wrote:

> Introduce res_counter_ratelimit as a generic structure to implement
> throttling-based cgroup subsystems.
> 
> [ Only the interfaces needed by the IO controller are implemented right now ]
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  include/linux/res_counter.h |   70 +++++++++++++++++++++++++
>  kernel/res_counter.c        |  118 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 187 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 0ab55c4..ff677d9 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -45,6 +46,38 @@ struct res_counter {
>  	spinlock_t lock;
>  };
>  
> +/* The various policies that can be used for throttling */
> +#define	RATELIMIT_LEAKY_BUCKET	0
> +#define	RATELIMIT_TOKEN_BUCKET	1
> +
> +struct res_counter_ratelimit {
> +	/*
> +	 * the current resource consumption level
> +	 */
> +	unsigned long long usage;
> +	/*
> +	 * the maximal value of the usage from the counter creation
> +	 */
> +	unsigned long long max_usage;
> +	/*
> +	 * the rate limit that cannot be exceeded
> +	 */
> +	unsigned long long limit;
> +	/*
> +	 * the limiting policy / algorithm
> +	 */
> +	unsigned long long policy;
> +	/*
> +	 * timestamp of the last accounted resource request
> +	 */
> +	unsigned long long timestamp;
> +	/*
> +	 * the lock to protect all of the above.
> +	 * the routines below consider this to be IRQ-safe
> +	 */
> +	spinlock_t lock;
> +};

With such nice struct comments, it looks like you should convert them
to kernel-doc for structs.  See Documentation/kernel-doc-nano-HOWTO.txt
for into, or ask me if you need some help with it.

Thanks,
---
~Randy
