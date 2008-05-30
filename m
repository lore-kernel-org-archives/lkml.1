Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYE3Mxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYE3Mxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 08:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYE3MxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 08:53:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:62085 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYE3MxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 08:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pp42ZIQIRLefKgBm6H9KijBVTew8GWX4wIg4LtoXbeDxK1LSM7RyZO+blzmOQm+1Qa4BVdmVK5jlgPvkIEqJ6yRRgU65WG+kxhpdbHjD8KVTs0Lv54ki8Fio9snN6KH0LCwIFxXYGq2/cuX9QzabublOtGHQ95PYFpLVIXy6MTQ=
Message-ID: <ca0148c30805300552u7eb5da43tfc75127a2e819d1@mail.gmail.com>
Date: Fri, 30 May 2008 15:52:59 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [PATCH v1.2.26] wan: new driver retina
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m3prr6obkz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca0148c30805280342l39ffe387rf4c670b17804f99d@mail.gmail.com>
	 <m3prr6obkz.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/28 Krzysztof Halasa <khc@pm.waw.pl>:
> "Matti Linnanvuori" <mattilinn@gmail.com> writes:
>
>> +/* net device related stuff: */
>> +#define FEPCI_NETDEV_IOCTL_STREAM_BUFSIZE 0x89F1
>> +#define FEPCI_NETDEV_IOCTL_STREAM_UNITSIZE 0x89F2
>> +#define FEPCI_NETDEV_IOCTL_STREAM_OPEN 0x89F3
>> +#define FEPCI_NETDEV_IOCTL_STREAM_START 0x89F4
>> +#define FEPCI_NETDEV_IOCTL_STREAM_CLOSE 0x89F6
>
>  *      THESE IOCTLS ARE _DEPRECATED_ AND WILL DISAPPEAR IN 2.5.X -DaveM
>  */
>
> #define SIOCDEVPRIVATE  0x89F0  /* to 89FF */
>
> They haven't disappered yet but I'd rather use something else.
> Personally, sysfs stuff, unless you need to do it frequently/fast.

I would not like to change a legacy driver much.

>> +#define MAX_DEVICES 32u
>
> Why such artificial limit?

I have removed that.

>> +/* need to update MODULE_PARM also */
>> +#define MAX_INTERFACES (CHANNELS * MAX_DEVICES)
>
> Doesn't seem to be used anywhere.

I have removed that.

>> +#include <asm/pgtable.h>
>
> I'm not sure SetPageReserved() etc. belong to drivers.

I have removed that.

>> +module_param(retina_noarp_with_ptp, bool, S_IRUGO);
>> +MODULE_PARM_DESC(retina_noarp_with_ptp,
>> +              "0 to disable NOARP, 1 to enable NOARP");
>
> Why not use a dynamic setting? ip link set XXX arp on|off?

I have removed that parameter.

>> +     /* Process ID of the current mailbox user (for whom it is reserved) */
>> +     unsigned int ioctl_saved_pid;
>
> Is this PID checking needed at all? It sure creates many problems,
> such as process' death and number wrapping.

I have replaced that with a mutex.

>> +/* global variables (common to whole driver, all the cards): */
>> +static int major;                    /* char device major number */
>> +static struct fepci_card_private card_privates[MAX_DEVICES];
>
> Why not dynamic?

I have made it dynamic.

>> +static int fepci_char_open(struct inode *inode, struct file *filp)
>> +{
>> +     unsigned int minor = MINOR(inode->i_rdev);
>> +     if (unlikely(minor >= find_cnt || card_privates[minor].pci_dev == NULL))
>> +             return -ENXIO;
>> +     filp->f_op = &fepci_char_fops;
>> +     if (unlikely(!try_module_get(THIS_MODULE)))
>> +             return -EBUSY;
>
> That won't work race-free, use owner field.

You mean the f_op assignment? I have removed that.

>> +     if (offset == STREAM_BUFFER_POINTER_AREA) {
>> +             virtual_address = stream_pointers;
>> +             if (virtual_address == 0) {
>> +                     printk(KERN_WARNING "%s: mmap: internal error.\n",
>> +                            fepci_name);
>> +                     return -ENOMEM;
>> +             }
>
> Why not just BUG_ON(!virtual_address)?

I just removed that because it seemed impossible.

>> +             switch (get_semafore(real_mailbox)) {
>> +             case 0x40:
>> +             case 0x20:
>> +             case 0x21:
>> +                     /* copy the mailbox */
>> +                     retval = fepci_copy_from_user(ioaddr +
>> +                                             FEPCI_MAILBOX_OFFSETT + 4,
>> +                                             arg + 2, _IOC_SIZE(cmd) - 2, 1);
>> +                     /* semafore -> 10 */
>> +                     set_semafore(real_mailbox, 0x10);
>> +                     mod_timer(&card_privates[minor].mailbox_timer,
>> +                               jiffies + 20 * HZ);
>> +                     break;
>> +             case 0x10:
>> +             case 0x11:
>> +             case 0x80:
>
> Some comments about real_mailbox values maybe?

I have replaced them with enumerated values.

>> +static ssize_t fepci_char_read(struct file *filp, char __user *buf,
>> +                            size_t count, loff_t *f_pos)
>> +{
>> +     if (count > 1)
>> +             count = 1;
>> +     if (unlikely(copy_to_user(buf, "\n", count)))
>> +             return -EFAULT;
>> +     return count;
>> +}
>
> So why exactly is the above useful?

I have removed that.

>> +static int fepci_stream_open_down(struct net_device *dev,
>> +                               struct fepci_ch_private *fp)
>> +{
>> +     unsigned tx_pages, rx_pages, tx_order, rx_order;
>> +     unsigned page_number;
>> +     unsigned int i;
>> +
>> +     if (unlikely(fp->in_eth_mode)) {
>> +             dev_warn(&dev->dev,
>> +                      "Interface is in Ethernet mode, "
>> +                      "cannot open stream interface\n");
>> +             return -EBUSY;
>> +     }
>
> Some locking maybe? That seems like a great recipe for races.
> I'd check the recent discussions about the big kernel lock too.

Private net device ioctls are locked with rtnl_lock, so I see no race there.

>> +     for (page_number = 0; page_number < rx_pages; page_number++)
>> +             /* make pages reserved to allow remappping pages
>> +                with io_remap_pfn_range */
>> +             SetPageReserved(virt_to_page
>> +                             ((unsigned long)fp->rx_buffer +
>> +                              (page_number << PAGE_SHIFT)));
>> +     for (page_number = 0; page_number < tx_pages; page_number++)
>> +             /* make pages reserved to allow remappping pages
>> +                with io_remap_pfn_range */
>> +             SetPageReserved(virt_to_page
>> +                             ((unsigned long)fp->tx_buffer +
>> +                              (page_number << PAGE_SHIFT)));
>
> Looks dangerous.

I have removed that.

>> +static inline void fepci_stream_stop(struct net_device *dev,
>> +                                  struct fepci_ch_private *fp)
>> +{
>> +     uint8_t __iomem *ioaddr = (uint8_t __iomem *)dev->base_addr;
>> +     fp->stream_on = 0;
>> +     /* Stop Rx and Tx channels. */
>> +     writel(0x0, ioaddr + fp->reg_rxctrl);
>> +     writel(0x0, ioaddr + fp->reg_txctrl);
>> +
>> +     /* Disable interrupts by clearing the interrupt mask. */
>> +     set_int_mask(fp->channel_number, 0x0, fp->this_card_priv);
>> +
>> +     /* unregister irq */
>> +     free_irq(dev->irq, dev);
>> +
>> +     {
>> +             unsigned i = min(RX_RING_SIZE, TX_RING_SIZE) - 1;
>> +             do {
>> +                     if (likely(!pci_dma_mapping_error(
>> +                             pci_unmap_addr(fp->rx + i, address))))
>> +                             pci_unmap_single(fp->this_card_priv->
>> +                                              pci_dev,
>> +                                              pci_unmap_addr(fp->rx + i,
>> +                                                             address),
>> +                                              fp->unit_sz,
>> +                                              PCI_DMA_FROMDEVICE);
>> +                     if (likely(!pci_dma_mapping_error(
>> +                             pci_unmap_addr(fp->tx + i, address))))
>> +                             pci_unmap_single(fp->this_card_priv->
>> +                                              pci_dev,
>> +                                              pci_unmap_addr(fp->tx + i,
>> +                                                             address),
>> +                                              fp->unit_sz, PCI_DMA_TODEVICE);
>> +             } while (i--);
>> +     }
>> +}
>
> If you move this "unsigned i" (or better unsigned v or something as
> "i" is usually used for pure ints) to the start of this function,
> the code will look much better.

I have removed the block.

>> +static int fepci_rebuild_header(struct sk_buff *skb)
>> +{
>> +     return 0;
>> +}
>
> Unneeded?

I have removed that.

>> +static int __devinit fepci_init_one(struct pci_dev *pdev,
>> +                                 const struct pci_device_id *ent)
>> +{
>
>  +      if (PCI_FUNC(pdev->devfn) != 0)
>> +             return -ENXIO;
>
> Don't you plan multi-function cards? :-)

No, I don't. I got some erroneous multi-function values once.

>> +             /* HW_ADDR is got using the mailbox: */
>> +             {
>> +                     struct fepci_real_mailbox __iomem *real_mailbox =
>> +                             (struct fepci_real_mailbox __iomem *)
>> +                             (ioaddr + FEPCI_MAILBOX_OFFSETT);
>
> Same comment about moving variable to the start (of the parent block
> maybe). If you want it to be a separate function then do that.

I changed that, too.

>> +static int fepci_open(struct net_device *dev)
>> +{
>> +     struct fepci_ch_private *fp = netdev_priv(dev);
>> +     if (unlikely(fp->in_stream_mode))
>> +             fepci_stream_close_down(dev, fp);
>
> Wouldn't it be better to return -EBUSY instead?

I think it is better to allow a user more freedom.

>> +static int fepci_start_xmit(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +     struct fepci_ch_private *fp;
>> +     unsigned cur_tx;
>> +     unsigned next;
>> +     unsigned tx_length;
>> +     dma_addr_t bus_address;
>> +
>> +     if (unlikely(skb_padto(skb, ETH_ZLEN)))
>> +             return NETDEV_TX_OK;
>
> Statistics maybe?

I have added statistics increase.

>> +static inline void fepci_rx(struct fepci_ch_private *fp, struct
>> net_device *dev)
>> +{
>> +             if (!(desc_b & transfer_not_done)) { /* transfer done */
>> +                     fp->cur_rx = (i + 1) & (RX_RING_SIZE - 1);
>> +                     if (unlikely(desc_b & (fifo_error | size_error |
>> +                                            crc_error | octet_error |
>> +                                            line_error))) {
>> +                             if (desc_b & fifo_error)
>> +                                     fp->stats.rx_frame_errors++;
>> +                             else if (desc_b & size_error)
>> +                                     fp->stats.rx_over_errors++;
>> +                             else if (desc_b & crc_error)
>> +                                     fp->stats.rx_crc_errors++;
>> +ENABLE_TRANSFER:             writel(enable_transfer, &rx_desc->desc_b);
>> +                             fp->stats.rx_errors++;
>> +                             continue;
>> +                     } else {
>
> You don't need "else" due to "continue", right? More space for you.

Done.

>> +static struct net_device_stats *fepci_get_stats(struct net_device *dev)
>> +{
>> +     struct fepci_ch_private *fp = netdev_priv(dev);
>> +     return &fp->stats;
>> +}
>
> If you use the built-in net_device_stats you don't need the function.

I have moved to built-in.

>> +static void set_rx_mode(struct net_device *dev)
>> +{
>> +     dev_dbg(&dev->dev, "set_rx_mode\n");
>> +}
>
> Seems unused.

Removed.

A new patch is at http://groups.google.com/group/pcidriver
