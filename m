Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbYLXTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbYLXTLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 14:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYLXTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 14:11:26 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:50710 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbYLXTLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:11:25 -0500
Date: Wed, 24 Dec 2008 22:11:23 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: greg@kroah.com, dbrownell@users.sourceforge.net, timur@freescale.com,
       leoli@freescale.com, linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Driver for Freescale QUICC Engine USB Host
	Controller
Message-ID: <20081224191123.GA16966@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru> <20081223132840.55e7b666.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081223132840.55e7b666.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 01:28:40PM -0800, Andrew Morton wrote:
> On Wed, 24 Dec 2008 00:03:22 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This patch adds support for the FHCI USB controller, as found
> > in the Freescale MPC836x and MPC832x processors. It can support
> > Full or Low speed modes.
> > 
> > Quite a lot the hardware is doing by itself (SOF generation, CRC
> > generation and checking), though scheduling and retransmission is on
> > software's shoulders.
> > 
> > This controller does not integrate the root hub, so this driver also
> > fakes one-port hub. External hub is required to support more than
> > one device.
> > 
> 
> <quick scan>
> 
> Nice-looking driver.  But the namespace pollution is tremendous!

Thanks for the review, Andrew.

Name-space pollution fixed.

[..]
> > +static int fhci_mem_init(struct fhci_hcd *fhci)
> > +{
> > +	int i;
> > +	int error = 0;
> > +
> > +	fhci->hc_list = kzalloc(sizeof(*fhci->hc_list), GFP_KERNEL);
> > +	if (!fhci->hc_list)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&fhci->hc_list->ctrl_list);
> > +	INIT_LIST_HEAD(&fhci->hc_list->bulk_list);
> > +	INIT_LIST_HEAD(&fhci->hc_list->iso_list);
> > +	INIT_LIST_HEAD(&fhci->hc_list->intr_list);
> > +	INIT_LIST_HEAD(&fhci->hc_list->done_list);
> > +
> > +	fhci->vroot_hub = kzalloc(sizeof(*fhci->vroot_hub), GFP_KERNEL);
> > +	if (!fhci->vroot_hub)
> > +		return -ENOMEM;
> 
> Did we leak fhci->hc_list?

Apparently. Fixed.

[...]
> > +struct ed *get_empty_ed(struct fhci_hcd *fhci)
> > +{
> > +	struct ed *ed;
> > +
> > +	if (!list_empty(&fhci->empty_eds)) {
> > +		ed = list_entry(fhci->empty_eds.next, struct ed, node);
> > +		list_del(fhci->empty_eds.next);
> > +	} else {
> > +		ed = kmalloc(sizeof(*ed), GFP_ATOMIC);
> > +		if (!ed)
> > +			fhci_err(fhci, "No memory to allocate to ED\n");
> > +		else
> > +			init_ed(ed);
> > +	}
> > +
> > +	return ed;
> > +}
> 
> The GFP_ATOMICs here are regrettable.  Are these functions ever called
> from a context in which a more reliable allocation mode can be used?
> If so, the caller should pass in the gfp_t.

No, these are called with a spinlock held. But we don't normally
allocate things via this function, instead we pre-allocate the eds
and tds in the fhci_mem_init, so the kmalloc above is the last resort
when no empty tds/eds left in the appropriate lists (normally should
not happen).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
