Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYDCHVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYDCHVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbYDCHVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:21:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47633 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbYDCHVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:21:15 -0400
Date: Thu, 3 Apr 2008 16:24:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] cgroup: use a hash table for css_set finding
Message-Id: <20080403162459.4a90d574.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F470AB.2070904@cn.fujitsu.com>
References: <47F470AB.2070904@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 03 Apr 2008 13:52:43 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:
> +/* hash table for cgroup groups. This improves the performance to
> + * find an existing css_set */
> +#define CSS_SET_HASH_BITS	7
> +#define CSS_SET_TABLE_SIZE	(1 << CSS_SET_HASH_BITS)
> +static struct hlist_head css_set_table[CSS_SET_TABLE_SIZE];

How above number is selected ?

> +static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
> +{
> +	int i;
> +	int index;
> +	unsigned long tmp = 0UL;
> +
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
> +		tmp += (unsigned long)css[i];
> +

maybe css[i]'s lower 2-3 bits will be ignored. because thery are always 0.

And I don't like "+" for hash. how about
==
	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
	unsigned long x;
	x = (unsigned long)css[i];
	tmp = (x >> 16) ^ (x & 0xffff)
==
or some func, which uses full bits.


> +	index = hash_long(tmp, CSS_SET_HASH_BITS);
> +
> +	return &css_set_table[index];
> +}
> +
>  /* We don't maintain the lists running through each css_set to its
>   * task until after the first call to cgroup_iter_start(). This
>   * reduces the fork()/exit() overhead for people who have cgroups
> @@ -219,6 +240,7 @@ static int use_task_css_set_links;
>  static void unlink_css_set(struct css_set *cg)
>  {
>  	write_lock(&css_set_lock);
> +	hlist_del(&cg->hlist);
>  	list_del(&cg->list);
>  	css_set_count--;

This css_set_lock is worth to be rwlock ?
how about per hashline spinlock ? (but per-hashline seems overkill..)

Thanks,
-Kame

