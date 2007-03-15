Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXCOTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXCOTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbXCOTJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:09:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXCOTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:08:51 -0400
Date: Thu, 15 Mar 2007 11:07:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-kernel@vger.kernel.org, haver@vnet.ibm.com, hch@infradead.org,
       dwmw2@infradead.org, jwboyer@linux.vnet.ibm.com, dedekind@infradead.org
Subject: Re: [PATCH 10/22 take 3] UBI: EBA unit
Message-Id: <20070315110703.1c2dcce4.akpm@linux-foundation.org>
In-Reply-To: <20070314152024.1112.15655.sendpatchset@localhost.localdomain>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	<20070314152024.1112.15655.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There's way too much code here to expect it to get decently reviewed, alas.

> On Wed, 14 Mar 2007 17:20:24 +0200 Artem Bityutskiy <dedekind@infradead.org> wrote:
>
> ...
>
> +/**
> + * leb_get_ver - get logical eraseblock version.
> + *
> + * @ubi: the UBI device description object
> + * @vol_id: the volume ID
> + * @lnum: the logical eraseblock number
> + *
> + * The logical eraseblock has to be locked. Note, all this leb_ver stuff is
> + * obsolete and will be removed eventually. FIXME: to be removed together with
> + * leb_ver support.
> + */
> +static inline int leb_get_ver(struct ubi_info *ubi, int vol_id, int lnum)
> +{
> +	int idx, leb_ver;
> +
> +	idx = vol_id2idx(ubi, vol_id);
> +
> +	spin_lock(&ubi->eba.eba_tbl_lock);
> +	ubi_assert(ubi->eba.eba_tbl[idx].recs);
> +	leb_ver = ubi->eba.eba_tbl[idx].recs[lnum].leb_ver;
> +	spin_unlock(&ubi->eba.eba_tbl_lock);
> +
> +	return leb_ver;
> +}

I very much doubt that the locking in this function (and in the similar
ones here) does anything useful.

> +static unsigned long long next_sqnum(struct ubi_info *ubi)
> +{
> +	unsigned long long sqnum;
> +
> +	spin_lock(&ubi->eba.eba_tbl_lock);
> +	sqnum = ubi->eba.global_sq_cnt++;
> +	spin_unlock(&ubi->eba.eba_tbl_lock);
> +
> +	return sqnum;
> +}

That one makes sense,

> +static inline void leb_map(struct ubi_info *ubi, int vol_id, int lnum, int pnum)
> +{
> +	int idx;
> +
> +	idx = vol_id2idx(ubi, vol_id);
> +	spin_lock(&ubi->eba.eba_tbl_lock);
> +	ubi_assert(ubi->eba.eba_tbl[idx].recs);
> +	ubi_assert(ubi->eba.eba_tbl[idx].recs[lnum].pnum < 0);
> +	ubi->eba.eba_tbl[idx].recs[lnum].pnum = pnum;
> +	spin_unlock(&ubi->eba.eba_tbl_lock);
> +}

I doubt if that one does.

> +/**
> + * leb_unmap - un-map a logical eraseblock.
> + *
> + * @ubi: the UBI device description object
> + * @vol_id: the volume ID
> + * @lnum: the logical eraseblock number to unmap
> + *
> + * This function un-maps a logical eraseblock and increases its version. The
> + * logical eraseblock has to be locked.
> + */
> +static inline void leb_unmap(struct ubi_info *ubi, int vol_id, int lnum)

The patch is full of nutty inlining.

Suggestion: just remove all of it.  Then reintroduce inlining in only
those places where a benefit is demonstrable.  Reduced code size according to
/bin/size would be a suitable metric.

> +static inline int leb2peb(struct ubi_info *ubi, int vol_id, int lnum)
> +{
> +	int idx, pnum;
> +
> +	idx = vol_id2idx(ubi, vol_id);
> +
> +	spin_lock(&ubi->eba.eba_tbl_lock);
> +	ubi_assert(ubi->eba.eba_tbl[idx].recs);
> +	pnum = ubi->eba.eba_tbl[idx].recs[lnum].pnum;
> +	spin_unlock(&ubi->eba.eba_tbl_lock);
> +
> +	return pnum;
> +}

Again, the locking seems pointless.


