Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYBEJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYBEJjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 04:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYBEJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 04:39:06 -0500
Received: from ns.ariel-networks.com ([124.39.57.10]:49857 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYBEJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 04:39:04 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: [QUESTION] I have a question about making device driver
Message-Id: <20080205093900.D0BF6948006@ns.ariel-networks.com>
Date: Tue,  5 Feb 2008 18:39:00 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by Hiroyasu Ohyama
====

Thank you for giving some advices.

>
>>I'm writing device driver for parallel port on Linux.
>
>Another one?


I write it for study and fun. And the main reason I chose parallel port is that I think it is simpler than any other device.


>
>>In initial function which is argument of module_init() in my device
>>driver, I reserved I/O address region, 0x378-0x37a, with using
>>request_region() and regist my charactor device driver calling
>>register_chrdev().
>>
>>After I compile and link it. I insert this module and I can confirm
>>that I obtaind the range of I/O address at /proc/ioports. But I
>>cannot write data on I/O address line, It means that following check
>>program shows "false".
>
>>--- check program ---
>>#include <linux/types.h>
>>#include <asm/io.h>
>>#include <stdio.h>
>
>A userspace program? I thought this was about kernel device drivers.


Yes, It is a userspace program to see what I can write parallel port device controller or not.

And, I'm sorry , I should not have explained my device driver in text, but should have written source code.
So that, the following is source code of the device driver. It works only to obtain I/O resource (I/O address and IRQ).


>
>>int main(void){
>>    int base = 0x378;
>>    char read, write;
>>
>>    ioperm(base, 1, 1);
>>
>>    write = 0xa;
>>    outb(write, base);
>>    read = inb(base);
>>    if((read & 0xf) == write){
>
>Some parallel port chips always return 0 on inb(base), for example
>the AMD K6 boards that shipped with VIA Apollo chipsets (1998). On
>the other hand, a chipset as old as to carry a i386DX CPU (probably
>was all Intel back then) returns the desired 0xA on inb(base).


The CPU of hardware requirement is Athlon XP that shipped with SIS 964L, I think that has i386 compatibility but I'll manage with a execution environment having Intel and try it with the other machine.
In current machine, whatever I write date to parallel port controller which is in booked I/O address 0x378, I get only 0xff from inb(0x378).

I found that the check program that I worte in previous mail shows true with loaded parport_pc.
So that I read source code of parport_pc which is driver/parport/parport_pc.c to seek how it enable to write data to I/O line. And I located function to do I/O, that is parport_SPP_supported().
I thought that It was supposed to do enable to do I/O before calling this function, But I couldn't find especially processing.
After that, I didn't find processing that I seeked.

The mainly difference between my device driver and parport_pc , except for beauty and support of several device , is support of DMA.
But I believe this difference is not related.



--- kernel module (device driver) ---

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/fs.h>	
#include <linux/errno.h>
#include <linux/delay.h>
#include <linux/kdev_t.h>
#include <linux/slab.h>
#include <linux/cdev.h>
#include <linux/mm.h>
#include <linux/ioport.h>
#include <linux/interrupt.h>
#include <linux/workqueue.h>
#include <linux/poll.h>
#include <linux/wait.h>
#include <asm/io.h>

#define SHORT_NR_PORTS	8	

static int major = 0;	

unsigned long short_base = 0x378;

volatile int short_irq = 7;
static struct cdev *obj_cdev;

MODULE_AUTHOR ("hiroyasu ohyama");
MODULE_LICENSE("GPL2");

struct file_operations my_fops = {
	.owner	 = THIS_MODULE,
};

irqreturn_t short_sh_interrupt(int irq, void *dev_id, struct pt_regs *regs)
{
	printk(KERN_INFO "interrupt\n");

	return 0;
}

int short_init(void)
{
	int result;
	int err;
	int dev_num;
	dev_t dev;

	if (! request_region(short_base, SHORT_NR_PORTS, "hiro_test")) {
		printk(KERN_INFO "can't get I/O port address 0x%lx\n",
				short_base);
		return -ENODEV;
	}

	alloc_chrdev_region(&dev, 0, 1, "hiro_test");
	major = MAJOR(dev);
	
	dev_num = MKDEV(major, 0);

	obj_cdev = cdev_alloc();
	cdev_init(obj_cdev, &my_fops);
	obj_cdev->owner = THIS_MODULE;
	obj_cdev->ops = &my_fops;
	err = cdev_add(obj_cdev, dev_num, 1);
	if(err){
		printk(KERN_INFO "err_num : %d", err);	
	}

	result = request_irq(short_irq, short_sh_interrupt,
			SA_INTERRUPT,"hiro_test",
			NULL);
	if (result) {
		printk(KERN_INFO "can't get assigned irq %i\n", short_irq);
		short_irq = -1;
	}
	
	printk(KERN_INFO "hiro_test: loaded\n");
	return 0; 
}

void short_cleanup(void)
{
	free_irq(short_irq, NULL);
	cdev_del(obj_cdev);
	release_region(short_base,SHORT_NR_PORTS);
	unregister_chrdev_region(MKDEV(major, 0), 1);
	
	printk(KERN_INFO "hiro_test: Unloaded\n");
}

module_init(short_init);
module_exit(short_cleanup);

