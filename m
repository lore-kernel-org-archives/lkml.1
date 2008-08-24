Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYHXJAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYHXJAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYHXJAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:00:08 -0400
Received: from web33201.mail.mud.yahoo.com ([209.191.69.149]:39145 "HELO
	web33201.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752048AbYHXJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:00:02 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Aug 2008 05:00:01 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=PLcp5re/4ijNNrdeUJAgNkdRP009Pcjvd310DRlMwPFycnxpaPhIeXG2QHDA52Yb8ahzmf87f5+wEilgVO3upiJ8hSMr5B0JpSMqNydn1zK/zrpGcrGEQe4lJQk7Yu19RlyjSW3q/DMdT5PghYmiHxFndkFkUMKb8lOiqteC0iE=;
X-YMail-OSG: PIlnINYVM1kFMqDJSnIngLvHcDOVkH58PI0nAB9w_nBDbN8iDafjIVPzS8sQGXcE6kgaVxHDA7r7bkdz.TC6kJ5mSBoCzi7WSCyyPkiMCVX1GjruCLHnjfp4ud6GeHeTyMI-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Sun, 24 Aug 2008 01:53:20 -0700 (PDT)
From: jassi brar <jassi_singh_brar@yahoo.com>
Reply-To: jassi_singh_brar@yahoo.com
Subject: An idea .... with code
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <801995.65435.qm@web33201.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  Lately a question has been bugging me: Why do we keep complicated(specific ioctls to set up and set free) LOOP driver to emulate a data file as block-device, for it to be mounted/formated.

 Wouldn't it be nice if we didnt have to specify '-o loop' or use losetup -d etc?

 With inspiration from UMS-Gadget and LOOP driver itself, I implemented a proof of concept: A kernel module which creats a node in /sys/devices/ and un/loads files to be emulated as block devices. The interface doesn't implement any new ioctls or a syscall.

To load a file all we need to do is:-

$ echo +filename > /sys/devices/virblk/manage   //NOTE the - sign

To unload a file:- 

$ echo -filename > /sys/devices/virblk/manage   //NOTE the - sign


 The module creates one thread per node and alloc/free the data structures in the runtime thereby neither limiting the max number of files that could be emulated nor hogging space when not necessary.


/*************************/

[root@localhost jmod]# dd if=/dev/zero of=image bs=1024 count=102400

[root@localhost jmod]# echo +image > /sys/devices/virblk/manage 
[root@localhost jmod]# cat /sys/devices/virblk/manage
/home/jassi/jmod/image' as 'v0blk'

[root@localhost jmod]# dmesg -c
File(image) is being emulated as block device v0blk
 v0blk: unknown partition table

[root@localhost jmod]# fdisk /dev/v0blk 
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0x360df22f.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-100, default 1): 
Using default value 1
Last cylinder or +size or +sizeM or +sizeK (1-100, default 100): 50

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4): 2
First cylinder (51-100, default 51): 
Using default value 51
Last cylinder or +size or +sizeM or +sizeK (51-100, default 100): 
Using default value 100

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

[root@localhost jmod]# mkfs.ext2 /dev/v0blk1 
mke2fs 1.40.8 (13-Mar-2008)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
12824 inodes, 51184 blocks
2559 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=52428800
7 block groups
8192 blocks per group, 8192 fragments per group
1832 inodes per group
Superblock backups stored on blocks: 
	8193, 24577, 40961

Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 36 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

[root@localhost jmod]# mkfs.ext2 /dev/v0blk2 
mke2fs 1.40.8 (13-Mar-2008)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
12824 inodes, 51200 blocks
2560 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=52428800
7 block groups
8192 blocks per group, 8192 fragments per group
1832 inodes per group
Superblock backups stored on blocks: 
	8193, 24577, 40961

Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 38 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

[root@localhost jmod]# dmesg -c
 v0blk: v0blk1 v0blk2
 v0blk: v0blk1 v0blk2

[root@localhost jmod]# echo -image > /sys/devices/virblk/manage 
[root@localhost jmod]# dmesg -c
Killed thread 'vblk0_thread'

[root@localhost jmod]# echo +image > /sys/devices/virblk/manage 
[root@localhost jmod]# dmesg 
File(image) is being emulated as block device v0blk
 v0blk: v0blk1 v0blk2

[root@localhost jmod]# parted /dev/v0blk
GNU Parted 1.8.8
Using /dev/v0blk
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p                                                                
Model: Unknown (unknown)
Disk /dev/v0blk: 105MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system  Flags
 1      16.4kB  52.4MB  52.4MB  primary  ext2              
 2      52.4MB  105MB   52.4MB  primary  ext2              

(parted) q                                                                
[root@localhost jmod]# 

/**************************************/


The module source code is attached too:-

--------------------------8<-------------------------------

/*
 * Kernel module to emulate a user space file as a block device transparently.
 *
 * Copyright (C) 2008 Jaswinder Singh Brar <jassi_singh_brar AT yahoo DOT com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/hdreg.h>
#include <linux/blkdev.h>
#include <linux/kthread.h>

#define VBD_MAJOR	121 /* Just some available */
#define VBD_NAME	"vblk"

#define NUM_SPC_BITS	5 /* == 32 */
#define NUM_HEADS_BITS	6 /* == 64 */
#define SECT_SIZE_BITS	9 /* == 512 */
#define NUM_MINORS	16

#define REGBLKDEV  (1<<0)
#define REGPDEV    (1<<1)
#define CRTDEVFL   (1<<2)

/*
 * Various parameters could be configured at module load time or 'echo +' command.
 */
struct vir_blk_dev{
	int                    index;
	int                    heads_bits;
	int                    cylinders;
	int                    sectspercyl_bits;
	int                    sect_size_bits;
	int                    use_count;
	int                    md_change;
	int                    ro;
	loff_t                 sects;
	struct file           *filp;
	struct gendisk        *gd;
	struct request_queue  *rq;
	struct bio            *vbd_biotail;
	struct bio            *vbd_bio;
	struct list_head       vbd_list;
	struct task_struct    *vbd_thread;
	struct semaphore       sem;
	spinlock_t             vbd_lock;
	wait_queue_head_t      vbd_event;
};

static LIST_HEAD(vbd_head);

static struct device vir_dev = {
	.bus_id = "virblk",
};

static int data_xfer(struct vir_blk_dev *vbd, struct page *page, unsigned int len, 
				unsigned int off, int wr, sector_t sector)
{
	ssize_t ret;
	loff_t pos = sector * (1<<(vbd->sect_size_bits));
	void *buf = kmap(page) + off;

	if(sector + (len >> vbd->sect_size_bits) > get_capacity(vbd->gd)){
		printk("Trying to move past the end!\n");
		kunmap(page);
		return -EIO;
	}

	if(wr)
	   ret = vbd->filp->f_op->write(vbd->filp, buf, len, &pos);
	else
	   ret = vbd->filp->f_op->read(vbd->filp, buf, len, &pos);

	kunmap(page);

	if(likely(ret == len))
		return 0;

	if(ret >= 0)
		ret = -EIO;

	return ret;
}

static void handle_bio(struct vir_blk_dev *vbd, struct bio *bio)
{
	int i, ret = -EIO;
	struct bio_vec *bvec;
	sector_t sector;

	sector = bio->bi_sector;
	bio_for_each_segment(bvec, bio, i){

		ret = data_xfer(vbd, bvec->bv_page, bvec->bv_len, bvec->bv_offset, 
							bio_data_dir(bio) == WRITE, sector);
		if(ret){
			break;
		}
		sector += (bvec->bv_len >> vbd->sect_size_bits);
	}

	bio_endio(bio, ret);
}

static int vbd_make_request(struct request_queue *rq, struct bio *bio)
{
	struct vir_blk_dev *vbd = (struct vir_blk_dev *)rq->queuedata;

	spin_lock_irq(&vbd->vbd_lock);

	if(vbd->vbd_biotail != NULL){
		vbd->vbd_biotail->bi_next = bio;
		vbd->vbd_biotail = bio;
	}else{
		vbd->vbd_bio = vbd->vbd_biotail = bio;
	}

	wake_up(&vbd->vbd_event);
	spin_unlock_irq(&vbd->vbd_lock);
	return 0;
} 

static int jmod_open(struct inode *inode, struct file *filp)
{
	struct vir_blk_dev *vbd = (struct vir_blk_dev *)inode->i_bdev->bd_disk->private_data;

	down(&vbd->sem);
	filp->private_data = (void *)vbd;
	vbd->use_count++;
	up(&vbd->sem);

	return 0;
}

static int jmod_release(struct inode *inode, struct file *filp)
{
	struct vir_blk_dev *vbd = (struct vir_blk_dev *)inode->i_bdev->bd_disk->private_data;

	down(&vbd->sem);
	vbd->filp->f_op->fsync(vbd->filp, vbd->filp->f_path.dentry, 1);
	vbd->use_count--;
	up(&vbd->sem);

	return 0;
}

static int jmod_getgeo(struct block_device *bdev, struct hd_geometry *gm)
{
	struct vir_blk_dev *vbd = bdev->bd_disk->private_data;

	down(&vbd->sem);
	gm->heads = 1<<(vbd->heads_bits);
	gm->sectors = 1<<(vbd->sectspercyl_bits);
	gm->cylinders = get_capacity(bdev->bd_disk) >> (vbd->heads_bits + vbd->sectspercyl_bits);
	up(&vbd->sem);

	return 0;
}

static int jmod_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
{
	return 0;
}


static int jmod_mediachanged(struct gendisk *gd)
{
	struct vir_blk_dev *vbd = gd->private_data;

	return vbd->md_change;
}

static int jmod_revalidatedisk(struct gendisk *gd)
{
	struct vir_blk_dev *vbd = gd->private_data;

	down(&vbd->sem);
	if(vbd->md_change)
		vbd->md_change = 0;
	up(&vbd->sem);

	return 0;
}

static struct block_device_operations vbd_fops = {
	.owner = THIS_MODULE,
	.open = jmod_open,
	.release = jmod_release,
	.ioctl = jmod_ioctl,
	.getgeo = jmod_getgeo,
	.media_changed = jmod_mediachanged,
	.revalidate_disk = jmod_revalidatedisk,
};

/*
 * ind : First minor number of the disk
 * */
static struct vir_blk_dev *vblk_alloc(int ind)
{
	struct gendisk *disk;
	struct vir_blk_dev *vbd;

	vbd = kzalloc(sizeof(*vbd), GFP_KERNEL);
	if (vbd == NULL)
		goto out;

	vbd->filp = NULL;
	vbd->vbd_thread = NULL;
	vbd->use_count = 0;
	vbd->md_change = 1;
	vbd->index = ind;
	vbd->vbd_bio = NULL;
	vbd->vbd_biotail = NULL;

	vbd->rq = blk_alloc_queue(GFP_KERNEL);
	if(vbd->rq == NULL){
		goto out;
	}
	blk_queue_make_request(vbd->rq, vbd_make_request);
	blk_queue_bounce_limit(vbd->rq, BLK_BOUNCE_ANY);

	disk = vbd->gd = alloc_disk(NUM_MINORS);
	if(disk == NULL){
		goto out;
	}
	disk->major		= VBD_MAJOR;
	disk->first_minor	= ind*NUM_MINORS;
	disk->fops		= &vbd_fops;
	disk->private_data	= (void *)vbd;
	vbd->rq->queuedata	= (void *)vbd;
	disk->queue		= vbd->rq;
	disk->flags |= GENHD_FL_REMOVABLE;
	sprintf(disk->disk_name, "v%dblk", ind);
	init_waitqueue_head(&vbd->vbd_event);

	return vbd;

out:
	if(vbd && vbd->rq){
		blk_cleanup_queue(vbd->rq);
	}
	if(vbd){
		kfree(vbd);
	}
	return NULL;
}

static struct file* open_backing_file(const char *filename, int *ro, loff_t *size)
{
	struct file      *filp = NULL;
	struct inode     *inode = NULL;

	*ro = 0;
	*size = 0;

	filp = filp_open(filename, O_RDWR | O_LARGEFILE, 0);
	if (-EROFS == PTR_ERR(filp))
		*ro = 1;
	if (*ro)
		filp = filp_open(filename, O_RDONLY | O_LARGEFILE, 0);
	if (IS_ERR(filp)) {
		printk("unable to open backing file: %s\n", filename);
		return NULL;
	}

	if(!(filp->f_mode & FMODE_WRITE))
		*ro = 1;

	if(filp->f_path.dentry)
		inode = filp->f_path.dentry->d_inode;

	if(inode && S_ISBLK(inode->i_mode)){
		if (bdev_read_only(inode->i_bdev))
			*ro = 1;
	}else if(!inode || !S_ISREG(inode->i_mode)){
		printk("invalid file type: %s\n", filename);
		filp_close(filp, current->files);
		return NULL;
	}

	if (!filp->f_op || !(filp->f_op->read || filp->f_op->aio_read)) {
		printk("file not readable: %s\n", filename);
		filp_close(filp, current->files);
		return NULL;
	}
	if (!(filp->f_op->write || filp->f_op->aio_write))
		*ro = 1;

	*size = i_size_read(inode->i_mapping->host);
	if (*size < 0) {
		printk("unable to find file size: %s\n", filename);
		filp_close(filp, current->files);
		return NULL;
	}

	get_file(filp);

	filp_close(filp, current->files);
	return filp;
}

static int io_handler(void *data)
{
	struct vir_blk_dev* vbd = (struct vir_blk_dev *)data;
	struct bio *bio;

	allow_signal(SIGINT);
	allow_signal(SIGTERM);
	allow_signal(SIGKILL);
	allow_signal(SIGUSR1);

	set_user_nice(current, -20);
	set_fs(get_ds());

	while(!kthread_should_stop()){

		down(&vbd->sem);
		while(vbd->vbd_bio != NULL){
			spin_lock_irq(&vbd->vbd_lock);
			bio = vbd->vbd_bio;
			if(bio == vbd->vbd_biotail){
				vbd->vbd_biotail = NULL;
			}
			vbd->vbd_bio = bio->bi_next;
			bio->bi_next = NULL;
			spin_unlock_irq(&vbd->vbd_lock);

			handle_bio(vbd, bio);
		}
		up(&vbd->sem);

		wait_event_interruptible(vbd->vbd_event, (vbd->vbd_bio!=NULL) || kthread_should_stop());
	}

	down(&vbd->sem);

	/* Flush any pending bio's */
	while(vbd->vbd_bio != NULL){
		spin_lock_irq(&vbd->vbd_lock);

		bio = vbd->vbd_bio;
		if(bio == vbd->vbd_biotail)
			vbd->vbd_biotail = NULL;

		vbd->vbd_bio = bio->bi_next;
		bio->bi_next = NULL;

		spin_unlock_irq(&vbd->vbd_lock);

		bio_endio(bio, -EIO);
	}

	if(vbd->gd)
		del_gendisk(vbd->gd);

	if(vbd->rq)
		blk_cleanup_queue(vbd->rq);

	if(vbd->gd)
		put_disk(vbd->gd);

	vbd->vbd_thread = NULL;

	up(&vbd->sem);

	return 0;
}

static struct vir_blk_dev* create_vbd(int ind, const char *filename)
{
	int ro = 0;
	loff_t size = 0;
	struct file* fl;
	struct vir_blk_dev *vbd = NULL;

	fl = open_backing_file(filename, &ro, &size);
	if(fl == NULL)
		goto retnull;

	/* Check if the file is already being emulated */
	list_for_each_entry(vbd, &vbd_head, vbd_list){
		if(vbd->filp->f_path.dentry->d_name.hash == fl->f_path.dentry->d_name.hash){
			printk("File already being emulated\n");
			return NULL;
		}
	}

	vbd = vblk_alloc(ind);
	if(vbd == NULL){
		printk(KERN_ALERT "Couldn't create anymore VBD!\n");
		goto retnull;
	}

	vbd->filp = fl;
	vbd->ro = ro;

	vbd->sectspercyl_bits = NUM_SPC_BITS;
	vbd->heads_bits = NUM_HEADS_BITS;
	vbd->sect_size_bits = SECT_SIZE_BITS;
	vbd->sects = size >> (vbd->sect_size_bits);

	set_capacity(vbd->gd, vbd->sects);
	vbd->cylinders = get_capacity(vbd->gd) >> (vbd->heads_bits + vbd->sectspercyl_bits);
	spin_lock_init(&vbd->vbd_lock);
	init_MUTEX(&vbd->sem);

	/* Create a thread to handle Read/Write */
	vbd->vbd_thread = kthread_create(io_handler, vbd, "vblk%d_thread", vbd->index);
	if(IS_ERR(vbd->vbd_thread)){
		printk(KERN_ALERT "Unable to create thread for %s!\n", vbd->gd->disk_name);
		goto retnull;
	}
	wake_up_process(vbd->vbd_thread);
	printk("File(%s) is being emulated as block device %s\n", filename, vbd->gd->disk_name);
	add_disk(vbd->gd);

	return vbd;

retnull:
	if(vbd != NULL){
		if(vbd->rq != NULL)
			blk_cleanup_queue(vbd->rq);

		if(vbd->gd != NULL)
			put_disk(vbd->gd);

		kfree(vbd);
	}
	return NULL;
}

static void pdev_release(struct device *dev)
{
	return;
}

static int detach_vbd(const char *filename)
{
	struct file *filp;
	struct vir_blk_dev *next, *vbd;

	filp = filp_open(filename, O_RDONLY | O_LARGEFILE, 0);
	if(IS_ERR(filp))
		return 0;

	list_for_each_entry_safe(vbd, next, &vbd_head, vbd_list){
		if(vbd->filp->f_path.dentry->d_name.hash == filp->f_path.dentry->d_name.hash){
			if(vbd->use_count != 0){
				printk("Can't unload busy device(%s)\n", vbd->gd->disk_name);
				filp_close(filp, current->files);
				return 0;
			}
			kthread_stop(vbd->vbd_thread);
			while(vbd->vbd_thread != NULL)
				schedule();
			printk("Killed thread 'vblk%d_thread'\n", vbd->index);
			list_del(&vbd->vbd_list);
			kfree(vbd);
			filp_close(filp, current->files);
			return 1;
		}
	}
	printk("File(%s) not being emulated\n", filename);
	filp_close(filp, current->files);
	return 0;
}

static int attach_vbd(char *filename)
{
	int ind, i;
	struct vir_blk_dev *vbd = NULL;

	/* Find an available Ind */
	ind = i = 0;
	do{
		i = ind;
		list_for_each_entry(vbd, &vbd_head, vbd_list){
			if(vbd->index == ind){
				ind++;
				break;
			}
		}
	}while(ind != i);

	vbd = create_vbd(ind, filename);
	if(vbd != NULL){
		list_add_tail(&vbd->vbd_list, &vbd_head);
		return 1;
	}else{
		printk("Unable to load(%s)\n", filename);
		return 0;
	}
}

static ssize_t nodes_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	if(count>0 && buf[count-1] == '\n')
		((char *) buf)[count-1] = 0;

	if(buf[0] == '-' && detach_vbd(buf+1))
		return count;
	else if(buf[0] == '+' && attach_vbd(buf+1))
		return count;
	else
		return -EINVAL;
}

static ssize_t nodes_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	ssize_t ret = 0;
	struct vir_blk_dev *vbd;
	char *fname;

	list_for_each_entry(vbd, &vbd_head, vbd_list){
		down(&vbd->sem);
		fname = d_path(&vbd->filp->f_path, buf, PAGE_SIZE - 1);

		if(IS_ERR(fname)){
			ret = PTR_ERR(fname);
			up(&vbd->sem);
			break;
		}
		ret += sprintf(buf+ret, "%s' as '%s'\n", fname, vbd->gd->disk_name);
		up(&vbd->sem);
	}

	return ret;
}

static DEVICE_ATTR(manage, S_IRUGO|S_IWUSR, nodes_show, nodes_store);

static int __init vb_init(void)
{
	int ret = 0;
	int op_done = 0;

	ret = register_blkdev(VBD_MAJOR, VBD_NAME);
	if(ret){
		printk(KERN_NOTICE "Could not register_blkdev!\n");
		ret = -EIO;
		goto cleanup;
	}else{
		op_done |= REGBLKDEV;
	}

	vir_dev.release = pdev_release;
	if(device_register(&vir_dev)){
		ret = -EIO;
		printk(KERN_NOTICE "Could not device_register!\n");
		goto cleanup;
	}else{
		op_done |= REGPDEV;
	}

	if(device_create_file(&vir_dev, &dev_attr_manage)){
		ret = -EIO;
		printk(KERN_NOTICE "Could not device_create_file!\n");
		goto cleanup;
	}else{
		op_done |= CRTDEVFL;
	}

	return ret;

cleanup:
	if(op_done & CRTDEVFL){
		device_remove_file(&vir_dev, &dev_attr_manage);
		op_done &= ~CRTDEVFL;
	}

	if(op_done & REGPDEV){
		device_unregister(&vir_dev);
		op_done &= ~REGPDEV;
	}

	if(op_done & REGBLKDEV){
		unregister_blkdev(VBD_MAJOR, VBD_NAME);
		op_done &= ~REGBLKDEV;
	}

	return ret;
}

static void __exit vb_exit(void)
{
	struct vir_blk_dev *vbd, *next;

	list_for_each_entry_safe(vbd, next, &vbd_head, vbd_list){
		kthread_stop(vbd->vbd_thread);
		while(vbd->vbd_thread != NULL)
			schedule();
		printk("Killed thread 'vblk%d_thread'\n", vbd->index);
		list_del(&vbd->vbd_list);
		kfree(vbd);
	}

	device_remove_file(&vir_dev, &dev_attr_manage);
	device_unregister(&vir_dev);

	unregister_blkdev(VBD_MAJOR, VBD_NAME);
}

module_init(vb_init);
module_exit(vb_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A Block Device Emulator");
--------------------------8<--------------------------


 If i am not missing why this module shudn't be preferred, i would like to improve upon the code and try to contribute it back.

 Of course, please CC the replies to me too.

Regards,
Jassi


      
