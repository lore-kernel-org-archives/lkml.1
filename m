Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYKVLhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYKVLhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbYKVLhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:37:04 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:35159 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYKVLhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:37:03 -0500
Message-ID: <4927EEBF.1060207@cosmosbay.com>
Date: Sat, 22 Nov 2008 12:36:31 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH 2/3 v2] proc: Export statistics for softirq to /proc
References: <20081121202232.0489f84b.kobayashi.kk@ncos.nec.co.jp> <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081121202708.95ec8b3f.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 22 Nov 2008 12:36:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi a écrit :
> Export statistics for softirq in /proc/softirqs and /proc/stat.
> 
> 1. /proc/softirqs
> Implement /proc/softirqs which shows the number of softirq
> for each CPU like /proc/interrupts.
> 
> 2. /proc/stat
> Add the "softirq" line to /proc/stat.
> This line shows the number of softirq for all cpu.
> The first column is the total of all softirqs and
> each subsequent column is the total for particular softirq.
> 
> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  fs/proc/Makefile   |    1 +
>  fs/proc/softirqs.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/stat.c     |   17 +++++++++++++++
>  3 files changed, 75 insertions(+), 0 deletions(-)
>  create mode 100644 fs/proc/softirqs.c
> 
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 63d9651..11a7b5c 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -18,6 +18,7 @@ proc-y	+= meminfo.o
>  proc-y	+= stat.o
>  proc-y	+= uptime.o
>  proc-y	+= version.o
> +proc-y	+= softirqs.o
>  proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
>  proc-$(CONFIG_NET)		+= proc_net.o
>  proc-$(CONFIG_PROC_KCORE)	+= kcore.o
> diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
> new file mode 100644
> index 0000000..543f9d9
> --- /dev/null
> +++ b/fs/proc/softirqs.c
> @@ -0,0 +1,57 @@
> +#include <linux/init.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +
> +static const char *desc_array[] = {
> +	"HI",
> +	"TIMER",
> +	"NET_TX",
> +	"NET_RX",
> +	"BLOCK",
> +	"TASKLET",
> +	"SCHED",
> +#ifdef CONFIG_HIGH_RES_TIMERS
> +	"HRTIMER",
> +#endif
> +	"RCU"};
> +


You could use C99 initializers here

[HI_SOFTIRQ] = "HI",
[TIMER_SOFTIRQ] = "TIMER",
...

