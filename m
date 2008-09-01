Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYIAFZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYIAFZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 01:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYIAFZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 01:25:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57209 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYIAFZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 01:25:06 -0400
Date: Mon, 1 Sep 2008 14:30:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] res_counter: fix off-by-one bug in setting limit
Message-Id: <20080901143007.9c623ef4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48BB78E7.5080001@cn.fujitsu.com>
References: <48BB78E7.5080001@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2008 13:08:55 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> I found we can no longer set limit to 0 with 2.6.27-rcX:
>  # mount -t cgroup -omemory xxx /mnt
>  # mkdir /mnt/0
>  # echo 0 > /mnt/0/memory.limit_in_bytes
>  bash: echo: write error: Device or resource busy
> 
> It turned out 'limit' can't be set to 'usage', which is wrong IMO.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

But setting limit to 0(usage) in memcg is buggy operation unless you want to see OOM..
Hmm..

Thanks,
-Kame


> ---
>  include/linux/res_counter.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index fdeadd9..271c1c2 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -166,7 +166,7 @@ static inline int res_counter_set_limit(struct res_counter *cnt,
>  	int ret = -EBUSY;
>  
>  	spin_lock_irqsave(&cnt->lock, flags);
> -	if (cnt->usage < limit) {
> +	if (cnt->usage <= limit) {
>  		cnt->limit = limit;
>  		ret = 0;
>  	}
> -- 1.5.4.rc3 
> 

