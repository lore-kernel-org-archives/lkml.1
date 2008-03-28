Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYC1KNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYC1KNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYC1KN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:13:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYC1KN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:13:26 -0400
Date: Fri, 28 Mar 2008 03:12:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 05/26] UBIFS: add file-system build
Message-Id: <20080328031246.8c7e849b.akpm@linux-foundation.org>
In-Reply-To: <1206629746-4298-6-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<1206629746-4298-6-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 16:55:25 +0200 Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> +static int init_constants_late(struct ubifs_info *c)
> +{
> +	int tmp, err;
> +	long long tmp64;
> +
> +	c->main_bytes = c->main_lebs * c->leb_size;
> +
> +	c->max_znode_sz = sizeof(struct ubifs_znode) +
> +				c->fanout * sizeof(struct ubifs_zbranch);
> +
> +	tmp = ubifs_idx_node_sz(c, 1);
> +	c->ranges[UBIFS_IDX_NODE].min_len = tmp;
> +	c->min_idx_node_sz = ALIGN(tmp, 8);
> +
> +	tmp = ubifs_idx_node_sz(c, c->fanout);
> +	c->ranges[UBIFS_IDX_NODE].max_len = tmp;
> +	c->max_idx_node_sz = ALIGN(tmp, 8);
> +
> +	/* Make sure LEB size is large enough to fit full commit */
> +	tmp = UBIFS_CS_NODE_SZ + UBIFS_REF_NODE_SZ * c->jhead_cnt;
> +	tmp = ALIGN(tmp, c->min_io_size);
> +	if (tmp > c->leb_size) {
> +		dbg_err("too small LEB size %d, at least %d needed",
> +			c->leb_size, tmp);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Make sure that the log is large enough to fit reference nodes for
> +	 * all buds plus one reserved LEB.
> +	 */
> +	tmp64 = c->max_bud_bytes;
> +	tmp = do_div(tmp64, c->leb_size);

do_div() operates on u64, not signed long long.  This will warn on several
architectures.
