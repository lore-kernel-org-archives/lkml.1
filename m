Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYAGLaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYAGLaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYAGL3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:29:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:52837 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753953AbYAGL3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:29:53 -0500
Date: Mon, 7 Jan 2008 12:29:51 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 19/24] udf: check if udf_load_logicalvol failed
Message-ID: <20080107112951.GC12589@duck.suse.cz>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-20-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-20-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-12-07 02:51:09, marcin.slusarz@gmail.com wrote:
> udf_load_logicalvol may fail eg in out of memory conditions - check it
> and propagate error further
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
  I certainly agree with the idea of the change. Just note that
udf_process_sequence() returns 1 in case of failure so propagating an error
is not ideal - we should keep things consistent. And also note that the
actual value is disregarded in udf_load_partition() anyway.

									Honza
> ---
>  fs/udf/super.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 4aef612..f8c5794 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1141,6 +1141,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
>  	uint32_t vdsn;
>  	uint16_t ident;
>  	long next_s = 0, next_e = 0;
> +	int ret;
>  
>  	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
>  
> @@ -1216,7 +1217,11 @@ static int udf_process_sequence(struct super_block *sb, long block,
>  			if (i == VDS_POS_PRIMARY_VOL_DESC) {
>  				udf_load_pvoldesc(sb, bh);
>  			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
> -				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
> +				ret = udf_load_logicalvol(sb, bh, fileset);
> +				if (ret != 0) {
> +					brelse(bh);
> +					return ret;
> +				}
>  			} else if (i == VDS_POS_PARTITION_DESC) {
>  				struct buffer_head *bh2 = NULL;
>  				if (udf_load_partdesc(sb, bh)) {
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
