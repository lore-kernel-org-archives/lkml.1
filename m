Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYJGU5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYJGU5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYJGU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:57:00 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:57395 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJGU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:56:59 -0400
Message-ID: <48EBCD04.1070804@nortel.com>
Date: Tue, 07 Oct 2008 14:56:36 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Thiago Lacerda <thiagotbl@gmail.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Questions about mmap
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com> <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com> <48E8C8AB.3010308@s5r6.in-berlin.de> <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com> <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com> <Pine.LNX.4.61.0810071637120.21987@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0810071637120.21987@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 20:56:40.0595 (UTC) FILETIME=[32627E30:01C928BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> On Tue, 7 Oct 2008, Thiago Lacerda wrote:
> 
> 
>>Thank you Stefan.... by I'd something more concrete.
>>
>>I'm trying to do like this:
>>
>>//Code of the char device
>>unsigned int **test;
>>static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
>>     printk(KERN_INFO"Calling mmap\n");
>>     vma->vm_flags |= VM_LOCKED;
>>     if(remap_pfn_range(vma, vma->vm_start,
>>virt_to_phys((void*)((unsigned long)test)) >> PAGE_SHIFT, vma->vm_end
>>- vma->vm_start, PAGE_SHARED))
>>               return -EAGAIN;
>>     printk(KERN_INFO"mmap returned\n");
>>     return 0;
>>}
>>
>>static int __init testeInit(void) {
>>/* after creating char device and registering it*/
>>...
>>....
>>test = (unsigned int**) kmalloc(sizeof(unsigned int*)*1024, GFP_KERNEL);
>>int i;
>>for(i = 0; i < 1024; i++)
>>    test[i] = NULL;
>>
>>unsigned int* temp1 = (unsigned int*) kmalloc(sizeof(unsigned int), GFP_KERNEL);
>>(*temp1) = 9;
>>test[0] = temp1;
>>return 0;
>>}
>>
>>and at user program:
>>
>>int main() {
>>   int fd;
>>
>>   unsigned int **mptr;
>>   size_t size = 1024*sizeof(unsigned int*);
>>   fd = open("/dev/myDev", O_RDWR);
>>   if( fd == -1) {
>>       printf("open error...\n");
>>       exit(0);
>>   }
>>
>>   mptr = mmap(0, sizeof(unsigned int*)*1024, PROT_READ | PROT_WRITE,
>>MAP_FILE | MAP_SHARED, fd, 0);
>>   if(mptr == MAP_FAILED) {
>>       printf("mmap() failed\n");
>>       exit(1);
>>   }
>>   printf("teste[0]: %u\n", *mptr[0]);
>>   munmap(mptr, size);
>>   close(fd);
>>   return 0;
>>}
>>
>>It's not working, could you tell me what am I doing wrong? It is for
>>my undergraduate thesis ans it is really driving me mad.
>>
>>I hope that you can help me.
>>
>>best regards.
>>
>>--
>>Thiago de Barros Lacerda
> 
> 
> It looks like you are trying to memory-map a pointer that
> you expect to de-reference in user space. Perhaps you can
> tell us what it is that you are trying to do. You need
> to use copy/to/from_user to copy things from or to the kernel.
> 
> Attempts to dereference kernel data will fail because the
> segments for kernel data or code are not the same as user
> data or code.

I do not think this is entirely true.  I haven't tried it recently, but 
I have reserved a page of kernel memory in a driver and mapped it into 
userspace such that it can be accessed by both.

This can be useful for cases where you want to make continuously-updated 
information available to userspace without the overhead of a syscall.

There can be some gotchas though...last time I tried this on ARM I had 
to explicitly flush the cache on the memory area after writing it in the 
kernel to ensure that userspace saw the updated data since it was 
accessing it via a different virtual address.

Chris
