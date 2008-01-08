Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYAHXzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYAHXzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYAHXzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:55:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:52827 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYAHXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=w36q+PftS9evVLIxAkp369xrLRheDwa/PTxJbDqBkkdzFGrN980CAUf0dXu4kk0Lza68tOBB5fhXRgYIkp9Y//BhHeOdWCZa4vB9k++gHuS2Xsp4J1W8EnRGSibrCatimiSSnZn+FvN92bX34D03V8443iSkjt7qE+2XezxYI7E=
Message-ID: <47840D56.2080107@gmail.com>
Date: Wed, 09 Jan 2008 02:55:02 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <20080108200044.GI16309@parisc-linux.org> <4d8e3fd30801081203l636c5923j7965efaa9c121c56@mail.gmail.com> <20080108201606.GJ16309@parisc-linux.org> <20080108202059.GK16309@parisc-linux.org>
In-Reply-To: <20080108202059.GK16309@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox пишет:
> On Tue, Jan 08, 2008 at 01:16:06PM -0700, Matthew Wilcox wrote:
>> On Tue, Jan 08, 2008 at 09:03:13PM +0100, Paolo Ciarrocchi wrote:
>>> Yes of course, I've been silly in didn't verify whether the file compile
>>> but I would appreciate to know whether I'm on the right track or not.
>> Well ... you're not.
> 
> Here's what a correct conversion might look like.  I haven't tried to
> compile it, so I'm copying and pasting it in order to damage whitespace
> and make sure nobody tries to compile it.

It seems that the kernel janitors project needs to explicitly describe the
prerequisites a person should meet before tackling the enterprise's toughest
technical challenges such as operating system kernel development.

On the face of it, it seems quite ridiculous to me that a team of extremely
qualified kernel engineers spend their valuable time teaching the basics of
the C language using this mailing list. Time is precious, and even more so
when we are having that many unresolved problems, e.g. when the Kernel Bug
Tracker lists more than 1300 open bugs:

http://bugzilla.kernel.org/buglist.cgi?order=relevance&bug_status=__open__

Paolo, I have nothing against you personally as you seem to have adequately
reacted to what is going on and went on strengthening your C skills; my point
is that an operating system kernel development facility such as LKML is most
probably not the right place to set up a correspondence course in programming
basics.

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
> 

