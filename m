Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557Ab0ADQNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0ADQNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235Ab0ADQNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:13:00 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11582 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0ADQNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:13:00 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Joe Perches <joe@perches.com>,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jan 2010 16:12:30 +0000
Subject: RE: [PATCH 2/2] drivers/block/cciss: Create and use cciss_debug
 functions, use pr_info
Thread-Topic: [PATCH 2/2] drivers/block/cciss: Create and use cciss_debug
 functions, use pr_info
Thread-Index: AcqBJcHVFEbrlKK8ThqlnuCiu+5hZQMMuUew
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886995B7E023@GVW0547EXC.americas.hpqcorp.net>
References: <cover.1261279381.git.joe@perches.com>
 <e18c6d67cbdb4307c3ff002d2e5e43276bf67301.1261279381.git.joe@perches.com>
In-Reply-To: <e18c6d67cbdb4307c3ff002d2e5e43276bf67301.1261279381.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Saturday, December 19, 2009 9:37 PM
> To: Stephen M. Cameron; Miller, Mike (OS Dev)
> Cc: ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/2] drivers/block/cciss: Create and use
> cciss_debug functions, use pr_info
>
> Centralize #ifdef CCISS code blocks by using
> cciss_debug[_foo] functions
>
> cciss_debug for printk
> cciss_debug_cfg_table for print_cfg_table cciss_debug_bytes
> for print_bytes cciss_debug_cmd for print_cmd
>
> Convert remaining printk without KERN_ levels to pr_info(
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c      |  143 ++++++++++++++------------------
>  drivers/block/cciss_scsi.c |  195
> +++++++++++++++++++-------------------------
>  2 files changed, 146 insertions(+), 192 deletions(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 14f0e06..1b9cfa7 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -61,6 +61,18 @@
>  #define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
>  #define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
>
> +#ifdef CCISS_DEBUG
> +#define cciss_debug(fmt, ...)                                \
> +     printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__) #else
> +#define cciss_debug(fmt, ...)
>       \
> +({                                                           \
> +     if (0)                                                  \
> +             printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);  \
> +     0;                                                      \
> +})
> +#endif
> +
>  /* Embedded module documentation macros - see modules.h */
> MODULE_AUTHOR("Hewlett-Packard Company");
> MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
> @@ -829,9 +841,7 @@ static CommandList_struct
> *cmd_alloc(ctlr_info_t *h, int get_from_pool)
>               } while (test_and_set_bit
>                        (i & (BITS_PER_LONG - 1),
>                         h->cmd_pool_bits + (i /
> BITS_PER_LONG)) != 0); -#ifdef CCISS_DEBUG
> -             printk(KERN_DEBUG "cciss: using command buffer
> %d\n", i);
> -#endif
> +             cciss_debug("using command buffer %d\n", i);
>               c = h->cmd_pool + i;
>               memset(c, 0, sizeof(CommandList_struct));
>               cmd_dma_handle = h->cmd_pool_dhandle
> @@ -897,9 +907,7 @@ static int cciss_open(struct block_device
> *bdev, fmode_t mode)
>       ctlr_info_t *host = get_host(bdev->bd_disk);
>       drive_info_struct *drv = get_drv(bdev->bd_disk);
>
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "cciss_open %s\n", bdev->bd_disk->disk_name);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("%s %s\n", __func__, bdev->bd_disk->disk_name);
>
>       if (drv->busy_configuring)
>               return -EBUSY;
> @@ -938,9 +946,7 @@ static int cciss_release(struct gendisk
> *disk, fmode_t mode)
>       ctlr_info_t *host = get_host(disk);
>       drive_info_struct *drv = get_drv(disk);
>
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "cciss_release %s\n", disk->disk_name);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("%s %s\n", __func__, disk->disk_name);
>
>       drv->usage_count--;
>       host->usage_count--;
> @@ -1107,9 +1113,7 @@ static int cciss_ioctl(struct
> block_device *bdev, fmode_t mode,
>       int ctlr = host->ctlr;
>       void __user *argp = (void __user *)arg;
>
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "cciss_ioctl: Called with cmd=%x
> %lx\n", cmd, arg);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("%s: Called with cmd=%x %lx\n", __func__, cmd, arg);
>
>       switch (cmd) {
>       case CCISS_GETPCIINFO:
> @@ -1154,9 +1158,9 @@ static int cciss_ioctl(struct
> block_device *bdev, fmode_t mode,
>                       if (copy_from_user
>                           (&intinfo, argp,
> sizeof(cciss_coalint_struct)))
>                               return -EFAULT;
> -                     if ((intinfo.delay == 0) &&
> (intinfo.count == 0))
> -                     {
> -//                      printk("cciss_ioctl: delay and count
> cannot be 0\n");
> +                     if ((intinfo.delay == 0) &&
> (intinfo.count == 0)) {
> +                             cciss_debug("%s: delay and
> count cannot be 0\n",
> +                                         __func__);
>                               return -EINVAL;
>                       }
>                       spin_lock_irqsave(CCISS_LOCK(ctlr),
> flags); @@ -1686,9 +1690,7 @@ static void
> cciss_softirq_done(struct request *rq)
>               ++sg_index;
>       }
>
> -#ifdef CCISS_DEBUG
> -     printk("Done with %p\n", rq);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("Done with %p\n", rq);
>
>       /* set the residual count for pc requests */
>       if (blk_pc_request(rq))
> @@ -3098,10 +3100,8 @@ static void do_cciss_request(struct
> request_queue *q)
>       c->Request.CDB[0] =
>           (rq_data_dir(creq) == READ) ? h->cciss_read :
> h->cciss_write;
>       start_blk = blk_rq_pos(creq);
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "cciss: sector =%d nr_sectors=%d\n",
> -            (int)blk_rq_pos(creq), (int)blk_rq_sectors(creq));
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("sector =%d nr_sectors=%u\n",
> +                 (int)blk_rq_pos(creq), blk_rq_sectors(creq));
>
>       sg_init_table(tmp_sg, h->maxsgentries);
>       seg = blk_rq_map_sg(q, creq, tmp_sg);
> @@ -3166,11 +3166,8 @@ static void do_cciss_request(struct
> request_queue *q)
>       if (seg > h->maxSG)
>               h->maxSG = seg;
>
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "cciss: Submitting %ld sectors in %d
> segments "
> -                     "chained[%d]\n",
> -                     blk_rq_sectors(creq), seg, chained);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("Submitting %u sectors in %d segments
> chained[%d]\n",
> +                 blk_rq_sectors(creq), seg, chained);
>
>       c->Header.SGList = c->Header.SGTotal = seg + chained;
>       if (seg > h->max_cmd_sgentries)
> @@ -3484,39 +3481,40 @@ static int
> check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
>   *   the io functions.
>   *   This is for debug only.
>   */
> -#ifdef CCISS_DEBUG
> -static void print_cfg_table(CfgTable_struct *tb)
> +static void cciss_debug_cfg_table(CfgTable_struct *tb)
>  {
> +#ifdef CCISS_DEBUG
>       int i;
>       char temp_name[17];
>
> -     printk("Controller Configuration information\n");
> -     printk("------------------------------------\n");
> +     cciss_debug("Controller Configuration information\n");
> +     cciss_debug("------------------------------------\n");
>       for (i = 0; i < 4; i++)
>               temp_name[i] = readb(&(tb->Signature[i]));
>       temp_name[4] = '\0';
> -     printk("   Signature = %s\n", temp_name);
> -     printk("   Spec Number = %d\n", readl(&(tb->SpecValence)));
> -     printk("   Transport methods supported = 0x%x\n",
> -            readl(&(tb->TransportSupport)));
> -     printk("   Transport methods active = 0x%x\n",
> -            readl(&(tb->TransportActive)));
> -     printk("   Requested transport Method = 0x%x\n",
> -            readl(&(tb->HostWrite.TransportRequest)));
> -     printk("   Coalesce Interrupt Delay = 0x%x\n",
> -            readl(&(tb->HostWrite.CoalIntDelay)));
> -     printk("   Coalesce Interrupt Count = 0x%x\n",
> -            readl(&(tb->HostWrite.CoalIntCount)));
> -     printk("   Max outstanding commands = 0x%d\n",
> -            readl(&(tb->CmdsOutMax)));
> -     printk("   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
> +     cciss_debug("   Signature = %s\n", temp_name);
> +     cciss_debug("   Spec Number = %d\n", readl(&(tb->SpecValence)));
> +     cciss_debug("   Transport methods supported = 0x%x\n",
> +                 readl(&(tb->TransportSupport)));
> +     cciss_debug("   Transport methods active = 0x%x\n",
> +                 readl(&(tb->TransportActive)));
> +     cciss_debug("   Requested transport Method = 0x%x\n",
> +                 readl(&(tb->HostWrite.TransportRequest)));
> +     cciss_debug("   Coalesce Interrupt Delay = 0x%x\n",
> +                 readl(&(tb->HostWrite.CoalIntDelay)));
> +     cciss_debug("   Coalesce Interrupt Count = 0x%x\n",
> +                 readl(&(tb->HostWrite.CoalIntCount)));
> +     cciss_debug("   Max outstanding commands = 0x%d\n",
> +                 readl(&(tb->CmdsOutMax)));
> +     cciss_debug("   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
>       for (i = 0; i < 16; i++)
>               temp_name[i] = readb(&(tb->ServerName[i]));
>       temp_name[16] = '\0';
> -     printk("   Server Name = %s\n", temp_name);
> -     printk("   Heartbeat Counter = 0x%x\n\n\n",
> readl(&(tb->HeartBeat)));
> -}
> +     cciss_debug("   Server Name = %s\n", temp_name);
> +     cciss_debug("   Heartbeat Counter = 0x%x\n\n\n",
> +                 readl(&(tb->HeartBeat)));
>  #endif                               /* CCISS_DEBUG */
> +}
>
>  static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned
> long pci_bar_addr)  { @@ -3652,11 +3650,9 @@ static int
> __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>               return err;
>       }
>
> -#ifdef CCISS_DEBUG
> -     printk("command = %x\n", command);
> -     printk("irq = %x\n", pdev->irq);
> -     printk("board_id = %x\n", board_id);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("command = %x\n", command);
> +     cciss_debug("irq = %x\n", pdev->irq);
> +     cciss_debug("board_id = %x\n", board_id);
>
>  /* If the kernel supports MSI/MSI-X we will try to enable
> that functionality,
>   * else we use the IO-APIC interrupt assigned to us by system ROM.
> @@ -3678,9 +3674,8 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>                                                * already removed
>                                                */
>
> -#ifdef CCISS_DEBUG
> -     printk("address 0 = %lx\n", c->paddr);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("address 0 = %lx\n", c->paddr);
> +
>       c->vaddr = remap_pci_mem(c->paddr, 0x250);
>
>       /* Wait for the board to become ready.  (PCI hotplug
> needs this.) @@ -3701,14 +3696,10 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>       /* get the address index number */
>       cfg_base_addr = readl(c->vaddr + SA5_CTCFG_OFFSET);
>       cfg_base_addr &= (__u32) 0x0000ffff;
> -#ifdef CCISS_DEBUG
> -     printk("cfg base address = %x\n", cfg_base_addr);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("cfg base address = %x\n", cfg_base_addr);
>       cfg_base_addr_index = find_PCI_BAR_index(pdev,
> cfg_base_addr); -#ifdef CCISS_DEBUG
> -     printk("cfg base address index = %llx\n",
> -             (unsigned long long)cfg_base_addr_index);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("cfg base address index = %llx\n",
> +                 (unsigned long long)cfg_base_addr_index);
>       if (cfg_base_addr_index == -1) {
>               pr_warning("Cannot find cfg_base_addr_index\n");
>               err = -ENODEV;
> @@ -3716,17 +3707,13 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>       }
>
>       cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
> -#ifdef CCISS_DEBUG
> -     printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("cfg offset = %llx\n", (unsigned long
> long)cfg_offset);
>       c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
>
> cfg_base_addr_index) +
>                                   cfg_offset,
> sizeof(CfgTable_struct));
>       c->board_id = board_id;
>
> -#ifdef CCISS_DEBUG
> -     print_cfg_table(c->cfgtable);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug_cfg_table(c->cfgtable);
>
>       /* Some controllers support Zero Memory Raid (ZMR).
>        * When configured in ZMR mode the number of supported
> @@ -3761,7 +3748,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>           (readb(&c->cfgtable->Signature[1]) != 'I') ||
>           (readb(&c->cfgtable->Signature[2]) != 'S') ||
>           (readb(&c->cfgtable->Signature[3]) != 'S')) {
> -             printk("Does not appear to be a valid CISS
> config table\n");
> +             pr_info("Does not appear to be a valid CISS
> config table\n");
>               err = -ENODEV;
>               goto err_out_free_res;
>       }
> @@ -3791,9 +3778,7 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>               pci_write_config_dword(pdev,
> PCI_COMMAND_PARITY, dma_refetch);
>       }
>
> -#ifdef CCISS_DEBUG
> -     printk("Trying to put board into Simple mode\n");
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("Trying to put board into Simple mode\n");
>       c->max_commands = readl(&(c->cfgtable->CmdsOutMax));
>       /* Update the field, and then ring the doorbell */
>       writel(CFGTBL_Trans_Simple,
> &(c->cfgtable->HostWrite.TransportRequest));
> @@ -3810,13 +3795,9 @@ static int __devinit
> cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
>               schedule_timeout(msecs_to_jiffies(1));
>       }
>
> -#ifdef CCISS_DEBUG
> -     printk(KERN_DEBUG "I counter got to %d %x\n", i,
> -            readl(c->vaddr + SA5_DOORBELL));
> -#endif                               /* CCISS_DEBUG */
> -#ifdef CCISS_DEBUG
> -     print_cfg_table(c->cfgtable);
> -#endif                               /* CCISS_DEBUG */
> +     cciss_debug("I counter got to %d %x\n",
> +                 i, readl(c->vaddr + SA5_DOORBELL));
> +     cciss_debug_cfg_table(c->cfgtable);
>
>       if (!(readl(&(c->cfgtable->TransportActive)) &
> CFGTBL_Trans_Simple)) {
>               pr_warning("unable to get board into simple
> mode\n"); diff --git a/drivers/block/cciss_scsi.c
> b/drivers/block/cciss_scsi.c index bd7d0c5..54543f1 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -185,7 +185,7 @@ scsi_cmd_free(ctlr_info_t *h,
> CommandList_struct *cmd)
>       sa = (struct cciss_scsi_adapter_data_t *) h->scsi_ctlr;
>       stk = &sa->cmd_stack;
>       if (stk->top >= CMD_STACK_SIZE) {
> -             printk("cciss: scsi_cmd_free called too many times.\n");
> +             pr_info("scsi_cmd_free called too many times.\n");
>               BUG();
>       }
>       stk->top++;
> @@ -209,7 +209,7 @@ scsi_cmd_stack_setup(int ctlr, struct
> cciss_scsi_adapter_data_t *sa)
>               pci_alloc_consistent(hba[ctlr]->pdev, size,
> &stk->cmd_pool_handle);
>
>       if (stk->pool == NULL) {
> -             printk("stk->pool is null\n");
> +             pr_info("stk->pool is null\n");
>               return -1;
>       }
>
> @@ -232,10 +232,10 @@ scsi_cmd_stack_free(int ctlr)
>       sa = (struct cciss_scsi_adapter_data_t *) hba[ctlr]->scsi_ctlr;
>       stk = &sa->cmd_stack;
>       if (stk->top != CMD_STACK_SIZE-1) {
> -             printk( "cciss: %d scsi commands are still
> outstanding.\n",
> +             pr_info("%d scsi commands are still outstanding.\n",
>                       CMD_STACK_SIZE - stk->top);
>               // BUG();
> -             printk("WE HAVE A BUG HERE!!! stk=0x%p\n", stk);
> +             pr_alert("WE HAVE A BUG HERE!!! stk=0x%p\n", stk);
>       }
>       size = sizeof(struct cciss_scsi_cmd_stack_elem_t) *
> CMD_STACK_SIZE;
>
> @@ -243,91 +243,64 @@ scsi_cmd_stack_free(int ctlr)
>       stk->pool = NULL;
>  }
>
> -#if 0
> -static int xmargin=8;
> -static int amargin=60;
> -
>  static void
> -print_bytes (unsigned char *c, int len, int hex, int ascii)
> +cciss_debug_bytes(const void *p, size_t len, bool ascii)
>  {
> -
> -     int i;
> -     unsigned char *x;
> -
> -     if (hex)
> -     {
> -             x = c;
> -             for (i=0;i<len;i++)
> -             {
> -                     if ((i % xmargin) == 0 && i>0) printk("\n");
> -                     if ((i % xmargin) == 0) printk("0x%04x:", i);
> -                     printk(" %02x", *x);
> -                     x++;
> -             }
> -             printk("\n");
> -     }
> -     if (ascii)
> -     {
> -             x = c;
> -             for (i=0;i<len;i++)
> -             {
> -                     if ((i % amargin) == 0 && i>0) printk("\n");
> -                     if ((i % amargin) == 0) printk("0x%04x:", i);
> -                     if (*x > 26 && *x < 128) printk("%c", *x);
> -                     else printk(".");
> -                     x++;
> -             }
> -             printk("\n");
> -     }
> +#ifdef CCISS_DEBUG
> +     print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": ",
> DUMP_PREFIX_OFFSET,
> +                    16, 1, p, len, ascii);
> +#endif
>  }
>
>  static void
> -print_cmd(CommandList_struct *cp)
> +cciss_debug_cmd(CommandList_struct *cp)
>  {
> -     printk("queue:%d\n", cp->Header.ReplyQueue);
> -     printk("sglist:%d\n", cp->Header.SGList);
> -     printk("sgtot:%d\n", cp->Header.SGTotal);
> -     printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper,
> -                     cp->Header.Tag.lower);
> -     printk("LUN:0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
> -             cp->Header.LUN.LunAddrBytes[0],
> -             cp->Header.LUN.LunAddrBytes[1],
> -             cp->Header.LUN.LunAddrBytes[2],
> -             cp->Header.LUN.LunAddrBytes[3],
> -             cp->Header.LUN.LunAddrBytes[4],
> -             cp->Header.LUN.LunAddrBytes[5],
> -             cp->Header.LUN.LunAddrBytes[6],
> -             cp->Header.LUN.LunAddrBytes[7]);
> -     printk("CDBLen:%d\n", cp->Request.CDBLen);
> -     printk("Type:%d\n",cp->Request.Type.Type);
> -     printk("Attr:%d\n",cp->Request.Type.Attribute);
> -     printk(" Dir:%d\n",cp->Request.Type.Direction);
> -     printk("Timeout:%d\n",cp->Request.Timeout);
> -     printk( "CDB: %02x %02x %02x %02x %02x %02x %02x %02x"
> -             " %02x %02x %02x %02x %02x %02x %02x %02x\n",
> -             cp->Request.CDB[0], cp->Request.CDB[1],
> -             cp->Request.CDB[2], cp->Request.CDB[3],
> -             cp->Request.CDB[4], cp->Request.CDB[5],
> -             cp->Request.CDB[6], cp->Request.CDB[7],
> -             cp->Request.CDB[8], cp->Request.CDB[9],
> -             cp->Request.CDB[10], cp->Request.CDB[11],
> -             cp->Request.CDB[12], cp->Request.CDB[13],
> -             cp->Request.CDB[14], cp->Request.CDB[15]),
> -     printk("edesc.Addr: 0x%08x/0%08x, Len  = %d\n",
> -             cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower,
> -                     cp->ErrDesc.Len);
> -     printk("sgs..........Errorinfo:\n");
> -     printk("scsistatus:%d\n", cp->err_info->ScsiStatus);
> -     printk("senselen:%d\n", cp->err_info->SenseLen);
> -     printk("cmd status:%d\n", cp->err_info->CommandStatus);
> -     printk("resid cnt:%d\n", cp->err_info->ResidualCnt);
> -     printk("offense size:%d\n",
> cp->err_info->MoreErrInfo.Invalid_Cmd.offense_size);
> -     printk("offense byte:%d\n",
> cp->err_info->MoreErrInfo.Invalid_Cmd.offense_num);
> -     printk("offense value:%d\n",
> cp->err_info->MoreErrInfo.Invalid_Cmd.offense_value);
> -
> -}
> -
> +#ifdef CCISS_DEBUG
> +     cciss_debug("queue:%d\n", cp->Header.ReplyQueue);
> +     cciss_debug("sglist:%d\n", cp->Header.SGList);
> +     cciss_debug("sgtot:%d\n", cp->Header.SGTotal);
> +     cciss_debug("Tag:0x%08x/0x%08x\n",
> +                 cp->Header.Tag.upper, cp->Header.Tag.lower);
> +     cciss_debug("LUN:0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
> +                 cp->Header.LUN.LunAddrBytes[0],
> +                 cp->Header.LUN.LunAddrBytes[1],
> +                 cp->Header.LUN.LunAddrBytes[2],
> +                 cp->Header.LUN.LunAddrBytes[3],
> +                 cp->Header.LUN.LunAddrBytes[4],
> +                 cp->Header.LUN.LunAddrBytes[5],
> +                 cp->Header.LUN.LunAddrBytes[6],
> +                 cp->Header.LUN.LunAddrBytes[7]);
> +     cciss_debug("CDBLen:%d\n", cp->Request.CDBLen);
> +     cciss_debug("Type:%d\n",cp->Request.Type.Type);
> +     cciss_debug("Attr:%d\n",cp->Request.Type.Attribute);
> +     cciss_debug(" Dir:%d\n",cp->Request.Type.Direction);
> +     cciss_debug("Timeout:%d\n",cp->Request.Timeout);
> +     cciss_debug("CDB: %02x %02x %02x %02x %02x %02x %02x %02x"
> +                 " %02x %02x %02x %02x %02x %02x %02x %02x\n",
> +                 cp->Request.CDB[0], cp->Request.CDB[1],
> +                 cp->Request.CDB[2], cp->Request.CDB[3],
> +                 cp->Request.CDB[4], cp->Request.CDB[5],
> +                 cp->Request.CDB[6], cp->Request.CDB[7],
> +                 cp->Request.CDB[8], cp->Request.CDB[9],
> +                 cp->Request.CDB[10], cp->Request.CDB[11],
> +                 cp->Request.CDB[12], cp->Request.CDB[13],
> +                 cp->Request.CDB[14], cp->Request.CDB[15]);
> +     cciss_debug("edesc.Addr: 0x%08x/0%08x, Len  = %d\n",
> +                 cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower,
> +                 cp->ErrDesc.Len);
> +     cciss_debug("sgs..........Errorinfo:\n");
> +     cciss_debug("scsistatus:%d\n", cp->err_info->ScsiStatus);
> +     cciss_debug("senselen:%d\n", cp->err_info->SenseLen);
> +     cciss_debug("cmd status:%d\n", cp->err_info->CommandStatus);
> +     cciss_debug("resid cnt:%d\n", cp->err_info->ResidualCnt);
> +     cciss_debug("offense size:%d\n",
> +                 cp->err_info->MoreErrInfo.Invalid_Cmd.offense_size);
> +     cciss_debug("offense byte:%d\n",
> +                 cp->err_info->MoreErrInfo.Invalid_Cmd.offense_num);
> +     cciss_debug("offense value:%d\n",
> +
> cp->err_info->MoreErrInfo.Invalid_Cmd.offense_value);
>  #endif
> +}
>
>  static int
>  find_bus_target_lun(int ctlr, int *bus, int *target, int
> *lun) @@ -368,8 +341,8 @@ cciss_scsi_add_entry(int ctlr, int hostno,
>       unsigned char addr1[8], addr2[8];
>
>       if (n >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
> -             printk("cciss%d: Too many devices, "
> -                     "some will be inaccessible.\n", ctlr);
> +             pr_info("%d: Too many devices, some will be
> inaccessible.\n",
> +                     ctlr);
>               return -1;
>       }
>
> @@ -425,7 +398,7 @@ cciss_scsi_add_entry(int ctlr, int hostno,
>          know our hostno and we don't want to print anything first
>          time anyway (the scsi layer's inquiries will show
> that info) */
>       if (hostno != -1)
> -             printk("cciss%d: %s device c%db%dt%dl%d added.\n",
> +             pr_info("%d: %s device c%db%dt%dl%d added.\n",
>                       ctlr, scsi_device_type(sd->devtype), hostno,
>                       sd->bus, sd->target, sd->lun);
>       return 0;
> @@ -448,9 +421,9 @@ cciss_scsi_remove_entry(int ctlr, int
> hostno, int entry,
>       for (i=entry;i<ccissscsi[ctlr].ndevices-1;i++)
>               ccissscsi[ctlr].dev[i] = ccissscsi[ctlr].dev[i+1];
>       ccissscsi[ctlr].ndevices--;
> -     printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
> +     pr_info("%d: %s device c%db%dt%dl%d removed.\n",
>               ctlr, scsi_device_type(sd.devtype), hostno,
> -                     sd.bus, sd.target, sd.lun);
> +             sd.bus, sd.target, sd.lun);
>  }
>
>
> @@ -555,15 +528,15 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
>
>               if (found == 0) { /* device no longer present. */
>                       changes++;
> -                     /* printk("cciss%d: %s device
> c%db%dt%dl%d removed.\n",
> -                             ctlr,
> scsi_device_type(csd->devtype), hostno,
> -                                     csd->bus, csd->target,
> csd->lun); */
> +                     /* pr_info("%d: %s device c%db%dt%dl%d
> removed.\n",
> +                                ctlr,
> scsi_device_type(csd->devtype), hostno,
> +                                csd->bus, csd->target, csd->lun); */
>                       cciss_scsi_remove_entry(ctlr, hostno, i,
>                               removed, &nremoved);
>                       /* remove ^^^, hence i not incremented */
>               } else if (found == 1) { /* device is different
> in some way */
>                       changes++;
> -                     printk("cciss%d: device c%db%dt%dl%d
> has changed.\n",
> +                     pr_info("%d: device c%db%dt%dl%d has
> changed.\n",
>                               ctlr, hostno, csd->bus,
> csd->target, csd->lun);
>                       cciss_scsi_remove_entry(ctlr, hostno, i,
>                               removed, &nremoved);
> @@ -728,7 +701,7 @@ complete_scsi_command( CommandList_struct
> *cp, int timeout, __u32 tag)
>       /* cmd->result |= (GOOD < 1); */                /*
> status byte */
>
>       cmd->result |= (ei->ScsiStatus);
> -     /* printk("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
> +     /* pr_info("Scsistatus is 0x%02x\n", ei->ScsiStatus);  */
>
>       /* copy the sense data whether we need to or not. */
>
> @@ -773,8 +746,8 @@ complete_scsi_command( CommandList_struct
> *cp, int timeout, __u32 tag)
>                                          cp);
>                       break;
>                       case CMD_INVALID: {
> -                             /* print_bytes(cp, sizeof(*cp), 1, 0);
> -                             print_cmd(cp); */
> +                             cciss_debug_bytes(cp,
> sizeof(*cp), false);
> +                             cciss_debug_cmd(cp);
>       /* We get CMD_INVALID if you address a non-existent
> tape drive instead
>       of a selection timeout (no response).  You will see
> this if you yank
>       out a tape drive, then try to access it. This is kind
> of a shame @@ -817,8 +790,8 @@ complete_scsi_command(
> CommandList_struct *cp, int timeout, __u32 tag)
>                                          cp, ei->CommandStatus);
>               }
>       }
> -     // printk("c:%p:c%db%dt%dl%d ", cmd, ctlr->ctlr, cmd->channel,
> -     //      cmd->target, cmd->lun);
> +     /* pr_info("c:%p:c%db%dt%dl%d ",
> +             cmd, ctlr->ctlr, cmd->channel, cmd->target,
> cmd->lun); */
>       cmd->scsi_done(cmd);
>       scsi_cmd_free(ctlr, cp);
>  }
> @@ -904,7 +877,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *c,
>       cp->Header.Tag.lower = cp->busaddr;  // Use k. address
> of cmd as tag
>       // Fill in the request block...
>
> -     /* printk("Using scsi3addr
> 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n",
> +     /* pr_info("Using scsi3addr
> 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n",
>               scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
>               scsi3addr[4], scsi3addr[5], scsi3addr[6],
> scsi3addr[7]); */
>
> @@ -952,7 +925,7 @@ cciss_scsi_interpret_error(CommandList_struct *cp)
>                               pr_warning("SCSI status is
> abnormally zero.  (probably indicates selection timeout
> reported incorrectly due to a known firmware bug, circa July,
> 2001.)\n");
>               break;
>               case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
> -                     printk("UNDERRUN\n");
> +                     pr_info("UNDERRUN\n");
>               break;
>               case CMD_DATA_OVERRUN:
>                       pr_warning("cp %p has completed with
> data overrun reported\n", @@ -963,8 +936,8 @@
> cciss_scsi_interpret_error(CommandList_struct *cp)
>                       /* to non-existent targets as invalid
> commands. */
>                       pr_warning("cp %p is reported invalid
> (probably means target device no longer present)\n",
>                                  cp);
> -                     /* print_bytes((unsigned char *) cp,
> sizeof(*cp), 1, 0);
> -                     print_cmd(cp);  */
> +                     cciss_debug_bytes(cp, sizeof(*cp), false);
> +                     cciss_debug_cmd(cp);
>                       }
>               break;
>               case CMD_PROTOCOL_ERR:
> @@ -1012,7 +985,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *c,
> unsigned char *scsi3addr,
>       spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
>
>       if (cp == NULL) {                       /* trouble... */
> -             printk("cmd_alloc returned NULL!\n");
> +             pr_info("cmd_alloc returned NULL!\n");
>               return -1;
>       }
>
> @@ -1074,7 +1047,7 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *c,
>       cp = scsi_cmd_alloc(c);
>       spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
>       if (cp == NULL) {                       /* trouble... */
> -             printk("cmd_alloc returned NULL!\n");
> +             pr_info("cmd_alloc returned NULL!\n");
>               return -1;
>       }
>
> @@ -1392,10 +1365,11 @@ cciss_scsi_queue_command (struct
> scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
>               return 0;
>       }
>
> -     /* printk("cciss_queue_command, p=%p, cmd=0x%02x,
> c%db%dt%dl%d\n",
> -             cmd, cmd->cmnd[0], ctlr, cmd->channel,
> cmd->target, cmd->lun);*/
> -     // printk("q:%p:c%db%dt%dl%d ", cmd, ctlr, cmd->channel,
> -     //      cmd->target, cmd->lun);
> +     /* pr_info("%s: p=%p, cmd=0x%02x, c%db%dt%dl%d\n",
> +             __func__, cmd, cmd->cmnd[0],
> +             ctlr, cmd->channel, cmd->target, cmd->lun);*/
> +     /* pr_info("q:%p:c%db%dt%dl%d ",
> +             cmd, ctlr, cmd->channel, cmd->target, cmd->lun); */
>
>       /* Ok, we have a reasonable scsi nexus, so send the cmd
> down, and
>             see what the device thinks of it. */ @@ -1404,7
> +1378,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd,
> void (* done)(struct scsi_cmnd
>       cp = scsi_cmd_alloc(*c);
>       spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>       if (cp == NULL) {                       /* trouble... */
> -             printk("scsi_cmd_alloc returned NULL!\n");
> +             pr_info("scsi_cmd_alloc returned NULL!\n");
>               /* FIXME: next 3 lines are -> BAD! <- */
>               cmd->result = DID_NO_CONNECT << 16;
>               done(cmd);
> @@ -1454,8 +1428,7 @@ cciss_scsi_queue_command (struct
> scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
>               break;
>
>         default:
> -             printk("cciss: unknown data direction: %d\n",
> -                     cmd->sc_data_direction);
> +             pr_info("unknown data direction: %d\n",
> cmd->sc_data_direction);
>               BUG();
>               break;
>       }
> @@ -1515,7 +1488,7 @@ cciss_engage_scsi(int ctlr)
>       stk = &sa->cmd_stack;
>
>       if (sa->registered) {
> -             printk("cciss%d: SCSI subsystem already
> engaged.\n", ctlr);
> +             pr_info("%d: SCSI subsystem already engaged.\n", ctlr);
>               spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>               return -ENXIO;
>       }
> @@ -1599,7 +1572,7 @@ retry_tur:
>       }
>
>       if (rc)
> -             printk("cciss%d: giving up on device.\n", h->ctlr);
> +             pr_info("%d: giving up on device.\n", h->ctlr);
>       else
>               pr_warning("%d: device is ready.\n", h->ctlr);
>
> --
> 1.6.6.rc0.57.gad7a
>
>
