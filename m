Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYJIWre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYJIWre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYJIWrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:47:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:38905 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYJIWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=MJP5Uv6sQc60/GQGJ21anLjgASdt8jfAOLW4mCj8dbGBNJOK3ERdw47z6MCtZHZdBq
         oHEY5aMLlUsDAwxz1CPZtSxrY8a89ZpU68Sd4vIPXTREdDVjFtUWjdIp75KEmGmSC3zs
         CqRtBGvRIqKKYe7kQ4pEi8BF9Z5K6AH/eAGww=
Message-ID: <48EE89ED.3050309@gmail.com>
Date: Thu, 09 Oct 2008 23:47:09 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading
 firmware with PCMCIA adapter
References: <200810091722.56812.arvidjaar@newmail.ru> <200810091959.54987.arvidjaar@newmail.ru> <1223568410.18104.42.camel@dhcp-100-3-195.bos.redhat.com> <200810092321.55033.arvidjaar@newmail.ru>
In-Reply-To: <200810092321.55033.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> The attached patch fixes 4K stack for me. I have not tested spectrum case.

Thanks for identifying the problem. The Agere case looks good - a few suggestions for the Symbol case though:

> diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
> --- a/drivers/net/wireless/orinoco.c
> +++ b/drivers/net/wireless/orinoco.c
> @@ -549,12 +556,16 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
>  		int secondary)
>  {
>  	hermes_t *hw = &priv->hw;
> -	int ret;
> +	int ret = 0;
>  	const unsigned char *ptr;
>  	const unsigned char *first_block;
>  
>  	/* Plug Data Area (PDA) */
> -	__le16 pda[256];
> +	__le16 *pda;

Please initialise pda to NULL here...

> +	pda = kzalloc(fw->pda_size, GFP_KERNEL);
> +	if (!pda)
> +		return -ENOMEM;

And move the allocation to

>  	/* Binary block begins after the 0x1A marker */
>  	ptr = image;
> @@ -563,22 +574,22 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
>  
>  	/* Read the PDA from EEPROM */
>  	if (secondary) {

 ... here.

> -		ret = hermes_read_pda(hw, pda, fw->pda_addr, sizeof(pda), 1);
> +		ret = hermes_read_pda(hw, pda, fw->pda_addr, fw->pda_size, 1);
>  		if (ret)
> -			return ret;
> +			goto free;
>  	}
>  
>  	/* Stop the firmware, so that it can be safely rewritten */
>  	if (priv->stop_fw) {
>  		ret = priv->stop_fw(priv, 1);
>  		if (ret)
> -			return ret;
> +			goto free;
>  	}
>  
>  	/* Program the adapter with new firmware */
>  	ret = hermes_program(hw, first_block, end);
>  	if (ret)
> -		return ret;
> +		goto free;
>  
>  	/* Write the PDA to the adapter */
>  	if (secondary) {
> @@ -586,28 +597,31 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
>  		ptr = first_block + len;
>  		ret = hermes_apply_pda(hw, ptr, pda);
>  		if (ret)
> -			return ret;
> +			goto free;

Then kfree(pda) here. We're done with it now.

>  	}
>  
>  	/* Run the firmware */
>  	if (priv->stop_fw) {
>  		ret = priv->stop_fw(priv, 0);
>  		if (ret)
> -			return ret;
> +			goto free;

So this isn't needed.

>  	}
>  
>  	/* Reset hermes chip and make sure it responds */
>  	ret = hermes_init(hw);
>  
>  	/* hermes_reset() should return 0 with the secondary firmware */
> -	if (secondary && ret != 0)
> -		return -ENODEV;
> +	if (secondary && ret != 0) {
> +		ret = -ENODEV;
> +		goto free;
> +	}

nor this.

>  
>  	/* And this should work with any firmware */
>  	if (!hermes_present(hw))
> -		return -ENODEV;
> +		ret = -ENODEV;
>  
> -	return 0;

or these.

> +free:
 
But you absolutely have to kfree(pda) here. I would prefer the label be something like 'abort' (what we are doing), rather than 'free' - but there's merit in keeping with what you have called in in orinoco_dl_firmware which already has an 'abort' label.

> +	return ret;
>  }
 
The net effect of the above suggestion is that we won't allocate memory when programming the primary firmware (which is just before we do the secondary).

Dan Williams wrote:
> maybe you should not use priv->pda_size but
> #define SYMBOL_PDA_SIZE 256 and use that for the hermes_read_pda()
> length just to ensure the patched code is functionally the same as
> before the patch.

Using fw->pda_size should be fine. The value comes from a const static, set to 0x100 for Symbol.


Regards,

Dave.
