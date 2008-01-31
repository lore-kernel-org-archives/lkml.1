Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbYAaMXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbYAaMXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbYAaMXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:23:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:42677 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756448AbYAaMXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:23:43 -0500
Date: Thu, 31 Jan 2008 13:23:42 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] udf: udf_CS0toNLS cleanup
Message-ID: <20080131122341.GC1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-4-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-4-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:53, marcin.slusarz@gmail.com wrote:
> - fix error handling - always zero output variable
> - don't zero explicitely fields zeroed by memset
> - mark "in" paramater as const
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/udf/unicode.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index f4e54e5..d068d33 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -248,35 +248,32 @@ error_out:
>  }
>  
>  static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
> -			struct ustr *ocu_i)
> +			const struct ustr *ocu_i)
>  {
> -	uint8_t *ocu;
> -	uint32_t c;
> +	const uint8_t *ocu;
>  	uint8_t cmp_id, ocu_len;
>  	int i;
>  
> -	ocu = ocu_i->u_name;
>  
>  	ocu_len = ocu_i->u_len;
> -	cmp_id = ocu_i->u_cmpID;
> -	utf_o->u_len = 0;
> -
>  	if (ocu_len == 0) {
>  		memset(utf_o, 0, sizeof(struct ustr));
> -		utf_o->u_cmpID = 0;
> -		utf_o->u_len = 0;
>  		return 0;
>  	}
>  
> -	if ((cmp_id != 8) && (cmp_id != 16)) {
> +	cmp_id = ocu_i->u_cmpID;
> +	if (cmp_id != 8 && cmp_id != 16) {
> +		memset(utf_o, 0, sizeof(struct ustr));
>  		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
>  		       cmp_id, ocu_i->u_name);
>  		return 0;
>  	}
>  
> +	ocu = ocu_i->u_name;
> +	utf_o->u_len = 0;
>  	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN - 3));) {
>  		/* Expand OSTA compressed Unicode to Unicode */
> -		c = ocu[i++];
> +		uint32_t c = ocu[i++];
>  		if (cmp_id == 16)
>  			c = (c << 8) | ocu[i++];
>  
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
