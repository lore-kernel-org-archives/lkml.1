Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbYCEMca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbYCEMca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbYCEMcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:32:21 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44003 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbYCEMcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:32:20 -0500
Date: Wed, 5 Mar 2008 09:10:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pawel Plociennik <paplociennik@gmail.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
Message-ID: <20080305081016.GA9257@elf.ucw.cz>
References: <200803011409.59526.paplociennik@gmail.com> <20080303141203.GB12606@elf.ucw.cz> <3d8471ca0803030719x418f9997tc428344e659a6c90@mail.gmail.com> <200803050838.03452.paplociennik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803050838.03452.paplociennik@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Monday 03 March 2008 10:19, Guillaume Chazarain wrote:
> >
> > init=/working_distro/lib/ld-linux.so.2 --library-path
> > /working_distro/lib  /working_distro/usr/sbin/chroot /working_distro/
> > /sbin/init
> > 
> root=<root> init=/working_distro/lib/ld-linux.so.2 --library-path 
> /working_distro/lib working_distro/usr/sbin/chroot /working_distro/ /sbin/init
> 
> I think that it is *interestly* hack but I am not sure that it will be an usable method for all of a distroes which exists on the world.
> At last my patch is as simple as possible and it has *only* a *few lines of the code* and it can be used
> as *independent* method to various *hundred* distroes.
> 
> root=<root> chroot=<chroot>
> 
> and it looks *beautiful* I think :-)
> 
> so I have sent a patch again which it has corrected a *coding style* and a new description in a kernel-parameters.txt file
> (a suggestions for better description are welcome).
> I think that this can be a *last version* of a patch.
> Because I am *newbie* in a kernel hacking I hope that someone will had been written me what now with it ?
> Maybe send this patch *directly* to *kernel guru* such as Andrew
> Morton which manages a -mm series ?

You need to add Signed-off-by... as per
Documentation/Submitting*... and proper changelog would be nice.

And you can add 

Acked-by: Pavel Machek <pavel@suse.cz>

Yes, I think this should go to mm. ... but better Cc Andrew next time.
								Pavel

> 
> diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt
> --- linux-2.6.24-orig/Documentation/kernel-parameters.txt	2008-02-25 20:53:26.000000000 -0500
> +++ linux-2.6.24/Documentation/kernel-parameters.txt	2008-03-04 09:51:52.000000000 -0500
> @@ -381,6 +381,8 @@ and is between 256 and 4096 characters. 
>  			Value can be changed at runtime via
>  				/selinux/checkreqprot.
>  	
> +	chroot=		[KNL] change a root for an init process.
> +
>  	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
>  			[Deprecated]
>  			Forces specified clocksource (if available) to be used
> diff -urp linux-2.6.24-orig/init/main.c linux-2.6.24/init/main.c
> --- linux-2.6.24-orig/init/main.c	2008-03-01 12:58:37.000000000 -0500
> +++ linux-2.6.24/init/main.c	2008-03-05 08:23:32.000000000 -0500
> @@ -755,8 +755,20 @@ static void __init do_pre_smp_initcalls(
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
> +	if (chroot_str)
> +		if (sys_chroot(chroot_str) < 0)
> +			printk(KERN_WARNING "chroot=%s failed\n", chroot_str);
> +
>  	argv_init[0] = init_filename;
>  	kernel_execve(init_filename, argv_init, envp_init);
>  }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
