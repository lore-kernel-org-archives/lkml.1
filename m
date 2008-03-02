Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbYCBPnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYCBPnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCBPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:42:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2356 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752480AbYCBPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:42:54 -0500
Date: Sun, 2 Mar 2008 16:35:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pawel Plociennik <paplociennik@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] chroot= as a new kernel parameter
Message-ID: <20080302153503.GD3861@ucw.cz>
References: <200803011409.59526.paplociennik@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803011409.59526.paplociennik@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> hi *real* hackers,

:-).

> it is a my first post to lkml and I hope that you will have not been
> ignored me if I have done some incorrect thing.
> 
> In the short this patch has added a new chroot= kernel parameter which can be used
> to changing a chroot of an init process before it will has been runed.
> I use that for testing variouses distroes without making a separate partition but
> by copied a new root-fs to a new subdirectory on the my *base* filesystem.

Yes please. I was thinking about doing this long ago, but never got to
coding it.


> diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt
> --- linux-2.6.24-orig/Documentation/kernel-parameters.txt	2008-02-25 20:53:26.000000000 -0500
> +++ linux-2.6.24/Documentation/kernel-parameters.txt	2008-02-25 20:51:21.000000000 -0500
> @@ -381,6 +381,8 @@ and is between 256 and 4096 characters. 
>  			Value can be changed at runtime via
>  				/selinux/checkreqprot.
>  	
> +	chroot=		[KNL] call chroot() for init proccess.
> +
>  	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
>  			[Deprecated]
>  			Forces specified clocksource (if available) to be used
> diff -urp linux-2.6.24-orig/init/main.c linux-2.6.24/init/main.c
> --- linux-2.6.24-orig/init/main.c	2008-03-01 12:58:37.000000000 -0500
> +++ linux-2.6.24/init/main.c	2008-02-25 20:36:06.000000000 -0500
> @@ -755,8 +755,22 @@ static void __init do_pre_smp_initcalls(
>  		spawn_softlockup_task();
>  }
>  
> +static void *chroot_str;
> +static int __init chroot_setup(char *str)
> +{
> +	chroot_str = str;
> +	return 1;
> +}
> +__setup("chroot=", chroot_setup);
> +
>  static void run_init_process(char *init_filename)
>  {
> +	if(chroot_str) {

'if ('

> +		if(sys_chroot(chroot_str) < 0)

here too.

> +			printk("chroot=%s failed\n", chroot_str);
> +		else
> +			printk("chroot=%s successed\n",chroot_str);

And I do not think we want to printk in the success case.

Thanks, 
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
