Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYH2Ile@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYH2Ile (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYH2IlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:41:09 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:38468 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYH2IlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:41:06 -0400
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, greg@kroah.com, linux-usb@vger.kernel.org,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200808281704.20999.arnd@arndb.de>
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
	 <200808281704.20999.arnd@arndb.de>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Fri, 29 Aug 2008 16:57:45 +0800
Message-Id: <1220000265.30607.10.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2008 08:40:54.0418 (UTC) FILETIME=[F31A3720:01C909B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 17:04 +0200, Arnd Bergmann wrote:
> On Thursday 28 August 2008, Li Yang wrote:
> > Some of Freescale SoC chips have a QE or CPM co-processor which
> > supports full speed USB.  The driver adds device mode support
> > of both QE and CPM USB controller to Linux USB gadget.  The
> > driver is tested with MPC8360 and MPC8272, and should work with
> > other models having QE/CPM given minor tweaks.
> 
> Looks pretty good, just a few comments on the driver:
>   
> > +config USB_GADGET_FSL_QE
> > +	boolean "Freescale QE/CPM USB Device Controller"
> > +	depends on FSL_SOC && (QUICC_ENGINE || CPM)
> > +	help
> > +	   Some of Freescale PowerPC processors have a Full Speed
> > +	   QE/CPM2 USB controller, which support device mode with 4
> > +	   programmable endpoints. This driver supports the
> > +	   controller in the MPC8360 and MPC8272, and should work with
> > +	   controllers having QE or CPM2, given minor tweaks.
> > +
> > +	   Say "y" to link the driver statically, or "m" to build a
> > +	   dynamically linked module called "fsl_qe_udc" and force all
> > +	   gadget drivers to also be dynamically linked.
> > +
> > +config USB_FSL_QE
> > +	tristate
> > +	depends on USB_GADGET_FSL_QE
> > +	default USB_GADGET
> > +	select USB_GADGET_SELECTED
> 
> 
> Why do you need the two config options, not just one?

This is common for udc drivers.  I guess this measure is used to make
the selection of udc drivers a choice list while still make it possible
to compiled as module.

> 
> > +#ifdef CONFIG_CPM2
> > +#include <asm/cpm.h>
> > +
> > +#define qe_muram_addr cpm_muram_addr
> > +#define qe_muram_offset cpm_muram_offset
> > +#define qe_muram_alloc cpm_muram_alloc
> > +#define qe_muram_free cpm_muram_free
> > +#endif
> ...
> > +static int qe_ep_cmd_restarttx(struct qe_ep *ep)
> > +{
> > +	u8 ep_num;
> > +#ifdef CONFIG_CPM2
> > +	u32 command;
> > +	u8 opcode;
> > +
> > +	ep_num = ep->epnum << CPM_USB_EP_SHIFT;
> > +	command = CPM_USB_RESTART_TX | (u32)ep_num;
> > +	opcode = CPM_USB_RESTART_TX_OPCODE;
> > +	cpm_command(command, opcode);
> > +#else
> > +	ep_num = ep->epnum;
> > +	qe_issue_cmd(QE_USB_RESTART_TX, QE_CR_SUBBLOCK_USB, ep_num, 0);
> > +#endif
> > +	return 0;
> > +}
> 
> This part doesn't look good, you should try to avoid hardcoding
> the specific type of chip (QE or CPM2) here. AFAICT, you can build
> a multiplatform kernel that supports both QE and CPM2, but your code
> here would be broken in that case if you try to run it on QE.

Ok.

> 
> > +static void setup_received_handle(struct qe_udc *udc,
> > +					struct usb_ctrlrequest *setup);
> > +static int qe_ep_rxframe_handle(struct qe_ep *ep);
> > +static void ep0_req_complete(struct qe_udc *udc, struct qe_req *req);
> 
> Better try to avoid static forward declarations by reordering your
> functions in call order. That is the common coding style and makes
> drivers easier to read when you're used to it.
> 
> > +
> > +	tasklet_schedule(&udc->rx_tasklet);
> 
> Not a problem, but an observation: Most new code uses work queues instead
> of tasklets these days, which gives you more predictable real time
> latencies.
> If you don't have a specific reason to prefer a tasklet, just use
> a workqueue here.

Is this truly a trend?  Work queue is more flexible but it has higher
latency.  Why are work queues preferred?

- Leo


