Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYAGM3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYAGM3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYAGM3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:29:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYAGM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:29:43 -0500
Date: Mon, 7 Jan 2008 12:29:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] udf: create common function for tag checksumming
Message-ID: <20080107122933.GD3710@infradead.org>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com> <1199582513-7915-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199582513-7915-2-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -36,6 +36,18 @@
>  
>  #define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
>  
> +/* computes tag checksum */
> +static inline uint8_t udf_tag_checksum(const tag *t)
> +{
> +	uint8_t *data = (uint8_t *)t;
> +	uint8_t checksum = 0;
> +	int i;
> +	for (i = 0; i < sizeof(tag); ++i)
> +		if (i != 4) /* that's the position of checksum */
> +			checksum += data[i];
> +	return checksum;
> +}

This function is large enough that it should be out of line in a .c
file.  Also I'd prefer using the Linux native types ala:

/* computes tag checksum */
static u8 udf_tag_checksum(const tag *t)
{
	u8 *data = (u8 *)t;
	u8 checksum = 0;
	int i;

	for (i = 0; i < sizeof(tag); i++) {
		if (i != 4) /* position of the checksum */
			checksum += data[i];
	}

	return checksum;
}
