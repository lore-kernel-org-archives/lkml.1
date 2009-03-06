Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZCFWlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZCFWlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZCFWjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:63791 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZCFWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=afO1CuN93jJKJCurrLILeS7T3bYPOnQCyj2kHh0qQw03fuv10+A5wl+zplf7DOO0xg
         19JiZZoLXHTJZ4REmdWaNZhhOaMI2hLI9XWT4Gu+qivo4ayvmr36EBY62wYDhQEO/Anu
         8n+shTnnpVIEpWV/25T8mTtRzy9XPgxSWwMUc=
Message-ID: <49B1A624.9040704@gmail.com>
Date: Fri, 06 Mar 2009 23:39:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, cooloney@kernel.org, cliff.cai@analog.com,
       drzeus@drzeus.cx
Subject: Re: + mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch
 added to -mm tree
References: <200903062208.n26M8NSH004472@imap1.linux-foundation.org>
In-Reply-To: <200903062208.n26M8NSH004472@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.3.2009 23:08, akpm@linux-foundation.org wrote:
> Subject: mmc: align data size for host which only supports power-of-2 block
> From: Bryan Wu<cooloney@kernel.org>
>
>
> Signed-off-by: Cliff Cai<cliff.cai@analog.com>
> Signed-off-by: Bryan Wu<cooloney@kernel.org>
> Cc: Pierre Ossman<drzeus@drzeus.cx>
> Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> ---
> --- a/drivers/mmc/core/core.c~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
> +++ a/drivers/mmc/core/core.c
> @@ -321,7 +321,13 @@ unsigned int mmc_align_data_size(struct
>   	 * the core about its problems yet, so for now we just 32-bit
>   	 * align the size.
>   	 */
> -	sz = ((sz + 3) / 4) * 4;
> +
> +	/* Align size for host which only supports power-of-2 block */
> +	if (card->host->powerof2_block) {
> +		if (sz&  (sz - 1))
> +			sz = 1<<  fls(sz);

Is there a reason why not use
sz = roundup_pow_of_two(sz)
instead of the two lines?

> +	} else
> +		sz = ((sz + 3) / 4) * 4;

While you are at it:
sz = roundup(sz, 4);

> --- a/include/linux/mmc/host.h~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
> +++ a/include/linux/mmc/host.h
> @@ -162,6 +162,7 @@ struct mmc_host {
>   	struct dentry		*debugfs_root;
>
>   	unsigned long		private[0] ____cacheline_aligned;
> +	unsigned int		powerof2_block;	/* host only supports power-of-2 block */

Does this have any users? The patch description is too bare. I'm trying 
to cope with one mmc device failure, may this help?
