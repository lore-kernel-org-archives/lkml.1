Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYJGUnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYJGUnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYJGUnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:43:41 -0400
Received: from mail91.analogic.com ([208.224.220.31]:51134 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752941AbYJGUnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:43:40 -0400
X-AuditID: 0a770115-a7030bb000001b04-3e-48ebc9fb85fe
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 07 Oct 2008 20:43:18.0184 (UTC) FILETIME=[541C4A80:01C928BD]
Content-class: urn:content-classes:message
Subject: Re: Questions about mmap
Date: Tue, 7 Oct 2008 16:43:17 -0400
Message-ID: <Pine.LNX.4.61.0810071637120.21987@chaos.analogic.com>
In-Reply-To: <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Questions about mmap
Thread-Index: AckovVQ7xJg2syxJTHGvHsFNxPj2Bw==
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com> <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com> <48E8C8AB.3010308@s5r6.in-berlin.de> <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com> <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Thiago Lacerda" <thiagotbl@gmail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Thiago Lacerda wrote:

> Thank you Stefan.... by I'd something more concrete.
>
> I'm trying to do like this:
>
> //Code of the char device
> unsigned int **test;
> static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
>      printk(KERN_INFO"Calling mmap\n");
>      vma->vm_flags |= VM_LOCKED;
>      if(remap_pfn_range(vma, vma->vm_start,
> virt_to_phys((void*)((unsigned long)test)) >> PAGE_SHIFT, vma->vm_end
> - vma->vm_start, PAGE_SHARED))
>                return -EAGAIN;
>      printk(KERN_INFO"mmap returned\n");
>      return 0;
> }
>
> static int __init testeInit(void) {
> /* after creating char device and registering it*/
> ...
> ....
> test = (unsigned int**) kmalloc(sizeof(unsigned int*)*1024, GFP_KERNEL);
> int i;
> for(i = 0; i < 1024; i++)
>     test[i] = NULL;
>
> unsigned int* temp1 = (unsigned int*) kmalloc(sizeof(unsigned int), GFP_KERNEL);
> (*temp1) = 9;
> test[0] = temp1;
> return 0;
> }
>
> and at user program:
>
> int main() {
>    int fd;
>
>    unsigned int **mptr;
>    size_t size = 1024*sizeof(unsigned int*);
>    fd = open("/dev/myDev", O_RDWR);
>    if( fd == -1) {
>        printf("open error...\n");
>        exit(0);
>    }
>
>    mptr = mmap(0, sizeof(unsigned int*)*1024, PROT_READ | PROT_WRITE,
> MAP_FILE | MAP_SHARED, fd, 0);
>    if(mptr == MAP_FAILED) {
>        printf("mmap() failed\n");
>        exit(1);
>    }
>    printf("teste[0]: %u\n", *mptr[0]);
>    munmap(mptr, size);
>    close(fd);
>    return 0;
> }
>
> It's not working, could you tell me what am I doing wrong? It is for
> my undergraduate thesis ans it is really driving me mad.
>
> I hope that you can help me.
>
> best regards.
>
> --
> Thiago de Barros Lacerda

It looks like you are trying to memory-map a pointer that
you expect to de-reference in user space. Perhaps you can
tell us what it is that you are trying to do. You need
to use copy/to/from_user to copy things from or to the kernel.

Attempts to dereference kernel data will fail because the
segments for kernel data or code are not the same as user
data or code.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4786.81 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
