Return-Path: <linux-kernel-owner+w=401wt.eu-S1765995AbXGXHP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765995AbXGXHP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXGXHPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:15:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2543 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXGXHPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QxHsTZKTZIO/+1o0eQ2/9CzuN6zJYLU4txElFHLk0T9mgyPvnJLbIp2WDaUnQTizoksOZ//kXSOTjnHVeeLUwfspZdFZjHYPtbOS7cV2cBarV8OnSe+2j1rkEw/stfcNq9SZz0Cn8CGZ1ybkRVQUZumfT6e+g7Wftnlj95LD4Ws=
Message-ID: <309a667c0707240015q4a9f32d0h88f0b25f2714d1dc@mail.gmail.com>
Date: Tue, 24 Jul 2007 12:45:11 +0530
From: "Devesh Sharma" <devesh28@gmail.com>
To: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Need Help on compat_ioctl implementation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I am facing some difficulty to implement compat_ioctl entry point in
my driver code, please help me out to sort out the things.
The ioctl is READ WRITE type,
It takes one header structure as argument the structure is as follows,
typedef struct
    {
        unsigned int Header;
        void  *          Data;
        unsigned int  Size;
    } IOCTL_HEADER;

corresponding compat strucutre is
typedef struct ioctl_header32
{
 compat_uint_t  Header ;
 compat_uptr_t Data ;
 compat_uint_t Size ;
}IOCTL_HEADER32 ;

the IOCTL is expected to fill following structure and return.
typedef struct
{
    unsigned int msgsize;
    char           msg[512];
} MSG ;

 compat_ioctl entry point is as follows.

long func_ioctl32(

            struct file *filp,

            unsigned int cmd,

            unsigned long arg)
{
    long ret = 0 ;
    IOCTL_HEADER hdr64 ;
    IOCTL_HEADER32 __user *hdr32 ;
    unsigned long tmp ;
    u64 data ;
    unsigned long size ;

    hdr32 = (IOCTL_HEADER32 __user *)compat_ptr(arg) ;
    __get_user(tmp, &(hdr32->Header)) ;
    __get_user(data, &(hdr32->Data)) ;
    __get_user(size, &(hdr32->Size)) ;

    if(!access_ok(
                  VERIEY_READ|VERIFY_WRITE,
                  compat_ptr(data),
                  sizeof(unsigned long)))
    {
        printk("No access to this address\n") ;
        return -EFAULT ;
    }

    hdr64.Header = tmp ;
    hdr64.Data    = data ;
    hdr64.Size   = size ;
    handle_ioctls(filp, cmd, (void *)&hdr64) ; /*This func is specific
to compat ioctl.*/

   return ret;
}

In handle_ioctl I am doing following steps.
{
ioctl_hdr = (IOCTL_HEADER *)cmd_buff ;

    switch(cmd)
    {
        case IOCTL_MSG_GET :
             {
                 MSG32 *msg32 ; /* Compat msg struct is defined.*/
                  MSG msg ;
                 unsigned int i ;

                 msg32 = (MSG32 __user *)ioctl_hdr->Data ;
                 msg.msgsize = 128 ;
                 strcpy(msg.msg, MSG_STR) ; /*MSG_STR is a macro string*/
                 put_user(msg.msgsize, &(msg32->msgsize)) ; /* This
works fine.*/
                 put_user(msg.msg[0], (char *) compat_ptr(msg32->msg))
; /* This is giving SEG FAULT */
             }
     }
}

Question :
What is the correct way to perform string copy? Or is this method
correct? if not what is the correct way?
Any links or pointers are most welcome

Thanks in advance
Devesh
