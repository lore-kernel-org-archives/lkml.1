Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXFSHyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXFSHyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXFSHyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:54:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:44472 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXFSHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sapNwNyPi2q+NMfdeCG5P3uKLWeO+XkRfE4ENUXykkkCKzuI8YV3QT3lFi6ANEuqTH5z6FxoPn/6ti0FPBUEudRSknaCTqXfotQIYYfXHuN56Fn6YV4ByudEqCNVnBPZDTXQZZihe6+KSzji2mWkqAuUMTzMu5TybBCmq5iaZQg=
Message-ID: <46778BC6.8020001@gmail.com>
Date: Tue, 19 Jun 2007 09:54:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: News Letter <newletter.yhl@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about a strange behavior of copy_to_user() in ioctl
 call
References: <48a616c60706181753m7fefd35as7f6093d2d54ae05@mail.gmail.com>
In-Reply-To: <48a616c60706181753m7fefd35as7f6093d2d54ae05@mail.gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

News Letter napsal(a):
> Hi,
> 
> I need some help here to understand copy_to_user(). I encountered a
> strange copy_to_user() behavior when working on CentOS from Redhat
> (kernel version 2.6.9-22.ELsmp, x86_64 CPU).
> 
> For a kernel module, I wrote a ioctl call to allow user mode program
> to get some kernel data information. When a user program called the
> ioctl, most of the time the ioctl failed with EFAULT, failed at
> copy_to_user(). It succeeded a few times after a lot of running.
> 
> Failed message indicated copy_to_user() returned 3840 (which is
> exactly what is asked to copy, PAGE_SIZE-256). The printed value of
> the user pointer were identical for successful ioctl calls and failed
> ioctl calls. Some relevant details are at the end of this email. I
> tried with calloc(PAGE_SIZE, 1), static buffer and automatic variable
> on stack in user mode program. They gave the same result.
> 
> I appreciate any help.
> 
> Best,
> Jasper
> 
> The ioctl call structure is defined as follows,
> 
> struct ioctl_get_info
> {
>   ... /* some other information */
>   unsigned long user_pointer;
>   unsigned user_buffer_len;
>   unsigned returned_len;
>   ... /* some other information */
> };
> 
> Inside kernel module, a page is allocated with :
> 
> static unsigned char *test_page;
> 
> static init_test(void)
> {
>   test_page = __get_free_pages(GFP_KERNEL, 0);
>   if (!test_page)
>         .... /* some error handling */
> }
> 
> static int test_ioctl(struct inode * inode, struct file * filp,
> unsigned int cmd_in, unsigned long arg)
> {
>   struct ioctl_get_info igi;
>   unsigned size;
>   unsigned long remain;
> 
>  size = IOC_SIZE(cmd_in);
>  if (size != sizeof(igi))
>    ....
> 
>  ... /* some sanity checking */
> 
>  if (!access_ok(VERIFY_READ, (char *)arg, size))
>  {
>      printk(KERN_INFO "...");
>      return -EFAULT;
>   }
> 
>   if (copy_from_user(&igi, (char *)arg, size) != 0)
>   {
>       printk(... ...)
>       return -EFAULT;
>   }
> 
>   if (!access_ok(VERIFY_WRITE, (char *)igi.user_pointer,
> igi.user_buffer_len))
>   {
>       printk(...);
>       return -EFAULT;
>   }
> 
>   size = PAGE_SIZE - 256;
>   if (size > igi.user_buffer_len)
>      size = igi.user_buffer_len;
>   printk("igi.user_pointer %p size %u\n", igi.user_pointer, size);

Weird. Are you sure, that previous access_ok doesn't fail with this 'size', not
the 'igi.user_buffer_len'? Anyway, you can remove these access_ok checks, since
they are provided by copy_from/to_user after debugging.

>   if ((remain = copy_to_user((char *)igi.user_pointer, page + 256,
> size)) != 0)
>   {
>      printk ("Failed to copy from user at %p remain %lu asked %u\n",
> igi.user_pointer, remain, asked);
> /* failed here */
>      return -EFAULT;
>   }
>    igi.returned_len = size;
> 
>   /* copy other information */
> 
>   return 0;
> }

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
