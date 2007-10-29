Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbXJ2Hkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbXJ2Hkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXJ2Hkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:40:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbXJ2Hkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:40:40 -0400
Date: Mon, 29 Oct 2007 00:40:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       linux-mm@kvack.org
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
Message-Id: <20071029004002.60c7182a.akpm@linux-foundation.org>
In-Reply-To: <1193064057.16541.1.camel@matrix>
References: <1193064057.16541.1.camel@matrix>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 16:40:57 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> Hi,
> 
> i have a problem with vmalloc() and vm_ops.page_mkwrite().
> 
> ReadOnly access works, but on a write access the VM will
> endless invoke the vm_ops.page_mkwrite() handler.
> 
> I tracked down the problem to the
> 	struct page.mapping pointer,
> which is NULL.
> 
> The problem original occurs with the fb_defio driver (driver/video/fb_defio.c).
> This driver use the vm_ops.page_mkwrite() handler for tracking the modified pages,
> which will be in an extra thread handled, to perform the IO and clean and
> write protect all pages with page_clean().
> 
> I am not sure if the is a feature of the new rmap code or a bug.
> 
> Is there an way to get a similar functionality? Currently, i have no
> idea
> how to get the ptep from a page alloced with vmalloc().
> 
> Greetings,
> Stefani
> 
> Here is a small sample driver:
> 
> #include <linux/module.h>
> #include <linux/errno.h>
> #include <linux/string.h>
> #include <linux/mm.h>
> #include <linux/vmalloc.h>
> #include <linux/fs.h>
> 
> #define	DEVICE_NAME	"mydrv"
> #define	DEVICE_MAJOR	240
> 
> static u8 *mydrv_memory;
> static const u_long mydrv_memory_size=1024*1024; // 1 Megabyte
> 
> #ifdef MODULE
> static u_long vmas=0;
> #endif
> 
> static void mydrv_vma_open(struct vm_area_struct *vma)
> {
> #ifdef MODULE
> 	if (vmas++==0)
> 		try_module_get(THIS_MODULE);
> #endif
> }
> 
> static void mydrv_vma_close(struct vm_area_struct *vma)
> {
> #ifdef MODULE
> 	if (--vmas==0)
> 		module_put(THIS_MODULE);
> #endif
> }
> 
> struct page *mydrv_vma_nopage(struct vm_area_struct *vma,unsigned long
> address,int *type)
> {
> 	unsigned long offset;
> 	struct page *page;
> 
> 	offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
> 	printk("--> mydrv_vma_nopage:%lu(%08lx)\n",offset,offset);
> 
> 	if (offset >= mydrv_memory_size)
> 		return NOPAGE_SIGBUS;
> 
> 	page = vmalloc_to_page(mydrv_memory + offset);
> 	if (!page)
> 		return NOPAGE_OOM;
> 
> 	get_page(page);
> 	if (type)
> 		*type = VM_FAULT_MINOR;
> 	return page;
> }
> 
> int mydrv_mkwrite(struct vm_area_struct *vma,struct page *page)
> {
> 	printk("--> mydrv_mkwrite:%p\n",page->mapping);
> 
> 	return 0;
> }
> 
> struct vm_operations_struct mydrv_vm_ops = {
> 	.open =		mydrv_vma_open,
> 	.close =	mydrv_vma_close,
> 	.nopage =	mydrv_vma_nopage,
> 	.page_mkwrite =	mydrv_mkwrite,
> };
> 
> static int mydrv_mmap(struct file *file, struct vm_area_struct *vma)
> {
> 	vma->vm_ops = &mydrv_vm_ops;
> 	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
> 	vma->vm_private_data = 0;
> 	mydrv_vma_open(vma);
> 	return 0;
> }
> 
> int mydrv_open(struct inode *inode, struct file *file)
> {
> 	int		minor;
> 
> 	minor=MINOR(file->f_dentry->d_inode->i_rdev);
> 	printk("--> mydrv_open called for minor: %d\n", minor);
> 
> 	if (minor>0) {
> 		printk("--> mydrv_open minor %d failed\n",minor);
> 		return -ENODEV;
> 	}
> 
> 	printk("--> mydrv_open o.K.\n");
> 	return 0;
> }
> 
> 
> int mydrv_close(struct inode *inode, struct file *file)
> {
> 	int		minor;
> 
> 	minor=MINOR(file->f_dentry->d_inode->i_rdev);
> 	printk("--> mydrv_close for minor: %d\n", minor);
> 	return 0;
> }
> 
> struct file_operations mydrv_fops = {
> 	.owner=THIS_MODULE,
> 	.mmap=mydrv_mmap,
> 	.open=mydrv_open,
> 	.release=mydrv_close,
> };
> 
> int init_module(void)
> {
> 	printk("--> init_module called\n");
> 
> 	if (!(mydrv_memory = vmalloc(mydrv_memory_size)))
> 		return -ENOMEM;
> 
> 	if (register_chrdev(DEVICE_MAJOR, DEVICE_NAME, &mydrv_fops) < 0) {
> 		printk("--> Error registering driver.\n");
> 		return -ENODEV;
> 	}
> 
> 	memset(mydrv_memory, 0, mydrv_memory_size);
> 	printk("--> init_module done\n");
> 	return 0;
> }
> 
> 
> void cleanup_module(void)
> {
> 	printk("--> cleanup_module called\n");
> 	unregister_chrdev(DEVICE_MAJOR,DEVICE_NAME);
> 	vfree(mydrv_memory);
> 	printk("--> cleanup_module done\n");
> }
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Stefan Seibold <Stefani@Seibold.net>");
> MODULE_DESCRIPTION("Test Driver");
> 

(cc's added)
