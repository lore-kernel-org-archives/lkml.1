Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZHQFcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZHQFcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZHQFcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:32:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63085 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZHQFcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:32:04 -0400
Message-ID: <4A88EACC.6010805@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:29:48 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +static void place_entity(struct io_service_tree *st, struct io_entity *entity,
> +				int add_front)
> +{
> +	u64 vdisktime = st->min_vdisktime;
> +	struct rb_node *parent;
> +	struct io_entity *entry;
> +	int nr_active = st->nr_active - 1;
> +
> +	/*
> +	 * Currently put entity at the end of last entity. This probably will
> +	 * require adjustments as we move along
> +	 */
> +	if (io_entity_class_idle(entity)) {
> +		vdisktime = elv_delta_fair(ELV_IDLE_DELAY, entity);
> +		parent = rb_last(&st->active);
> +		if (parent) {
> +			entry = rb_entry(parent, struct io_entity, rb_node);
> +			vdisktime += entry->vdisktime;
> +		}
> +	} else if (!add_front && nr_active) {
> +		parent = rb_last(&st->active);
> +		if (parent) {
> +			entry = rb_entry(parent, struct io_entity, rb_node);
> +			vdisktime = entry->vdisktime;
> +		}
> +	} else
> +		vdisktime = st->min_vdisktime;

Hi Vivek,

Should we set vdisktime a little small than st->min_vdisktime to ensure putting
this entity at the left-most position when add_front is set?

> +
> +	entity->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> +}
> +
> +static inline void io_entity_update_prio(struct io_entity *entity)
> +{
> +	if (unlikely(entity->ioprio_changed)) {
> +		/*
> +		 * Re-initialize the service tree as ioprio class of the
> +		 * entity might have changed.
> +		 */
> +		init_io_entity_service_tree(entity, parent_entity(entity));
> +		entity->ioprio_changed = 0;
> +	}
> +}
> +


-- 
Regards
Gui Jianfeng

