Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYBEK6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYBEK6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYBEK62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:58:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:25334 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbYBEK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Kl2O/dBD4/qnG6R0LqO42HI4aPwjPPrOhxk18JxRF/qee1H0DVefWeFGNd8SUM1Rwk5R1vAxEi+Bdz4gNzP2VGbgtQhTNZ537DBw2anYxdsIpDj7kYX31KX+8IhEECWwqY4NVSsWdZW/iNwm1KrXRYGG41bvBIZKwb4UBypz1ng=
Message-ID: <47A8414D.7080200@gmail.com>
Date: Tue, 05 Feb 2008 11:58:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ohyama_sec@ariel-networks.com
CC: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [QUESTION] I have a question about making device driver
References: <20080205093900.D0BF6948006@ns.ariel-networks.com>
In-Reply-To: <20080205093900.D0BF6948006@ns.ariel-networks.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2008 10:39 AM, ohyama_sec@ariel-networks.com wrote:
>>> --- check program ---
>>> #include <linux/types.h>
>>> #include <asm/io.h>
>>> #include <stdio.h>
>> A userspace program? I thought this was about kernel device drivers.
> 
> 
> Yes, It is a userspace program to see what I can write parallel port device controller or not.
> 
> And, I'm sorry , I should not have explained my device driver in text, but should have written source code.
> So that, the following is source code of the device driver. It works only to obtain I/O resource (I/O address and IRQ).
> 
> 
>>> int main(void){
>>>    int base = 0x378;
>>>    char read, write;
>>>
>>>    ioperm(base, 1, 1);

if (ioperm(...)) {
	perror("ioperm");
	return 1;
}

and retest.

>>>
>>>    write = 0xa;
>>>    outb(write, base);
>>>    read = inb(base);
>>>    if((read & 0xf) == write){
[...]
> 
> --- kernel module (device driver) ---
> 
[...]
> 
> #define SHORT_NR_PORTS	8	
> 
> static int major = 0;	
> 
> unsigned long short_base = 0x378;
> 
> volatile int short_irq = 7;
> static struct cdev *obj_cdev;
> 
> MODULE_AUTHOR ("hiroyasu ohyama");
> MODULE_LICENSE("GPL2");
> 
> struct file_operations my_fops = {
> 	.owner	 = THIS_MODULE,
> };
> 
> irqreturn_t short_sh_interrupt(int irq, void *dev_id, struct pt_regs *regs)
> {
> 	printk(KERN_INFO "interrupt\n");
> 
> 	return 0;
> }
> 
> int short_init(void)
> {
> 	int result;
> 	int err;
> 	int dev_num;
> 	dev_t dev;
> 
> 	if (! request_region(short_base, SHORT_NR_PORTS, "hiro_test")) {
> 		printk(KERN_INFO "can't get I/O port address 0x%lx\n",
> 				short_base);
> 		return -ENODEV;
> 	}
> 
> 	alloc_chrdev_region(&dev, 0, 1, "hiro_test");

why do you register chrdev?

> 	major = MAJOR(dev);
> 	
> 	dev_num = MKDEV(major, 0);
> 
> 	obj_cdev = cdev_alloc();
> 	cdev_init(obj_cdev, &my_fops);
> 	obj_cdev->owner = THIS_MODULE;
> 	obj_cdev->ops = &my_fops;
> 	err = cdev_add(obj_cdev, dev_num, 1);
> 	if(err){
> 		printk(KERN_INFO "err_num : %d", err);	
> 	}
> 
