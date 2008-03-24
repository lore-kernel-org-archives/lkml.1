Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbYCXPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbYCXPBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbYCXPBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:01:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:47831 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbYCXPBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:01:34 -0400
To: Joe Perches <joe@perches.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies) -> jiffies, timeout
References: <47E28637.4010700@tiscali.nl>
	<1206031566.26345.63.camel@localhost>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 24 Mar 2008 16:01:32 +0100
In-Reply-To: <1206031566.26345.63.camel@localhost> (Joe Perches's message of "Thu\, 20 Mar 2008 09\:46\:06 -0700")
Message-ID: <m3fxug2mk3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

>>  	while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
>> -		if (time_before(timeout, jiffies)) {
>> +		if (time_before(jiffies, timeout)) {
>>  			printk(KERN_WARNING "wanXL %s: timeout waiting for"
>>  			       " PUTS to complete\n", pci_name(pdev));
>>  			wanxl_pci_remove_one(pdev);
>
> Wouldn't it be better to have a schedule() in those
> while loops too?

There is a schedule() here:

        timeout = jiffies + 20 * HZ;
        while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
                if (time_before(timeout, jiffies)) {
                        printk(KERN_WARNING "wanXL %s: timeout waiting for"
                               " PUTS to complete\n", pci_name(pdev));
                        wanxl_pci_remove_one(pdev);
                        return -ENODEV;
                }

                switch(stat & 0xC0) {
                case 0x00:      /* hmm - PUTS completed with non-zero code? */
                case 0x80:      /* PUTS still testing the hardware */
                        break;

                default:
                        printk(KERN_WARNING "wanXL %s: PUTS test 0x%X"
                               " failed\n", pci_name(pdev), stat & 0x30);
                        wanxl_pci_remove_one(pdev);
                        return -ENODEV;
                }

                schedule();
        }

The timeout is 20 seconds, busy loop wouldn't make any sense.

> Maybe a more generic macro / statement expression
> would be more readable?

I don't think so. BTW the only "long" loop is the POTS one (after hw
reset or rmmod + insmod), IIRC it takes about 1 second for every MB of
installed DRAM. Officially you can have 1 or 4 MB, and 16 MB module
works (IIRC, on my card) as well - thus 20 * HZ timeout.

A couple of reversed time_{after,before}, yes (with reversed
arguments, i.e., functionally equivalent but probably harder to
parse). Will look at them.
-- 
Krzysztof Halasa
