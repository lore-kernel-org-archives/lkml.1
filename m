Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZEGHnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZEGHnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZEGHn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:43:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZEGHnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:43:25 -0400
Message-ID: <4A0290ED.7080506@cn.fujitsu.com>
Date: Thu, 07 May 2009 15:42:37 +0800
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
Subject: Re: [PATCH 05/18] io-controller: Common hierarchical fair queuing
 code in elevaotor layer
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1241553525-28095-6-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch enables hierarchical fair queuing in common layer. It is
> controlled by config option CONFIG_GROUP_IOSCHED.
...
> +}
> +
> +void iocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
> +{
> +	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
> +	struct hlist_node *n, *tmp;
> +	struct io_group *iog;
> +
> +	/*
> +	 * Since we are destroying the cgroup, there are no more tasks
> +	 * referencing it, and all the RCU grace periods that may have
> +	 * referenced it are ended (as the destruction of the parent
> +	 * cgroup is RCU-safe); bgrp->group_data will not be accessed by
> +	 * anything else and we don't need any synchronization.
> +	 */
> +	hlist_for_each_entry_safe(iog, n, tmp, &iocg->group_data, group_node)
> +		io_destroy_group(iocg, iog);
> +
> +	BUG_ON(!hlist_empty(&iocg->group_data));
> +

    Hi Vivek,

    IMHO, free_css_id() needs to be called here.

> +	kfree(iocg);
> +}
> +
> +void io_disconnect_groups(struct elevator_queue *e)
> +{
> +	struct hlist_node *pos, *n;
> +	struct io_group *iog;
> +	struct elv_fq_data *efqd = &e->efqd;
> +
> +	hlist_for_each_entry_safe(iog, pos, n, &efqd->group_list,
> +					elv_data_node) {
> +		hlist_del(&iog->elv_data_node);
> +

-- 
Regards
Gui Jianfeng

