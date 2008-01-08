Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYAHUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYAHUph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYAHUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:45:29 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:8541 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYAHUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tQNZ+jY0kXoxkcWSjfRyg3hcE+cB2zemBYBewzbjZMKJ6B1/dkDbxTEnfowGMNaudDrPYM43WOdFAr5Mb6F3KLZ6PgZRsIVOlcpQqkaGvQTDBy//IM3Ij18TXGASG9SLuFh6l5wuUyGBTJrUrgj/iNIpIOxNk8DA+D+BhuoUIyg=
Message-ID: <4d8e3fd30801081245s3871d9a9n89b4db07c5a3a8d5@mail.gmail.com>
Date: Tue, 8 Jan 2008 21:45:24 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
In-Reply-To: <20080108204214.GA2117@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108164015.GC31504@one.firstfloor.org>
	 <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
	 <20080108204214.GA2117@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 9:42 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > I grepped and tried to do what you suggested.
>
> First a quick question: how would you rate your C knowledge? Did you
> ever write a program yourself?

Yes I did but I probably beeing inactive for too much time,
I need to back studing a bit before submitting another patch.

> My proposal assumes that you have at least basic C knowledge.
>
> > The first file that git grep reported was:
> > arch/arm/common/rtctime.c:static const struct file_operations rtc_fops = {
>
> It's probably better to only do that on files which you can easily compile.
> For ARM you would need a cross compiler.
>
> >
> > So I cooked up the following patch (probably mangled, just to give you
> > a rough idea of what I did):
> > diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
> > index bf1075e..19dedb5 100644
> > --- a/arch/arm/common/rtctime.c
> > +++ b/arch/arm/common/rtctime.c
> > @@ -189,13 +189,16 @@ static int rtc_ioctl(struct inode *inode, struct
> > file *file, unsigned int cmd,
> >               if (ret)
> >                       break;
> >               ret = copy_to_user(uarg, &alrm.time, sizeof(tm));
> > -             if (ret)
> > +             if (ret) {
> > +                     unlock_kernel();
> >                       ret = -EFAULT;
>
> In this case it would be better to just put the unlock_kernel() directly
> before the single return. You only need to sprinkle them all over when
> the function has multiple returns.

Understood. As Matthew did in his patch.

> Or then change the flow to only
> have a single return, but that would be slightly advanced.
>
>
> > -             if (ret)
> > +             if (ret) {
> > +                     unlock_kernel();
> >                       ret = -EFAULT;
> > +             }
> >               break;
> >
> >       default:
> > @@ -329,15 +340,18 @@ static int rtc_fasync(int fd, struct file *file, int on)
> >       return fasync_helper(fd, file, on, &rtc_async_queue);
> >  }
> >
> > -static const struct file_operations rtc_fops = {
> > +static long rtc_fioctl(struct file_operations rtc_fops)
> > +{
> > +     lock_kernel();
>
> No the lock_kernel() of course has to be in the function, not in the structure
> definition which does not contain any code.

Yes, understood now. Silly me :-/

> Also the _operations structure stays the same (except for .ioctl -> .unlocked_ioctl);
> only the the ioctl function prototype changes.
>
>
> > Am I'm working in the right direction or should I completely redo the patch?
>
> I would suggest to only work on files that compile. e.g. do a
>
> make allyesconfig
> make -j$[$(grep -c processor /proc/cpuinfo)*2] &1 |tee LOG             (will probably take a long time)
>
> first and then only modify files when are mentioned in "LOG"

Thanks you.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
