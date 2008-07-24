Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYGXLP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYGXLP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYGXLPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:15:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbYGXLPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:15:12 -0400
Date: Thu, 24 Jul 2008 13:14:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console v3
Message-ID: <20080724111450.GM28817@elte.hu>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807231739.39620.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


very nice feature!

The code structure looks good to me, here's a few minor style nits:

> +	/* Now that we have observed the completed transaction,
> +	 * clear the done bit.
> +	 */

while i understand that this is cut & pasted code, please use standard 
comment style:

  /*
   * Comment ...
   *  ... line.
   */

(ditto the same mistake in other places too)

> +	/* Read the result */
> +	ret = dbgp_bulk_read(devnum, 0, data, size);
> +	return ret;

do:

    return dbgp_bulk_read(devnum, 0, data, size);

> +	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
> +		PCI_STATUS_CAP_LIST))
> +		return 0;
> +	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);

it's generally nicer to the eyes to add an extra newline after a block 
with return in it.

> +	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
> +		u8 id;
> +		pos &= ~3;

please put a newline between variable definitions and first statement.

> +
> +static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned *rslot,
> +				unsigned *rfunc)
> +{
> +	unsigned bus, slot, func;
> +
> +	for (bus = 0; bus < 256; bus++) {
> +		for (slot = 0; slot < 32; slot++) {
> +			for (func = 0; func < 8; func++) {
> +				u32 class;
> +				unsigned cap;
> +
> +				class = read_pci_config(bus, slot, func,
> +							 PCI_CLASS_REVISION);
> +				if ((class >> 8) != PCI_CLASS_SERIAL_USB_EHCI)
> +					continue;
> +				cap = find_cap(bus, slot, func,
> +						 PCI_CAP_ID_EHCI_DEBUG);

the line 80 breaks you had to add here show that the nesting is too deep 
here - i'd suggest a helper __find_dbgp() function to put the iterator 
into.

> +	if ((ctrl & DBGP_CLAIM) != DBGP_CLAIM) {
> +		dbgp_printk("No device in debug port\n");
> +		writel(ctrl & ~DBGP_CLAIM, &ehci_debug->control);
> +		return -1;
> +
> +	}

stray newline.

> +static int __init early_dbgp_init(char *s)
> +{
> +	struct usb_debug_descriptor dbgp_desc;
> +	void __iomem *ehci_bar;
> +	unsigned ctrl, devnum;
> +	unsigned bus, slot, func, cap;
> +	unsigned debug_port, bar, offset;
> +	unsigned bar_val;
> +	char *e;
> +	int ret;
> +	unsigned dbgp_num;

use an explicit integer type please instead of 'unsigned'. Also, try to 
use reverse christmas-tree ordering for same-type entries (and where 
possible, between different types as well):

> +	struct usb_debug_descriptor dbgp_desc;
> +	unsigned int debug_port, bar, offset;
> +	unsigned int bus, slot, func, cap;
> +	unsigned int ctrl, devnum;
> +	unsigned int dbgp_num;
> +	unsigned int bar_val;
> +	void __iomem *ehci_bar;
> +	char *e;
> +	int ret;


here:

> +	dbgp_num = 0;
> +	if (*s)
> +		dbgp_num = simple_strtoul(s, &e, 10);
> +	dbgp_printk("dbgp_num: %d\n", dbgp_num);
> +	cap = find_dbgp(dbgp_num, &bus, &slot, &func);
> +	if (!cap)
> +		return -1;
> +
> +	dbgp_printk("Found EHCI debug port\n");

i'd suggest a newline after the first dbgp_printk(), to make the two 
sections stand out better.

> +	}
> +
> +

stray newline.

> +	/* FIXME I don't have the bar size so just guess PAGE_SIZE is more
> +	 * than enough.  1K is the biggest I have seen.
> +	 */

comment style.

> +	ret = ehci_setup();
> +	if (ret < 0) {
> +		dbgp_printk("ehci_setup failed\n");
> +		ehci_debug = 0;
> +		return -1;

please put newlines before return statements, to make sure there's a 
hickup in the visual flow during review. (which hickup return statements 
should cause, they must not be glossed over)

> +	}
> +
> +

stray newline.

> Index: linux-2.6/drivers/usb/host/ehci.h
> ===================================================================
> --- linux-2.6.orig/drivers/usb/host/ehci.h
> +++ linux-2.6/drivers/usb/host/ehci.h
> @@ -210,146 +210,11 @@ timer_action (struct ehci_hcd *ehci, enu

i suggest you make this code movement a separate patch. In the unlikely 
event of there being any regression it's an easier bisection target.

looks good to me otherwise.

	Ingo
