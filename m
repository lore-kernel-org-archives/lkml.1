Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZEMCkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZEMCkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZEMCkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:40:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZEMCkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:40:03 -0400
Message-ID: <4A0A32CB.4020609@cn.fujitsu.com>
Date: Wed, 13 May 2009 10:39:07 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/18] io-controller: Export disk time used and nr sectors
 dipatched through cgroups
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-8-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  
> +/*
> + * traverse through all the io_groups associated with this cgroup and calculate
> + * the aggr disk time received by all the groups on respective disks.
> + */
> +static u64 calculate_aggr_disk_time(struct io_cgroup *iocg)
> +{
> +	struct io_group *iog;
> +	struct hlist_node *n;
> +	u64 disk_time = 0;
> +
> +	rcu_read_lock();

  This function is in slow-path, so no need to call rcu_read_lock(), just need to ensure
  that the caller already holds the iocg->lock.

> +	hlist_for_each_entry_rcu(iog, n, &iocg->group_data, group_node) {
> +		/*
> +		 * There might be groups which are not functional and
> +		 * waiting to be reclaimed upon cgoup deletion.
> +		 */
> +		if (rcu_dereference(iog->key))
> +			disk_time += iog->entity.total_service;
> +	}
> +	rcu_read_unlock();
> +
> +	return disk_time;
> +}
> +

-- 
Regards
Gui Jianfeng

