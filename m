Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbZLKCDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbZLKCDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbZLKCDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:03:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62330 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762122AbZLKCDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W3m4nCHrLKC7PPFYPMiNFJMIMZcVM+AidxO5fs5yIbREuARKEjOd4Jask10IpYGYaX
         ckSOoPVCFZZivCt+GrhJhZWc0UDj0y1q1IqM5lm7Rg4HzFTdYfiJe51WzgOIiJ4uyNCM
         UJGPUHXn/eV2U6ndpwoiiEA2X/VsABhYPve24=
MIME-Version: 1.0
In-Reply-To: <20091210185626.26f9828a@cuia.bos.redhat.com>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
Date: Fri, 11 Dec 2009 11:03:53 +0900
Message-ID: <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.


On Fri, Dec 11, 2009 at 8:56 AM, Rik van Riel <riel@redhat.com> wrote:
> Under very heavy multi-process workloads, like AIM7, the VM can
> get into trouble in a variety of ways.  The trouble start when
> there are hundreds, or even thousands of processes active in the
> page reclaim code.
>
> Not only can the system suffer enormous slowdowns because of
> lock contention (and conditional reschedules) between thousands
> of processes in the page reclaim code, but each process will try
> to free up to SWAP_CLUSTER_MAX pages, even when the system already
> has lots of memory free.  In Larry's case, this resulted in over
> 6000 processes fighting over locks in the page reclaim code, even
> though the system already had 1.5GB of free memory.
>
> It should be possible to avoid both of those issues at once, by
> simply limiting how many processes are active in the page reclaim
> code simultaneously.
>
> If too many processes are active doing page reclaim in one zone,
> simply go to sleep in shrink_zone().
>
> On wakeup, check whether enough memory has been freed already
> before jumping into the page reclaim code ourselves.  We want
> to use the same threshold here that is used in the page allocator
> for deciding whether or not to call the page reclaim code in the
> first place, otherwise some unlucky processes could end up freeing
> memory for the rest of the system.
>
> Reported-by: Larry Woodman <lwoodman@redhat.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
>
> ---
> This patch is against today's MMOTM tree. It has only been compile tested,
> I do not have an AIM7 system standing by.
>
> Larry, does this fix your issue?
>
>  Documentation/sysctl/vm.txt |   18 ++++++++++++++++++
>  include/linux/mmzone.h      |    4 ++++
>  include/linux/swap.h        |    1 +
>  kernel/sysctl.c             |    7 +++++++
>  mm/page_alloc.c             |    3 +++
>  mm/vmscan.c                 |   38 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 71 insertions(+)
>
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index fc5790d..5cf766f 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/vm:
>  - legacy_va_layout
>  - lowmem_reserve_ratio
>  - max_map_count
> +- max_zone_concurrent_reclaim
>  - memory_failure_early_kill
>  - memory_failure_recovery
>  - min_free_kbytes
> @@ -278,6 +279,23 @@ The default value is 65536.
>
>  =============================================================
>
> +max_zone_concurrent_reclaim:
> +
> +The number of processes that are allowed to simultaneously reclaim
> +memory from a particular memory zone.
> +
> +With certain workloads, hundreds of processes end up in the page
> +reclaim code simultaneously.  This can cause large slowdowns due
> +to lock contention, freeing of way too much memory and occasionally
> +false OOM kills.
> +
> +To avoid these problems, only allow a smaller number of processes
> +to reclaim pages from each memory zone simultaneously.
> +
> +The default value is 8.
> +
> +=============================================================

I like this. but why do you select default value as constant 8?
Do you have any reason?

I think it would be better to select the number proportional to NR_CPU.
ex) NR_CPU * 2 or something.

Otherwise looks good to me.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
