Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYAGMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYAGMlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYAGMlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:41:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYAGMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:41:09 -0500
Date: Mon, 7 Jan 2008 12:41:05 +0000
From: Christoph Hellwig <hch@infradead.org>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] udf: create common function for changing free
	space counter
Message-ID: <20080107124104.GE3710@infradead.org>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com> <1199582513-7915-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199582513-7915-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 02:21:49AM +0100, marcin.slusarz@gmail.com wrote:
> +static inline bool udf_inc_free_space(struct udf_sb_info *sbi,
> +				      u16 partition, u32 cnt)
> +{
> +	if (sbi->s_lvid_bh) {
> +		struct logicalVolIntegrityDesc *lvid =
> +					(struct logicalVolIntegrityDesc *)
> +							sbi->s_lvid_bh->b_data;
> +		lvid->freeSpaceTable[partition] =
> +			cpu_to_le32(le32_to_cpu(
> +					lvid->freeSpaceTable[partition]) + cnt);
> +	}
> +	return sbi->s_lvid_bh != NULL;
> +}

No need to mark helpers like this inline, the compiler will take care
of it if nessecary.  Also I'd add an early return for the sbi->s_lvid_bh
case and a local variable for the freespace to make the function better
readable:

static bool udf_inc_free_space(struct udf_sb_info *sbi, u16 partition,
		u32 cnt)
{
	struct logicalVolIntegrityDesc *lvid;

	if (!sbi->s_lvid_bh)
		return 0;

	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
	free = le32_to_cpu(lvid->freeSpaceTable[partition]) + cnt;
	lvid->freeSpaceTable[partition] = cpu_to_le32(free);
	return 1;
}
		

