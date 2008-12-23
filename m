Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYLWVnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYLWVnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYLWVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:43:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYLWVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:43:04 -0500
Date: Tue, 23 Dec 2008 13:28:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: greg@kroah.com, dbrownell@users.sourceforge.net, timur@freescale.com,
       leoli@freescale.com, linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Driver for Freescale QUICC Engine USB Host
 Controller
Message-Id: <20081223132840.55e7b666.akpm@linux-foundation.org>
In-Reply-To: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 00:03:22 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch adds support for the FHCI USB controller, as found
> in the Freescale MPC836x and MPC832x processors. It can support
> Full or Low speed modes.
> 
> Quite a lot the hardware is doing by itself (SOF generation, CRC
> generation and checking), though scheduling and retransmission is on
> software's shoulders.
> 
> This controller does not integrate the root hub, so this driver also
> fakes one-port hub. External hub is required to support more than
> one device.
> 

<quick scan>

Nice-looking driver.  But the namespace pollution is tremendous!

>
> ...
>
> +static int fhci_mem_init(struct fhci_hcd *fhci)
> +{
> +	int i;
> +	int error = 0;
> +
> +	fhci->hc_list = kzalloc(sizeof(*fhci->hc_list), GFP_KERNEL);
> +	if (!fhci->hc_list)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&fhci->hc_list->ctrl_list);
> +	INIT_LIST_HEAD(&fhci->hc_list->bulk_list);
> +	INIT_LIST_HEAD(&fhci->hc_list->iso_list);
> +	INIT_LIST_HEAD(&fhci->hc_list->intr_list);
> +	INIT_LIST_HEAD(&fhci->hc_list->done_list);
> +
> +	fhci->vroot_hub = kzalloc(sizeof(*fhci->vroot_hub), GFP_KERNEL);
> +	if (!fhci->vroot_hub)
> +		return -ENOMEM;

Did we leak fhci->hc_list?

> +	INIT_LIST_HEAD(&fhci->empty_eds);
> +	INIT_LIST_HEAD(&fhci->empty_tds);
> +
> +	/* initialize work queue to handle done list */
> +	fhci_tasklet.data = (unsigned long)fhci;
> +	fhci->process_done_task = &fhci_tasklet;
> +
> +	for (i = 0; i < MAX_TDS; i++) {
> +		struct td *td = kmalloc(sizeof(*td), GFP_KERNEL);
> +
> +		if (!td) {
> +			error = 1;
> +			break;
> +		}
> +		recycle_empty_td(fhci, td);
> +	}
> +	for (i = 0; i < MAX_EDS; i++) {
> +		struct ed *ed = kmalloc(sizeof(*ed), GFP_KERNEL);
> +
> +		if (!ed) {
> +			error = 1;
> +			break;
> +		}
> +		recycle_empty_ed(fhci, ed);
> +	}
> +
> +	if (error) {
> +		fhci_mem_free(fhci);
> +		return -ENOMEM;
> +	}
> +
> +	fhci->active_urbs = 0;
> +
> +	return error;
> +}
> +
>
> ...
>
> +void config_transceiver(struct fhci_hcd *fhci, enum fhci_port_status status)

poorly-chosen global identifier.

> +{
> +	fhci_dbg(fhci, "-> %s: %d\n", __func__, status);
> +
> +	switch (status) {
> +	case FHCI_PORT_POWER_OFF:
> +		fhci_gpio_set_value(fhci, GPIO_POWER, false);
> +		break;
> +	case FHCI_PORT_DISABLED:
> +	case FHCI_PORT_WAITING:
> +		fhci_gpio_set_value(fhci, GPIO_POWER, true);
> +		break;
> +	case FHCI_PORT_LOW:
> +		fhci_gpio_set_value(fhci, GPIO_SPEED, false);
> +		break;
> +	case FHCI_PORT_FULL:
> +		fhci_gpio_set_value(fhci, GPIO_SPEED, true);
> +		break;
> +	default:
> +		WARN_ON(1);
> +		break;
> +	}
> +
> +	fhci_dbg(fhci, "<- %s: %d\n", __func__, status);
> +}
> +
> +/* disable the USB port by clearing the EN bit in the USBMOD register */
> +void usb_port_disable(struct fhci_hcd *fhci)

another 

> +{
> +	struct fhci_usb *usb = (struct fhci_usb *)fhci->usb_lld;
> +	enum fhci_port_status port_status;
> +
> +	fhci_dbg(fhci, "-> %s\n", __func__);
> +
> +	fhci_stop_sof_timer(fhci);
> +
> +	flush_all_transmissions(usb);
> +
> +	fhci_usb_disable_interrupt((struct fhci_usb *)fhci->usb_lld);
> +	port_status = usb->port_status;
> +	usb->port_status = FHCI_PORT_DISABLED;
> +
> +	/* Enable IDLE since we want to know if something comes along */
> +	usb->saved_msk |= USB_E_IDLE_MASK;
> +	out_be16(&usb->fhci->regs->usb_mask, usb->saved_msk);
> +
> +	/* check if during the disconnection process attached new device */
> +	if (port_status == FHCI_PORT_WAITING)
> +		device_connected_interrupt(fhci);
> +	usb->vroot_hub->port.wPortStatus &= ~USB_PORT_STAT_ENABLE;
> +	usb->vroot_hub->port.wPortChange |= USB_PORT_STAT_C_ENABLE;
> +	fhci_usb_enable_interrupt((struct fhci_usb *)fhci->usb_lld);
> +
> +	fhci_dbg(fhci, "<- %s\n", __func__);
> +}
> +
> +/* enable the USB port by setting the EN bit in the USBMOD register */
> +void usb_port_enable(void *lld)

another.  Please review all non-static symbols which this driver adds.

> +{
> +	struct fhci_usb *usb = (struct fhci_usb *)lld;
> +	struct fhci_hcd *fhci = usb->fhci;
> +
> +	fhci_dbg(fhci, "-> %s\n", __func__);
> +
> +	config_transceiver(fhci, usb->port_status);
> +
> +	if ((usb->port_status != FHCI_PORT_FULL) &&
> +			(usb->port_status != FHCI_PORT_LOW))
> +		fhci_start_sof_timer(fhci);
> +
> +	usb->vroot_hub->port.wPortStatus |= USB_PORT_STAT_ENABLE;
> +	usb->vroot_hub->port.wPortChange |= USB_PORT_STAT_C_ENABLE;
> +
> +	fhci_dbg(fhci, "<- %s\n", __func__);
> +}
> +
>
> ...
>
> +static struct td *get_empty_td(struct fhci_hcd *fhci)
> +{
> +	struct td *td;
> +
> +	if (!list_empty(&fhci->empty_tds)) {
> +		td = list_entry(fhci->empty_tds.next, struct td, node);
> +		list_del(fhci->empty_tds.next);
> +	} else {
> +		td = kmalloc(sizeof(*td), GFP_ATOMIC);
> +		if (!td)
> +			fhci_err(fhci, "No memory to allocate to TD\n");
> +		else
> +			init_td(td);
> +	}
> +
> +	return td;
> +}
> +
> +void recycle_empty_td(struct fhci_hcd *fhci, struct td *td)
> +{
> +	init_td(td);
> +	list_add(&td->node, &fhci->empty_tds);
> +}
> +
> +struct ed *get_empty_ed(struct fhci_hcd *fhci)
> +{
> +	struct ed *ed;
> +
> +	if (!list_empty(&fhci->empty_eds)) {
> +		ed = list_entry(fhci->empty_eds.next, struct ed, node);
> +		list_del(fhci->empty_eds.next);
> +	} else {
> +		ed = kmalloc(sizeof(*ed), GFP_ATOMIC);
> +		if (!ed)
> +			fhci_err(fhci, "No memory to allocate to ED\n");
> +		else
> +			init_ed(ed);
> +	}
> +
> +	return ed;
> +}

The GFP_ATOMICs here are regrettable.  Are these functions ever called
from a context in which a more reliable allocation mode can be used? 
If so, the caller should pass in the gfp_t.

>
> ...
>
> +u32 create_endpoint(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
> +			   u32 ring_len)

This is a poorly chosen global identifier.  fhci_create_endpoint()
would be better.


