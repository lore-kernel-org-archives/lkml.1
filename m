Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYIELCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYIELCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYIELCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:02:35 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:56839 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYIELCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:02:34 -0400
X-Greylist: delayed 74561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 07:02:33 EDT
Date: Fri, 5 Sep 2008 12:02:23 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PCI: revise VPD access interface
Message-ID: <20080905110222.GH7908@solarflare.com>
References: <20080904205636.130211023@vyatta.com> <20080904205718.626058270@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904205718.626058270@vyatta.com>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Change PCI VPD API which was only used by sysfs to something usable
> in drivers. 
>    * move iteration over multiple words to the low level
>    * cleanup types of arguments
>    * add exportable wrapper
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> --- a/drivers/pci/access.c	2008-09-04 10:16:52.000000000 -0700
> +++ b/drivers/pci/access.c	2008-09-04 10:19:47.000000000 -0700
[...]
> -static int pci_vpd_pci22_write(struct pci_dev *dev, int pos, int size,
> -			       const char *buf)
> +static int pci_vpd_pci22_write(struct pci_dev *dev, loff_t pos, size_t count,
> +			       const void *buf)
>  {
>  	struct pci_vpd_pci22 *vpd =
>  		container_of(dev->vpd, struct pci_vpd_pci22, base);
> -	u32 val;
> +	loff_t end = pos + count;
>  	int ret;
>  
> -	if (pos < 0 || pos > vpd->base.len || pos & 3 ||
> -	    size > vpd->base.len - pos || size < 4)
> +	if (pos > vpd->base.len || pos & 3)
>  		return -EINVAL;
>  
> -	val = (u8) *buf++;
> -	val |= ((u8) *buf++) << 8;
> -	val |= ((u8) *buf++) << 16;
> -	val |= ((u32)(u8) *buf++) << 24;
> -
>  	ret = mutex_lock_killable(&vpd->lock);
>  	if (ret)
>  		return ret;
> -	ret = pci_vpd_pci22_wait(dev);
> -	if (ret < 0)
> -		goto out;
> -	ret = pci_user_write_config_dword(dev, vpd->cap + PCI_VPD_DATA,
> -					  val);
> -	if (ret < 0)
> -		goto out;
> -	ret = pci_user_write_config_word(dev, vpd->cap + PCI_VPD_ADDR,
> -					 pos | PCI_VPD_ADDR_F);
> -	if (ret < 0)
> -		goto out;
> -	vpd->busy = true;
> -	vpd->flag = 0;
> -	ret = pci_vpd_pci22_wait(dev);
> -out:
> -	mutex_unlock(&vpd->lock);
> -	if (ret < 0)
> -		return ret;
>  
> -	return 4;
> +	while (pos < end) {
> +		u32 val;
> +
> +		ret = pci_vpd_pci22_wait(dev);
> +		if (ret < 0)
> +			break;
> +		memcpy(&val, buf, sizeof(u32));
[...]

I'm not sure this is correct.  pci_user_write_config_dword() expects a
value in host byte order, but this memcpy() makes val always little-endian.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.
