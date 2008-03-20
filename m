Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYCTUbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYCTUbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbYCTUXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:23:53 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:49498 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695AbYCTUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:23:50 -0400
Message-ID: <47E2C7D2.5080601@tiscali.nl>
Date: Thu, 20 Mar 2008 21:23:46 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: khc@pm.waw.pl, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wan/wanxl.c: time_before(timeout, jiffies)
 -> jiffies, timeout
References: <47E28637.4010700@tiscali.nl> <1206031566.26345.63.camel@localhost>
In-Reply-To: <1206031566.26345.63.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2008-03-20 at 16:43 +0100, Roel Kluin wrote:
>> fix reversal of timeout and jiffies

> Wouldn't it be better to have a schedule() in those
> while loops too?
> 
> Maybe a more generic macro / statement expression
> would be more readable?

It appears more readable.

> perhaps something like (compiled/untested):

A few generic comments (not yet tested)

>  drivers/net/wan/wanxl.c |   86 ++++++++++++++++------------------------------
>  1 files changed, 30 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
> index d4aab8a..db1eabe 100644
> --- a/drivers/net/wan/wanxl.c
> +++ b/drivers/net/wan/wanxl.c
> @@ -51,6 +51,19 @@ static const char* version = "wanXL serial card driver version: 0.48";
>  #define MBX2_MEMSZ_MASK 0xFFFF0000 /* PUTS Memory Size Register mask */
>  
>  
> +#define TEST_UNTIL_TIMEOUT(test, hz)			\
> +({							\
> +	typeof test t;					\

	typeof(test) t;					\

will this work if test is a function?

> +	unsigned long timeout = jiffies + hz;		\

	unsigned long timeout = jiffies + (hz);		\

> +	do {						\
> +		t = test;				\

		t = (test);				\

> +		if (t)					\
> +			break;				\
> +		schedule();				\
> +	} while (time_before(jiffies, timeout));	\
> +	t;						\
> +})

> +
>  typedef struct {
>  	struct net_device *dev;
>  	struct card_t *card;
> @@ -396,7 +409,6 @@ static int wanxl_open(struct net_device *dev)
>  {
>  	port_t *port = dev_to_port(dev);
>  	u8 __iomem *dbr = port->card->plx + PLX_DOORBELL_TO_CARD;
> -	unsigned long timeout;
>  	int i;
>  
>  	if (get_status(port)->open) {
> @@ -412,18 +424,15 @@ static int wanxl_open(struct net_device *dev)
>  	/* signal the card */
>  	writel(1 << (DOORBELL_TO_CARD_OPEN_0 + port->node), dbr);
>  
> -	timeout = jiffies + HZ;
> -	do
> -		if (get_status(port)->open) {
> -			netif_start_queue(dev);
> -			return 0;
> -		}
> -	while (time_after(timeout, jiffies));
> +	if (!TEST_UNTIL_TIMEOUT((get_status(port)->open), HZ)) {
> +		printk(KERN_ERR "%s: unable to open port\n", dev->name);
> +		/* ask the card to close the port, should it be still alive */
> +		writel(1 << (DOORBELL_TO_CARD_CLOSE_0 + port->node), dbr);
> +		return -EFAULT;
> +	}
>  
> -	printk(KERN_ERR "%s: unable to open port\n", dev->name);
> -	/* ask the card to close the port, should it be still alive */
> -	writel(1 << (DOORBELL_TO_CARD_CLOSE_0 + port->node), dbr);
> -	return -EFAULT;
> +	netif_start_queue(dev);
> +	return 0;
>  }
>  
>  
> @@ -431,7 +440,6 @@ static int wanxl_open(struct net_device *dev)
>  static int wanxl_close(struct net_device *dev)
>  {
>  	port_t *port = dev_to_port(dev);
> -	unsigned long timeout;
>  	int i;
>  
>  	hdlc_close(dev);
> @@ -439,13 +447,7 @@ static int wanxl_close(struct net_device *dev)
>  	writel(1 << (DOORBELL_TO_CARD_CLOSE_0 + port->node),
>  	       port->card->plx + PLX_DOORBELL_TO_CARD);
>  
> -	timeout = jiffies + HZ;
> -	do
> -		if (!get_status(port)->open)
> -			break;
> -	while (time_after(timeout, jiffies));
> -
> -	if (get_status(port)->open)
> +	if (TEST_UNTIL_TIMEOUT((!get_status(port)->open), HZ))
>  		printk(KERN_ERR "%s: unable to close port\n", dev->name);
>  
>  	netif_stop_queue(dev);
> @@ -481,17 +483,11 @@ static struct net_device_stats *wanxl_get_stats(struct net_device *dev)
>  
>  static int wanxl_puts_command(card_t *card, u32 cmd)
>  {
> -	unsigned long timeout = jiffies + 5 * HZ;
> -
>  	writel(cmd, card->plx + PLX_MAILBOX_1);
> -	do {
> -		if (readl(card->plx + PLX_MAILBOX_1) == 0)
> -			return 0;
> -
> -		schedule();
> -	}while (time_after(timeout, jiffies));
> +	if (TEST_UNTIL_TIMEOUT((readl(card->plx + PLX_MAILBOX_1)), 5 * HZ))
> +		return -1;
>  
> -	return -1;
> +	return 0;
>  }
>  
>  
> @@ -649,27 +645,12 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
>  #endif
>  
>  	timeout = jiffies + 20 * HZ;

you can remove the line above as well

> -	while ((stat = readl(card->plx + PLX_MAILBOX_0)) != 0) {
> -		if (time_before(timeout, jiffies)) {
> -			printk(KERN_WARNING "wanXL %s: timeout waiting for"
> -			       " PUTS to complete\n", pci_name(pdev));
> -			wanxl_pci_remove_one(pdev);
> -			return -ENODEV;
> -		}
> -
> -		switch(stat & 0xC0) {
> -		case 0x00:	/* hmm - PUTS completed with non-zero code? */
> -		case 0x80:	/* PUTS still testing the hardware */
> -			break;
> -
> -		default:
> -			printk(KERN_WARNING "wanXL %s: PUTS test 0x%X"
> +	if (TEST_UNTIL_TIMEOUT(((stat = readl(card->plx + PLX_MAILBOX_0)) != 0),
> +			       20 * HZ)) {
> +		printk(KERN_WARNING "wanXL %s: PUTS test 0x%X"
>  			       " failed\n", pci_name(pdev), stat & 0x30);
>  			wanxl_pci_remove_one(pdev);
>  			return -ENODEV;

Doesn't this change behavior for (stat & 0xC0) != 0x00 or 0x80?

> -		}
> -
> -		schedule();
>  	}
>  
>  	/* get on-board memory size (PUTS detects no more than 4 MB) */
> @@ -734,15 +715,8 @@ static int __devinit wanxl_pci_init_one(struct pci_dev *pdev,
>  		return -ENODEV;
>  	}
>  
> -	stat = 0;
> -	timeout = jiffies + 5 * HZ;
> -	do {
> -		if ((stat = readl(card->plx + PLX_MAILBOX_5)) != 0)
> -			break;
> -		schedule();
> -	}while (time_after(timeout, jiffies));
> -
> -	if (!stat) {
> +	if (TEST_UNTIL_TIMEOUT(((stat = readl(card->plx + PLX_MAILBOX_5)) != 0),
> +			       5 * HZ)) {
>  		printk(KERN_WARNING "wanXL %s: timeout while initializing card "
>  		       "firmware\n", pci_name(pdev));
>  		wanxl_pci_remove_one(pdev);
> 
> 
