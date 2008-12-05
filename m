Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYLESfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYLESfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYLESfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:35:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYLESfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:35:31 -0500
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <493947EB.3050404@gmail.com>
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>
	 <4938EE0B.8020501@msgid.tls.msk.ru>  <493929D2.4070900@gmail.com>
	 <1228488921.3858.25.camel@blaa>  <493947EB.3050404@gmail.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 18:33:55 +0000
Message-Id: <1228502036.3858.53.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 16:25 +0100, Jiri Slaby wrote:
> Mark McLoughlin wrote:
> >> Fix the virtio bus instead.
> > 
> > Yeah, the patch I posted wasn't meant as a fix for this traceback.
> 
> So what's the module_get patch needed for?

A misguided attempt to create an artificial dependency between virtio
device drivers and the virtio bus implementation?

> > Here's one that does fix it.
> ...
> > From: Mark McLoughlin <markmc@redhat.com>
> > Subject: [PATCH] virtio: add device release() function
> > 
> > Add a release() function for virtio_pci devices so as to avoid:
> > 
> >   Device 'virtio0' does not have a release() function, it is broken and must be fixed
> > 
> > The struct device is embedded in the struct virtio_pci_device which
> > is freed by virtio_pci_remove(), so virtio_pci_release_dev() need
> > not actually do anything.
> > 
> > Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> > ---
> >  drivers/virtio/virtio_pci.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > index c7dc37c..7d4899c 100644
> > --- a/drivers/virtio/virtio_pci.c
> > +++ b/drivers/virtio/virtio_pci.c
> > @@ -70,12 +70,17 @@ static struct pci_device_id virtio_pci_id_table[] = {
> >  
> >  MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
> >  
> > +static void virtio_pci_release_dev(struct device *dev)
> > +{
> > +}
> 
> You have to have a strong reason to have empty release. This is not the
> case, you should do the free here, not in remove, I suppose.

Okay, see the other patch I just sent.

> > @@ -328,6 +333,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
> >  		return -ENOMEM;
> >  
> >  	vp_dev->vdev.dev.parent = &virtio_pci_root;
> > +	vp_dev->vdev.dev.release = virtio_pci_release_dev;
> 
> This should rather be in register_virtio_device

Why? Because dev.release should be set by the same place that does
device_register() or ...?

The resources being allocated here are virtio-pci specific, so if we
wanted to do something like this we'd perhaps need to add a ->release()
to struct virtio_device and just call that hook.

Cheers,
Mark.

