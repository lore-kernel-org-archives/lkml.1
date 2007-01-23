Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXAWPib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXAWPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXAWPib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:38:31 -0500
Received: from thccv19.oz.nthu.edu.tw ([140.114.63.219]:50468 "EHLO
	thccv19.oz.nthu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXAWPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:38:30 -0500
From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
To: "'Anton Altaparmakov'" <aia21@cam.ac.uk>
Cc: <linux-kernel@vger.kernel.org>
References: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky> <1169557944.4475.8.camel@imp.csi.cam.ac.uk> <030801c73ef8$f2198a00$0100a8c0@sslabmayasky> <Pine.LNX.4.64.0701231449110.16296@hermes-1.csi.cam.ac.uk>
Subject: RE: Could convert a buffer that allocated by vmalloc to pages?
Date: Tue, 23 Jan 2007 23:40:29 +0800
Message-ID: <031101c73f04$cff18700$0100a8c0@sslabmayasky>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <Pine.LNX.4.64.0701231449110.16296@hermes-1.csi.cam.ac.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acc+/fwRujCTdTrtQAW8gRpNMyAOyAABl6bA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,
All of the code as below:
//==============================================
extern struct vm_struct *vmlist;
struct vm_struct *vmlist2,*L2vm;

int find_vm_struct(void *addr)
{
                struct vm_struct **p;
                int i;
                struct page *pg;
                printk("&vmlist=%x\n",&vmlist);
                for (p = &vmlist ; (L2vm = *p) != NULL ;p = &L2vm->next) {
                       if (L2vm->addr == addr)
                       goto found;
                }
                printk(KERN_INFO "find_vm_struct filed\n");
                return 0;
                found:
                printk(KERN_INFO "find_vm_struct OK:%x addr:%x
nr_pages:%d\n",L2vm,L2vm->addr,L2vm->nr_pages);
                for(i=0;i<L2vm->nr_pages;i++)
                {
                        if(L2vm->pages[i])
                                printk("page
allocated:%x\n",page_address(L2vm->pages[i]));
                }
                return 1;

}


static int __init mymodule_init()
{
        L2cache=vmalloc(40960);

        if(L2cache)
        {
                struct page *tpage;
                printk(KERN_INFO "L2 cache allocat success,
address:%x\n",L2cache);
                read_lock(&vmlist_lock);
                find_vm_struct(L2cache);
                read_unlock(&vmlist_lock);
                tpage=vmalloc_to_page(L2cache);
                printk(KERN_INFO "vmalloc_to_page tpage :%x\n",tpage);
        }
        else
        {
                printk(KERN_INFO "L2 cache allocat failed\n");
                return -1;
        }
        return 0;
}
//===============================================================
The mymodule_init() is the initial function of my moudle, it will call
vmalloc to malloc a memory area(big buffer), the buffer will be used to do
DMA transmission.
If allocated the buffer successfuly, it will find the vm_struct of the
buffer, the address of vm_struct  will be stored in L2vm.
If found the vm_struct, it will show all pages of the big buffer.
You can see the page get from vmalloc_to_page() is different to all of the
pages get form vm_struct.

Is it possible that the buffer allocated by vmalloc be used to do DMA
transmission?

THX
-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Anton Altaparmakov
Sent: Tuesday, January 23, 2007 10:50 PM
To: Yu-Chen Wu
Cc: linux-kernel@vger.kernel.org
Subject: RE: Could convert a buffer that allocated by vmalloc to pages?

On Tue, 23 Jan 2007, Yu-Chen Wu wrote:
> I tried vmalloc_to_page() and I have some question.
> I print the "pages" in vm_struct structure of the buffer to compare the
> address get from vmalloc_to_page(), result as follows:

Both the code you are showing and your question do not make any sense 
to me...  You need to show all of the code not some random fragments...  
What the heck is L2vm for a start?

Best regards,

	Anton

> //===source code====
> L2cache=vmalloc(L2SIZE);// L2SIZE=40960
> printk(KERN_INFO "find_vm_struct OK:%x
> addr:%xnr_pages:%d\n",L2vm,L2vm->addr,L2vm->nr_pages);
> for(i=0;i<L2vm->nr_pages;i++)
>  {
>       if(L2vm->pages[i])
>          printk("page allocated:%x\n",page_address(L2vm->pages[i]));
>  }
> tpage=vmalloc_to_page(L2cache);
> printk(KERN_INFO "vmalloc_to_page tpage :%x\n",tpage);
> //===========info of dmesg==================
> [ 1561.768471] page allocated:73d65000
> [ 1561.768474] page allocated:781e9000
> [ 1561.768476] page allocated:6203f000
> [ 1561.768478] page allocated:57fdf000
> [ 1561.768481] page allocated:56ed4000
> [ 1561.768483] page allocated:56ed5000
> [ 1561.768485] page allocated:64ab6000
> [ 1561.768488] page allocated:7cc1e000
> [ 1561.768490] page allocated:60ea8000
> [ 1561.768492] page allocated:60ea9000
> [ 1561.768497] vmalloc_to_page tpage :7fcf7e18
> 
> Why the page address get from vmalloc_to_page is different with the first
> page address of the vm_struct (73d65000)?
> 
> THX
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Anton
Altaparmakov
> Sent: Tuesday, January 23, 2007 9:12 PM
> To: Yu-Chen Wu
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Could convert a buffer that allocated by vmalloc to pages?
> 
> On Tue, 2007-01-23 at 21:04 +0800, Yu-Chen Wu wrote:
> > Hi,
> > I write a driver have a big buffer (16MB,allocated by vmalloc).
> > I want to use the buffer to do DMA transmission so I need getting the
> pages
> > of the buffer.
> > Have any kernel API can do this?
> > My platform is x86_64 and 2GB RAM
> 
> vmalloc_to_page()...
> 
> See mm/memory.c for the function and how to use it.
> 
> Best regards,
> 
>         Anton
> 

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

