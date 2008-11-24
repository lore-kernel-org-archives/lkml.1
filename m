Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYKXQKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYKXQKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYKXQKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:10:08 -0500
Received: from main.gmane.org ([80.91.229.2]:43697 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYKXQKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:10:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Subject: Re: [PATCH] USB/ISP1760: Add support for the generic platfrom device centralized driver model (v2)
Date: Mon, 24 Nov 2008 16:44:09 +0100
Organization: SIGMA Chemnitz GmbH
Message-ID: <lyfxlhyvqu.fsf@ensc-virt.intern.sigma-chemnitz.de>
References: <1227000093-19034-1-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-usb@vger.kernel.org
X-Gmane-NNTP-Posting-Host: gw-c.sigma-chemnitz.de
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
Cancel-Lock: sha1:N3dYUkO0yniUlZODH6K8vwWbFDg=
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu <cooloney@kernel.org>
writes:

>  - isp1760 interrupt is default setup TRIGGER_LOW
> ...
> +	irq = platform_get_irq(pdev, 0);
> ...
> +	hcd = isp1760_register(addr->start, resource_size(addr), irq,
> +		IRQF_DISABLED | IRQF_SHARED | IRQF_TRIGGER_LOW,
> +		&pdev->dev, dev_name(&pdev->dev),
> +		devflags);

TRIGGER_LOW default is bad on e.g. XScale platforms which have
edge triggered interrupts. It would be better to use the resource
flags for interrupt configuration. E.g.

----
	struct resource				*irq_res;
        unsigned long                           flags;

	irq_res  = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

        flags = ((irq_res->flags & IRQF_TRIGGER_MASK) |
                 ((irq_res->flags & IORESOURCE_IRQ_SHAREABLE) ?
                 IRQF_SHARED : 0));

        if ((irq_res->flags & (IORESOURCE_IRQ_HIGHEDGE|IORESOURCE_IRQ_LOWEDGE)))
		dev_flags |= ISP1760_FLAG_INTR_EDGE_TRIG;

   	hcd = isp1760_register(addr->start, resource_size(addr), irq,
   		IRQF_DISABLED | flags,
   		&pdev->dev, dev_name(&pdev->dev),
   		devflags);
----



Enrico

