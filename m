Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZBSLws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZBSLws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZBSLwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:52:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:43631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZBSLwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:52:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,235,1233561600"; 
   d="scan'208";a="491343368"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Feb 2009 19:53:59 +0800
Subject: help! locks problem in block layer request queue?
Thread-Topic: help! locks problem in block layer request queue?
Thread-Index: AcmSiMAK48aC3kf9SOKz4SMn4x7POA==
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313024842389@pdsmsx503.ccr.corp.intel.com>
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


Hi all,

Sorry for the too long email. But I encountered a kernle OOP problem when testing my standalone NAND block driver (it's almost a normal block device driver) and not sure why this happen.

In my development environment, the linux 2.6.27 kernel boot with initrd, then 'chroot' to an MMC card. After chroot, I try to mkfs.ext3 on NAND device. but it caused the kernel OOP message.
If I mkfs.ext3 on NAND device before chroot, then it works well (it can mount/umount, copy file correctly accross system reboot).

Below is the log message (/dev/mmcblk0 is the MMC card device node, and /dev/nda is the NAND flash device node) and part of the driver code.

>From the OOP message, It seems there's improper usage of locks in my driver code, but actually, there only one spinlock used in the driver (spinlock_t qlock defined in struct spectra_nand_dev). And it only used by registered request queue. Also, I used a semaphore ('spectra_sem') to prevent the low layer function from being re-entered. As the low layer (hardware layer) now works in PIO mode and it's very slowly, so maybe it holds the spinlock or semaphore for too long time?

It will be highly appreciated if any comments / advices.  Thanks a lot for your time.

---------------------------------------------------------------------------------------------------------------------------------------------
                OOP log message
---------------------------------------------------------------------------------------------------------------------------------------------
# mount /dev/mmcblk0 /mnt
[   55.340007] kjournald starting.  Commit interval 5 seconds
[   55.340007] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   55.340007] EXT3 FS on mmcblk0, internal journal
[   55.340007] EXT3-fs: recovery complete.
[   55.340007] EXT3-fs: mounted filesystem with ordered data mode.
[   55.340007] mount used greatest stack depth: 5956 bytes left

# chroot /mnt

sh-3.2# mkfs.ext3 /dev/nda
mke2fs 1.41.3 (12-Oct-2008)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
233392 inodes, 933248 blocks
46662 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=956301312
29 block groups
32768 blocks per group, 32768 fragments per group
8048 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Writing inode tables:  28/29

done
Creating journal (16384 blocks): [  442.798152] BUG: scheduling while atomic: pdflush/211/0x00000001
[  442.829634] 2 locks held by pdflush/211:
[  442.867684]  #0:  (&type->s_umount_key#13){----}, at: [<c0181b4e>] writeback_inodes+0x63/0xbd
[  442.907838]  #1:  (&dev->qlock){--..}, at: [<c0246023>] __make_request+0x2a1/0x303
[  442.949275] Pid: 211, comm: pdflush Not tainted 2.6.27-developer #7
[  442.991140]  [<c011fa2d>] __schedule_bug+0x59/0x60
[  443.033518]  [<c0452c60>] schedule+0x97/0x824
[  443.074412]  [<c013c626>] ? find_usage_backwards+0xc7/0xe8
[  443.074412]  [<c013c626>] ? find_usage_backwards+0xc7/0xe8
[  443.074412]  [<c013de7b>] ? check_usage_backwards+0x54/0x76
[  443.074412]  [<c0453649>] schedule_timeout+0x17/0xbe
[  443.074412]  [<c013e695>] ? mark_held_locks+0x53/0x6a
[  443.074412]  [<c013e857>] ? trace_hardirqs_on+0xb/0xd
[  443.074412]  [<c013e824>] ? trace_hardirqs_on_caller+0xe9/0x111
[  443.074412]  [<c013e857>] ? trace_hardirqs_on+0xb/0xd
[  443.074412]  [<c045455b>] __down_interruptible+0x64/0x95
[  443.074412]  [<c0136644>] down_interruptible+0x25/0x37
[  443.074412]  [<c02bae51>] GLOB_SBD_transfer+0x1a4/0x241
[  443.074412]  [<c02bb047>] SBD_xfer_request+0x159/0x244
[  443.074412]  [<c0243d4e>] ? elv_next_request+0x163/0x196
[  443.074412]  [<c02bb227>] GLOB_SBD_request+0xd1/0x123
[  443.074412]  [<c02459cf>] ? blk_remove_plug+0x70/0x83
[  443.074412]  [<c0245a56>] __generic_unplug_device+0x1d/0x20
[  443.074412]  [<c0243f4c>] elv_insert+0x1cb/0x1d3
[  443.074412]  [<c0243fcb>] __elv_add_request+0x77/0x7c
[  443.074412]  [<c0246054>] __make_request+0x2d2/0x303
[  443.074412]  [<c0244daf>] generic_make_request+0x36e/0x39c
[  443.074412]  [<c0164985>] ? cache_alloc_debugcheck_after+0x63/0x1b8
[  443.074412]  [<c014d645>] ? mempool_alloc_slab+0xe/0x10
[  443.074412]  [<c014d645>] ? mempool_alloc_slab+0xe/0x10
[  443.074412]  [<c014d89b>] ? mempool_alloc+0x33/0xd1
[  443.074412]  [<c014d645>] ? mempool_alloc_slab+0xe/0x10
[  443.074412]  [<c014d89b>] ? mempool_alloc+0x33/0xd1
[  443.074412]  [<c0244e8d>] submit_bio+0xb0/0xb8
[  443.074412]  [<c0187c53>] ? bio_alloc_bioset+0x50/0x8a
[  443.074412]  [<c0184ade>] submit_bh+0xbc/0xd9
[  443.074412]  [<c0186e3e>] __block_write_full_page+0x1a9/0x279
[  443.074412]  [<c0188982>] ? blkdev_get_block+0x0/0x84
[  443.074412]  [<c0186fcb>] block_write_full_page+0xbd/0xc6
[  443.074412]  [<c0188982>] ? blkdev_get_block+0x0/0x84
[  443.074412]  [<c0189b88>] blkdev_writepage+0xf/0x11
[  443.074412]  [<c015072e>] __writepage+0xb/0x26
[  443.074412]  [<c0150f6a>] write_cache_pages+0x155/0x265
[  443.074412]  [<c0150723>] ? __writepage+0x0/0x26
[  443.074412]  [<c015107a>] ? generic_writepages+0x0/0x27
[  443.074412]  [<c0151097>] generic_writepages+0x1d/0x27
[  443.074412]  [<c01510c4>] do_writepages+0x23/0x34
[  443.074412]  [<c01812bd>] __writeback_single_inode+0x15c/0x32c
[  443.074412]  [<c018187a>] generic_sync_sb_inodes+0x24a/0x368
[  443.074412]  [<c0136013>] ? down_read_trylock+0x39/0x43
[  443.074412]  [<c0181b61>] writeback_inodes+0x76/0xbd
[  443.074412]  [<c015161e>] background_writeout+0x79/0xa5
[  443.074412]  [<c0151b3a>] pdflush+0xe5/0x17c
[  443.074412]  [<c01515a5>] ? background_writeout+0x0/0xa5
[  443.074412]  [<c0151a55>] ? pdflush+0x0/0x17c
[  443.074412]  [<c0132b81>] kthread+0x3b/0x61
[  443.074412]  [<c0132b46>] ? kthread+0x0/0x61
[  443.074412]  [<c0103f57>] kernel_thread_helper+0x7/0x10
[  443.074412]  =======================

done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 33 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
[  514.220017] mkfs.ext3 used greatest stack depth: 5764 bytes left
sh-3.2#
...

------------------------------------------------------------------------------------------------------------------------------
               Part of the driver code  (block device driver)
------------------------------------------------------------------------------------------------------------------------------
#include "ffsport.h"
#include "flash.h"
#include <linux/interrupt.h>
#include <linux/delay.h>


#define NUM_DEVICES             1
#define PARTITIONS              4
#define KERNEL_SECTOR_SIZE      512
#define NUM_OUTSTANDING_FTL_REQUESTS    8

#define GLOB_SBD_NAME          "nd"
#define GLOB_SBD_IRQ_NUM       (29)
#define GLOB_VERSION            "driver version 20081224"

#define GLOB_SBD_IOCTL_GC                                              (0x7701)
#define GLOB_SBD_IOCTL_WL                                              (0x7702)
#define GLOB_SBD_IOCTL_FORMAT                                      (0x7703)
#define GLOB_SBD_IOCTL_ERASE_FLASH                             (0x7704)
#define GLOB_SBD_IOCTL_FLUSH_CACHE                             (0x7705)
#define GLOB_SBD_IOCTL_COPY_BLK_TABLE                       (0x7706)
#define GLOB_SBD_IOCTL_COPY_WEAR_LEVELING_TABLE  (0x7707)

#define RESERVED_MB_FOR_OS_IMAGE    25

int nand_debug_level = 0;
module_param(nand_debug_level, int, 0644);
MODULE_PARM_DESC(nand_debug_level, "debug level value: 1-3");

MODULE_LICENSE("GPL");

struct spectra_nand_dev {
        struct pci_dev *dev;
        uint size;
        short users;
        spinlock_t qlock;
        struct request_queue *queue;
        struct gendisk *gd;
};

static int GLOB_SBD_majornum;

static char *GLOB_version = GLOB_VERSION;

static struct spectra_nand_dev nand_device[NUM_DEVICES];

static int dev_num;

static struct semaphore spectra_sem;

static int res_blks_os = 1;

#if 0
unsigned char __iomem *mrst_NandCtrl_reg_base_addr;
#endif

IDENTFY_DEVICE_DATA IdentifyDeviceData;

#define SBD_SECTOR_SIZE         (IdentifyDeviceData.PageDataSize)
#define SBD_BLOCK_SIZE          (IdentifyDeviceData.PageDataSize * IdentifyDeviceData.PagesPerBlock)

byte *mem_pool_ptr = NULL;

#define SECTOR_SIZE_RATIO       (SBD_SECTOR_SIZE/KERNEL_SECTOR_SIZE)

static int force_flush_cache(void) {
        if (down_interruptible(&spectra_sem))
                return -ERESTARTSYS;
        if (ERR == GLOB_FTL_Flush_Cache()) {
                printk(KERN_ERR "Fail to Flush FTL Cache!\n");
                up(&spectra_sem);
                return -EFAULT;
        } else {
                up(&spectra_sem);
                return 0;
        }
}

/* Static Function Declarations */
static void GLOB_SBD_request(struct request_queue *q);


static int GLOB_SBD_transfer(unsigned long sector,
                             unsigned long nsect, int prevnsect, char *buffer,
                             int write)
{
        unsigned long dwAddress;
        u16 i;
        int result = PASS;

        if (sector % SECTOR_SIZE_RATIO)
                printk(KERN_ERR
                       "Spectra: %s requested with sector %lu not a multiple"
                        " of Spectra sector size %d\n",
                       (write ? "Write" : "Read"), sector, SBD_SECTOR_SIZE);
        if (nsect % SECTOR_SIZE_RATIO)
                printk(KERN_ERR
                       "Spectra: %s requested at sector %lu with num bytes %lu"
                        " not a multiple of Spectra sector size %d\n",
                       (write ? "Write" : "Read"), sector, nsect,
                       SBD_SECTOR_SIZE);

        dwAddress = sector * KERNEL_SECTOR_SIZE;

        /* Add a big enough offset to prevent the OS Image from
        *  being accessed or damaged by file system */
        dwAddress += (SBD_BLOCK_SIZE * res_blks_os);

        nsect /= SECTOR_SIZE_RATIO;
        if (!nsect)
                printk(KERN_ERR "Spectra: %s of less than 1 sector requested\n",
                       (write ? "Write" : "Read"));

        nsect += prevnsect;

        for (i = prevnsect; i < nsect; i++) {
                        if (down_interruptible(&spectra_sem))
                                return -ERESTARTSYS;
                        if (write)
                                result = GLOB_FTL_Page_Write(buffer, dwAddress);
                        else
                                result = GLOB_FTL_Page_Read(buffer, dwAddress);
                        up(&spectra_sem);

                        if (PASS != result)
                                break;

                dwAddress += SBD_SECTOR_SIZE;
                buffer += SBD_SECTOR_SIZE;
        }
        return (result == PASS) ? (i - prevnsect) : -1;
}

/*&&&&&&&&&&&&&&&&&&&&&&
 * Transfer a full request.
 &&&&&&&&&&&&&&&&&&&&&&&*/
static int SBD_xfer_request(struct request *req)
{
        int nsect = 0, sbd_nsect = 0, ret_val = 0;
        struct bio_vec *bvec;
        struct req_iterator iter;
        unsigned long flags, prevsects = 0, currsects;
        sector_t sector;

        nand_dbg_print(NAND_DBG_TRACE, "%s, Line %d, Function: %s\n",
                       __FILE__, __LINE__, __func__);

        rq_for_each_segment(bvec, req, iter) {
                if (ret_val >= 0) {
                        char *buffer = bvec_kmap_irq(bvec, &flags);
                        currsects = bvec->bv_len / KERNEL_SECTOR_SIZE;
                        if (!(iter.i)) {
                                sector = iter.bio->bi_sector;
                                prevsects = currsects;
                        } else {
                                sector = iter.bio->bi_sector + prevsects;
                                prevsects += currsects;
                        }
                        ret_val = GLOB_SBD_transfer(sector, currsects, sbd_nsect,
                                              buffer,
                                              bio_data_dir(iter.bio) == WRITE);
                        bvec_kunmap_irq(buffer, &flags);
                        nsect += currsects;

                        sbd_nsect += ret_val;
                }
        }

        return (ret_val >= 0) ? (sbd_nsect * SECTOR_SIZE_RATIO) : -1;
}

static void SBD_prepare_flush(struct request_queue *q, struct request *rq)
{
        rq->cmd_type = REQ_TYPE_LINUX_BLOCK;
        /* rq->timeout = 5 * HZ; */
        rq->cmd[0] = REQ_LB_OP_FLUSH;
}


/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 * Request function that "handles clustering".
 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
static void GLOB_SBD_request(struct request_queue *q)
{
        struct request *req;
        int sectors_xferred, success = 1;

                while (
                      ((req = elv_next_request(q)) != NULL)) {
                      /* FIXME: Ensure that no DMA writes are outstanding... */
                        if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
                                        req->cmd[0] == REQ_LB_OP_FLUSH) {
                                        if (force_flush_cache()) /* Fail to flush cache */
                                                end_request(req, 0);
                                        else
                                                end_request(req, 1);
                                        continue;
                        }

                        if (!blk_fs_request(req)) {
                                nand_dbg_print(NAND_DBG_WARN, "Spectra: Skip non-fs request\n");
                                end_request(req, 0);
                                continue;
                        }

                        sectors_xferred = SBD_xfer_request(req);
                        success = (sectors_xferred < 0) ? 0 : 1;

                        __blk_end_request(req, success ? 0 : -EIO,
                                          sectors_xferred << 9);
                }
}

static int GLOB_SBD_open(struct inode *inode, struct file *filep)
{
        nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
                       __FILE__, __LINE__, __func__);

        return 0;
}

static int GLOB_SBD_release(struct inode *inode, struct file *filep)
{
        nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
                       __FILE__, __LINE__, __func__);

        force_flush_cache();

        return 0;
}


int GLOB_SBD_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
                   unsigned long arg)
{
        struct hd_geometry geo;
        long size;
        struct spectra_nand_dev *dev = inode->i_bdev->bd_disk->private_data;

        switch (cmd) {
        case GLOB_SBD_IOCTL_FORMAT:
                nand_dbg_print(NAND_DBG_DEBUG, "Spectra IOCTL: Flash format "
                               "being performed\n");
                if (PASS != GLOB_FTL_Flash_Format())
                        return -EFAULT;
                return 0;

        case GLOB_SBD_IOCTL_FLUSH_CACHE:
                nand_dbg_print(NAND_DBG_DEBUG, "Spectra IOCTL: Cache flush "
                               "being performed\n");
                return (force_flush_cache());
        }

        return -ENOTTY;
}

static struct block_device_operations GLOB_SBD_ops = {
        .owner = THIS_MODULE,
        .open = GLOB_SBD_open,
        .release = GLOB_SBD_release,
        .ioctl = GLOB_SBD_ioctl,
};

static int SBD_setup_device(struct spectra_nand_dev *dev, int which)
{
        int res_blks;

        memset(dev, 0, sizeof(struct spectra_nand_dev));
        res_blks = get_res_blk_num_bad_blk() + get_res_blk_num_os();

        dev->size =
            IdentifyDeviceData.PageDataSize * IdentifyDeviceData.PagesPerBlock *
            (IdentifyDeviceData.wDataBlockNum - res_blks);

        res_blks_os = get_res_blk_num_os();

        spin_lock_init(&dev->qlock);

        dev->queue = blk_init_queue(GLOB_SBD_request, &dev->qlock);
        if (dev->queue == NULL) {
                printk(KERN_ERR
                       "Spectra: Request queue could not be initialized."
                        " Aborting\n ");
                goto out_vfree;
        }

        blk_queue_hardsect_size(dev->queue, SBD_SECTOR_SIZE);
        blk_queue_ordered(dev->queue, QUEUE_ORDERED_DRAIN_FLUSH,
                                                SBD_prepare_flush);
        dev->queue->queuedata = dev;

        dev->gd = alloc_disk(PARTITIONS);
        if (!dev->gd) {
                printk(KERN_ERR
                       "Spectra: Could not allocate disk. Aborting \n ");
                goto out_vfree;
        }
        dev->gd->major = GLOB_SBD_majornum;
        dev->gd->first_minor = which * PARTITIONS;
        dev->gd->fops = &GLOB_SBD_ops;
        dev->gd->queue = dev->queue;
        dev->gd->private_data = dev;
        snprintf(dev->gd->disk_name, 32, "%s%c", GLOB_SBD_NAME, which + 'a');
        set_capacity(dev->gd, dev->size / KERNEL_SECTOR_SIZE);
        add_disk(dev->gd);

        return 0;
out_vfree:
        return -ENOMEM;
}

static const struct pci_device_id nand_pci_ids[] = {
        {
         .vendor = 0x8086,
         .device = 0x0809,
         .subvendor = PCI_ANY_ID,
         .subdevice = PCI_ANY_ID,
         },
        { /* end: all zeroes */ }
};

static int nand_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
{
        int ret = -ENODEV;
        struct spectra_nand_dev *pndev = &nand_device[dev_num];

        nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
                       __FILE__, __LINE__, __func__);

        ret = pci_enable_device(dev);
        if (ret) {
                printk(KERN_ERR "Spectra: pci_enable_device failed.\n");
                return ret;
        }

        pci_set_master(dev);
        pndev->dev = dev;

#if 0
        unsigned long csr_base;
        unsigned long csr_len;

        csr_base = pci_resource_start(dev, 0);
        if (!csr_base) {
                printk(KERN_ERR "Spectra: pci_resource_start failed!\n");
                return -ENODEV;
        }

        csr_len = pci_resource_len(dev, 0);
        if (!csr_len) {
                printk(KERN_ERR "Spectra: pci_resource_len failed!\n");
                return -ENODEV;
        }

        ret = pci_request_regions(dev, GLOB_SBD_NAME);
        if (ret) {
                printk(KERN_ERR "Spectra: Unable to request "
                       "memory region\n");
                goto failed_req_csr;
        }

        mrst_NandCtrl_reg_base_addr = ioremap_nocache(csr_base, csr_len);
        if (!mrst_NandCtrl_reg_base_addr) {
                printk(KERN_ERR "Spectra: Unable to remap " "memory region\n");
                ret = -ENOMEM;
                goto failed_remap_csr;
        }

#endif

        pci_set_drvdata(dev, pndev);

        create_sysfs_entry(&dev->dev);

        dev_num++;

        return 0;

#if 0
failed_req_irq:
        iounmap(mrst_NandCtrl_reg_base_addr);
failed_remap_csr:
        pci_release_regions(dev);
failed_req_csr:

        return ret;
#endif

}

static int find_valid_blk_table = 0;

static void nand_pci_remove(struct pci_dev *dev)
{
#if 0
        struct spectra_nand_dev *pndev = pci_get_drvdata(dev);
#endif
        nand_dbg_print(NAND_DBG_WARN, "%s, Line %d, Function: %s\n",
                       __FILE__, __LINE__, __func__);

        if (find_valid_blk_table)
                force_flush_cache();
#if 0
        free_irq(dev->irq, pndev);
        iounmap(mrst_NandCtrl_reg_base_addr);
        pci_release_regions(dev);
#endif
        pci_disable_device(dev);
}

MODULE_DEVICE_TABLE(pci, nand_pci_ids);

static struct pci_driver nand_pci_driver = {
        .name = GLOB_SBD_NAME,
        .id_table = nand_pci_ids,
        .probe = nand_pci_probe,
        .remove = nand_pci_remove,
};

static int GLOB_SBD_init(void)
{
        int i, retval;

        sema_init(&spectra_sem, 1);

        retval = pci_register_driver(&nand_pci_driver);
        if (retval)
                return -ENOMEM;

        GLOB_SBD_majornum = register_blkdev(0, GLOB_SBD_NAME);
        if (GLOB_SBD_majornum <= 0) {
                printk(KERN_ERR "Unable to get the major %d for Spectra",
                       GLOB_SBD_majornum);
                return -EBUSY;
        }

        if (PASS != GLOB_FTL_Flash_Init()) {
                printk(KERN_ERR "Spectra: Unable to Initialize Flash Device. "
                       "Aborting\n");
                goto out_flash_register;
        }

        if (PASS != GLOB_FTL_IdentifyDevice(&IdentifyDeviceData)) {
                printk(KERN_ERR "Spectra: Unable to Read Flash Device. "
                       "Aborting\n");
                goto out_flash_register;
        } else {
                nand_dbg_print(NAND_DBG_WARN, "In GLOB_SBD_init: Num blocks=%d, "
                       "pagesperblock=%d, pagedatasize=%d\n",
                       (int)IdentifyDeviceData.wDataBlockNum,
                       (int)IdentifyDeviceData.PagesPerBlock,
                       (int)IdentifyDeviceData.PageDataSize);
        }

        if (SBD_SECTOR_SIZE % KERNEL_SECTOR_SIZE) {
                printk(KERN_ERR "Spectra: Flash page data size is not an "
                       "integral multiple of kernel sector size %d. Aborting\n",
                       KERNEL_SECTOR_SIZE);
                goto out_flash_register;
        }

    if (!(mem_pool_ptr = (byte *)vmalloc(IdentifyDeviceData.SizeOfGlobalMem))) {
        printk(KERN_ERR "Spectra: Unable to Initialize Memory Pool. Aborting\n");
        goto out_mempool_flash_register;
    }

        if (PASS != GLOB_FTL_Mem_Config(mem_pool_ptr)) {
                printk(KERN_ERR "Spectra: Unable to Read Flash Device. "
                       "Aborting\n");
                goto out_mempool_flash_register;
        }

        printk(KERN_ALERT "Spectra: searching block table, please wait ...\n");
        if (PASS != GLOB_FTL_Init()) {
                printk(KERN_ERR "Spectra: Unable to Initialize FTL Layer. "
                       "Aborting\n");
                goto out_ftl_flash_register;
        } else {
                find_valid_blk_table = 1;       /* Found valid block table */
        }

        for (i = 0; i < NUM_DEVICES; i++)
                if (SBD_setup_device(&nand_device[i], i) == -ENOMEM)
                        goto out_ftl_flash_register;

        return 0;

out_ftl_flash_register:
        GLOB_FTL_Cache_Release();
out_flash_register:
        GLOB_FTL_Flash_Release();
        unregister_blkdev(GLOB_SBD_majornum, GLOB_SBD_NAME);
        pci_unregister_driver(&nand_pci_driver);
#if GEN2APIs
out_mempool_flash_register:
        vfree(mem_pool_ptr);
#endif
        printk(KERN_ERR "Spectra: Module load failed.\n");
        return -ENOMEM;
}

static void __exit GLOB_SBD_exit(void)
{
        int i;

        for (i = 0; i < NUM_DEVICES; i++) {
                struct spectra_nand_dev *dev = &nand_device[i];
                if (dev->gd) {
                        del_gendisk(dev->gd);
                        put_disk(dev->gd);
                }
                if (dev->queue)
                        blk_cleanup_queue(dev->queue);
        }

        unregister_blkdev(GLOB_SBD_majornum, GLOB_SBD_NAME);

        force_flush_cache();

        GLOB_FTL_Cache_Release();

        vfree(mem_pool_ptr);

        GLOB_FTL_Flash_Release();
        pci_unregister_driver(&nand_pci_driver);
}

module_init(GLOB_SBD_init);
module_exit(GLOB_SBD_exit);

....

-----------------------------------------------------------------------------------------------------------------------------------

Thanks.

Best Regards,
Yunpeng Gao

