Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZIJBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZIJBOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZIJBOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:14:37 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:52396 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZIJBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:14:36 -0400
Subject: Re: [PATCH] TPM: Fixup boot probe timeout for tpm_tis driver
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Jan Beulich <jbeulich@novell.com>,
       adi@vmware.com
In-Reply-To: <20090909232218.GK406@obsidianresearch.com>
References: <20090909232218.GK406@obsidianresearch.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 22:14:27 -0300
Message-Id: <1252545267.4837.62.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson sent this a while ago in a patchset, I think I lost track
of it in the middle of the other patches, sorry. In any case, ACK.

http://marc.info/?l=linux-kernel&m=124650185023490&w=2

Thanks,
Rajiv 

On Wed, 2009-09-09 at 17:22 -0600, Jason Gunthorpe wrote:
> When probing the device in tpm_tis_init the call request_locality
> uses timeout_a, which wasn't being initalized until after
> request_locality. This results in request_locality falsely timing
> out if the chip is still starting. Move the initialization to before
> request_locality.
> 
> This probably only matters for embedded cases (ie mine), a BIOS likely
> gets the TPM into a state where this code path isn't necessary.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/tpm_tis.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 241b5ae..c1e5ab8 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -450,6 +450,12 @@ static int tpm_tis_init(struct device *dev, u32 start,
>  		goto out_err;
>  	}
> 
> +	/* Default timeouts */
> +	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> +	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> +
>  	if (request_locality(chip, 0) != 0) {
>  		rc = -ENODEV;
>  		goto out_err;
> @@ -457,12 +463,6 @@ static int tpm_tis_init(struct device *dev, u32 start,
> 
>  	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> 
> -	/* Default timeouts */
> -	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> -	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> -	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> -	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> -
>  	dev_info(dev,
>  		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));

