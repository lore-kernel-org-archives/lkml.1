Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbXGXI0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbXGXI0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbXGXIZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:25:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbXGXIZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:25:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Devesh Sharma" <devesh28@gmail.com>
Subject: Re: Need Help on compat_ioctl implementation
Date: Tue, 24 Jul 2007 09:28:49 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
References: <309a667c0707240015q4a9f32d0h88f0b25f2714d1dc@mail.gmail.com>
In-Reply-To: <309a667c0707240015q4a9f32d0h88f0b25f2714d1dc@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707240928.50378.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Iv7EjNmmoqHLddNJUiW7J6SjLqLKQpnfnLg/
 6xLxps56xcvCs0jpkj8qYRaVTIaLf1PZiLDxWa2VEGaPibqpzG
 YF+5MeQGhPTqQ8kEokwCw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007, Devesh Sharma wrote:
> Hello all,
> I am facing some difficulty to implement compat_ioctl entry point in
> my driver code, please help me out to sort out the things.
> The ioctl is READ WRITE type,
> It takes one header structure as argument the structure is as follows,
> typedef struct
>     {
>         unsigned int Header;
>         void  *          Data;
>         unsigned int  Size;
>     } IOCTL_HEADER;
> 
> corresponding compat strucutre is
> typedef struct ioctl_header32
> {
>  compat_uint_t  Header ;
>  compat_uptr_t Data ;
>  compat_uint_t Size ;
> }IOCTL_HEADER32 ;
> 
> the IOCTL is expected to fill following structure and return.
> typedef struct
> {
>     unsigned int msgsize;
>     char           msg[512];
> } MSG ;

What driver is that? Is it in the mainline kernel? If not, you
should probably completely redo your ioctl interface, as this
has problems to start with, even for the non-compat case...

>  compat_ioctl entry point is as follows.
> 
> long func_ioctl32(
> 
>             struct file *filp,
> 
>             unsigned int cmd,
> 
>             unsigned long arg)
> {
>     long ret = 0 ;
>     IOCTL_HEADER hdr64 ;
>     IOCTL_HEADER32 __user *hdr32 ;
>     unsigned long tmp ;
>     u64 data ;
>     unsigned long size ;
> 
>     hdr32 = (IOCTL_HEADER32 __user *)compat_ptr(arg) ;
>     __get_user(tmp, &(hdr32->Header)) ;
>     __get_user(data, &(hdr32->Data)) ;
>     __get_user(size, &(hdr32->Size)) ;
> 
>     if(!access_ok(
>                   VERIEY_READ|VERIFY_WRITE,
>                   compat_ptr(data),
>                   sizeof(unsigned long)))
>     {
>         printk("No access to this address\n") ;
>         return -EFAULT ;
>     }

You need to check access_ok() before you attempt __get_user.
Also, you must check the return code from each __get_user,
because access_ok() does not check if the data is actually
readable, only if it is part of the user space address range.

It would be easier to do a single copy_from_user on the entire
32 bit header.

>     hdr64.Header = tmp ;
>     hdr64.Data    = data ;

this needs to do a compat_ptr() conversion.

>     hdr64.Size   = size ;
>     handle_ioctls(filp, cmd, (void *)&hdr64) ; /*This func is specific
> to compat ioctl.*/

your handle_ioctls should not need to be specific to compat ioctl,
it's much easier to use the same code for both cases.

>    return ret;
> }
> 
> In handle_ioctl I am doing following steps.
> {
> ioctl_hdr = (IOCTL_HEADER *)cmd_buff ;
> 
>     switch(cmd)
>     {
>         case IOCTL_MSG_GET :
>              {
>                  MSG32 *msg32 ; /* Compat msg struct is defined.*/

The way you showed the definition, MSG32 is identical to MSG,
so you should not define a new structure.

>                   MSG msg ;
>                  unsigned int i ;
> 
>                  msg32 = (MSG32 __user *)ioctl_hdr->Data ;
>                  msg.msgsize = 128 ;
>                  strcpy(msg.msg, MSG_STR) ; /*MSG_STR is a macro string*/
>                  put_user(msg.msgsize, &(msg32->msgsize)) ; /* This
> works fine.*/
>                  put_user(msg.msg[0], (char *) compat_ptr(msg32->msg))
> ; /* This is giving SEG FAULT */

this is not the place to use compat_ptr. If you want to write a single
character here, you could do it like

	put_user(msg.msg[0], &msg32->msg[0]));

But really, you should not need a compat handler for this part, just
call the native handle_ioctl function on the msg.

>              }
>      }
> }
> 
> Question :
> What is the correct way to perform string copy? Or is this method
> correct? if not what is the correct way?
> Any links or pointers are most welcome

Honestly, your code looks so wrong that it's probably not worth trying
to get just the compat_ioctl part right. Please give a pointer to
the full source.

	Arnd <><
