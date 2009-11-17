Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZKQSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZKQSHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZKQSHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:07:49 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20599 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZKQSHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:07:47 -0500
Subject: Re: [PATCH 06/16] blkio: Introduce per cfq group weights and
 vdisktime calculations
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
In-Reply-To: <1258134015-21632-7-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
	 <1258134015-21632-7-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 13:07:45 -0500
Message-ID: <1258481265.6084.293.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 12:40 -0500, Vivek Goyal wrote:

> +
> +static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
> +{
> +	s64 delta = (s64)(vdisktime - min_vdisktime);
> +	if (delta > 0)
> +		min_vdisktime = vdisktime;
> +
> +	return min_vdisktime;
> +}
> +
> +static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
> +{
> +	s64 delta = (s64)(vdisktime - min_vdisktime);
> +	if (delta < 0)
> +		min_vdisktime = vdisktime;
> +
> +	return min_vdisktime;
> +}
> +
> +static void update_min_vdisktime(struct cfq_rb_root *st)
> +{
> +	u64 vdisktime = st->min_vdisktime;
> +	struct cfq_group *cfqg;
> +
> +	if (st->active) {
> +		cfqg = rb_entry(st->active, struct cfq_group, rb_node);
> +		vdisktime = cfqg->vdisktime;
> +	}
> +
> +	if (st->left) {
> +		cfqg = rb_entry(st->left, struct cfq_group, rb_node);
> +		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
> +	}
> +
> +	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
> +}

Any reason why you don't use min_t(u64, vdisktime, cfqg->vdisktime) and
max_t(u64, st->min_vdisktime, vdisktime)) here?

