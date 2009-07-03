Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZGCKsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZGCKsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZGCKsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:48:31 -0400
Received: from mga05.intel.com ([192.55.52.89]:62073 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbZGCKsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="471759205"
Date: Fri, 3 Jul 2009 12:50:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] MFD/PCAP: ezx_pcap_setbits()
Message-ID: <20090703105027.GD4176@sortiz.org>
References: <1246072640.10360.422.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246072640.10360.422.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 12:17:20AM -0300, Daniel Ribeiro wrote:
> Provides an atomic set_bits functions, as needed by the pcap-regulator
> driver.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Applied to my for-next branch, thanks Daniel.

Cheers,
Samuel.

 
> ---
>  drivers/mfd/ezx-pcap.c       |   23 +++++++++++++++++++++++
>  include/linux/mfd/ezx-pcap.h |    1 +
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index 732664f..86d3948 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -107,6 +107,29 @@ int ezx_pcap_read(struct pcap_chip *pcap, u8 reg_num, u32 *value)
>  }
>  EXPORT_SYMBOL_GPL(ezx_pcap_read);
>  
> +int ezx_pcap_set_bits(struct pcap_chip *pcap, u8 reg_num, u32 mask, u32 val)
> +{
> +	int ret;
> +	u32 tmp = PCAP_REGISTER_READ_OP_BIT |
> +		(reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
> +
> +	mutex_lock(&pcap->io_mutex);
> +	ret = ezx_pcap_putget(pcap, &tmp);
> +	if (ret)
> +		goto out_unlock;
> +
> +	tmp &= (PCAP_REGISTER_VALUE_MASK & ~mask);
> +	tmp |= (val & mask) | PCAP_REGISTER_WRITE_OP_BIT |
> +		(reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
> +
> +	ret = ezx_pcap_putget(pcap, &tmp);
> +out_unlock:
> +	mutex_unlock(&pcap->io_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ezx_pcap_set_bits);
> +
>  /* IRQ */
>  int irq_to_pcap(struct pcap_chip *pcap, int irq)
>  {
> diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
> index b15caac..dec82b0 100644
> --- a/include/linux/mfd/ezx-pcap.h
> +++ b/include/linux/mfd/ezx-pcap.h
> @@ -25,6 +25,7 @@ struct pcap_chip;
>  
>  int ezx_pcap_write(struct pcap_chip *, u8, u32);
>  int ezx_pcap_read(struct pcap_chip *, u8, u32 *);
> +int ezx_pcap_set_bits(struct pcap_chip *, u8, u32, u32);
>  int pcap_to_irq(struct pcap_chip *, int);
>  int irq_to_pcap(struct pcap_chip *, int);
>  int pcap_adc_async(struct pcap_chip *, u8, u32, u8[], void *, void *);
> -- 
> tg: (e94c381..) pcap/set_bits (depends on: pcap/fix-irq-handler)
> 
> -- 
> Daniel Ribeiro



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
