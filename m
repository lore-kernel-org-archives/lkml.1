Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZFHLaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZFHLaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZFHLaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:30:04 -0400
Received: from main.gmane.org ([80.91.229.2]:59069 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZFHLaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:30:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Suraj Iyer <ssiyer@ti.com>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Date: Mon, 8 Jun 2009 11:28:28 +0000 (UTC)
Message-ID: <loom.20090608T110141-763@post.gmane.org>
References: <200906011358.28359.florian@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.163.20.231 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; {97FA8135-C8A0-8B5D-976B-92E0CEE7F378}; SV1; .NET CLR 2.0.50727))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Fainelli <florian <at> openwrt.org> writes:

> 
> This patch adds support for the TI VLYNQ high-speed,
> serial and packetized bus. This bus allows external
> devices to be connected to the System-on-Chip and
> appear in the main system memory just like any memory
> mapped peripheral. It is widely used in TI's networking
> and mutlimedia SoC, including the AR7 SoC.

In addition, the VLYNQ connectivity can also enable usage of one or more
simultaneous functionitilies (such as WLAN, Ethernet or other peripherals) of o
one SoC on another. In this sense, a single VLYNQ bus interface supports 
multifunctional devices or multiple peripherals and not just one peripheral or 
device.

> 
> ...
> ...
>
> +
> +int vlynq_set_local_mapping(struct vlynq_device *dev, u32 tx_offset,
> +			    struct vlynq_mapping *mapping)
> +{
> +	int i;
> +
> +	if (!dev->enabled)
> +		return -ENXIO;
> +
> +	vlynq_reg_write(dev->local->tx_offset, tx_offset);
> +	for (i = 0; i < 4; i++) {
> +		vlynq_reg_write(dev->local->rx_mapping[i].offset,
> +							mapping[i].offset);
> +		vlynq_reg_write(dev->local->rx_mapping[i].size,
> +							mapping[i].size);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(vlynq_set_local_mapping);
> +
> +int vlynq_set_remote_mapping(struct vlynq_device *dev, u32 tx_offset,
> +			     struct vlynq_mapping *mapping)
> +{
> +	int i;
> +
> +	if (!dev->enabled)
> +		return -ENXIO;
> +
> +	vlynq_reg_write(dev->remote->tx_offset, tx_offset);
> +	for (i = 0; i < 4; i++) {
> +		vlynq_reg_write(dev->remote->rx_mapping[i].offset,
> +							mapping[i].offset);
> +		vlynq_reg_write(dev->remote->rx_mapping[i].size,
> +							mapping[i].size);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(vlynq_set_remote_mapping);
> +

It seems that the current VLYNQ patch assumes that there is just one 
funcitonality or functional device (vlynq_device) that is attached with the 
VLYNQ. It will help to separate out the configuration of VLYNQ (through 
vlynq_set_local_mapping / vlynq_set_remote_mapping) from the functionalities 
(i.e. vlynq_device) that can be supported over VLYNQ. Once, the functional 
devices / drivers are isolated from the SoC specific VLYNQ configurations, the 
drivers can be independently re-used across multiple VLYNQ based SoC(s).   

Some of the other potential benefits, down the line, arising out of the 
stated isolation would be the discovery & auto-configuration of VLYNQ SoC(s), 
construction of daisy-chain and derive enumerated values (such as base 
addresses and interrupt numbers) required by the peripheral or functional
drivers.

Specifically, the VLYNQ (SoC) configuration is platform specific and 
functional drivers (vlynq_device & vlynq_driver) should not be attached to it.

Thanks,
Suraj

