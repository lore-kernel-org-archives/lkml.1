Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYLEP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYLEP0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYLEP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:26:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:29226 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYLEPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:25:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=S28n0OBeG8iWezgCeLdjXDcZV6odfkEl8TqMqS/dkiPo2DHtiPy88y0WwQYa4Y9E7c
         UBq1PtfgRDTi3DB2lC5ainm8JMiBUJmqKWjwajygFS8VFJwPWXDX3qPC89r00Lh7uJJS
         U8yIUjHadPk8QoLtLpTlpa7fy1epvIgLVQIJg=
Message-ID: <493947EB.3050404@gmail.com>
Date: Fri, 05 Dec 2008 16:25:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>	 <4938EE0B.8020501@msgid.tls.msk.ru>  <493929D2.4070900@gmail.com> <1228488921.3858.25.camel@blaa>
In-Reply-To: <1228488921.3858.25.camel@blaa>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
>> Fix the virtio bus instead.
> 
> Yeah, the patch I posted wasn't meant as a fix for this traceback.

So what's the module_get patch needed for?

> Here's one that does fix it.
...
> From: Mark McLoughlin <markmc@redhat.com>
> Subject: [PATCH] virtio: add device release() function
> 
> Add a release() function for virtio_pci devices so as to avoid:
> 
>   Device 'virtio0' does not have a release() function, it is broken and must be fixed
> 
> The struct device is embedded in the struct virtio_pci_device which
> is freed by virtio_pci_remove(), so virtio_pci_release_dev() need
> not actually do anything.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> ---
>  drivers/virtio/virtio_pci.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index c7dc37c..7d4899c 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -70,12 +70,17 @@ static struct pci_device_id virtio_pci_id_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
>  
> +static void virtio_pci_release_dev(struct device *dev)
> +{
> +}

You have to have a strong reason to have empty release. This is not the
case, you should do the free here, not in remove, I suppose.

> @@ -328,6 +333,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>  		return -ENOMEM;
>  
>  	vp_dev->vdev.dev.parent = &virtio_pci_root;
> +	vp_dev->vdev.dev.release = virtio_pci_release_dev;

This should rather be in register_virtio_device

