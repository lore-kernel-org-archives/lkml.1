Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZINFaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZINFaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZINFaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:30:09 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:38086 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZINFaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=DLpqZYAUW/ZGGpGCzGUXrmi67yskersm3IpKhN6SvqmRgiT0j6NIR2o+Xasr6hWvys
         xIi2LhoIzRxoU6koy0oLoDVbluM1+aP1YX3zk3dGQ/vpTHRBh9ZBX6lGwK9eCWx7Yiae
         maz1WCKkSFQx0KAX5KKi6OXH9tl54saJLyrNo=
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 17:30:12 +1200
Message-ID: <202cde0e0909132230y52b805a4i8792f2e287b01acb@mail.gmail.com>
Subject: HugeTLB: Driver example
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an example of simple driver which provides huge pages mapping
for user level applications. The  procedure for mapping of huge pages
to userspace by the driver is:

1. Create a hugetlb file on vfs mount of hugetlbfs (h_file)

2. File operations of /dev/hpage_map do the following:
In file open we  associate mappings of /dev/xxx with the file on
hugetlbfs (like it is done in ipc/shm.c)
       file->f_mapping = h_file->f_mapping;
In get_unmapped_area we should tell about addressing constraints in
case of huge pages by calling hugetlbfs procedures. (as in ipc/shm.c)
       return get_unmapped_area(h_file, addr, len, pgoff, flags);

3 In mmap get huge page in order to DMA or for something else
(hugetlb_get_user_page call).
..................
4 Remove hugetlbfs file

---
#include <linux/module.h>
#include <linux/mm.h>
#include <linux/file.h>
#include <linux/pagemap.h>
#include <linux/hugetlb.h>
#include <linux/pagevec.h>
#include <linux/miscdevice.h>
#include <asm/io.h>
#include <asm/ioctl.h>

#define HFILE_SIZE 16UL*1024*1024
static struct file	*h_file;

static int hpage_map_mmap(struct file *file, struct vm_area_struct *vma)
{
	int ret;
	struct page *page;
	struct hstate *h;
	unsigned long addr = vma->vm_start;

	if ((ret = h_file->f_op->mmap(h_file, vma)))
	    return ret;

	h = hstate_file(h_file);
	
	while (addr < vma->vm_end) {
		page = hugetlb_get_user_page(vma, addr);
		if (IS_ERR(page))
		        return -EFAULT;
		addr += huge_page_size(h);
		/* Add code to configure DMA here */
	}
	return 0;
}

static unsigned long hpage_map_get_unmapped_area(struct file *file,
	unsigned long addr, unsigned long len, unsigned long pgoff,
	unsigned long flags)
{
	/* Tell about addressing constrains in case of huge pages,
	 * hugetlbfs knows how to do this */
	return get_unmapped_area(h_file, addr, len, pgoff, flags);
}
static int hpage_map_open(struct inode * inode, struct file * file)
{
	/* Associate mappings of /dev/xxx with the file on hugetlbfs
	 * like it is done in ipc/shm.c */
	file->f_mapping = h_file->f_mapping;
	return 0;
}

/*
 * The file operations for /dev/hpage_map
 */
static const struct file_operations hpage_map_fops = {
	.owner		= THIS_MODULE,
	.mmap		= hpage_map_mmap,
	.open 		= hpage_map_open,
	.get_unmapped_area	= hpage_map_get_unmapped_area,
};

static struct miscdevice hpage_map_dev = {
	MISC_DYNAMIC_MINOR,
	"hpage_map",
	&hpage_map_fops
};

static int __init
hpage_map_init(void)
{
	int ret;
	struct user_struct *user = NULL;

	/* Create the device in the /sys/class/misc directory. */
	if ((ret = misc_register(&hpage_map_dev)))
		return ret;

	/* Create file on hugetlbfs */
	h_file = hugetlb_file_setup("hpage_map_dev", HFILE_SIZE, 0, &user,
				HUGETLB_DEVBACK_INODE);
	if (IS_ERR(h_file)) {
		misc_deregister(&hpage_map_dev);
		ret = -ENOENT;
	}
	return ret;
}

module_init(hpage_map_init);

static void __exit
hpage_map_exit(void)
{
	fput(h_file);
	misc_deregister(&hpage_map_dev);
}

module_exit(hpage_map_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Alexey Korolev");
MODULE_DESCRIPTION("Example of driver with hugetlb mapping");
MODULE_VERSION("1.0");
