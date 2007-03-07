Return-Path: <linux-kernel-owner+w=401wt.eu-S1030659AbXCGOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030659AbXCGOrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030794AbXCGOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:47:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:14568 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030659AbXCGOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R4wh1S1w+jiuN4/coZHDWSRbDlhYcjBQpJ8Ri00A2Md6rKIXWWvzrsFhsriIM9bIi/MFe9W80SaDrO07j5Bw2CSUNFeSUzHw4gDXePyRLJ0e8FrI/mWdzbzuYGCqLATKjnGTJO8dwStMZtCwS0SOqX2FAoCgziBWvJI/uyRdq7E=
Message-ID: <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com>
Date: Wed, 7 Mar 2007 09:47:08 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Input: add sensable phantom driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <2460126662758025813@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 3/7/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> add sensable phantom driver
...

General question - can this driver use force-feedback mecahnisms
already present in kernel instead of exporting raw datastream to
userspace. What are shortcomings of kernels force-feedback
implemenattion that make it insufficient for phantom?

> +
> +#define phantom_remap(io, vma, addr)   ({                              \
> +       vma->vm_pgoff = (addr) >> PAGE_SHIFT;                           \
> +       io ## remap_pfn_range(vma, (vma)->vm_start, (vma)->vm_pgoff,    \
> +               (vma)->vm_end - (vma)->vm_start, (vma)->vm_page_prot);  \
> +})
> +
> +static int phantom_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct phantom_device *dev = file->private_data;
> +       int retval;
> +
> +       switch (vma->vm_pgoff) {
> +       case 0:
> +               retval = phantom_remap(, vma, virt_to_phys(dev->stat));

This really hurts my eyes. Is there any reason for using the macro here?
> +               break;
> +       case 1:
> +               retval = phantom_remap(io_, vma, dev->ibase);
> +               break;
> +       default:
> +               retval = phantom_remap(io_, vma, dev->obase);
> +       }
> +
> +       return retval ? -EINVAL : 0;
> +}
> +
> +
> +static int __devinit phantom_probe(struct pci_dev *pdev,
> +       const struct pci_device_id *pci_id)
> +{
> +       struct phantom_device *pht;
> +       unsigned int minor;
> +       int retval;
> +
> +       retval = pci_enable_device(pdev);
> +       if (retval)
> +               goto err;
> +
> +       minor = phantom_get_free();
> +       if (minor == PHANTOM_MAX_MINORS) {
> +               dev_err(&pdev->dev, "too many devices found!\n");
> +               retval = -EIO;
> +               goto err;
> +       }
> +
> +       phantom_devices[minor] = 1;

Locking? In face of multithreaded PCI probes it might be needed.

> +
> +       retval = pci_request_regions(pdev, "phantom");
> +       if (retval)
> +               goto err_null;
> +
> +       retval = -ENOMEM;
> +       pht = kzalloc(sizeof(*pht), GFP_KERNEL);
> +       if (pht == NULL) {
> +               dev_err(&pdev->dev, "unable to allocate device\n");
> +               goto err_reg;
> +       }
> +
> +       pht->stat = (void *)__get_free_page(GFP_KERNEL | __GFP_WAIT);
> +       if (pht->stat == NULL)
> +               goto err_fr;
> +
> +       pht->caddr = pci_iomap(pdev, 0, 0);
> +       if (pht->caddr == NULL) {
> +               dev_err(&pdev->dev, "can't remap conf space\n");
> +               goto err_frp;
> +       }
> +       pht->ibase = pci_resource_start(pdev, 2);
> +       pht->obase = pci_resource_start(pdev, 3);
> +
> +       mutex_init(&pht->open_lock);
> +       init_waitqueue_head(&pht->wait);
> +
> +       phantom_write_cfgl(pht, 0, PHN_IRQCTL);
> +       retval = request_irq(pdev->irq, phantom_isr,
> +                       IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
> +       if (retval) {
> +               dev_err(&pdev->dev, "can't establish ISR\n");
> +               goto err_unm;
> +       }
> +
> +       cdev_init(&pht->cdev, &phantom_file_ops);
> +       pht->cdev.owner = THIS_MODULE;
> +       retval = cdev_add(&pht->cdev, MKDEV(phantom_major, minor), 1);
> +       if (retval) {
> +               dev_err(&pdev->dev, "chardev registration failed\n");
> +               goto err_irq;
> +       }
> +
> +       device_create(phantom_class, &pdev->dev, MKDEV(phantom_major, minor),
> +                       "phantom%u", minor);
> +

Error handling is needed.

-- 
Dmitry
