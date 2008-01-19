Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbYASPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbYASPMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbYASPMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:12:13 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:18302 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbYASPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:12:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U4uy/AFp0sLnZKoAPijGVZ1K+Zrzcln1lBpD0RjQV1T2rZIE58qgjy/HndAX1kcAHJCSkbk2hA4nJoafni8nmllx2TXzmnkreoSBx2YSb2hmH4QUiM00EGv7lLTCoLZUN5SGEDxHOTss3gs+2+pcr67Tt8QZ1oYCVoJMSLtWmWA=
Message-ID: <ee3dc96c0801190712v56bcfde5qa015888f2bcbde98@mail.gmail.com>
Date: Sat, 19 Jan 2008 12:12:10 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: new file in kernel.
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801191526200.27831@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
	 <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
	 <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com>
	 <Pine.LNX.4.64.0801191526200.27831@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jan,

The idea of the indirection is to make it transparent for the user.
The idea is to do almost the same as what IPC does. The user calls
"get", then "attach". In the "get" syscall I create a tmp file and
return some id. Then the user calls an "attach" syscall with the
returned id.

The result is that he gets a shared memorymapped to his vma.

Is my idea clearer now?

As for the snippet, thank you. But I read somewhere that it is not
recommended to call system calls inside another system call, right?

So, I think somthing like this code would do, right?

asmlinkage long sys_my_shmget(int size)
{
       long ret;

       ret = sys_open("/tmp/shmfile", O_CREAT | O_RDWR  , 777);
       if (ret < 0)
               return ret;
       sys_close(fd);
       return 0;
}

what do you think??



Greetings, Rafael Sisto

On Jan 19, 2008 11:30 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 19 2008 11:08, Rafael Sisto wrote:
> >
> >I had already read that webpage, but I dont need to change the data on
> >that file. I just want to create a new file and then close it, so I
> >can use it later in another system call, to mmap it to a user space.
> >Is it clearer now?
> >Can you please give me some code snippet?
>
> I don't get what your indirection is supposed to do.
>
>  userspace -> sys_open -> kernel space -> create file
>            -> sys_close -> kernel space -> close it
>
> vs
>
>  userspace -> sys_mycall -> kernelspace -> sys_open -> create_file
>                                         -> sys_close -> create_file
>
> As for code snippets:
>
> asmlinkage logn sys_mycall(const char __user *filename,
>     unsigned int flags, unsigned int mode)
> {
>         long ret;
>
>         ret = sys_open(filename, flags, mode);
>         if (ret < 0)
>                 return ret;
>
>         return sys_close(fd);
> }
>
> You see, this is currently just too trivial to make sense, but if
> it helps you, no problem.
>
> >Sorry for the last mail, I answered to your personal mail only)
>
> Here, we use Reply-to-all.
>
>
