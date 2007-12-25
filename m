Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXLYL74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXLYL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 06:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXLYL7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 06:59:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43373 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXLYL7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 06:59:48 -0500
Date: Tue, 25 Dec 2007 11:59:46 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] udf: convert UDF_SB_ALLOC_PARTMAPS macro to
	udf_sb_alloc_partition_maps function
Message-ID: <20071225115946.GB8296@infradead.org>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com> <1198455022-27674-4-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198455022-27674-4-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 01:10:19AM +0100, marcin.slusarz@gmail.com wrote:
> @@ -53,6 +53,7 @@
>  #include <linux/vfs.h>
>  #include <linux/vmalloc.h>
>  #include <asm/byteorder.h>
> +#include <linux/errno.h>

linux/*.h always before asm/*.h

> +static int __must_check udf_sb_alloc_partition_maps(struct super_block *sb, __u32 count)

I think __must_check is primarily for public APIs.  But if it really
helps you here I won't complain.

Also please use u32 over __u32 (dito for the other similar types)

> +{
> +	struct udf_sb_info *sbi = UDF_SB(sb);
> +	sbi->s_partmaps = kzalloc(sizeof(struct udf_part_map) * count, GFP_KERNEL);
> +	if (sbi->s_partmaps != NULL)
> +		sbi->s_partitions = count;
> +	else {
> +		sbi->s_partitions = 0;
> +		udf_error(sb, __FUNCTION__, "Unable to allocate space for %d partition maps", count);
> +	}
> +	return sbi->s_partmaps != NULL ? 0 : -ENOMEM;
> +}

But please don't introduce new overlong lines in entirely new functions.

Also the code look rather odd, I'd rather write it as:

static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
{
	struct udf_sb_info *sbi = UDF_SB(sb);

	sbi->s_partmaps = kcalloc(count, sizeof(struct udf_part_map),
				  GFP_KERNEL);
	if (!sbi->s_partmaps) {
		udf_error(sb, __FUNCTION__,
			  "Unable to allocate space for %d partition maps",
			  count);
		sbi->s_partitions = 0;
		return -ENOMEM;
	}

	sbi->s_partitions = count;
	return 0;
}
