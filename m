Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbZBEPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbZBEPeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZBEPeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:34:01 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48283 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZBEPeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:34:00 -0500
Date: Thu, 5 Feb 2009 09:26:24 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] TPM: integrity fix
Message-ID: <20090205152624.GA27410@us.ibm.com>
References: <1233846390-21146-1-git-send-email-srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233846390-21146-1-git-send-email-srajiv@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> Fix to function which is called by IMA, now tpm_chip_find_get() considers the case in which the machine doesn't have a TPM or, if it has, its TPM isn't enabled.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Is this to fix James' problem with IMA on bootup?

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  drivers/char/tpm/tpm.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 0387965..912a473 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -666,18 +666,20 @@ EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
>   */
>  static struct tpm_chip *tpm_chip_find_get(int chip_num)
>  {
> -	struct tpm_chip *pos;
> +	struct tpm_chip *pos, *chip = NULL;
> 
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {

Crap I even paused for a second when I reviewed the original
patch.  I think the conversation in my head went something like
"but will pos be NULL at the end of the loop?"  "Oh, it must".  gah.

>  		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
>  			continue;
> 
> -		if (try_module_get(pos->dev->driver->owner))
> +		if (try_module_get(pos->dev->driver->owner)) {
> +			chip = pos;
>  			break;
> +		}
>  	}
>  	rcu_read_unlock();
> -	return pos;
> +	return chip;
>  }
> 
>  #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
> -- 
> 1.5.6.3
