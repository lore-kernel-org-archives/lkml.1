Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXEAUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXEAUCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXEAUCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:02:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21883 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbXEAUCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:02:32 -0400
Date: Tue, 1 May 2007 13:04:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/5] jffs2: Add a "favourlzo" compression mode to jffs2
Message-Id: <20070501130411.b320afa7.randy.dunlap@oracle.com>
In-Reply-To: <1178030833.5883.55.camel@localhost.localdomain>
References: <1178030833.5883.55.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 15:47:12 +0100 Richard Purdie wrote:

> Add a "favourlzo" compression mode to jffs2 which tries to
> optimise by size but gives lzo an advantage when comparing sizes.
> This means the faster lzo algorithm can be preferred when there
> isn't much difference in compressed size (the exact threshold can
> be changed).
> 
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
> ---
>  fs/Kconfig       |    7 +++++++
>  fs/jffs2/compr.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>  fs/jffs2/compr.h |    3 +++
>  3 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 1645dfa..328a62f 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -1359,6 +1359,13 @@ config JFFS2_CMODE_SIZE
>            Tries all compressors and chooses the one which has the smallest
>            result.
>  
> +config JFFS2_CMODE_FAVOURLZO
> +        bool "Favour LZO"
> +        help
> +          Tries all compressors and chooses the one which has the smallest
> +          result but gives some preference to LZO (which has faster
> +	  decompression) at the expense of size.

Use tabs instead of spaces on "bool" and "help".
Use <tab><space><space> on help text lines.

>  endchoice
>  
>  config CRAMFS
> diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
> index 6a23408..fdb0efd 100644
> --- a/fs/jffs2/compr.c
> +++ b/fs/jffs2/compr.c
> @@ -24,6 +24,34 @@ static int jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
>  /* Statistics for blocks stored without compression */
>  static uint32_t none_stat_compr_blocks=0,none_stat_decompr_blocks=0,none_stat_compr_size=0;
>  
> +
> +/*
> + * Return 1 to use this compression
> + */
> +static int jffs2_is_best_compression(struct jffs2_compressor *this,
> +		struct jffs2_compressor *best, uint32_t size, uint32_t bestsize)
> +{
> +	switch (jffs2_compression_mode) {

Place case statements at same indent level as 'switch'.

> +		case JFFS2_COMPR_MODE_SIZE:
> +			if (bestsize > size)
> +				return 1;
> +			return 0;
> +		case JFFS2_COMPR_MODE_FAVOURLZO:
> +			if ((this->compr == JFFS2_COMPR_LZO) && (bestsize > size))
> +				return 1;
> +			if ((best->compr != JFFS2_COMPR_LZO) && (bestsize > size))
> +				return 1;
> +			if ((this->compr == JFFS2_COMPR_LZO) && (bestsize > (size * FAVOUR_LZO_PERCENT / 100)))

line too long.

> +				return 1;
> +			if ((bestsize * FAVOUR_LZO_PERCENT / 100) > size)
> +				return 1;
> +
> +			return 0;
> +	}
> +	/* Shouldn't happen */
> +	return 0;
> +}
> +
>  /* jffs2_compress:
>   * @data: Pointer to uncompressed data
>   * @cdata: Pointer to returned pointer to buffer for compressed data
> @@ -106,15 +135,15 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
>                          }
>                          if (!this->compr_buf) {
>                                  spin_unlock(&jffs2_compressor_list_lock);
> -                                tmp_buf = kmalloc(orig_dlen,GFP_KERNEL);
> +                                tmp_buf = kmalloc(orig_slen,GFP_KERNEL);

space after comma

>                                  spin_lock(&jffs2_compressor_list_lock);
>                                  if (!tmp_buf) {
> -                                        printk(KERN_WARNING "JFFS2: No memory for compressor allocation. (%d bytes)\n",orig_dlen);
> +                                        printk(KERN_WARNING "JFFS2: No memory for compressor allocation. (%d bytes)\n",orig_slen);

space after comma.  Line too long (except for David :).

>                                          continue;
>                                  }
>                                  else {
>                                          this->compr_buf = tmp_buf;
> -                                        this->compr_buf_size = orig_dlen;
> +                                        this->compr_buf_size = orig_slen;
>                                  }
>                          }
>                          this->usecount++;
> @@ -125,7 +154,8 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
>                          spin_lock(&jffs2_compressor_list_lock);
>                          this->usecount--;
>                          if (!compr_ret) {
> -                                if ((!best_dlen)||(best_dlen>*cdatalen)) {
> +				if (((!best_dlen) || jffs2_is_best_compression(this, best, *cdatalen, best_dlen))

line too long

> +						&& (*cdatalen < *datalen)) {
>                                          best_dlen = *cdatalen;
>                                          best_slen = *datalen;
>                                          best = this;

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
