Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXFOASN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXFOASN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXFOAR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:17:59 -0400
Received: from smtp-01b.mandic.com.br ([200.225.81.136]:58888 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750878AbXFOAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:17:58 -0400
Message-ID: <4671DAAF.8000008@mandic.com.br>
Date: Thu, 14 Jun 2007 21:17:51 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Test_Module] Changing brightness in Toshiba notebooks with Phoenix
 Bios
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding from: Toshiba_Linux-Users (tlinux-users@linux.toshiba-dme.co.jp)

=============
I only tested on my Toshiba Satellite Pro A100 and it works.

To compile:
Edit a Makefile and add:
   obj-m := test.o

then run in the same directory:

  make -C /usr/src/linux SUBDIRS=`pwd` modules

Then make the file for the new device:

  mknod test_file c 181 0

Load de module:

  insmod test.ko

And now, if you are very very lucky, maybe it will work:

   echo 3 > test_file

But I warn: THE MOST PROBABLY THING WILL HAPPEN IS THE FREEZE OF THE
LAPTOP IF YOUR MODEL DOESN'T MATCH EXACTLY WITH THE MODEL I TESTED. If
you don't have a Phoenix BIOS don't try this, and if you have.. well..
it's your election x)

Here is the driver

test.c
=================== CUT HERE ===================
/*
* Module for Toshiba lcd bright change.
* I only made it for my Toshiba Satellite Pro A100 with Phoenix BIOS
* I don't know under which models it works (I suppose very few)
* The asm code I inserted I took it from a disass of the windows
* driver provided by Toshiba.
* WARNING:
* The driver does NOT make any tests if the model is valid or not
* so, the MOST probably effect of running this will be the hang of
* the laptop, or something worse.
* PLEASE DON'T USE THIS unless you really know what you are doing
* This module isn't made for give support to any Toshiba model,
* only for tests purpouses , sorry about it.
*
* Jaime F. <jaimeff@gmail.com>
* License: GNU/GPL
*/


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/io.h>

#define DEVICE_NAME "lcd_bright"
#define MAJOR_NUM 181

char *ptr;

static ssize_t
device_write(struct file *file,
             const char __user * buffer, size_t length, loff_t * offset)
{
  char *addr;
  addr=(char *)__pa(ptr);
  addr+=0x10;

  strcpy(ptr, "INVTOS");
  //ptr+=10;
  *(ptr+16)=(char) buffer[0]-0x30;
  //printk("escribiendo %x\n", *ptr);
/*
  inb( 0x2e);
  inb( 0x2f);
  outb(7, 0x2e);
  outb(9, 0x2f);
  v3=inb(0x2f);
  outb2(0x2e, 0x55);
  outb2(0x2e, 7);
  outb2(0x2f,0x10);
  outb2(0x2e,0xe0);
  v4=inb(0x2f);
  outb2(0x2f,2);
  v5=inb(0x2f);
  outb2(0x2f,3);

  outb2(0x2e, 7);
  outb2(0x2f,9);
  outb2(0x2e,0x60);
  v1=inb(0x2f);
  outb2(0x2e,7);
  outb2(0x2f,0x10);
  outb2(0x2e,0xe0);
  outb2(0x2f,0);
  outb2(0x2e, 7);
  outb2(0x2f, 9);
  outb2 ( 0x2e, 0xaa);
  outb2 ( 0x400, 0xAF);
  v2=inb( 0x401);
  outb2( 0x400, 0xAF);
*/

  __asm__("cli\n"
        /*        "mov $0x01E4, %%eax\n"
                  "mov $0x00b0, %%dx\n"
                  "movb $0x02, 0xEF\n"
                  "out %%eax, %%dx\n"
*/
                "mov %0, %%edx\n"
                "mov %%edx, %%edi\n"
                "mov $0x20, %%ecx\n"
                "mov $0x8000f840, %%eax\n mov $0xcf8, %%edx\n out %%eax, 
%%dx\n"
                "mov $0xcfc, %%dx\n"
                "in %%dx, %%eax\n"
                "and $0x0000ff80, %%eax\n"
                "add $0x2c, %%eax\n"
                "mov %%ax, %%dx\n"
                "in %%dx, %%eax\n"
                "push %%eax\n"
//              "mov %%ax, %%dx\n"
                "xor %%eax, %%eax\n"
                "out %%eax, %%dx\n"
                "mov $0xA2E4, %%eax\n"
                "mov $0xb2, %%dx\n"
                "out %%eax, %%dx\n"
                "pop %%eax\n"
                "mov $0x102c, %%dx\n"
                "out %%eax, %%dx\n"
/*              "movl $0x10, %%edx\n\t"
                "movl %%edx, %%edi\n\t"
                "movl $0x20, %%ecx\n"
                "movw  $0x00E4, %%ax\n"
                "movb  $0x5, %%ah\n"
                "outw  %%ax, $0xb2\n"
                "movl %%eax, %0\n sti\n"
                */
        :
        :"r"(addr): "%eax", "%edx", "%ecx","%edi", "%esi");
  return length;
}

struct file_operations Fops = {
  .write = device_write,
};

int init_module()
{
  int ret_val;
  ptr=(char *)kmalloc(100, GFP_KERNEL);
  ptr+=10;
  ret_val = register_chrdev(MAJOR_NUM, DEVICE_NAME, &Fops);

  if (ret_val < 0)
  {
    printk(KERN_ALERT "El registro del dispositivo falló (%d)\n", ret_val);
    return ret_val;
  }

return 0;
}

void cleanup_module()
{
  int ret;

  ret = unregister_chrdev(MAJOR_NUM, DEVICE_NAME);

  if (ret < 0)
    printk(KERN_ALERT "Error: unregister_chrdev: %d\n", ret);
}

===================== CUT HERE ====================

Best Regards,
Renato S. Yamane
