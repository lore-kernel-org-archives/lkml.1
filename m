Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYAHU05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYAHU05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYAHU0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:26:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:55305 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYAHU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s580oNDpZY6+LflG9pchbXPFVQ15LhvzRp5nibXmDr1zKWza+6iR5CmK1/tcuLZUUjPXXgOsuLNvNxbVkbpqMJYKRUYYKPU/hkuyMBqu1vbrxKIyOzd9NrV6iK1htiNI3I63i2g1Rea8Ka/BQdaMRgw9YyXMU/pbGzytJFNhh4c=
Message-ID: <4d8e3fd30801081226u8911e19w7e2d3ef5a3545ef8@mail.gmail.com>
Date: Tue, 8 Jan 2008 21:26:45 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
In-Reply-To: <20080108202059.GK16309@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108164015.GC31504@one.firstfloor.org>
	 <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
	 <20080108200044.GI16309@parisc-linux.org>
	 <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com>
	 <20080108201606.GJ16309@parisc-linux.org>
	 <20080108202059.GK16309@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 9:21 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Jan 08, 2008 at 01:16:06PM -0700, Matthew Wilcox wrote:
> > On Tue, Jan 08, 2008 at 09:03:13PM +0100, Paolo Ciarrocchi wrote:
> > > Yes of course, I've been silly in didn't verify whether the file compile
> > > but I would appreciate to know whether I'm on the right track or not.
> >
> > Well ... you're not.
>
> Here's what a correct conversion might look like.  I haven't tried to
> compile it, so I'm copying and pasting it in order to damage whitespace
> and make sure nobody tries to compile it.
>
> index bf1075e..0c543a8 100644
> --- a/arch/arm/common/rtctime.c
> +++ b/arch/arm/common/rtctime.c
> @@ -174,8 +174,7 @@ static unsigned int rtc_poll(struct file *file, poll_table *
>         return data != 0 ? POLLIN | POLLRDNORM : 0;
>  }
>
> -static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -                    unsigned long arg)
> +static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>         struct rtc_ops *ops = file->private_data;
>         struct rtc_time tm;
> @@ -183,6 +182,8 @@ static int rtc_ioctl(struct inode *inode, struct file *file,
>         void __user *uarg = (void __user *)arg;
>         int ret = -EINVAL;
>
> +       lock_kernel();
> +
>         switch (cmd) {
>         case RTC_ALM_READ:
>                 ret = rtc_arm_read_alarm(ops, &alrm);
> @@ -277,6 +278,9 @@ static int rtc_ioctl(struct inode *inode, struct file *file,
>                         ret = ops->ioctl(cmd, arg);
>                 break;
>         }
> +
> +       unlock_kernel();
> +
>         return ret;
>  }
>
> @@ -334,7 +338,7 @@ static const struct file_operations rtc_fops = {
>         .llseek         = no_llseek,
>         .read           = rtc_read,
>         .poll           = rtc_poll,
> -       .ioctl          = rtc_ioctl,
> +       .unlocked_ioctl = rtc_ioctl,
>         .open           = rtc_open,
>         .release        = rtc_release,
>         .fasync         = rtc_fasync,
>

Thank you Matthew,
I definitely need to back studying before submitting another patch.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
