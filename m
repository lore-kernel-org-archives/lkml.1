Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXLDORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXLDORQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXLDORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:17:00 -0500
Received: from smtp2a.orange.fr ([80.12.242.140]:20780 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXLDOQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:16:58 -0500
X-ME-UUID: 20071204141656981.EF94D700009E@mwinf2a26.orange.fr
Message-ID: <47556155.90006@cosmosbay.com>
Date: Tue, 04 Dec 2007 15:16:53 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de>
In-Reply-To: <20071204114125.GA17310@torres.zugschlus.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Haber a écrit :
> While debugging Exim4's GnuTLS interface, I recently found out that
> reading from /dev/urandom depletes entropy as much as reading from
> /dev/random would. This has somehow surprised me since I have always
> believed that /dev/urandom has lower quality entropy than /dev/random,
> but lots of it.
>
> This also means that I can "sabotage" applications reading from
> /dev/random just by continuously reading from /dev/urandom, even not
> meaning to do any harm.
>
> Before I file a bug on bugzilla, can I ask why /dev/urandom wasn't
> implemented as a PRNG which is periodically (say, every 1024 bytes or
> even more) seeded from /dev/random? That way, /dev/random has a much
> higher chance of holding enough entropy for applications that really
> need "good" entropy.
>
> Entropy depletion has become an issue on Linux systems since the
> network was removed from the group of entropy sources a few years ago.
> Of the around 20 Linux systems that I currently have root privileges
> on, only two have a hardware RNG.
>   
Some network drivers still feed entropy pools :

$ find drivers/net | xargs grep -n IRQF_SAMPLE_RANDOM
drivers/net/mv643xx_eth.c:1336:                 IRQF_SHARED | 
IRQF_SAMPLE_RANDOM, dev->name, dev);
drivers/net/3c527.c:437:        err = request_irq(dev->irq, 
&mc32_interrupt, IRQF_SHARED | IRQF_SAMPLE_RANDOM, DRV_NAME, dev);
drivers/net/xen-netfront.c:1371:                                        
IRQF_SAMPLE_RANDOM, netdev->name,
drivers/net/macb.c:1131:        err = request_irq(dev->irq, 
macb_interrupt, IRQF_SAMPLE_RANDOM,
drivers/net/tg3.c:7268:         flags = IRQF_SAMPLE_RANDOM;
drivers/net/tg3.c:7273:         flags = IRQF_SHARED | IRQF_SAMPLE_RANDOM;
drivers/net/tg3.c:7291:                   IRQF_SHARED | 
IRQF_SAMPLE_RANDOM, dev->name, dev);
drivers/net/qla3xxx.c:3648:     unsigned long irq_flags = 
IRQF_SAMPLE_RANDOM | IRQF_SHARED;
drivers/net/3c523.c:292:        ret = request_irq(dev->irq, 
&elmc_interrupt, IRQF_SHARED | IRQF_SAMPLE_RANDOM,
drivers/net/cris/eth_v10.c:704:                 IRQF_SAMPLE_RANDOM, 
cardname, (void *)dev)) {
drivers/net/atl1/atl1_main.c:1967:      int irq_flags = IRQF_SAMPLE_RANDOM;
drivers/net/niu.c:4647:                           IRQF_SHARED | 
IRQF_SAMPLE_RANDOM,
drivers/net/netxen/netxen_nic_main.c:866:                                 
IRQF_SHARED|IRQF_SAMPLE_RANDOM, netdev->name,
drivers/net/ibmlana.c:784:      result = request_irq(priv->realirq, 
irq_handler, IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);

So I guess you could patch your kernel to get more entropy sources (even 
if they are not *perfect* for some purists)

> What can I do to keep sufficiently high entropy pools even if I read
> from /dev/urandom more than once in a while?
>
> Greetings
> Marc
>
>   




