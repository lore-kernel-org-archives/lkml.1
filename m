Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYAHUj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYAHUj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYAHUjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:39:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37664 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYAHUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:39:47 -0500
Date: Tue, 8 Jan 2008 21:42:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108204214.GA2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I grepped and tried to do what you suggested.

First a quick question: how would you rate your C knowledge? Did you
ever write a program yourself? 

My proposal assumes that you have at least basic C knowledge.

> The first file that git grep reported was:
> arch/arm/common/rtctime.c:static const struct file_operations rtc_fops = {

It's probably better to only do that on files which you can easily compile.
For ARM you would need a cross compiler.

> 
> So I cooked up the following patch (probably mangled, just to give you
> a rough idea of what I did):
> diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
> index bf1075e..19dedb5 100644
> --- a/arch/arm/common/rtctime.c
> +++ b/arch/arm/common/rtctime.c
> @@ -189,13 +189,16 @@ static int rtc_ioctl(struct inode *inode, struct
> file *file, unsigned int cmd,
>  		if (ret)
>  			break;
>  		ret = copy_to_user(uarg, &alrm.time, sizeof(tm));
> -		if (ret)
> +		if (ret) {
> +			unlock_kernel();
>  			ret = -EFAULT;

In this case it would be better to just put the unlock_kernel() directly
before the single return. You only need to sprinkle them all over when
the function has multiple returns. Or then change the flow to only
have a single return, but that would be slightly advanced.


> -		if (ret)
> +		if (ret) {
> +			unlock_kernel();
>  			ret = -EFAULT;
> +		}
>  		break;
> 
>  	default:
> @@ -329,15 +340,18 @@ static int rtc_fasync(int fd, struct file *file, int on)
>  	return fasync_helper(fd, file, on, &rtc_async_queue);
>  }
> 
> -static const struct file_operations rtc_fops = {
> +static long rtc_fioctl(struct file_operations rtc_fops)
> +{
> +	lock_kernel();

No the lock_kernel() of course has to be in the function, not in the structure
definition which does not contain any code.

Also the _operations structure stays the same (except for .ioctl -> .unlocked_ioctl); 
only the the ioctl function prototype changes.


> Am I'm working in the right direction or should I completely redo the patch?

I would suggest to only work on files that compile. e.g. do a

make allyesconfig
make -j$[$(grep -c processor /proc/cpuinfo)*2] &1 |tee LOG             (will probably take a long time) 

first and then only modify files when are mentioned in "LOG" 

-Andi
