Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXFSAxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXFSAxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763135AbXFSAxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:53:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:8773 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761816AbXFSAxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Mjh0kzTkUsh5Le4mfZ5Lofkqw6wO/LZqE//J3DjSkvuH4u2dQnsUUJt2lBvZG5WRd752Ir3jf8sUuLD8ap86nsjkhXWuH2OS/9qd/rDVce7AwgnWKMivHYM8SGl5Czo99sFY80BNeLPWvVN/Jot1Wj4BIAOXoXblBqI77jYLKic=
Message-ID: <48a616c60706181753m7fefd35as7f6093d2d54ae05@mail.gmail.com>
Date: Mon, 18 Jun 2007 20:53:19 -0400
From: "News Letter" <newletter.yhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about a strange behavior of copy_to_user() in ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need some help here to understand copy_to_user(). I encountered a
strange copy_to_user() behavior when working on CentOS from Redhat
(kernel version 2.6.9-22.ELsmp, x86_64 CPU).

For a kernel module, I wrote a ioctl call to allow user mode program
to get some kernel data information. When a user program called the
ioctl, most of the time the ioctl failed with EFAULT, failed at
copy_to_user(). It succeeded a few times after a lot of running.

Failed message indicated copy_to_user() returned 3840 (which is
exactly what is asked to copy, PAGE_SIZE-256). The printed value of
the user pointer were identical for successful ioctl calls and failed
ioctl calls. Some relevant details are at the end of this email. I
tried with calloc(PAGE_SIZE, 1), static buffer and automatic variable
on stack in user mode program. They gave the same result.

I appreciate any help.

Best,
Jasper

The ioctl call structure is defined as follows,

struct ioctl_get_info
{
   ... /* some other information */
   unsigned long user_pointer;
   unsigned user_buffer_len;
   unsigned returned_len;
   ... /* some other information */
};

Inside kernel module, a page is allocated with :

static unsigned char *test_page;

static init_test(void)
{
   test_page = __get_free_pages(GFP_KERNEL, 0);
   if (!test_page)
         .... /* some error handling */
}

static int test_ioctl(struct inode * inode, struct file * filp,
unsigned int cmd_in, unsigned long arg)
{
   struct ioctl_get_info igi;
   unsigned size;
   unsigned long remain;

  size = IOC_SIZE(cmd_in);
  if (size != sizeof(igi))
    ....

  ... /* some sanity checking */

  if (!access_ok(VERIFY_READ, (char *)arg, size))
  {
      printk(KERN_INFO "...");
      return -EFAULT;
   }

   if (copy_from_user(&igi, (char *)arg, size) != 0)
   {
       printk(... ...)
       return -EFAULT;
   }

   if (!access_ok(VERIFY_WRITE, (char *)igi.user_pointer, igi.user_buffer_len))
   {
       printk(...);
       return -EFAULT;
   }

   size = PAGE_SIZE - 256;
   if (size > igi.user_buffer_len)
      size = igi.user_buffer_len;
   printk("igi.user_pointer %p size %u\n", igi.user_pointer, size);
   if ((remain = copy_to_user((char *)igi.user_pointer, page + 256, size)) != 0)
   {
      printk ("Failed to copy from user at %p remain %lu asked %u\n",
igi.user_pointer, remain, asked);
/* failed here */
      return -EFAULT;
   }
    igi.returned_len = size;

   /* copy other information */

   return 0;
}
