Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYGNJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYGNJHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYGNJHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:07:25 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:39671 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYGNJHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:07:23 -0400
Message-ID: <487B1748.8010107@numericable.fr>
Date: Mon, 14 Jul 2008 11:07:20 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>
Subject: PATCH] block: update add_partition() error handling
Content-Type: multipart/mixed;
 boundary="------------090108040403090605030302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090108040403090605030302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello TJ,


I try your patch but it fails on apply (see check.c.X in attachment) and =

when compiling the kernel this build error occurs :l

fs/partitions/check.c:347: erreur: conflicting types for =E2=80=98add_par=
tition=E2=80=99
include/linux/genhd.h:533: erreur: previous declaration of=20
=E2=80=98add_partition=E2=80=99 was here
fs/partitions/check.c: In function =E2=80=98add_partition=E2=80=99:
fs/partitions/check.c:406: attention : =E2=80=98return=E2=80=99 with a va=
lue, in=20
function returning void
fs/partitions/check.c:412: attention : =E2=80=98return=E2=80=99 with a va=
lue, in=20
function returning void
fs/partitions/check.c: In function =E2=80=98rescan_partitions=E2=80=99:
fs/partitions/check.c:512: erreur: valeur void n'a pas =C3=A9t=C3=A9 igno=
r=C3=A9e comme=20
elle aurait d=C3=BB l'=C3=AAtre
make[2]: *** [fs/partitions/check.o] Erreur 1
make[1]: *** [fs/partitions] Erreur 2
make: *** [fs] Erreur 2

Regards.




--------------090108040403090605030302
Content-Type: text/x-csrc;
 name="check.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="check.c"

/*
 *  fs/partitions/check.c
 *
 *  Code extracted from drivers/block/genhd.c
 *  Copyright (C) 1991-1998  Linus Torvalds
 *  Re-organised Feb 1998 Russell King
 *
 *  We now have independent partition support from the
 *  block drivers, which allows all the partition code to
 *  be grouped in one location, and it to be mostly self
 *  contained.
 *
 *  Added needed MAJORS for new pairs, {hdi,hdj}, {hdk,hdl}
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/kmod.h>
#include <linux/ctype.h>
#include <linux/genhd.h>

#include "check.h"

#include "acorn.h"
#include "amiga.h"
#include "atari.h"
#include "ldm.h"
#include "mac.h"
#include "msdos.h"
#include "osf.h"
#include "sgi.h"
#include "sun.h"
#include "ibm.h"
#include "ultrix.h"
#include "efi.h"
#include "karma.h"
#include "sysv68.h"

#ifdef CONFIG_BLK_DEV_MD
extern void md_autodetect_dev(dev_t dev);
#endif

int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/

static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
	/*
	 * Probe partition formats with tables at disk address 0
	 * that also have an ADFS boot block at 0xdc0.
	 */
#ifdef CONFIG_ACORN_PARTITION_ICS
	adfspart_check_ICS,
#endif
#ifdef CONFIG_ACORN_PARTITION_POWERTEC
	adfspart_check_POWERTEC,
#endif
#ifdef CONFIG_ACORN_PARTITION_EESOX
	adfspart_check_EESOX,
#endif

	/*
	 * Now move on to formats that only have partition info at
	 * disk address 0xdc0.  Since these may also have stale
	 * PC/BIOS partition tables, they need to come before
	 * the msdos entry.
	 */
#ifdef CONFIG_ACORN_PARTITION_CUMANA
	adfspart_check_CUMANA,
#endif
#ifdef CONFIG_ACORN_PARTITION_ADFS
	adfspart_check_ADFS,
#endif

#ifdef CONFIG_EFI_PARTITION
	efi_partition,		/* this must come before msdos */
#endif
#ifdef CONFIG_SGI_PARTITION
	sgi_partition,
#endif
#ifdef CONFIG_LDM_PARTITION
	ldm_partition,		/* this must come before msdos */
#endif
#ifdef CONFIG_MSDOS_PARTITION
	msdos_partition,
#endif
#ifdef CONFIG_OSF_PARTITION
	osf_partition,
#endif
#ifdef CONFIG_SUN_PARTITION
	sun_partition,
#endif
#ifdef CONFIG_AMIGA_PARTITION
	amiga_partition,
#endif
#ifdef CONFIG_ATARI_PARTITION
	atari_partition,
#endif
#ifdef CONFIG_MAC_PARTITION
	mac_partition,
#endif
#ifdef CONFIG_ULTRIX_PARTITION
	ultrix_partition,
#endif
#ifdef CONFIG_IBM_PARTITION
	ibm_partition,
#endif
#ifdef CONFIG_KARMA_PARTITION
	karma_partition,
#endif
#ifdef CONFIG_SYSV68_PARTITION
	sysv68_partition,
#endif
	NULL
};
 
/*
 * disk_name() is used by partition check code and the genhd driver.
 * It formats the devicename of the indicated disk into
 * the supplied buffer (of size at least 32), and returns
 * a pointer to that same buffer (for convenience).
 */

char *disk_name(struct gendisk *hd, int part, char *buf)
{
	if (!part)
		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, part);
	else
		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, part);

	return buf;
}

const char *bdevname(struct block_device *bdev, char *buf)
{
	int part = MINOR(bdev->bd_dev) - bdev->bd_disk->first_minor;
	return disk_name(bdev->bd_disk, part, buf);
}

EXPORT_SYMBOL(bdevname);

/*
 * There's very little reason to use this, you should really
 * have a struct block_device just about everywhere and use
 * bdevname() instead.
 */
const char *__bdevname(dev_t dev, char *buffer)
{
	scnprintf(buffer, BDEVNAME_SIZE, "unknown-block(%u,%u)",
				MAJOR(dev), MINOR(dev));
	return buffer;
}

EXPORT_SYMBOL(__bdevname);

static struct parsed_partitions *
check_partition(struct gendisk *hd, struct block_device *bdev)
{
	struct parsed_partitions *state;
	int i, res, err;

	state = kmalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
	if (!state)
		return NULL;

	disk_name(hd, 0, state->name);
	printk(KERN_INFO " %s:", state->name);
	if (isdigit(state->name[strlen(state->name)-1]))
		sprintf(state->name, "p");

	state->limit = hd->minors;
	i = res = err = 0;
	while (!res && check_part[i]) {
		memset(&state->parts, 0, sizeof(state->parts));
		res = check_part[i++](state, bdev);
		if (res < 0) {
			/* We have hit an I/O error which we don't report now.
		 	* But record it, and let the others do their job.
		 	*/
			err = res;
			res = 0;
		}

	}
	if (res > 0)
		return state;
	if (err)
	/* The partition is unrecognized. So report I/O errors if there were any */
		res = err;
	if (!res)
		printk(" unknown partition table\n");
	else if (warn_no_part)
		printk(" unable to read partition table\n");
	kfree(state);
	return ERR_PTR(res);
}

static ssize_t part_start_show(struct device *dev,
			       struct device_attribute *attr, char *buf)
{
	struct hd_struct *p = dev_to_part(dev);

	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
}

static ssize_t part_size_show(struct device *dev,
			      struct device_attribute *attr, char *buf)
{
	struct hd_struct *p = dev_to_part(dev);
	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
}

static ssize_t part_stat_show(struct device *dev,
			      struct device_attribute *attr, char *buf)
{
	struct hd_struct *p = dev_to_part(dev);

	preempt_disable();
	part_round_stats(p);
	preempt_enable();
	return sprintf(buf,
		"%8lu %8lu %8llu %8u "
		"%8lu %8lu %8llu %8u "
		"%8u %8u %8u"
		"\n",
		part_stat_read(p, ios[READ]),
		part_stat_read(p, merges[READ]),
		(unsigned long long)part_stat_read(p, sectors[READ]),
		jiffies_to_msecs(part_stat_read(p, ticks[READ])),
		part_stat_read(p, ios[WRITE]),
		part_stat_read(p, merges[WRITE]),
		(unsigned long long)part_stat_read(p, sectors[WRITE]),
		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
		p->in_flight,
		jiffies_to_msecs(part_stat_read(p, io_ticks)),
		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
}

#ifdef CONFIG_FAIL_MAKE_REQUEST
static ssize_t part_fail_show(struct device *dev,
			      struct device_attribute *attr, char *buf)
{
	struct hd_struct *p = dev_to_part(dev);

	return sprintf(buf, "%d\n", p->make_it_fail);
}

static ssize_t part_fail_store(struct device *dev,
			       struct device_attribute *attr,
			       const char *buf, size_t count)
{
	struct hd_struct *p = dev_to_part(dev);
	int i;

	if (count > 0 && sscanf(buf, "%d", &i) > 0)
		p->make_it_fail = (i == 0) ? 0 : 1;

	return count;
}
#endif

static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
#ifdef CONFIG_FAIL_MAKE_REQUEST
static struct device_attribute dev_attr_fail =
	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
#endif

static struct attribute *part_attrs[] = {
	&dev_attr_start.attr,
	&dev_attr_size.attr,
	&dev_attr_stat.attr,
#ifdef CONFIG_FAIL_MAKE_REQUEST
	&dev_attr_fail.attr,
#endif
	NULL
};

static struct attribute_group part_attr_group = {
	.attrs = part_attrs,
};

static struct attribute_group *part_attr_groups[] = {
	&part_attr_group,
	NULL
};

static void part_release(struct device *dev)
{
	struct hd_struct *p = dev_to_part(dev);
	free_part_stats(p);
	kfree(p);
}

struct device_type part_type = {
	.name		= "partition",
	.groups		= part_attr_groups,
	.release	= part_release,
};

static inline void partition_sysfs_add_subdir(struct hd_struct *p)
{
	struct kobject *k;

	k = kobject_get(&p->dev.kobj);
	p->holder_dir = kobject_create_and_add("holders", k);
	kobject_put(k);
}

static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
{
	struct kobject *k;

	k = kobject_get(&disk->dev.kobj);
	disk->holder_dir = kobject_create_and_add("holders", k);
	disk->slave_dir = kobject_create_and_add("slaves", k);
	kobject_put(k);
}

void delete_partition(struct gendisk *disk, int part)
{
	struct hd_struct *p = disk->part[part-1];

	if (!p)
		return;
	if (!p->nr_sects)
		return;
	disk->part[part-1] = NULL;
	p->start_sect = 0;
	p->nr_sects = 0;
	part_stat_set_all(p, 0);
	kobject_put(p->holder_dir);
	device_del(&p->dev);
	put_device(&p->dev);
}

static ssize_t whole_disk_show(struct device *dev,
			       struct device_attribute *attr, char *buf)
{
	return 0;
}
static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
		   whole_disk_show, NULL);

void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
{
	char name[BDEVNAME_SIZE];
	struct hd_struct *p;
	int err;

	disk_name(disk, part, name);

	p = kzalloc(sizeof(*p), GFP_KERNEL);
	if (!p) {
		printk(KERN_WARNING "%s: failed to allocate partition "
		       "structure (part=%d)\n", name, part);
		return;
	}

	if (!init_part_stats(p)) {
		printk(KERN_WARNING "%s: failed to initialize partition stats "
		       "structure (part=%d)\n", name, part);
		kfree(p);
		return;
	}
	p->start_sect = start;
	p->nr_sects = len;
	p->disk = disk;
	p->partno = part;
	p->policy = disk->policy;

	if (isdigit(disk->dev.bus_id[strlen(disk->dev.bus_id)-1]))
		snprintf(p->dev.bus_id, BUS_ID_SIZE,
		"%sp%d", disk->dev.bus_id, part);
	else
		snprintf(p->dev.bus_id, BUS_ID_SIZE,
			 "%s%d", disk->dev.bus_id, part);

	device_initialize(&p->dev);
	p->dev.devt = MKDEV(disk->major, disk->first_minor + part);
	p->dev.class = &block_class;
	p->dev.type = &part_type;
	p->dev.parent = &disk->dev;
	disk->part[part-1] = p;

	/* delay uevent until 'holders' subdir is created */
	p->dev.uevent_suppress = 1;
	err = device_add(&p->dev);
	if (err)
		goto fail;

	partition_sysfs_add_subdir(p);
	p->dev.uevent_suppress = 0;
	if (flags & ADDPART_FLAG_WHOLEDISK) {
		err = device_create_file(&p->dev, &dev_attr_whole_disk);
		printk(" %s: failed to create sysfs attrs (%d)\n",
		       dev_name(&p->dev), err);
	}

	/* suppress uevent if the disk supresses it */
	if (!disk->dev.uevent_suppress)
		kobject_uevent(&p->dev.kobj, KOBJ_ADD);

	return 0;

 fail:
	if (p)
		free_part_stats(p);
	kfree(p);
	return err;
}

/* Not exported, helper to add_disk(). */
void register_disk(struct gendisk *disk)
{
	struct block_device *bdev;
	char *s;
	int i;
	struct hd_struct *p;
	int err;

	disk->dev.parent = disk->driverfs_dev;
	disk->dev.devt = MKDEV(disk->major, disk->first_minor);

	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
	/* ewww... some of these buggers have / in the name... */
	s = strchr(disk->dev.bus_id, '/');
	if (s)
		*s = '!';

	/* delay uevents, until we scanned partition table */
	disk->dev.uevent_suppress = 1;

	if (device_add(&disk->dev))
		return;
#ifndef CONFIG_SYSFS_DEPRECATED
	err = sysfs_create_link(block_depr, &disk->dev.kobj,
				kobject_name(&disk->dev.kobj));
	if (err) {
		device_del(&disk->dev);
		return;
	}
#endif
	disk_sysfs_add_subdirs(disk);

	/* No minors to use for partitions */
	if (disk->minors == 1)
		goto exit;

	/* No such device (e.g., media were just removed) */
	if (!get_capacity(disk))
		goto exit;

	bdev = bdget_disk(disk, 0);
	if (!bdev)
		goto exit;

	bdev->bd_invalidated = 1;
	err = blkdev_get(bdev, FMODE_READ, 0);
	if (err < 0)
		goto exit;
	blkdev_put(bdev);

exit:
	/* announce disk after possible partitions are created */
	disk->dev.uevent_suppress = 0;
	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);

	/* announce possible partitions */
	for (i = 1; i < disk->minors; i++) {
		p = disk->part[i-1];
		if (!p || !p->nr_sects)
			continue;
		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
	}
}

int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
{
	struct parsed_partitions *state;
	int p, res;

	if (bdev->bd_part_count)
		return -EBUSY;
	res = invalidate_partition(disk, 0);
	if (res)
		return res;
	bdev->bd_invalidated = 0;
	for (p = 1; p < disk->minors; p++)
		delete_partition(disk, p);
	if (disk->fops->revalidate_disk)
		disk->fops->revalidate_disk(disk);
	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
		return 0;
	if (IS_ERR(state))	/* I/O error reading the partition table */
		return -EIO;

	/* tell userspace that the media / partition table may have changed */
	kobject_uevent(&disk->dev.kobj, KOBJ_CHANGE);

	for (p = 1; p < state->limit; p++) {
		sector_t size = state->parts[p].size;
		sector_t from = state->parts[p].from;
		if (!size)
			continue;
		if (from + size > get_capacity(disk)) {
			printk(" %s: p%d exceeds device capacity\n",
				disk->disk_name, p);
		}
		res = add_partition(disk, p, from, size, state->parts[p].flags);
		if (res) {
			printk(" %s: failed to add p%d (%d)\n",
			       disk->disk_name, p, res);
			continue;
		}
#ifdef CONFIG_BLK_DEV_MD
		if (state->parts[p].flags & ADDPART_FLAG_RAID)
			md_autodetect_dev(bdev->bd_dev+p);
#endif
	}
	kfree(state);
	return 0;
}

unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
{
	struct address_space *mapping = bdev->bd_inode->i_mapping;
	struct page *page;

	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
				 NULL);
	if (!IS_ERR(page)) {
		if (PageError(page))
			goto fail;
		p->v = page;
		return (unsigned char *)page_address(page) +  ((n & ((1 << (PAGE_CACHE_SHIFT - 9)) - 1)) << 9);
fail:
		page_cache_release(page);
	}
	p->v = NULL;
	return NULL;
}

EXPORT_SYMBOL(read_dev_sector);

void del_gendisk(struct gendisk *disk)
{
	int p;

	/* invalidate stuff */
	for (p = disk->minors - 1; p > 0; p--) {
		invalidate_partition(disk, p);
		delete_partition(disk, p);
	}
	invalidate_partition(disk, 0);
	disk->capacity = 0;
	disk->flags &= ~GENHD_FL_UP;
	unlink_gendisk(disk);
	disk_stat_set_all(disk, 0);
	disk->stamp = 0;

	kobject_put(disk->holder_dir);
	kobject_put(disk->slave_dir);
	disk->driverfs_dev = NULL;
#ifndef CONFIG_SYSFS_DEPRECATED
	sysfs_remove_link(block_depr, disk->dev.bus_id);
#endif
	device_del(&disk->dev);
}

--------------090108040403090605030302
Content-Type: text/plain;
 name="check.c.orig"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="check.c.orig"

LyoKICogIGZzL3BhcnRpdGlvbnMvY2hlY2suYwogKgogKiAgQ29kZSBleHRyYWN0ZWQgZnJv
bSBkcml2ZXJzL2Jsb2NrL2dlbmhkLmMKICogIENvcHlyaWdodCAoQykgMTk5MS0xOTk4ICBM
aW51cyBUb3J2YWxkcwogKiAgUmUtb3JnYW5pc2VkIEZlYiAxOTk4IFJ1c3NlbGwgS2luZwog
KgogKiAgV2Ugbm93IGhhdmUgaW5kZXBlbmRlbnQgcGFydGl0aW9uIHN1cHBvcnQgZnJvbSB0
aGUKICogIGJsb2NrIGRyaXZlcnMsIHdoaWNoIGFsbG93cyBhbGwgdGhlIHBhcnRpdGlvbiBj
b2RlIHRvCiAqICBiZSBncm91cGVkIGluIG9uZSBsb2NhdGlvbiwgYW5kIGl0IHRvIGJlIG1v
c3RseSBzZWxmCiAqICBjb250YWluZWQuCiAqCiAqICBBZGRlZCBuZWVkZWQgTUFKT1JTIGZv
ciBuZXcgcGFpcnMsIHtoZGksaGRqfSwge2hkayxoZGx9CiAqLwoKI2luY2x1ZGUgPGxpbnV4
L2luaXQuaD4KI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgojaW5jbHVkZSA8bGludXgvZnMu
aD4KI2luY2x1ZGUgPGxpbnV4L2ttb2QuaD4KI2luY2x1ZGUgPGxpbnV4L2N0eXBlLmg+CiNp
bmNsdWRlIDxsaW51eC9nZW5oZC5oPgoKI2luY2x1ZGUgImNoZWNrLmgiCgojaW5jbHVkZSAi
YWNvcm4uaCIKI2luY2x1ZGUgImFtaWdhLmgiCiNpbmNsdWRlICJhdGFyaS5oIgojaW5jbHVk
ZSAibGRtLmgiCiNpbmNsdWRlICJtYWMuaCIKI2luY2x1ZGUgIm1zZG9zLmgiCiNpbmNsdWRl
ICJvc2YuaCIKI2luY2x1ZGUgInNnaS5oIgojaW5jbHVkZSAic3VuLmgiCiNpbmNsdWRlICJp
Ym0uaCIKI2luY2x1ZGUgInVsdHJpeC5oIgojaW5jbHVkZSAiZWZpLmgiCiNpbmNsdWRlICJr
YXJtYS5oIgojaW5jbHVkZSAic3lzdjY4LmgiCgojaWZkZWYgQ09ORklHX0JMS19ERVZfTUQK
ZXh0ZXJuIHZvaWQgbWRfYXV0b2RldGVjdF9kZXYoZGV2X3QgZGV2KTsKI2VuZGlmCgppbnQg
d2Fybl9ub19wYXJ0ID0gMTsgLypUaGlzIGlzIHVnbHk6IHNob3VsZCBtYWtlIGdlbmhkIHJl
bW92YWJsZSBtZWRpYSBhd2FyZSovCgpzdGF0aWMgaW50ICgqY2hlY2tfcGFydFtdKShzdHJ1
Y3QgcGFyc2VkX3BhcnRpdGlvbnMgKiwgc3RydWN0IGJsb2NrX2RldmljZSAqKSA9IHsKCS8q
CgkgKiBQcm9iZSBwYXJ0aXRpb24gZm9ybWF0cyB3aXRoIHRhYmxlcyBhdCBkaXNrIGFkZHJl
c3MgMAoJICogdGhhdCBhbHNvIGhhdmUgYW4gQURGUyBib290IGJsb2NrIGF0IDB4ZGMwLgoJ
ICovCiNpZmRlZiBDT05GSUdfQUNPUk5fUEFSVElUSU9OX0lDUwoJYWRmc3BhcnRfY2hlY2tf
SUNTLAojZW5kaWYKI2lmZGVmIENPTkZJR19BQ09STl9QQVJUSVRJT05fUE9XRVJURUMKCWFk
ZnNwYXJ0X2NoZWNrX1BPV0VSVEVDLAojZW5kaWYKI2lmZGVmIENPTkZJR19BQ09STl9QQVJU
SVRJT05fRUVTT1gKCWFkZnNwYXJ0X2NoZWNrX0VFU09YLAojZW5kaWYKCgkvKgoJICogTm93
IG1vdmUgb24gdG8gZm9ybWF0cyB0aGF0IG9ubHkgaGF2ZSBwYXJ0aXRpb24gaW5mbyBhdAoJ
ICogZGlzayBhZGRyZXNzIDB4ZGMwLiAgU2luY2UgdGhlc2UgbWF5IGFsc28gaGF2ZSBzdGFs
ZQoJICogUEMvQklPUyBwYXJ0aXRpb24gdGFibGVzLCB0aGV5IG5lZWQgdG8gY29tZSBiZWZv
cmUKCSAqIHRoZSBtc2RvcyBlbnRyeS4KCSAqLwojaWZkZWYgQ09ORklHX0FDT1JOX1BBUlRJ
VElPTl9DVU1BTkEKCWFkZnNwYXJ0X2NoZWNrX0NVTUFOQSwKI2VuZGlmCiNpZmRlZiBDT05G
SUdfQUNPUk5fUEFSVElUSU9OX0FERlMKCWFkZnNwYXJ0X2NoZWNrX0FERlMsCiNlbmRpZgoK
I2lmZGVmIENPTkZJR19FRklfUEFSVElUSU9OCgllZmlfcGFydGl0aW9uLAkJLyogdGhpcyBt
dXN0IGNvbWUgYmVmb3JlIG1zZG9zICovCiNlbmRpZgojaWZkZWYgQ09ORklHX1NHSV9QQVJU
SVRJT04KCXNnaV9wYXJ0aXRpb24sCiNlbmRpZgojaWZkZWYgQ09ORklHX0xETV9QQVJUSVRJ
T04KCWxkbV9wYXJ0aXRpb24sCQkvKiB0aGlzIG11c3QgY29tZSBiZWZvcmUgbXNkb3MgKi8K
I2VuZGlmCiNpZmRlZiBDT05GSUdfTVNET1NfUEFSVElUSU9OCgltc2Rvc19wYXJ0aXRpb24s
CiNlbmRpZgojaWZkZWYgQ09ORklHX09TRl9QQVJUSVRJT04KCW9zZl9wYXJ0aXRpb24sCiNl
bmRpZgojaWZkZWYgQ09ORklHX1NVTl9QQVJUSVRJT04KCXN1bl9wYXJ0aXRpb24sCiNlbmRp
ZgojaWZkZWYgQ09ORklHX0FNSUdBX1BBUlRJVElPTgoJYW1pZ2FfcGFydGl0aW9uLAojZW5k
aWYKI2lmZGVmIENPTkZJR19BVEFSSV9QQVJUSVRJT04KCWF0YXJpX3BhcnRpdGlvbiwKI2Vu
ZGlmCiNpZmRlZiBDT05GSUdfTUFDX1BBUlRJVElPTgoJbWFjX3BhcnRpdGlvbiwKI2VuZGlm
CiNpZmRlZiBDT05GSUdfVUxUUklYX1BBUlRJVElPTgoJdWx0cml4X3BhcnRpdGlvbiwKI2Vu
ZGlmCiNpZmRlZiBDT05GSUdfSUJNX1BBUlRJVElPTgoJaWJtX3BhcnRpdGlvbiwKI2VuZGlm
CiNpZmRlZiBDT05GSUdfS0FSTUFfUEFSVElUSU9OCglrYXJtYV9wYXJ0aXRpb24sCiNlbmRp
ZgojaWZkZWYgQ09ORklHX1NZU1Y2OF9QQVJUSVRJT04KCXN5c3Y2OF9wYXJ0aXRpb24sCiNl
bmRpZgoJTlVMTAp9OwogCi8qCiAqIGRpc2tfbmFtZSgpIGlzIHVzZWQgYnkgcGFydGl0aW9u
IGNoZWNrIGNvZGUgYW5kIHRoZSBnZW5oZCBkcml2ZXIuCiAqIEl0IGZvcm1hdHMgdGhlIGRl
dmljZW5hbWUgb2YgdGhlIGluZGljYXRlZCBkaXNrIGludG8KICogdGhlIHN1cHBsaWVkIGJ1
ZmZlciAob2Ygc2l6ZSBhdCBsZWFzdCAzMiksIGFuZCByZXR1cm5zCiAqIGEgcG9pbnRlciB0
byB0aGF0IHNhbWUgYnVmZmVyIChmb3IgY29udmVuaWVuY2UpLgogKi8KCmNoYXIgKmRpc2tf
bmFtZShzdHJ1Y3QgZ2VuZGlzayAqaGQsIGludCBwYXJ0LCBjaGFyICpidWYpCnsKCWlmICgh
cGFydCkKCQlzbnByaW50ZihidWYsIEJERVZOQU1FX1NJWkUsICIlcyIsIGhkLT5kaXNrX25h
bWUpOwoJZWxzZSBpZiAoaXNkaWdpdChoZC0+ZGlza19uYW1lW3N0cmxlbihoZC0+ZGlza19u
YW1lKS0xXSkpCgkJc25wcmludGYoYnVmLCBCREVWTkFNRV9TSVpFLCAiJXNwJWQiLCBoZC0+
ZGlza19uYW1lLCBwYXJ0KTsKCWVsc2UKCQlzbnByaW50ZihidWYsIEJERVZOQU1FX1NJWkUs
ICIlcyVkIiwgaGQtPmRpc2tfbmFtZSwgcGFydCk7CgoJcmV0dXJuIGJ1ZjsKfQoKY29uc3Qg
Y2hhciAqYmRldm5hbWUoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgY2hhciAqYnVmKQp7
CglpbnQgcGFydCA9IE1JTk9SKGJkZXYtPmJkX2RldikgLSBiZGV2LT5iZF9kaXNrLT5maXJz
dF9taW5vcjsKCXJldHVybiBkaXNrX25hbWUoYmRldi0+YmRfZGlzaywgcGFydCwgYnVmKTsK
fQoKRVhQT1JUX1NZTUJPTChiZGV2bmFtZSk7CgovKgogKiBUaGVyZSdzIHZlcnkgbGl0dGxl
IHJlYXNvbiB0byB1c2UgdGhpcywgeW91IHNob3VsZCByZWFsbHkKICogaGF2ZSBhIHN0cnVj
dCBibG9ja19kZXZpY2UganVzdCBhYm91dCBldmVyeXdoZXJlIGFuZCB1c2UKICogYmRldm5h
bWUoKSBpbnN0ZWFkLgogKi8KY29uc3QgY2hhciAqX19iZGV2bmFtZShkZXZfdCBkZXYsIGNo
YXIgKmJ1ZmZlcikKewoJc2NucHJpbnRmKGJ1ZmZlciwgQkRFVk5BTUVfU0laRSwgInVua25v
d24tYmxvY2soJXUsJXUpIiwKCQkJCU1BSk9SKGRldiksIE1JTk9SKGRldikpOwoJcmV0dXJu
IGJ1ZmZlcjsKfQoKRVhQT1JUX1NZTUJPTChfX2JkZXZuYW1lKTsKCnN0YXRpYyBzdHJ1Y3Qg
cGFyc2VkX3BhcnRpdGlvbnMgKgpjaGVja19wYXJ0aXRpb24oc3RydWN0IGdlbmRpc2sgKmhk
LCBzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2KQp7CglzdHJ1Y3QgcGFyc2VkX3BhcnRpdGlv
bnMgKnN0YXRlOwoJaW50IGksIHJlcywgZXJyOwoKCXN0YXRlID0ga21hbGxvYyhzaXplb2Yo
c3RydWN0IHBhcnNlZF9wYXJ0aXRpb25zKSwgR0ZQX0tFUk5FTCk7CglpZiAoIXN0YXRlKQoJ
CXJldHVybiBOVUxMOwoKCWRpc2tfbmFtZShoZCwgMCwgc3RhdGUtPm5hbWUpOwoJcHJpbnRr
KEtFUk5fSU5GTyAiICVzOiIsIHN0YXRlLT5uYW1lKTsKCWlmIChpc2RpZ2l0KHN0YXRlLT5u
YW1lW3N0cmxlbihzdGF0ZS0+bmFtZSktMV0pKQoJCXNwcmludGYoc3RhdGUtPm5hbWUsICJw
Iik7CgoJc3RhdGUtPmxpbWl0ID0gaGQtPm1pbm9yczsKCWkgPSByZXMgPSBlcnIgPSAwOwoJ
d2hpbGUgKCFyZXMgJiYgY2hlY2tfcGFydFtpXSkgewoJCW1lbXNldCgmc3RhdGUtPnBhcnRz
LCAwLCBzaXplb2Yoc3RhdGUtPnBhcnRzKSk7CgkJcmVzID0gY2hlY2tfcGFydFtpKytdKHN0
YXRlLCBiZGV2KTsKCQlpZiAocmVzIDwgMCkgewoJCQkvKiBXZSBoYXZlIGhpdCBhbiBJL08g
ZXJyb3Igd2hpY2ggd2UgZG9uJ3QgcmVwb3J0IG5vdy4KCQkgCSogQnV0IHJlY29yZCBpdCwg
YW5kIGxldCB0aGUgb3RoZXJzIGRvIHRoZWlyIGpvYi4KCQkgCSovCgkJCWVyciA9IHJlczsK
CQkJcmVzID0gMDsKCQl9CgoJfQoJaWYgKHJlcyA+IDApCgkJcmV0dXJuIHN0YXRlOwoJaWYg
KGVycikKCS8qIFRoZSBwYXJ0aXRpb24gaXMgdW5yZWNvZ25pemVkLiBTbyByZXBvcnQgSS9P
IGVycm9ycyBpZiB0aGVyZSB3ZXJlIGFueSAqLwoJCXJlcyA9IGVycjsKCWlmICghcmVzKQoJ
CXByaW50aygiIHVua25vd24gcGFydGl0aW9uIHRhYmxlXG4iKTsKCWVsc2UgaWYgKHdhcm5f
bm9fcGFydCkKCQlwcmludGsoIiB1bmFibGUgdG8gcmVhZCBwYXJ0aXRpb24gdGFibGVcbiIp
OwoJa2ZyZWUoc3RhdGUpOwoJcmV0dXJuIEVSUl9QVFIocmVzKTsKfQoKc3RhdGljIHNzaXpl
X3QgcGFydF9zdGFydF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKCQkJICAgICAgIHN0cnVj
dCBkZXZpY2VfYXR0cmlidXRlICphdHRyLCBjaGFyICpidWYpCnsKCXN0cnVjdCBoZF9zdHJ1
Y3QgKnAgPSBkZXZfdG9fcGFydChkZXYpOwoKCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVsbHVc
biIsKHVuc2lnbmVkIGxvbmcgbG9uZylwLT5zdGFydF9zZWN0KTsKfQoKc3RhdGljIHNzaXpl
X3QgcGFydF9zaXplX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAoJCQkgICAgICBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQp7CglzdHJ1Y3QgaGRfc3RydWN0
ICpwID0gZGV2X3RvX3BhcnQoZGV2KTsKCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVsbHVcbiIs
KHVuc2lnbmVkIGxvbmcgbG9uZylwLT5ucl9zZWN0cyk7Cn0KCnN0YXRpYyBzc2l6ZV90IHBh
cnRfc3RhdF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKCQkJICAgICAgc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikKewoJc3RydWN0IGhkX3N0cnVjdCAqcCA9
IGRldl90b19wYXJ0KGRldik7CgoJcHJlZW1wdF9kaXNhYmxlKCk7CglwYXJ0X3JvdW5kX3N0
YXRzKHApOwoJcHJlZW1wdF9lbmFibGUoKTsKCXJldHVybiBzcHJpbnRmKGJ1ZiwKCQkiJThs
dSAlOGx1ICU4bGx1ICU4dSAiCgkJIiU4bHUgJThsdSAlOGxsdSAlOHUgIgoJCSIlOHUgJTh1
ICU4dSIKCQkiXG4iLAoJCXBhcnRfc3RhdF9yZWFkKHAsIGlvc1tSRUFEXSksCgkJcGFydF9z
dGF0X3JlYWQocCwgbWVyZ2VzW1JFQURdKSwKCQkodW5zaWduZWQgbG9uZyBsb25nKXBhcnRf
c3RhdF9yZWFkKHAsIHNlY3RvcnNbUkVBRF0pLAoJCWppZmZpZXNfdG9fbXNlY3MocGFydF9z
dGF0X3JlYWQocCwgdGlja3NbUkVBRF0pKSwKCQlwYXJ0X3N0YXRfcmVhZChwLCBpb3NbV1JJ
VEVdKSwKCQlwYXJ0X3N0YXRfcmVhZChwLCBtZXJnZXNbV1JJVEVdKSwKCQkodW5zaWduZWQg
bG9uZyBsb25nKXBhcnRfc3RhdF9yZWFkKHAsIHNlY3RvcnNbV1JJVEVdKSwKCQlqaWZmaWVz
X3RvX21zZWNzKHBhcnRfc3RhdF9yZWFkKHAsIHRpY2tzW1dSSVRFXSkpLAoJCXAtPmluX2Zs
aWdodCwKCQlqaWZmaWVzX3RvX21zZWNzKHBhcnRfc3RhdF9yZWFkKHAsIGlvX3RpY2tzKSks
CgkJamlmZmllc190b19tc2VjcyhwYXJ0X3N0YXRfcmVhZChwLCB0aW1lX2luX3F1ZXVlKSkp
Owp9CgojaWZkZWYgQ09ORklHX0ZBSUxfTUFLRV9SRVFVRVNUCnN0YXRpYyBzc2l6ZV90IHBh
cnRfZmFpbF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKCQkJICAgICAgc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikKewoJc3RydWN0IGhkX3N0cnVjdCAqcCA9
IGRldl90b19wYXJ0KGRldik7CgoJcmV0dXJuIHNwcmludGYoYnVmLCAiJWRcbiIsIHAtPm1h
a2VfaXRfZmFpbCk7Cn0KCnN0YXRpYyBzc2l6ZV90IHBhcnRfZmFpbF9zdG9yZShzdHJ1Y3Qg
ZGV2aWNlICpkZXYsCgkJCSAgICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwK
CQkJICAgICAgIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQp7CglzdHJ1Y3QgaGRf
c3RydWN0ICpwID0gZGV2X3RvX3BhcnQoZGV2KTsKCWludCBpOwoKCWlmIChjb3VudCA+IDAg
JiYgc3NjYW5mKGJ1ZiwgIiVkIiwgJmkpID4gMCkKCQlwLT5tYWtlX2l0X2ZhaWwgPSAoaSA9
PSAwKSA/IDAgOiAxOwoKCXJldHVybiBjb3VudDsKfQojZW5kaWYKCnN0YXRpYyBERVZJQ0Vf
QVRUUihzdGFydCwgU19JUlVHTywgcGFydF9zdGFydF9zaG93LCBOVUxMKTsKc3RhdGljIERF
VklDRV9BVFRSKHNpemUsIFNfSVJVR08sIHBhcnRfc2l6ZV9zaG93LCBOVUxMKTsKc3RhdGlj
IERFVklDRV9BVFRSKHN0YXQsIFNfSVJVR08sIHBhcnRfc3RhdF9zaG93LCBOVUxMKTsKI2lm
ZGVmIENPTkZJR19GQUlMX01BS0VfUkVRVUVTVApzdGF0aWMgc3RydWN0IGRldmljZV9hdHRy
aWJ1dGUgZGV2X2F0dHJfZmFpbCA9CglfX0FUVFIobWFrZS1pdC1mYWlsLCBTX0lSVUdPfFNf
SVdVU1IsIHBhcnRfZmFpbF9zaG93LCBwYXJ0X2ZhaWxfc3RvcmUpOwojZW5kaWYKCnN0YXRp
YyBzdHJ1Y3QgYXR0cmlidXRlICpwYXJ0X2F0dHJzW10gPSB7CgkmZGV2X2F0dHJfc3RhcnQu
YXR0ciwKCSZkZXZfYXR0cl9zaXplLmF0dHIsCgkmZGV2X2F0dHJfc3RhdC5hdHRyLAojaWZk
ZWYgQ09ORklHX0ZBSUxfTUFLRV9SRVFVRVNUCgkmZGV2X2F0dHJfZmFpbC5hdHRyLAojZW5k
aWYKCU5VTEwKfTsKCnN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwIHBhcnRfYXR0cl9n
cm91cCA9IHsKCS5hdHRycyA9IHBhcnRfYXR0cnMsCn07CgpzdGF0aWMgc3RydWN0IGF0dHJp
YnV0ZV9ncm91cCAqcGFydF9hdHRyX2dyb3Vwc1tdID0gewoJJnBhcnRfYXR0cl9ncm91cCwK
CU5VTEwKfTsKCnN0YXRpYyB2b2lkIHBhcnRfcmVsZWFzZShzdHJ1Y3QgZGV2aWNlICpkZXYp
CnsKCXN0cnVjdCBoZF9zdHJ1Y3QgKnAgPSBkZXZfdG9fcGFydChkZXYpOwoJZnJlZV9wYXJ0
X3N0YXRzKHApOwoJa2ZyZWUocCk7Cn0KCnN0cnVjdCBkZXZpY2VfdHlwZSBwYXJ0X3R5cGUg
PSB7CgkubmFtZQkJPSAicGFydGl0aW9uIiwKCS5ncm91cHMJCT0gcGFydF9hdHRyX2dyb3Vw
cywKCS5yZWxlYXNlCT0gcGFydF9yZWxlYXNlLAp9OwoKc3RhdGljIGlubGluZSB2b2lkIHBh
cnRpdGlvbl9zeXNmc19hZGRfc3ViZGlyKHN0cnVjdCBoZF9zdHJ1Y3QgKnApCnsKCXN0cnVj
dCBrb2JqZWN0ICprOwoKCWsgPSBrb2JqZWN0X2dldCgmcC0+ZGV2LmtvYmopOwoJcC0+aG9s
ZGVyX2RpciA9IGtvYmplY3RfY3JlYXRlX2FuZF9hZGQoImhvbGRlcnMiLCBrKTsKCWtvYmpl
Y3RfcHV0KGspOwp9CgpzdGF0aWMgaW5saW5lIHZvaWQgZGlza19zeXNmc19hZGRfc3ViZGly
cyhzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKewoJc3RydWN0IGtvYmplY3QgKms7CgoJayA9IGtv
YmplY3RfZ2V0KCZkaXNrLT5kZXYua29iaik7CglkaXNrLT5ob2xkZXJfZGlyID0ga29iamVj
dF9jcmVhdGVfYW5kX2FkZCgiaG9sZGVycyIsIGspOwoJZGlzay0+c2xhdmVfZGlyID0ga29i
amVjdF9jcmVhdGVfYW5kX2FkZCgic2xhdmVzIiwgayk7Cglrb2JqZWN0X3B1dChrKTsKfQoK
dm9pZCBkZWxldGVfcGFydGl0aW9uKHN0cnVjdCBnZW5kaXNrICpkaXNrLCBpbnQgcGFydCkK
ewoJc3RydWN0IGhkX3N0cnVjdCAqcCA9IGRpc2stPnBhcnRbcGFydC0xXTsKCglpZiAoIXAp
CgkJcmV0dXJuOwoJaWYgKCFwLT5ucl9zZWN0cykKCQlyZXR1cm47CglkaXNrLT5wYXJ0W3Bh
cnQtMV0gPSBOVUxMOwoJcC0+c3RhcnRfc2VjdCA9IDA7CglwLT5ucl9zZWN0cyA9IDA7Cglw
YXJ0X3N0YXRfc2V0X2FsbChwLCAwKTsKCWtvYmplY3RfcHV0KHAtPmhvbGRlcl9kaXIpOwoJ
ZGV2aWNlX2RlbCgmcC0+ZGV2KTsKCXB1dF9kZXZpY2UoJnAtPmRldik7Cn0KCnN0YXRpYyBz
c2l6ZV90IHdob2xlX2Rpc2tfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsCgkJCSAgICAgICBz
dHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQp7CglyZXR1cm4gMDsK
fQpzdGF0aWMgREVWSUNFX0FUVFIod2hvbGVfZGlzaywgU19JUlVTUiB8IFNfSVJHUlAgfCBT
X0lST1RILAoJCSAgIHdob2xlX2Rpc2tfc2hvdywgTlVMTCk7Cgp2b2lkIGFkZF9wYXJ0aXRp
b24oc3RydWN0IGdlbmRpc2sgKmRpc2ssIGludCBwYXJ0LCBzZWN0b3JfdCBzdGFydCwgc2Vj
dG9yX3QgbGVuLCBpbnQgZmxhZ3MpCnsKCWNoYXIgbmFtZVtCREVWTkFNRV9TSVpFXTsKCXN0
cnVjdCBoZF9zdHJ1Y3QgKnA7CglpbnQgZXJyOwoKCWRpc2tfbmFtZShkaXNrLCBwYXJ0LCBu
YW1lKTsKCglwID0ga3phbGxvYyhzaXplb2YoKnApLCBHRlBfS0VSTkVMKTsKCWlmICghcCkg
ewoJCXByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiBmYWlsZWQgdG8gYWxsb2NhdGUgcGFydGl0
aW9uICIKCQkgICAgICAgInN0cnVjdHVyZSAocGFydD0lZClcbiIsIG5hbWUsIHBhcnQpOwoJ
CXJldHVybjsKCX0KCglpZiAoIWluaXRfcGFydF9zdGF0cyhwKSkgewoJCXByaW50ayhLRVJO
X1dBUk5JTkcgIiVzOiBmYWlsZWQgdG8gaW5pdGlhbGl6ZSBwYXJ0aXRpb24gc3RhdHMgIgoJ
CSAgICAgICAic3RydWN0dXJlIChwYXJ0PSVkKVxuIiwgbmFtZSwgcGFydCk7CgkJa2ZyZWUo
cCk7CgkJcmV0dXJuOwoJfQoJcC0+c3RhcnRfc2VjdCA9IHN0YXJ0OwoJcC0+bnJfc2VjdHMg
PSBsZW47CglwLT5kaXNrID0gZGlzazsKCXAtPnBhcnRubyA9IHBhcnQ7CglwLT5wb2xpY3kg
PSBkaXNrLT5wb2xpY3k7CgoJaWYgKGlzZGlnaXQoZGlzay0+ZGV2LmJ1c19pZFtzdHJsZW4o
ZGlzay0+ZGV2LmJ1c19pZCktMV0pKQoJCXNucHJpbnRmKHAtPmRldi5idXNfaWQsIEJVU19J
RF9TSVpFLAoJCSIlc3AlZCIsIGRpc2stPmRldi5idXNfaWQsIHBhcnQpOwoJZWxzZQoJCXNu
cHJpbnRmKHAtPmRldi5idXNfaWQsIEJVU19JRF9TSVpFLAoJCQkgIiVzJWQiLCBkaXNrLT5k
ZXYuYnVzX2lkLCBwYXJ0KTsKCglkZXZpY2VfaW5pdGlhbGl6ZSgmcC0+ZGV2KTsKCXAtPmRl
di5kZXZ0ID0gTUtERVYoZGlzay0+bWFqb3IsIGRpc2stPmZpcnN0X21pbm9yICsgcGFydCk7
CglwLT5kZXYuY2xhc3MgPSAmYmxvY2tfY2xhc3M7CglwLT5kZXYudHlwZSA9ICZwYXJ0X3R5
cGU7CglwLT5kZXYucGFyZW50ID0gJmRpc2stPmRldjsKCWRpc2stPnBhcnRbcGFydC0xXSA9
IHA7CgoJLyogZGVsYXkgdWV2ZW50IHVudGlsICdob2xkZXJzJyBzdWJkaXIgaXMgY3JlYXRl
ZCAqLwoJcC0+ZGV2LnVldmVudF9zdXBwcmVzcyA9IDE7CglkZXZpY2VfYWRkKCZwLT5kZXYp
OwoJcGFydGl0aW9uX3N5c2ZzX2FkZF9zdWJkaXIocCk7CglwLT5kZXYudWV2ZW50X3N1cHBy
ZXNzID0gMDsKCWlmIChmbGFncyAmIEFERFBBUlRfRkxBR19XSE9MRURJU0spCgkJZXJyID0g
ZGV2aWNlX2NyZWF0ZV9maWxlKCZwLT5kZXYsICZkZXZfYXR0cl93aG9sZV9kaXNrKTsKCgkv
KiBzdXBwcmVzcyB1ZXZlbnQgaWYgdGhlIGRpc2sgc3VwcmVzc2VzIGl0ICovCglpZiAoIWRp
c2stPmRldi51ZXZlbnRfc3VwcHJlc3MpCgkJa29iamVjdF91ZXZlbnQoJnAtPmRldi5rb2Jq
LCBLT0JKX0FERCk7Cn0KCi8qIE5vdCBleHBvcnRlZCwgaGVscGVyIHRvIGFkZF9kaXNrKCku
ICovCnZvaWQgcmVnaXN0ZXJfZGlzayhzdHJ1Y3QgZ2VuZGlzayAqZGlzaykKewoJc3RydWN0
IGJsb2NrX2RldmljZSAqYmRldjsKCWNoYXIgKnM7CglpbnQgaTsKCXN0cnVjdCBoZF9zdHJ1
Y3QgKnA7CglpbnQgZXJyOwoKCWRpc2stPmRldi5wYXJlbnQgPSBkaXNrLT5kcml2ZXJmc19k
ZXY7CglkaXNrLT5kZXYuZGV2dCA9IE1LREVWKGRpc2stPm1ham9yLCBkaXNrLT5maXJzdF9t
aW5vcik7CgoJc3RybGNweShkaXNrLT5kZXYuYnVzX2lkLCBkaXNrLT5kaXNrX25hbWUsIEtP
QkpfTkFNRV9MRU4pOwoJLyogZXd3dy4uLiBzb21lIG9mIHRoZXNlIGJ1Z2dlcnMgaGF2ZSAv
IGluIHRoZSBuYW1lLi4uICovCglzID0gc3RyY2hyKGRpc2stPmRldi5idXNfaWQsICcvJyk7
CglpZiAocykKCQkqcyA9ICchJzsKCgkvKiBkZWxheSB1ZXZlbnRzLCB1bnRpbCB3ZSBzY2Fu
bmVkIHBhcnRpdGlvbiB0YWJsZSAqLwoJZGlzay0+ZGV2LnVldmVudF9zdXBwcmVzcyA9IDE7
CgoJaWYgKGRldmljZV9hZGQoJmRpc2stPmRldikpCgkJcmV0dXJuOwojaWZuZGVmIENPTkZJ
R19TWVNGU19ERVBSRUNBVEVECgllcnIgPSBzeXNmc19jcmVhdGVfbGluayhibG9ja19kZXBy
LCAmZGlzay0+ZGV2LmtvYmosCgkJCQlrb2JqZWN0X25hbWUoJmRpc2stPmRldi5rb2JqKSk7
CglpZiAoZXJyKSB7CgkJZGV2aWNlX2RlbCgmZGlzay0+ZGV2KTsKCQlyZXR1cm47Cgl9CiNl
bmRpZgoJZGlza19zeXNmc19hZGRfc3ViZGlycyhkaXNrKTsKCgkvKiBObyBtaW5vcnMgdG8g
dXNlIGZvciBwYXJ0aXRpb25zICovCglpZiAoZGlzay0+bWlub3JzID09IDEpCgkJZ290byBl
eGl0OwoKCS8qIE5vIHN1Y2ggZGV2aWNlIChlLmcuLCBtZWRpYSB3ZXJlIGp1c3QgcmVtb3Zl
ZCkgKi8KCWlmICghZ2V0X2NhcGFjaXR5KGRpc2spKQoJCWdvdG8gZXhpdDsKCgliZGV2ID0g
YmRnZXRfZGlzayhkaXNrLCAwKTsKCWlmICghYmRldikKCQlnb3RvIGV4aXQ7CgoJYmRldi0+
YmRfaW52YWxpZGF0ZWQgPSAxOwoJZXJyID0gYmxrZGV2X2dldChiZGV2LCBGTU9ERV9SRUFE
LCAwKTsKCWlmIChlcnIgPCAwKQoJCWdvdG8gZXhpdDsKCWJsa2Rldl9wdXQoYmRldik7Cgpl
eGl0OgoJLyogYW5ub3VuY2UgZGlzayBhZnRlciBwb3NzaWJsZSBwYXJ0aXRpb25zIGFyZSBj
cmVhdGVkICovCglkaXNrLT5kZXYudWV2ZW50X3N1cHByZXNzID0gMDsKCWtvYmplY3RfdWV2
ZW50KCZkaXNrLT5kZXYua29iaiwgS09CSl9BREQpOwoKCS8qIGFubm91bmNlIHBvc3NpYmxl
IHBhcnRpdGlvbnMgKi8KCWZvciAoaSA9IDE7IGkgPCBkaXNrLT5taW5vcnM7IGkrKykgewoJ
CXAgPSBkaXNrLT5wYXJ0W2ktMV07CgkJaWYgKCFwIHx8ICFwLT5ucl9zZWN0cykKCQkJY29u
dGludWU7CgkJa29iamVjdF91ZXZlbnQoJnAtPmRldi5rb2JqLCBLT0JKX0FERCk7Cgl9Cn0K
CmludCByZXNjYW5fcGFydGl0aW9ucyhzdHJ1Y3QgZ2VuZGlzayAqZGlzaywgc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldikKewoJc3RydWN0IHBhcnNlZF9wYXJ0aXRpb25zICpzdGF0ZTsK
CWludCBwLCByZXM7CgoJaWYgKGJkZXYtPmJkX3BhcnRfY291bnQpCgkJcmV0dXJuIC1FQlVT
WTsKCXJlcyA9IGludmFsaWRhdGVfcGFydGl0aW9uKGRpc2ssIDApOwoJaWYgKHJlcykKCQly
ZXR1cm4gcmVzOwoJYmRldi0+YmRfaW52YWxpZGF0ZWQgPSAwOwoJZm9yIChwID0gMTsgcCA8
IGRpc2stPm1pbm9yczsgcCsrKQoJCWRlbGV0ZV9wYXJ0aXRpb24oZGlzaywgcCk7CglpZiAo
ZGlzay0+Zm9wcy0+cmV2YWxpZGF0ZV9kaXNrKQoJCWRpc2stPmZvcHMtPnJldmFsaWRhdGVf
ZGlzayhkaXNrKTsKCWlmICghZ2V0X2NhcGFjaXR5KGRpc2spIHx8ICEoc3RhdGUgPSBjaGVj
a19wYXJ0aXRpb24oZGlzaywgYmRldikpKQoJCXJldHVybiAwOwoJaWYgKElTX0VSUihzdGF0
ZSkpCS8qIEkvTyBlcnJvciByZWFkaW5nIHRoZSBwYXJ0aXRpb24gdGFibGUgKi8KCQlyZXR1
cm4gLUVJTzsKCgkvKiB0ZWxsIHVzZXJzcGFjZSB0aGF0IHRoZSBtZWRpYSAvIHBhcnRpdGlv
biB0YWJsZSBtYXkgaGF2ZSBjaGFuZ2VkICovCglrb2JqZWN0X3VldmVudCgmZGlzay0+ZGV2
LmtvYmosIEtPQkpfQ0hBTkdFKTsKCglmb3IgKHAgPSAxOyBwIDwgc3RhdGUtPmxpbWl0OyBw
KyspIHsKCQlzZWN0b3JfdCBzaXplID0gc3RhdGUtPnBhcnRzW3BdLnNpemU7CgkJc2VjdG9y
X3QgZnJvbSA9IHN0YXRlLT5wYXJ0c1twXS5mcm9tOwoJCWlmICghc2l6ZSkKCQkJY29udGlu
dWU7CgkJaWYgKGZyb20gKyBzaXplID4gZ2V0X2NhcGFjaXR5KGRpc2spKSB7CgkJCXByaW50
aygiICVzOiBwJWQgZXhjZWVkcyBkZXZpY2UgY2FwYWNpdHlcbiIsCgkJCQlkaXNrLT5kaXNr
X25hbWUsIHApOwoJCX0KCQlhZGRfcGFydGl0aW9uKGRpc2ssIHAsIGZyb20sIHNpemUsIHN0
YXRlLT5wYXJ0c1twXS5mbGFncyk7CiNpZmRlZiBDT05GSUdfQkxLX0RFVl9NRAoJCWlmIChz
dGF0ZS0+cGFydHNbcF0uZmxhZ3MgJiBBRERQQVJUX0ZMQUdfUkFJRCkKCQkJbWRfYXV0b2Rl
dGVjdF9kZXYoYmRldi0+YmRfZGV2K3ApOwojZW5kaWYKCX0KCWtmcmVlKHN0YXRlKTsKCXJl
dHVybiAwOwp9Cgp1bnNpZ25lZCBjaGFyICpyZWFkX2Rldl9zZWN0b3Ioc3RydWN0IGJsb2Nr
X2RldmljZSAqYmRldiwgc2VjdG9yX3QgbiwgU2VjdG9yICpwKQp7CglzdHJ1Y3QgYWRkcmVz
c19zcGFjZSAqbWFwcGluZyA9IGJkZXYtPmJkX2lub2RlLT5pX21hcHBpbmc7CglzdHJ1Y3Qg
cGFnZSAqcGFnZTsKCglwYWdlID0gcmVhZF9tYXBwaW5nX3BhZ2UobWFwcGluZywgKHBnb2Zm
X3QpKG4gPj4gKFBBR0VfQ0FDSEVfU0hJRlQtOSkpLAoJCQkJIE5VTEwpOwoJaWYgKCFJU19F
UlIocGFnZSkpIHsKCQlpZiAoUGFnZUVycm9yKHBhZ2UpKQoJCQlnb3RvIGZhaWw7CgkJcC0+
diA9IHBhZ2U7CgkJcmV0dXJuICh1bnNpZ25lZCBjaGFyICopcGFnZV9hZGRyZXNzKHBhZ2Up
ICsgICgobiAmICgoMSA8PCAoUEFHRV9DQUNIRV9TSElGVCAtIDkpKSAtIDEpKSA8PCA5KTsK
ZmFpbDoKCQlwYWdlX2NhY2hlX3JlbGVhc2UocGFnZSk7Cgl9CglwLT52ID0gTlVMTDsKCXJl
dHVybiBOVUxMOwp9CgpFWFBPUlRfU1lNQk9MKHJlYWRfZGV2X3NlY3Rvcik7Cgp2b2lkIGRl
bF9nZW5kaXNrKHN0cnVjdCBnZW5kaXNrICpkaXNrKQp7CglpbnQgcDsKCgkvKiBpbnZhbGlk
YXRlIHN0dWZmICovCglmb3IgKHAgPSBkaXNrLT5taW5vcnMgLSAxOyBwID4gMDsgcC0tKSB7
CgkJaW52YWxpZGF0ZV9wYXJ0aXRpb24oZGlzaywgcCk7CgkJZGVsZXRlX3BhcnRpdGlvbihk
aXNrLCBwKTsKCX0KCWludmFsaWRhdGVfcGFydGl0aW9uKGRpc2ssIDApOwoJZGlzay0+Y2Fw
YWNpdHkgPSAwOwoJZGlzay0+ZmxhZ3MgJj0gfkdFTkhEX0ZMX1VQOwoJdW5saW5rX2dlbmRp
c2soZGlzayk7CglkaXNrX3N0YXRfc2V0X2FsbChkaXNrLCAwKTsKCWRpc2stPnN0YW1wID0g
MDsKCglrb2JqZWN0X3B1dChkaXNrLT5ob2xkZXJfZGlyKTsKCWtvYmplY3RfcHV0KGRpc2st
PnNsYXZlX2Rpcik7CglkaXNrLT5kcml2ZXJmc19kZXYgPSBOVUxMOwojaWZuZGVmIENPTkZJ
R19TWVNGU19ERVBSRUNBVEVECglzeXNmc19yZW1vdmVfbGluayhibG9ja19kZXByLCBkaXNr
LT5kZXYuYnVzX2lkKTsKI2VuZGlmCglkZXZpY2VfZGVsKCZkaXNrLT5kZXYpOwp9Cg==
--------------090108040403090605030302
Content-Type: application/x-reject;
 name="check.c.rej"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="check.c.rej"

KioqKioqKioqKioqKioqCioqKiAzNDIsMzYwICoqKioKICBzdGF0aWMgREVWSUNFX0FUVFIo
d2hvbGVfZGlzaywgU19JUlVTUiB8IFNfSVJHUlAgfCBTX0lST1RILAogIAkJICAgd2hvbGVf
ZGlza19zaG93LCBOVUxMKTsKICAKLSB2b2lkIGFkZF9wYXJ0aXRpb24oc3RydWN0IGdlbmRp
c2sgKmRpc2ssIGludCBwYXJ0LCBzZWN0b3JfdCBzdGFydCwgc2VjdG9yX3QgbGVuLCBpbnQg
ZmxhZ3MpCiAgewotIAlzdHJ1Y3QgaGRfc3RydWN0ICpwOwogIAlpbnQgZXJyOwogIAogIAlw
ID0ga3phbGxvYyhzaXplb2YoKnApLCBHRlBfS0VSTkVMKTsKICAJaWYgKCFwKQotIAkJcmV0
dXJuOwogIAotIAlpZiAoIWluaXRfcGFydF9zdGF0cyhwKSkgewotIAkJa2ZyZWUocCk7Ci0g
CQlyZXR1cm47Ci0gCX0KICAJcC0+c3RhcnRfc2VjdCA9IHN0YXJ0OwogIAlwLT5ucl9zZWN0
cyA9IGxlbjsKICAJcC0+cGFydG5vID0gcGFydDsKLS0tIDM0MiwzNjUgLS0tLQogIHN0YXRp
YyBERVZJQ0VfQVRUUih3aG9sZV9kaXNrLCBTX0lSVVNSIHwgU19JUkdSUCB8IFNfSVJPVEgs
CiAgCQkgICB3aG9sZV9kaXNrX3Nob3csIE5VTEwpOwogIAorIGludCBhZGRfcGFydGl0aW9u
KHN0cnVjdCBnZW5kaXNrICpkaXNrLCBpbnQgcGFydCwKKyAJCSAgc2VjdG9yX3Qgc3RhcnQs
IHNlY3Rvcl90IGxlbiwgaW50IGZsYWdzKQogIHsKKyAJc3RydWN0IGhkX3N0cnVjdCAqcCA9
IE5VTEw7CiAgCWludCBlcnI7CiAgCisgCWlmIChkaXNrLT5wYXJ0W3BhcnQgLSAxXSkgewor
IAkJZXJyID0gLUVCVVNZOworIAkJZ290byBmYWlsOworIAl9CisgCisgCWVyciA9IC1FTk9N
RU07CiAgCXAgPSBremFsbG9jKHNpemVvZigqcCksIEdGUF9LRVJORUwpOwogIAlpZiAoIXAp
CisgCQlnb3RvIGZhaWw7CisgCWlmICghaW5pdF9wYXJ0X3N0YXRzKHApKQorIAkJZ290byBm
YWlsOwogIAogIAlwLT5zdGFydF9zZWN0ID0gc3RhcnQ7CiAgCXAtPm5yX3NlY3RzID0gbGVu
OwogIAlwLT5wYXJ0bm8gPSBwYXJ0Owo=
--------------090108040403090605030302--
