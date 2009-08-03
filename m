Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZHCWuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZHCWuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZHCWuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:50:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54912 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZHCWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XbS784H6KMzYtT0GwgjXuPsGMg/jd7IXE3Y1C1lf70SDwql/Ba9VtNuSieI+AimeOX
         std6mHCAmA5YbdyylrxiAQ/yi8DB/Ze1MGtMORAjje2J0XJ+Oycrz6p25bGmqJEzNDVE
         c6sKwl7LWSO4fWDKqknjYRpH/USta0P3HUY2Y=
Message-ID: <4A7769C6.50901@gmail.com>
Date: Tue, 04 Aug 2009 00:50:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: martyn.welch@gefanuc.com
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [patch 4/5] Staging: vme: add Tundra TSI148 VME-PCI Bridge driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210121.GE28430@kroah.com>
In-Reply-To: <20090803210121.GE28430@kroah.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 11:01 PM, Greg K-H wrote:
> +void tsi148_free_irq(int level, int statid)
> +{
> +	u32 tmp;
> +
> +	/* Get semaphore */

Hmm, useful comment. Anyway I think you plan to get rid of all those
while being in staging ;)?

> +	down(&(vme_irq));
> +
> +	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;

What if the interrupt comes now? I think you want to switch this block
with "Disable IRQ level" one. And take care of PCI posting (if it is not
enough that INTEO reaches the device by a consequent INTEN read).

> +	tsi148_bridge->irq[level - 1].callback[statid].priv_data = NULL;
> +	tsi148_bridge->irq[level - 1].count--;
> +
> +	/* Disable IRQ level */
> +	if (tsi148_bridge->irq[level - 1].count == 0) {
> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
> +		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
> +
> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEN);
> +		tmp &= ~TSI148_LCSR_INTEN_IRQEN[level - 1];
> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEN);
> +	}
> +
> +	/* Release semaphore */
> +	up(&(vme_irq));
> +}

