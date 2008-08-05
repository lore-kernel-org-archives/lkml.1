Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYHEEaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYHEEaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYHEEaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:30:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:47276 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYHEEaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:30:02 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <20080802151532.DE017A3C09@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 14:29:48 +1000
Message-Id: <1217910588.24157.151.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 16:35 +0200, Karsten Keil wrote:
> The driver was not so bad at big endian at all, only the optimised fifo
> read/write functions need a fix, with this fix the driver works on
> a pegasus PPC machine.

This is however very broken... IE, you should instead use iomap
and thus get ioreadXX_rep() and writeXX_rep() (XX = 16 or 32) that
will do the right thing for you. IE, they will do the right amount
of memory barriers and will avoid the unnecessary double-swapping
you are doing there.

Your code will happen to "work" but it's just way too ugly especially
since you are basically re-implementing what iomap already gives you.

Ben.

> Signed-off-by: Karsten Keil <kkeil@suse.de>
> ---
>  drivers/isdn/hardware/mISDN/hfcmulti.c |   27 +++++++++++++--------------
>  1 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> index 10144e8..e36360a 100644
> --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> @@ -140,7 +140,7 @@
>   * #define HFC_REGISTER_DEBUG
>   */
>  
> -static const char *hfcmulti_revision = "2.00";
> +static const char *hfcmulti_revision = "2.01";
>  
>  #include <linux/module.h>
>  #include <linux/pci.h>
> @@ -427,12 +427,12 @@ write_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
>  {
>  	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
>  	while (len>>2) {
> -		outl(*(u32 *)data, hc->pci_iobase);
> +		outl(cpu_to_le32(*(u32 *)data), hc->pci_iobase);
>  		data += 4;
>  		len -= 4;
>  	}
>  	while (len>>1) {
> -		outw(*(u16 *)data, hc->pci_iobase);
> +		outw(cpu_to_le16(*(u16 *)data), hc->pci_iobase);
>  		data += 2;
>  		len -= 2;
>  	}
> @@ -447,17 +447,19 @@ void
>  write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
>  {
>  	while (len>>2) {
> -		writel(*(u32 *)data, (hc->pci_membase)+A_FIFO_DATA0);
> +		writel(cpu_to_le32(*(u32 *)data),
> +			hc->pci_membase + A_FIFO_DATA0);
>  		data += 4;
>  		len -= 4;
>  	}
>  	while (len>>1) {
> -		writew(*(u16 *)data, (hc->pci_membase)+A_FIFO_DATA0);
> +		writew(cpu_to_le16(*(u16 *)data),
> +			hc->pci_membase + A_FIFO_DATA0);
>  		data += 2;
>  		len -= 2;
>  	}
>  	while (len) {
> -		writeb(*data, (hc->pci_membase)+A_FIFO_DATA0);
> +		writeb(*data, hc->pci_membase + A_FIFO_DATA0);
>  		data++;
>  		len--;
>  	}
> @@ -468,12 +470,12 @@ read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
>  {
>  	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
>  	while (len>>2) {
> -		*(u32 *)data = inl(hc->pci_iobase);
> +		*(u32 *)data = le32_to_cpu(inl(hc->pci_iobase));
>  		data += 4;
>  		len -= 4;
>  	}
>  	while (len>>1) {
> -		*(u16 *)data = inw(hc->pci_iobase);
> +		*(u16 *)data = le16_to_cpu(inw(hc->pci_iobase));
>  		data += 2;
>  		len -= 2;
>  	}
> @@ -490,18 +492,18 @@ read_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
>  {
>  	while (len>>2) {
>  		*(u32 *)data =
> -			readl((hc->pci_membase)+A_FIFO_DATA0);
> +			le32_to_cpu(readl(hc->pci_membase + A_FIFO_DATA0));
>  		data += 4;
>  		len -= 4;
>  	}
>  	while (len>>1) {
>  		*(u16 *)data =
> -			readw((hc->pci_membase)+A_FIFO_DATA0);
> +			le16_to_cpu(readw(hc->pci_membase + A_FIFO_DATA0));
>  		data += 2;
>  		len -= 2;
>  	}
>  	while (len) {
> -		*data = readb((hc->pci_membase)+A_FIFO_DATA0);
> +		*data = readb(hc->pci_membase + A_FIFO_DATA0);
>  		data++;
>  		len--;
>  	}
> @@ -5251,9 +5253,6 @@ HFCmulti_init(void)
>  	if (debug & DEBUG_HFCMULTI_INIT)
>  		printk(KERN_DEBUG "%s: init entered\n", __func__);
>  
> -#ifdef __BIG_ENDIAN
> -#error "not running on big endian machines now"
> -#endif
>  	hfc_interrupt = symbol_get(ztdummy_extern_interrupt);
>  	register_interrupt = symbol_get(ztdummy_register_interrupt);
>  	unregister_interrupt = symbol_get(ztdummy_unregister_interrupt);

