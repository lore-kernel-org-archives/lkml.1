Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYJGNk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYJGNk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJGNkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:40:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:32634 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYJGNkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qzIHsbWUo7wqD+8x0KXR5zy/VEbZzjfQDgZQH5puDeZrV1vgI6UL1KoxfvdHiABQ8Z
         jdeg3Z4JXy2NmEXNj9Z2+X664TxqLKJBInspyHHUZFpwaZKZo0LS0Qca5Iei69AsqW5f
         FTZ245KTQJ6Zm6jSLrWsrvbLhKvxF0Esa2mrw=
Message-ID: <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
Date: Tue, 7 Oct 2008 10:40:10 -0300
From: "Thiago Lacerda" <thiagotbl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Questions about mmap
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com>
	 <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>
	 <48E8C8AB.3010308@s5r6.in-berlin.de>
	 <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Stefan.... by I'd something more concrete.

I'm trying to do like this:

//Code of the char device
unsigned int **test;
static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
      printk(KERN_INFO"Calling mmap\n");
      vma->vm_flags |= VM_LOCKED;
      if(remap_pfn_range(vma, vma->vm_start,
virt_to_phys((void*)((unsigned long)test)) >> PAGE_SHIFT, vma->vm_end
- vma->vm_start, PAGE_SHARED))
                return -EAGAIN;
      printk(KERN_INFO"mmap returned\n");
      return 0;
}

static int __init testeInit(void) {
/* after creating char device and registering it*/
...
....
test = (unsigned int**) kmalloc(sizeof(unsigned int*)*1024, GFP_KERNEL);
int i;
for(i = 0; i < 1024; i++)
     test[i] = NULL;

unsigned int* temp1 = (unsigned int*) kmalloc(sizeof(unsigned int), GFP_KERNEL);
(*temp1) = 9;
test[0] = temp1;
return 0;
}

and at user program:

int main() {
    int fd;

    unsigned int **mptr;
    size_t size = 1024*sizeof(unsigned int*);
    fd = open("/dev/myDev", O_RDWR);
    if( fd == -1) {
        printf("open error...\n");
        exit(0);
    }

    mptr = mmap(0, sizeof(unsigned int*)*1024, PROT_READ | PROT_WRITE,
MAP_FILE | MAP_SHARED, fd, 0);
    if(mptr == MAP_FAILED) {
        printf("mmap() failed\n");
        exit(1);
    }
    printf("teste[0]: %u\n", *mptr[0]);
    munmap(mptr, size);
    close(fd);
    return 0;
}

It's not working, could you tell me what am I doing wrong? It is for
my undergraduate thesis ans it is really driving me mad.

I hope that you can help me.

best regards.

On Sun, Oct 5, 2008 at 11:01 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>
> Thiago Lacerda wrote:
> > typedef struct hashtable {
> >    flow_t *hashBuckets[X]; // X is a natural number
> >    unsigned int size;
> > } Hastable;
> >
> >
> > So, my question is: Can I mmap the hashtable struct and access
> > directly from userspace? I'm afraid that this could turn on mess
> > because of the array of pointers.
> > If it's possible, does anyone know a piece of code that can match my
> > problem? I've been googling and I just find codes dealing with structs
> > itself, not pointers.
>
> If you require portability, you can only use integer types of fixed size
> in kernel<->userspace ABIs.  Pointers can then be exchanged as __u64
> under the assumption that pointers not wider than 64 bits.  See for
> example the FW_CDEV_IOC_QUEUE_ISO ioctl in include/linux/firewire-cdev.h.
> --
> Stefan Richter
> -=====-==--- =-=- --=-=
> http://arcgraph.de/sr/


--
Thiago de Barros Lacerda
Computer Science Undergraduate Student - CIn/UFPE - 2004.2
Researcher/Software Developer - GPRT - Networking and
Telecommunications Research Group
