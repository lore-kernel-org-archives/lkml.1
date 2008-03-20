Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYCTVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYCTVJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYCTVJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:09:27 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2723 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbYCTVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:09:26 -0400
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies)
	-> jiffies, timeout
From: Joe Perches <joe@perches.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: khc@pm.waw.pl, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47E2C7D2.5080601@tiscali.nl>
References: <47E28637.4010700@tiscali.nl>
	 <1206031566.26345.63.camel@localhost>  <47E2C7D2.5080601@tiscali.nl>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 14:06:18 -0700
Message-Id: <1206047178.26345.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 21:23 +0100, Roel Kluin wrote:
> > -	while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
> > -		if (time_before(timeout, jiffies)) {
> > -			printk(KERN_WARNING "wanXL %s: timeout waiting for"
> > -			       " PUTS to complete\n", pci_name(pdev));
> > -			wanxl_pci_remove_one(pdev);
> > -			return -ENODEV;
> > -		}
> > -
> > -		switch(stat & 0xC0) {
> > -		case 0x00:	/* hmm - PUTS completed with non-zero code? */
> > -		case 0x80:	/* PUTS still testing the hardware */
> > -			break;
> > -
> > -		default:
> > -			printk(KERN_WARNING "wanXL %s: PUTS test 0x%X"
> > +	if (TEST_UNTIL_TIMEOUT(((stat = readl(card->plx + PLX_MAILBOX_0)) != 0),
> > +			       20 * HZ)) {
> > +		printk(KERN_WARNING "wanXL %s: PUTS test 0x%X"
> >  			       " failed\n", pci_name(pdev), stat & 0x30);
> >  			wanxl_pci_remove_one(pdev);
> >  			return -ENODEV;
> 
> Doesn't this change behavior for (stat & 0xC0) != 0x00 or 0x80?

Probably, I didn't look at it too much.  Feel free to fix it.

The patch was just to demonstrate the statement expression macro
and show the lack of schedules() in some of the loops.

Maybe the statement expression macro should optionally schedule too:

#define TEST_UNTIL_TIMEOUT(test, hz, schedule)		\
({							\
	typeof(test) t;					\
	unsigned long timeout = jiffies + (hz);		\
	do {						\
		t = (test);				\
		if (t)					\
			break;				\
		if ((schedule))				\
			schedule();			\
	} while (time_before(jiffies, timeout));	\
	t;						\
})

cheers, Joe

