Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYDGQrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYDGQrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYDGQq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:46:57 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25356 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751097AbYDGQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:46:52 -0400
Message-ID: <47FA4FD2.8060808@ru.mvista.com>
Date: Mon, 07 Apr 2008 20:46:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: jgarzik@pobox.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com>
In-Reply-To: <11684073371547-git-send-email-htejun@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> +/**
> + * devm_ioremap - Managed ioremap()
> + * @dev: Generic device to remap IO address for
> + * @offset: BUS offset to map
> + * @size: Size of map
> + *
> + * Managed ioremap().  Map is automatically unmapped on driver detach.
> + */
> +void __iomem *devm_ioremap(struct device *dev, unsigned long offset,
> +			   unsigned long size)
> +{
> +	void __iomem **ptr, *addr;
> +
> +	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	addr = ioremap(offset, size);
> +	if (addr) {
> +		*ptr = addr;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);
> +
> +	return addr;
> +}
> +EXPORT_SYMBOL(devm_ioremap);
> +
> +/**
> + * devm_ioremap_nocache - Managed ioremap_nocache()
> + * @dev: Generic device to remap IO address for
> + * @offset: BUS offset to map
> + * @size: Size of map
> + *
> + * Managed ioremap_nocache().  Map is automatically unmapped on driver
> + * detach.
> + */
> +void __iomem *devm_ioremap_nocache(struct device *dev, unsigned long offset,
> +				   unsigned long size)
> +{
> +	void __iomem **ptr, *addr;
> +
> +	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	addr = ioremap_nocache(offset, size);
> +	if (addr) {
> +		*ptr = addr;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);
> +
> +	return addr;
> +}
> +EXPORT_SYMBOL(devm_ioremap_nocache);

    A very late comment but nevertheless... :-)
    Those functions are going to break on 32-bit platforms with extended 
physical address (well, that's starting with Pentiums which had 36-bit PAE :-) 
AND devices mapped beyond 4 GB (e.g. PowerPC 44x).  You should have used 
resource_size_t for the 'offset' parameter. As this most probably means that 
libata is broken on such platforms, I'm going to submit a patch...

WBR, Sergei
