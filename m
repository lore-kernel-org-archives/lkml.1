Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXH2Qhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXH2Qhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXH2Qhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:37:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:35083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbXH2Qhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dPI+nY5PGjIzwRtUdAhDgeQBf1YOXNOKUdshMcKvQUj5Ef2r1/ub/HzVX0rvsKI2/blSIt4RQwSTyg5QtMz0Borz2kuJpMaCPeGGvlDAMChyTi/d+GlzPBcE3cltTbdmEgFUFa/k52jRMFkUaQIzwBZjj97HxAuj4xBNofauk1w=
Message-ID: <f158dc670708290937p73188b2aq12903c6f1c65a276@mail.gmail.com>
Date: Wed, 29 Aug 2007 10:37:31 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Anthony Liguori" <anthony@codemonkey.ws>
Subject: Re: [V9fs-developer] [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Cc: "Eric Van Hensbergen" <ericvh@gmail.com>, kvm-devel@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1188404984.13140.6.camel@squirrel>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11883271601857-git-send-email-ericvh@gmail.com>
	 <11883271601227-git-send-email-ericvh@gmail.com>
	 <11883271602233-git-send-email-ericvh@gmail.com>
	 <1188404984.13140.6.camel@squirrel>
X-Google-Sender-Auth: fa6642fd0163ea7f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That's also in our plans. There was no virtio support in KVM when I
started working in the transport.

Thanks,
    Lucho

On 8/29/07, Anthony Liguori <anthony@codemonkey.ws> wrote:
> I think that it would be nicer to implement the p9 transport on top of
> virtio instead of directly on top of PCI.  I think your PCI transport
> would make a pretty nice start of a PCI virtio transport though.
>
> Regards,
>
> Anthony Liguori
>
> On Tue, 2007-08-28 at 13:52 -0500, Eric Van Hensbergen wrote:
> > From: Latchesar Ionkov <lucho@ionkov.net>
> >
> > This adds a shared memory transport for a synthetic 9p device for
> > paravirtualized file system support under KVM/QEMU.
> >
> > Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
> > Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
> > ---
> >  Documentation/filesystems/9p.txt |    2 +
> >  net/9p/Kconfig                   |   10 ++-
> >  net/9p/Makefile                  |    4 +
> >  net/9p/trans_pci.c               |  295 ++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 310 insertions(+), 1 deletions(-)
> >  create mode 100644 net/9p/trans_pci.c
> >
> > diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
> > index 1a5f50d..e1879bd 100644
> > --- a/Documentation/filesystems/9p.txt
> > +++ b/Documentation/filesystems/9p.txt
> > @@ -46,6 +46,8 @@ OPTIONS
> >                       tcp  - specifying a normal TCP/IP connection
> >                       fd   - used passed file descriptors for connection
> >                                  (see rfdno and wfdno)
> > +                     pci  - use a PCI pseudo device for 9p communication
> > +                             over shared memory between a guest and host
> >
> >    uname=name user name to attempt mount as on the remote server.  The
> >               server may override or ignore this value.  Certain user
> > diff --git a/net/9p/Kconfig b/net/9p/Kconfig
> > index 09566ae..8517560 100644
> > --- a/net/9p/Kconfig
> > +++ b/net/9p/Kconfig
> > @@ -16,13 +16,21 @@ menuconfig NET_9P
> >  config NET_9P_FD
> >       depends on NET_9P
> >       default y if NET_9P
> > -     tristate "9P File Descriptor Transports (Experimental)"
> > +     tristate "9p File Descriptor Transports (Experimental)"
> >       help
> >         This builds support for file descriptor transports for 9p
> >         which includes support for TCP/IP, named pipes, or passed
> >         file descriptors.  TCP/IP is the default transport for 9p,
> >         so if you are going to use 9p, you'll likely want this.
> >
> > +config NET_9P_PCI
> > +     depends on NET_9P
> > +     tristate "9p PCI Shared Memory Transport (Experimental)"
> > +     help
> > +       This builds support for a PCI psuedo-device currently available
> > +       under KVM/QEMU which allows for 9p transactions over shared
> > +       memory between the guest and the host.
> > +
> >  config NET_9P_DEBUG
> >       bool "Debug information"
> >       depends on NET_9P
> > diff --git a/net/9p/Makefile b/net/9p/Makefile
> > index 7b2a67a..26ce89d 100644
> > --- a/net/9p/Makefile
> > +++ b/net/9p/Makefile
> > @@ -1,5 +1,6 @@
> >  obj-$(CONFIG_NET_9P) := 9pnet.o
> >  obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
> > +obj-$(CONFIG_NET_9P_PCI) += 9pnet_pci.o
> >
> >  9pnet-objs := \
> >       mod.o \
> > @@ -14,3 +15,6 @@ obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
> >
> >  9pnet_fd-objs := \
> >       trans_fd.o \
> > +
> > +9pnet_pci-objs := \
> > +     trans_pci.o \
> > diff --git a/net/9p/trans_pci.c b/net/9p/trans_pci.c
> > new file mode 100644
> > index 0000000..36ddc5f
> > --- /dev/null
> > +++ b/net/9p/trans_pci.c
> > @@ -0,0 +1,295 @@
> > +/*
> > + * net/9p/trans_pci.c
> > + *
> > + * 9P over PCI transport layer. For use with KVM/QEMU.
> > + *
> > + *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License version 2
> > + *  as published by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License
> > + *  along with this program; if not, write to:
> > + *  Free Software Foundation
> > + *  51 Franklin Street, Fifth Floor
> > + *  Boston, MA  02111-1301  USA
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/compiler.h>
> > +#include <linux/pci.h>
> > +#include <linux/init.h>
> > +#include <linux/ioport.h>
> > +#include <linux/completion.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/irq.h>
> > +#include <linux/poll.h>
> > +#include <net/9p/9p.h>
> > +#include <net/9p/transport.h>
> > +
> > +#define P9PCI_DRIVER_NAME "9P PCI Device"
> > +#define P9PCI_DRIVER_VERSION "1"
> > +
> > +#define PCI_VENDOR_ID_9P     0x5002
> > +#define PCI_DEVICE_ID_9P     0x000D
> > +
> > +#define MAX_PCI_BUF          (4*1024) /* TODO: Get a number from lucho */
> > +
> > +struct p9pci_trans {
> > +     struct pci_dev          *pdev;
> > +     void __iomem            *ioaddr;
> > +     void __iomem            *tx;
> > +     void __iomem            *rx;
> > +     int                     irq;
> > +     int                     pos;
> > +     int                     len;
> > +     wait_queue_head_t       wait;
> > +};
> > +static struct p9pci_trans *p9pci_trans; /* single channel for now */
> > +
> > +static struct pci_device_id p9pci_tbl[] = {
> > +     {PCI_VENDOR_ID_9P, PCI_DEVICE_ID_9P, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> > +     {0,}
> > +};
> > +
> > +static irqreturn_t p9pci_interrupt(int irq, void *dev)
> > +{
> > +     p9pci_trans = dev;
> > +     p9pci_trans->len = le32_to_cpu(readl(p9pci_trans->rx));
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "%p len %d\n", p9pci_trans->pdev,
> > +                                                     p9pci_trans->len);
> > +     iowrite32(0, p9pci_trans->ioaddr + 4);
> > +     wake_up_interruptible(&p9pci_trans->wait);
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int p9pci_read(struct p9_trans *trans, void *v, int len)
> > +{
> > +     struct p9pci_trans *ts;
> > +
> > +     if (!trans || trans->status == Disconnected || !trans->priv)
> > +             return -EREMOTEIO;
> > +
> > +     ts = trans->priv;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> > +                                             trans, ts->rx, ts->tx, v, len);
> > +     if (len > ts->len)
> > +             len = ts->len;
> > +
> > +     if (len) {
> > +             memcpy_fromio(v, ts->rx, len);
> > +             ts->len = 0;
> > +             /* let the host knows the message is consumed */
> > +             writel(0, ts->rx);
> > +             iowrite32(0, p9pci_trans->ioaddr + 4);
> > +             P9_DPRINTK(P9_DEBUG_TRANS, "zero rxlen %d txlen %d\n",
> > +                                             readl(ts->rx), readl(ts->tx));
> > +     }
> > +
> > +     return len;
> > +}
> > +
> > +static int p9pci_write(struct p9_trans *trans, void *v, int len)
> > +{
> > +     struct p9pci_trans *ts;
> > +
> > +     if (!trans || trans->status == Disconnected || !trans->priv)
> > +             return -EREMOTEIO;
> > +
> > +     ts = trans->priv;
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> > +                                             trans, ts->rx, ts->tx, v, len);
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "rxlen %d\n", readl(ts->rx));
> > +     if (readb(ts->tx) != 0)
> > +             return 0;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "tx addr %p io addr %p\n", ts->tx,
> > +                                                             ts->ioaddr);
> > +     memcpy_toio(ts->tx, v, len);
> > +     iowrite32(len, ts->ioaddr);
> > +     return len;
> > +}
> > +
> > +static unsigned int
> > +p9pci_poll(struct p9_trans *trans, struct poll_table_struct *pt)
> > +{
> > +     int ret;
> > +     struct p9pci_trans *ts;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p\n", trans);
> > +     if (!trans || trans->status != Connected || !trans->priv)
> > +             return -EREMOTEIO;
> > +
> > +     ts = trans->priv;
> > +     poll_wait(NULL, &ts->wait, pt);
> > +     ret = 0;
> > +     if (!readl(ts->tx))
> > +             ret |= POLLOUT;
> > +     if (readl(ts->rx))
> > +             ret |= POLLIN;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "txlen %d rxlen %d\n", readl(ts->tx),
> > +                                                             readl(ts->rx));
> > +     return ret;
> > +}
> > +
> > +/**
> > + * p9_sock_close - shutdown socket
> > + * @trans: private socket structure
> > + *
> > + */
> > +static void p9pci_close(struct p9_trans *trans)
> > +{
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p\n", trans);
> > +}
> > +
> > +static struct p9_trans *p9pci_trans_create(const char *name, char *arg)
> > +{
> > +     struct p9_trans *trans;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "\n");
> > +     trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
> > +     if (!trans)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     trans->status = Connected;
> > +     trans->write = p9pci_write;
> > +     trans->read = p9pci_read;
> > +     trans->close = p9pci_close;
> > +     trans->poll = p9pci_poll;
> > +     trans->priv = p9pci_trans;
> > +     writel(0, p9pci_trans->tx);
> > +     writel(0, p9pci_trans->rx);
> > +
> > +     return trans;
> > +}
> > +
> > +static int __devinit p9pci_probe(struct pci_dev *pdev,
> > +             const struct pci_device_id *ent)
> > +{
> > +     int err;
> > +     u8 pci_rev;
> > +
> > +     if (p9pci_trans)
> > +             return -1;
> > +
> > +     pci_read_config_byte(pdev, PCI_REVISION_ID, &pci_rev);
> > +
> > +     if (pdev->vendor == PCI_VENDOR_ID_9P &&
> > +         pdev->device == PCI_DEVICE_ID_9P)
> > +             printk(KERN_INFO "pci dev %s (id %04x:%04x rev %02x) is a 9P\n",
> > +                    pci_name(pdev), pdev->vendor, pdev->device, pci_rev);
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "%p\n", pdev);
> > +     p9pci_trans = kzalloc(sizeof(*p9pci_trans), GFP_KERNEL);
> > +     p9pci_trans->irq = -1;
> > +     init_waitqueue_head(&p9pci_trans->wait);
> > +     err = pci_enable_device(pdev);
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->pdev = pdev;
> > +     err = pci_request_regions(pdev, "9p");
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->ioaddr = pci_iomap(pdev, 0, 8);
> > +     if (!p9pci_trans->ioaddr) {
> > +             P9_DPRINTK(P9_DEBUG_ERROR, "Cannot remap MMIO, aborting\n");
> > +             err = -EIO;
> > +             goto error;
> > +     }
> > +
> > +     p9pci_trans->tx = pci_iomap(pdev, 1, 0x20000);
> > +     p9pci_trans->rx = pci_iomap(pdev, 2, 0x20000);
> > +     pci_set_drvdata(pdev, p9pci_trans);
> > +     err = request_irq(pdev->irq, &p9pci_interrupt, 0, "p9pci", p9pci_trans);
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->irq = pdev->irq;
> > +     return 0;
> > +
> > +error:
> > +     P9_DPRINTK(P9_DEBUG_ERROR, "error %d\n", err);
> > +     if (p9pci_trans->irq >= 0) {
> > +             synchronize_irq(p9pci_trans->irq);
> > +             free_irq(p9pci_trans->irq, p9pci_trans);
> > +     }
> > +
> > +     if (p9pci_trans->pdev) {
> > +             pci_release_regions(pdev);
> > +             pci_iounmap(pdev, p9pci_trans->ioaddr);
> > +             pci_set_drvdata(pdev, NULL);
> > +             pci_disable_device(pdev);
> > +     }
> > +
> > +     kfree(p9pci_trans);
> > +     return -1;
> > +}
> > +
> > +static void __devexit p9pci_remove(struct pci_dev *pdev)
> > +{
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "%p\n", pdev);
> > +     p9pci_trans = pci_get_drvdata(pdev);
> > +     if (!p9pci_trans)
> > +             return;
> > +
> > +     if (p9pci_trans->irq) {
> > +             synchronize_irq(p9pci_trans->irq);
> > +             free_irq(p9pci_trans->irq, p9pci_trans);
> > +     }
> > +
> > +     pci_release_regions(pdev);
> > +     pci_iounmap(pdev, p9pci_trans->ioaddr);
> > +     pci_set_drvdata(pdev, NULL);
> > +     kfree(p9pci_trans);
> > +     pci_disable_device(pdev);
> > +}
> > +
> > +static struct pci_driver p9pci_driver = {
> > +     .name           = P9PCI_DRIVER_NAME,
> > +     .id_table       = p9pci_tbl,
> > +     .probe          = p9pci_probe,
> > +     .remove         = __devexit_p(p9pci_remove),
> > +};
> > +
> > +static struct p9_trans_module p9_pci_trans = {
> > +     .name = "pci",
> > +     .maxsize = MAX_PCI_BUF,
> > +     .def = 0,
> > +     .create = p9pci_trans_create,
> > +};
> > +
> > +static int __init p9pci_init_module(void)
> > +{
> > +     v9fs_register_trans(&p9_pci_trans);
> > +     return pci_register_driver(&p9pci_driver);
> > +}
> > +
> > +static void __exit p9pci_cleanup_module(void)
> > +{
> > +     pci_unregister_driver(&p9pci_driver);
> > +     printk(KERN_ERR "Removal of 9p transports not implemented\n");
> > +     BUG();
> > +}
> > +
> > +module_init(p9pci_init_module);
> > +module_exit(p9pci_cleanup_module);
> > +
> > +MODULE_DEVICE_TABLE(pci, p9pci_tbl);
> > +MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
> > +MODULE_DESCRIPTION(P9PCI_DRIVER_NAME);
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION(P9PCI_DRIVER_VERSION);
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
