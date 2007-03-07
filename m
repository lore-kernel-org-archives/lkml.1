Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXCGQvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXCGQvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXCGQvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:51:53 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:41150 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbXCGQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:51:52 -0500
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 11:51:51 EST
Message-ID: <45EEEAA3.50009@gmail.com>
Date: Wed, 07 Mar 2007 17:38:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Input: add sensable phantom driver
References: <2460126662758025813@fi.muni.cz> <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com>
In-Reply-To: <d120d5000703070647t223f8858i8c495dcc3e1378a2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 07 Mar 2007 17:40:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> Hi Jiri,

Hi.

> On 3/7/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> add sensable phantom driver
> ...
> 
> General question - can this driver use force-feedback mecahnisms
> already present in kernel instead of exporting raw datastream to
> userspace. What are shortcomings of kernels force-feedback
> implemenattion that make it insufficient for phantom?

I didn't even think about it, sorry. Does any problem with rate about 2kHz come 
on your mind before I'll try to rewrite it?

>> +#define phantom_remap(io, vma, addr)   ({                              \
>> +       vma->vm_pgoff = (addr) >> PAGE_SHIFT;                           \
>> +       io ## remap_pfn_range(vma, (vma)->vm_start, (vma)->vm_pgoff,    \
>> +               (vma)->vm_end - (vma)->vm_start, (vma)->vm_page_prot);  \
>> +})
>> +
>> +static int phantom_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +       struct phantom_device *dev = file->private_data;
>> +       int retval;
>> +
>> +       switch (vma->vm_pgoff) {
>> +       case 0:
>> +               retval = phantom_remap(, vma, virt_to_phys(dev->stat));
> 
> This really hurts my eyes. Is there any reason for using the macro here?

Not necessarilly. (It remained here from times, when this driver was not 
intended to be merged, since rtc workaround. Now we have a source of the 2.4 
driver.). Anyway, if the ff layer was used, I'll get the whole mmap away.

>> +               break;
>> +       case 1:
>> +               retval = phantom_remap(io_, vma, dev->ibase);
>> +               break;
>> +       default:
>> +               retval = phantom_remap(io_, vma, dev->obase);
>> +       }
>> +
>> +       return retval ? -EINVAL : 0;
>> +}
>> +
>> +
>> +static int __devinit phantom_probe(struct pci_dev *pdev,
>> +       const struct pci_device_id *pci_id)
>> +{
>> +       struct phantom_device *pht;
>> +       unsigned int minor;
>> +       int retval;
>> +
>> +       retval = pci_enable_device(pdev);
>> +       if (retval)
>> +               goto err;
>> +
>> +       minor = phantom_get_free();
>> +       if (minor == PHANTOM_MAX_MINORS) {
>> +               dev_err(&pdev->dev, "too many devices found!\n");
>> +               retval = -EIO;
>> +               goto err;
>> +       }
>> +
>> +       phantom_devices[minor] = 1;
> 
> Locking? In face of multithreaded PCI probes it might be needed.

I think, this is the same issue?

<cite from="akpm" date="12/19/06">
On Sat, 16 Dec 2006 02:09:48 +0100 (CET)
Jiri Slaby <jirislaby@gmail.com> wrote:

 > isicom, fix probe race
 >
 > Fix two race conditions in the probe function with mutex.
 >
 > ...
 >
 >  static int __devinit isicom_probe(struct pci_dev *pdev,
 >       const struct pci_device_id *ent)
 >  {
 > +     static DEFINE_MUTEX(probe_lock);

hm.  How can isicom_probe() race with itself?  Even with the dreaded
multithreaded-pci-probing?  It's only called once, by a single thread.

Confused.
</cite>

What do you think? Greg?

>> +
>> +       retval = pci_request_regions(pdev, "phantom");
>> +       if (retval)
>> +               goto err_null;
>> +
>> +       retval = -ENOMEM;
>> +       pht = kzalloc(sizeof(*pht), GFP_KERNEL);
>> +       if (pht == NULL) {
>> +               dev_err(&pdev->dev, "unable to allocate device\n");
>> +               goto err_reg;
>> +       }
>> +
>> +       pht->stat = (void *)__get_free_page(GFP_KERNEL | __GFP_WAIT);
>> +       if (pht->stat == NULL)
>> +               goto err_fr;
>> +
>> +       pht->caddr = pci_iomap(pdev, 0, 0);
>> +       if (pht->caddr == NULL) {
>> +               dev_err(&pdev->dev, "can't remap conf space\n");
>> +               goto err_frp;
>> +       }
>> +       pht->ibase = pci_resource_start(pdev, 2);
>> +       pht->obase = pci_resource_start(pdev, 3);
>> +
>> +       mutex_init(&pht->open_lock);
>> +       init_waitqueue_head(&pht->wait);
>> +
>> +       phantom_write_cfgl(pht, 0, PHN_IRQCTL);
>> +       retval = request_irq(pdev->irq, phantom_isr,
>> +                       IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
>> +       if (retval) {
>> +               dev_err(&pdev->dev, "can't establish ISR\n");
>> +               goto err_unm;
>> +       }
>> +
>> +       cdev_init(&pht->cdev, &phantom_file_ops);
>> +       pht->cdev.owner = THIS_MODULE;
>> +       retval = cdev_add(&pht->cdev, MKDEV(phantom_major, minor), 1);
>> +       if (retval) {
>> +               dev_err(&pdev->dev, "chardev registration failed\n");
>> +               goto err_irq;
>> +       }
>> +
>> +       device_create(phantom_class, &pdev->dev, MKDEV(phantom_major, 
>> minor),
>> +                       "phantom%u", minor);
>> +
> 
> Error handling is needed.

Creating of sysfs node is not requisite, isn't it? (But yes, I'll at least spit 
some warning out.)

thanks for comments,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

