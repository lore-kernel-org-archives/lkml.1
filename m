Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbYBONpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbYBONpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYBONpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:45:45 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53909 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYBONpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:45:44 -0500
Date: Fri, 15 Feb 2008 14:45:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 03/14] [ISDN] Ready HiSax driver for modularization
Message-ID: <20080215134552.GK1178@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <566f4ac8f7469e2b8bebe93174e7a6e958c9098d.1203031878.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566f4ac8f7469e2b8bebe93174e7a6e958c9098d.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 01:10:23AM -0400, Jeff Garzik wrote:
> * move netjet, isac, arcofi, hscx common sub-modules to new libhisax.ko
> * export several symbols that are used by external drivers
> * move DEFAULT_PROTO* deterination to shareable header file
> * add hotplug and PCI-remove APIs
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> ---
>  drivers/isdn/hisax/Makefile    |   51 ++++++++++++++++++-----------------
>  drivers/isdn/hisax/arcofi.c    |    4 +++
>  drivers/isdn/hisax/config.c    |   57 ++++++++++++++++++++++++++--------------
>  drivers/isdn/hisax/hisax_cfg.h |    2 +
>  drivers/isdn/hisax/hscx.c      |    8 +++++
>  drivers/isdn/hisax/isac.c      |    6 ++++
>  drivers/isdn/hisax/isdnl1.c    |   12 +++++++-
>  drivers/isdn/hisax/lmgr.c      |    2 +
>  drivers/isdn/hisax/netjet.c    |    9 ++++++
>  drivers/isdn/hisax/q931.c      |    4 +++
>  10 files changed, 109 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
> index c7a3794..b0b09e9 100644
> --- a/drivers/isdn/hisax/Makefile
> +++ b/drivers/isdn/hisax/Makefile
> @@ -6,7 +6,7 @@
>  
>  EXTRA_CFLAGS      += -DHISAX_MAX_CARDS=$(CONFIG_HISAX_MAX_CARDS)
>  
> -obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o
> +obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o libhisax.o
>  obj-$(CONFIG_HISAX_SEDLBAUER_CS)	+= sedlbauer_cs.o
>  obj-$(CONFIG_HISAX_ELSA_CS)		+= elsa_cs.o
>  obj-$(CONFIG_HISAX_AVM_A1_CS)		+= avma1_cs.o
> @@ -16,6 +16,8 @@ obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
>  obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
>  obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
>  
> +libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o

Please use
> +libhisax-y				:= netjet.o isac.o arcofi.o hscx.o

>  
> diff --git a/drivers/isdn/hisax/arcofi.c b/drivers/isdn/hisax/arcofi.c
> index d30ce5b..bf2e10d 100644
> --- a/drivers/isdn/hisax/arcofi.c
> +++ b/drivers/isdn/hisax/arcofi.c
> @@ -132,3 +132,7 @@ init_arcofi(struct IsdnCardState *cs) {
>  	init_waitqueue_head(&cs->dc.isac.arcofi_wait);
>  	test_and_set_bit(HW_ARCOFI, &cs->HW_Flags);
>  }
> +
> +EXPORT_SYMBOL(init_arcofi);
> +EXPORT_SYMBOL(clear_arcofi);
> +EXPORT_SYMBOL(arcofi_fsm);

Should be just below their respective implmentation.

> diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
> index f395a72..6112013 100644
> --- a/drivers/isdn/hisax/config.c
> +++ b/drivers/isdn/hisax/config.c
> @@ -19,10 +19,12 @@
>  #include <linux/timer.h>
>  #include <linux/init.h>
>  #include "hisax.h"
> +#include "hisax_proto.h"
Should be last in the include order - not mixed between
<linux/xxx.h> includes.

>  #include <linux/module.h>

> +#ifdef CONFIG_PCI
> +void hisax_pci_remove_one(struct pci_dev *pdev)
> +{
> +	int cardnr = (unsigned long) pci_get_drvdata(pdev);
> +
> +	HiSax_closecard(cardnr);
> +	pci_disable_device(pdev);
> +	pci_set_drvdata(pdev, NULL);
> +}
> +
> +EXPORT_SYMBOL(hisax_pci_remove_one);

No empty line above.

>  
>  EXPORT_SYMBOL(hisax_init_pcmcia);
> +EXPORT_SYMBOL(hisax_init_hotplug);
>  EXPORT_SYMBOL(HiSax_closecard);
> +EXPORT_SYMBOL(HiSax_getrev);
> +EXPORT_SYMBOL(HiSax_putstatus);

Exports right after implmentation.

> --- a/drivers/isdn/hisax/hscx.c
> +++ b/drivers/isdn/hisax/hscx.c
> @@ -274,3 +274,11 @@ inithscxisac(struct IsdnCardState *cs, int part)
>  		cs->writeisac(cs, ISAC_CMDR, 0x41);
>  	}
>  }
> +
> +EXPORT_SYMBOL(HscxVersion);
> +EXPORT_SYMBOL(inithscxisac);
> +EXPORT_SYMBOL(inithscx);
> +EXPORT_SYMBOL(clear_pending_hscx_ints);
> +EXPORT_SYMBOL(hscx_l2l1);
> +EXPORT_SYMBOL(open_hscxstate);
> +EXPORT_SYMBOL(modehscx);

exports right after implmentation.

> diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
> index 07b1673..40bb5f8 100644
> --- a/drivers/isdn/hisax/isac.c
> +++ b/drivers/isdn/hisax/isac.c
> @@ -678,3 +678,9 @@ setup_isac(struct IsdnCardState *cs)
>  	cs->dbusytimer.data = (long) cs;
>  	init_timer(&cs->dbusytimer);
>  }
> +
> +EXPORT_SYMBOL(isac_interrupt);
> +EXPORT_SYMBOL(initisac);
> +EXPORT_SYMBOL(clear_pending_isac_ints);
> +EXPORT_SYMBOL(ISACVersion);
> +EXPORT_SYMBOL(setup_isac);

exports right after implmentation.

> +
> +EXPORT_SYMBOL(l1_msg);
> +EXPORT_SYMBOL(l1_msg_b);
> +EXPORT_SYMBOL(debugl1);
> +EXPORT_SYMBOL(setstack_l1_B);
> +EXPORT_SYMBOL(DChannel_proc_rcv);
> +EXPORT_SYMBOL(DChannel_proc_xmt);
> +#ifdef L2FRAME_DEBUG
> +EXPORT_SYMBOL(Logl2Frame);
> +#endif

ditto

> diff --git a/drivers/isdn/hisax/lmgr.c b/drivers/isdn/hisax/lmgr.c
> index d4f86d6..5980490 100644
> --- a/drivers/isdn/hisax/lmgr.c
> +++ b/drivers/isdn/hisax/lmgr.c
> @@ -48,3 +48,5 @@ setstack_manager(struct PStack *st)
>  {
>  	st->ma.layer = hisax_manager;
>  }
> +
> +EXPORT_SYMBOL(setstack_manager);
Drop empty line above.

> diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
> index 02c6fba..1e3e45b 100644
> --- a/drivers/isdn/hisax/netjet.c
> +++ b/drivers/isdn/hisax/netjet.c
> @@ -979,3 +979,12 @@ release_io_netjet(struct IsdnCardState *cs)
>  	release_region(cs->hw.njet.base, 256);
>  }
>  
> +EXPORT_SYMBOL(NETjet_WriteICfifo);
> +EXPORT_SYMBOL(NETjet_ReadICfifo);
> +EXPORT_SYMBOL(NETjet_WriteIC);
> +EXPORT_SYMBOL(NETjet_ReadIC);
> +EXPORT_SYMBOL(write_tiger);
> +EXPORT_SYMBOL(read_tiger);
> +EXPORT_SYMBOL(inittiger);
> +EXPORT_SYMBOL(netjet_fill_dma);
> +EXPORT_SYMBOL(release_io_netjet);

exports right after implementation.

> diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
> index aacbf0d..8a4e60b 100644
> --- a/drivers/isdn/hisax/q931.c
> +++ b/drivers/isdn/hisax/q931.c
> @@ -1520,3 +1520,7 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
>  	*dp = 0;
>  	HiSax_putstatus(cs, NULL, cs->dlog);
>  }
> +
> +EXPORT_SYMBOL(dlogframe);
> +EXPORT_SYMBOL(LogFrame);
> +EXPORT_SYMBOL(QuickHex);

exports right after implementation.
