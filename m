Return-Path: <linux-kernel-owner+w=401wt.eu-S1763845AbXEVTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763845AbXEVTgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXEVTgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:36:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbXEVTf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:35:58 -0400
Date: Tue, 22 May 2007 12:31:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3]x86_64: early_printk for early debug port support
Message-Id: <20070522123137.699d7a87.akpm@linux-foundation.org>
In-Reply-To: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
References: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 22:19:18 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> add early dbgp to early_printk.
> 
> kernel command line:
> earlyprintk=dbgp
> or
> earlyprintk=dbgp1
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 

Please try to sort out your email client?  MIME attachments are a pain to
reply to and are a pain to merge.

Please include a diffstat in patches so it is easy for people to see which
files are being altered.

The patch adds lots of new trailing whitespace.  Please trim that off
before sending.  Your editor's settings might need some attention.


>  arch/x86_64/kernel/early_printk.c |  600 ++++++++++++++++++++++++++++
>  drivers/usb/host/ehci.h           |   14 
>  include/asm-i386/fixmap.h         |    1 
>  include/asm-x86_64/fixmap.h       |    3 
>  4 files changed, 616 insertions(+), 2 deletions(-)

Please include an update to Documentation/kernel-parameters.txt

> diff -puN arch/x86_64/kernel/early_printk.c~x86_64-early_printk-for-early-debug-port-support arch/x86_64/kernel/early_printk.c
> --- a/arch/x86_64/kernel/early_printk.c~x86_64-early_printk-for-early-debug-port-support
> +++ a/arch/x86_64/kernel/early_printk.c
> @@ -3,9 +3,20 @@
>  #include <linux/init.h>
>  #include <linux/string.h>
>  #include <linux/screen_info.h>
> +#include <linux/usb/ch9.h>
> +#include <linux/pci_regs.h>
> +#include <linux/pci_ids.h>
> +#include <linux/errno.h>
> +
>  #include <asm/io.h>
>  #include <asm/processor.h>
>  #include <asm/fcntl.h>
> +#include <asm/pci-direct.h>
> +#include <asm/pgtable.h>
> +#include <asm/fixmap.h>
> +#define EARLY_PRINTK
> +#include "../../../drivers/usb/host/ehci.h"

err, perhaps we should move ehci.h somewhere more accessible? 
include/linux/usb/ would seem logical.


>  #include <xen/hvc-console.h>
>  
>  /* Simple VGA output */
> @@ -156,6 +167,582 @@ static struct console early_serial_conso
>  	.index =	-1,
>  };
>  
> +
> +static struct ehci_caps __iomem *ehci_caps;
> +static struct ehci_regs __iomem *ehci_regs;
> +static struct ehci_dbg_port __iomem *ehci_debug;
> +static unsigned dbgp_endpoint_out;
> +
> +#define USB_DEBUG_DEVNUM 127

What is this number?  Should it be documented?

> +#define DBGP_DATA_TOGGLE	0x8800
> +#define DBGP_PID_UPDATE(x, tok) \
> +	((((x) ^ DBGP_DATA_TOGGLE) & 0xffff00) | ((tok) & 0xff))
> +
> +#define DBGP_LEN_UPDATE(x, len) (((x) & ~0x0f) | ((len) & 0x0f))

Please convert the above into lowercase-named static inline C functions. 
Only use macros when for some reason regular C cannot be used.

> +static int dbgp_wait_until_complete(void)
> +{
> +	unsigned ctrl;
> +	int loop = 0x100000;
> +	do {

Please put a blank line between the end of the local definitions and the
start of the code.

> +		ctrl = readl(&ehci_debug->control);
> +		/* Stop when the transaction is finished */
> +		if (ctrl & DBGP_DONE)
> +			break;
> +	} while (--loop > 0);
> +
> +	if (!loop) return -1;

This needs a newline.

> +	/* Now that we have observed the completed transaction,
> +	 * clear the done bit.
> +	 */
> +	writel(ctrl | DBGP_DONE, &ehci_debug->control);
> +	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
> +}
> +
> +static void dbgp_mdelay(int ms)
> +{
> +	int i;
> +	while (ms--) {
> +		for (i = 0; i < 1000; i++)
> +			outb(0x1, 0x80);
> +	}
> +}
> +
> +static void dbgp_breath(void)
> +{
> +	/* Sleep to give the debug port a chance to breathe */
> +}
> +
> +static int dbgp_wait_until_done(unsigned ctrl)
> +{
> +	unsigned pids, lpid;
> +	int ret;
> +
> +	int loop = 3;

Pelase don't put random blank lines in the middle of variable declarations.

> +retry:
> +	writel(ctrl | DBGP_GO, &ehci_debug->control);
> +	ret = dbgp_wait_until_complete();
> +	pids = readl(&ehci_debug->pids);
> +	lpid = DBGP_PID_GET(pids);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	/* If the port is getting full or it has dropped data
> +	 * start pacing ourselves, not necessary but it's friendly.
> +	 */
> +	if ((lpid == USB_PID_NAK) || (lpid == USB_PID_NYET))
> +		dbgp_breath();
> +
> +	/* If I get a NACK reissue the transmission */
> +	if (lpid == USB_PID_NAK) {
> +		if(--loop > 0) goto retry;

Use "if (", rather that "if(".

Add a newline here.

> +	}

> +	return ret;
> +}
> +
> +static void dbgp_set_data(const void *buf, int size)
> +{
> +	const unsigned char *bytes = buf;
> +	unsigned lo, hi;
> +	int i;
> +	lo = hi = 0;
> +	for (i = 0; i < 4 && i < size; i++)
> +		lo |= bytes[i] << (8*i);
> +	for (; i < 8 && i < size; i++)
> +		hi |= bytes[i] << (8*(i - 4));
> +	writel(lo, &ehci_debug->data03);
> +	writel(hi, &ehci_debug->data47);
> +}
> +
> +static void dbgp_get_data(void *buf, int size)
> +{
> +	unsigned char *bytes = buf;
> +	unsigned lo, hi;
> +	int i;
> +	lo = readl(&ehci_debug->data03);
> +	hi = readl(&ehci_debug->data47);
> +	for (i = 0; i < 4 && i < size; i++)
> +		bytes[i] = (lo >> (8*i)) & 0xff;
> +	for (; i < 8 && i < size; i++)
> +		bytes[i] = (hi >> (8*(i - 4))) & 0xff;
> +}
> +
> +static int dbgp_bulk_write(unsigned devnum, unsigned endpoint, const char *bytes, int size)

This line exceeds 80 columns

> +{
> +	unsigned pids, addr, ctrl;
> +	int ret;
> +	if (size > DBGP_MAX_PACKET)
> +		return -1;
> +
> +	addr = DBGP_EPADDR(devnum, endpoint);
> +
> +	pids = readl(&ehci_debug->pids);
> +	pids = DBGP_PID_UPDATE(pids, USB_PID_OUT);
> +
> +	ctrl = readl(&ehci_debug->control);
> +	ctrl = DBGP_LEN_UPDATE(ctrl, size);
> +	ctrl |= DBGP_OUT;
> +	ctrl |= DBGP_GO;
> +
> +	dbgp_set_data(bytes, size);
> +	writel(addr, &ehci_debug->address);
> +	writel(pids, &ehci_debug->pids);
> +
> +	ret = dbgp_wait_until_done(ctrl);
> +	if (ret < 0) {
> +		return ret;
> +	}

unneeded braces

> +	return ret;
> +}
> +
>
> ...
>
> +static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
> +	int value, int index, void *data, int size)
> +{
> +	unsigned pids, addr, ctrl;
> +	struct usb_ctrlrequest req;
> +	int read;
> +	int ret;
> +
> +	read = (requesttype & USB_DIR_IN) != 0;
> +	if (size > (read?DBGP_MAX_PACKET:0))

Place spaces around the ?

> +		return -1;
> +
> +	/* Compute the control message */
> +	req.bRequestType = requesttype;
> +	req.bRequest = request;
> +	req.wValue = value;
> +	req.wIndex = index;
> +	req.wLength = size;
> +
> +	pids = DBGP_PID_SET(USB_PID_DATA0, USB_PID_SETUP);
> +	addr = DBGP_EPADDR(devnum, 0);
> +
> +	ctrl = readl(&ehci_debug->control);
> +	ctrl = DBGP_LEN_UPDATE(ctrl, sizeof(req));
> +	ctrl |= DBGP_OUT;
> +	ctrl |= DBGP_GO;
> +
> +	/* Send the setup message */
> +	dbgp_set_data(&req, sizeof(req));
> +	writel(addr, &ehci_debug->address);
> +	writel(pids, &ehci_debug->pids);
> +	ret = dbgp_wait_until_done(ctrl);
> +	if (ret < 0)
> +		return ret;
> +
> +

Only one blank line is needed

> +	/* Read the result */
> +	ret = dbgp_bulk_read(devnum, 0, data, size);
> +	return ret;
> +}
> +
> +
> +/* Find a PCI capability */
> +static __u32 __init find_cap(int num, int slot, int func, int cap)
> +{
> +	u8 pos;
> +	int bytes;
> +	if (!(read_pci_config_16(num,slot,func,PCI_STATUS) & PCI_STATUS_CAP_LIST))
> +		return 0;
> +	pos = read_pci_config_byte(num,slot,func,PCI_CAPABILITY_LIST);
> +	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
> +		u8 id;
> +		pos &= ~3;
> +		id = read_pci_config_byte(num,slot,func,pos+PCI_CAP_LIST_ID);
> +		if (id == 0xff)
> +			break;
> +		if (id == cap)
> +			return pos;
> +		pos = read_pci_config_byte(num,slot,func,pos+PCI_CAP_LIST_NEXT);
> +	}
> +	return 0;
> +}
> +
>
> ...
>
> +static int __init early_dbgp_init(char *s)

This function has no callers and causes a compiler warning.

> +static void early_dbgp_write(struct console *con, const char *str, unsigned n)

This function has a single reference:

> +{
> +	int chunk, ret;
> +	if (!ehci_debug)
> +		return;
> +	while (n > 0) {
> +		chunk = n;
> +		if (chunk > DBGP_MAX_PACKET)
> +			chunk = DBGP_MAX_PACKET;
> +		ret = dbgp_bulk_write(USB_DEBUG_DEVNUM,
> +			dbgp_endpoint_out, str, chunk);
> +		str += chunk;
> +		n -= chunk;
> +	}
> +}
> +
> +static struct console early_dbgp_console = {
> +	.name =		"earlydbg",
> +	.write =	early_dbgp_write,
> +	.flags = 	CON_PRINTBUFFER,
> +	.index = 	-1,
> +};

in here.  But nothing references early_dbgp_console, and another wraning is
emitted.

>  /* Console interface to a host file on AMD's SimNow! */
>  
>  static int simnow_fd;
> @@ -256,4 +843,17 @@ static int __init setup_early_printk(cha
>  	register_console(early_console);
>  	return 0;
>  }
> +
> +void __init enable_debug_console(char *buf)
> +{
> +#if DBGP_DEBUG
> +	if(early_console_initialized && early_console) {
> +		unregister_console(early_console);
> +		early_console_initialized = 0;
> +	}
> +	setup_early_printk(buf);
> +	keep_early = 1;
> +#endif
> +}

ah, and I guess that explains all the dead code.

>  early_param("earlyprintk", setup_early_printk);
> diff -puN drivers/usb/host/ehci.h~x86_64-early_printk-for-early-debug-port-support drivers/usb/host/ehci.h
> --- a/drivers/usb/host/ehci.h~x86_64-early_printk-for-early-debug-port-support
> +++ a/drivers/usb/host/ehci.h
> @@ -62,6 +62,7 @@ struct ehci_stats {
>  
>  #define	EHCI_MAX_ROOT_PORTS	15		/* see HCS_N_PORTS */
>  
> +#ifndef EARLY_PRINTK
>  struct ehci_hcd {			/* one per controller */
>  	/* glue to PCI and HCD framework */
>  	struct ehci_caps __iomem *caps;
> @@ -189,6 +190,7 @@ timer_action (struct ehci_hcd *ehci, enu
>  		mod_timer (&ehci->watchdog, t);
>  	}
>  }
> +#endif /* EARLY_PRINTK */
>  
> [lots of similar stuff]
>

Why were all these ifdefs added?


<fiddles>

OK, I went through the exercise of removing all the unused-symbol warnings
which DBGP_DEBUG=0 produces and guess what?  None of the code which you've
added does anything!  It all has to be moved inside DBGP_DEBUG to avoid
unused-symbol warnings.  It's all a big no-op if DBGP_DEBUG=0.  I suspect
you did all your test and devel with DBGP_DEBUG=1, then turned DBGP_DEBUG
off and shipped the code without retesting?




