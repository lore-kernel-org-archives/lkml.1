Return-Path: <linux-kernel-owner+w=401wt.eu-S965430AbXAWTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430AbXAWTgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965449AbXAWTgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:36:48 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:58117 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965430AbXAWTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:36:34 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Tue, 23 Jan 2007 19:36:14 +0000 (GMT)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Yu-Chen Wu <g944370@oz.nthu.edu.tw>
cc: linux-kernel@vger.kernel.org
Subject: RE: Could convert a buffer that allocated by vmalloc to pages?
In-Reply-To: <031101c73f04$cff18700$0100a8c0@sslabmayasky>
Message-ID: <Pine.LNX.4.64.0701231930000.16296@hermes-1.csi.cam.ac.uk>
References: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky>
 <1169557944.4475.8.camel@imp.csi.cam.ac.uk> <030801c73ef8$f2198a00$0100a8c0@sslabmayasky>
 <Pine.LNX.4.64.0701231449110.16296@hermes-1.csi.cam.ac.uk>
 <031101c73f04$cff18700$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 23 Jan 2007, Yu-Chen Wu wrote:
> All of the code as below:
> //==============================================
> extern struct vm_struct *vmlist;
> struct vm_struct *vmlist2,*L2vm;
> 
> int find_vm_struct(void *addr)
> {
>                 struct vm_struct **p;
>                 int i;
>                 struct page *pg;
>                 printk("&vmlist=%x\n",&vmlist);
>                 for (p = &vmlist ; (L2vm = *p) != NULL ;p = &L2vm->next) {
>                        if (L2vm->addr == addr)
>                        goto found;
>                 }
>                 printk(KERN_INFO "find_vm_struct filed\n");
>                 return 0;
>                 found:
>                 printk(KERN_INFO "find_vm_struct OK:%x addr:%x
> nr_pages:%d\n",L2vm,L2vm->addr,L2vm->nr_pages);
>                 for(i=0;i<L2vm->nr_pages;i++)
>                 {
>                         if(L2vm->pages[i])
>                                 printk("page
> allocated:%x\n",page_address(L2vm->pages[i]));

You are printing "page_address()" of each of the pages here.

[snip]
>                 find_vm_struct(L2cache);
>                 read_unlock(&vmlist_lock);
>                 tpage=vmalloc_to_page(L2cache);
>                 printk(KERN_INFO "vmalloc_to_page tpage :%x\n",tpage);

You are printing "tpage" instead of page_address(tpage)" here so of course 
it will not be the same as what you did above where you printed the 
page_address() instead of the pages themselves...

> Is it possible that the buffer allocated by vmalloc be used to do DMA
> transmission?

Only if you do it page by page as the pages are not physically contiguous, 
i.e. you would have to call vmalloc_to_page() for each page in the 
vmalloced area and then create a scatter-gather DMA operation working on 
each page in sequence.  I suspect this is not what you want...

You will need to read up on doing DMA mappings from the kernel to learn 
how to make memory physicall contiguous.  Hint start with reading 
Documentation/DMA-API.txt and DMA-mapping.txt...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
