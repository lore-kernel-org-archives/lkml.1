Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZHCWzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZHCWzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZHCWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:55:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42747 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbZHCWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OYuyhdOoNf9GMqzh6z88KYXqRpixGGoOh1L17e0j6tpojqx5V2KLOfLYZV1Xt2NJAK
         bw4Ts+GNyHYlu8pE/mGEjaGN4Sr5wQw61Kks70ZJb9Gx0TtoQiqksnU9XoaevrLv3U5q
         Gb2ziTTvuV0pTK6SZVNHD0mM9CcJjdpIKxNj0=
Message-ID: <4A776AEA.5030302@gmail.com>
Date: Tue, 04 Aug 2009 00:55:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: martyn.welch@gefanuc.com
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [patch 4/5] Staging: vme: add Tundra TSI148 VME-PCI Bridge driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210121.GE28430@kroah.com> <4A7769C6.50901@gmail.com>
In-Reply-To: <4A7769C6.50901@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2009 12:50 AM, Jiri Slaby wrote:
> On 08/03/2009 11:01 PM, Greg K-H wrote:
>> +	down(&(vme_irq));
>> +
>> +	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;
> 
> What if the interrupt comes now? 

On the second though, actually nothing worse than "Spurilous VME
interrupt" (if some arch doesn't reorder func and priv_data
assignments). It's not that bad, but still worth fixing.

> I think you want to switch this block
> with "Disable IRQ level" one. And take care of PCI posting (if it is not
> enough that INTEO reaches the device by a consequent INTEN read).
> 
>> +	tsi148_bridge->irq[level - 1].callback[statid].priv_data = NULL;
>> +	tsi148_bridge->irq[level - 1].count--;
>> +
>> +	/* Disable IRQ level */
>> +	if (tsi148_bridge->irq[level - 1].count == 0) {
>> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
>> +		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
>> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
>> +
>> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEN);
>> +		tmp &= ~TSI148_LCSR_INTEN_IRQEN[level - 1];
>> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEN);
>> +	}
>> +
>> +	/* Release semaphore */
>> +	up(&(vme_irq));
>> +}
> 

