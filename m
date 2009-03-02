Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbZCBIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbZCBIi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZCBIiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:38:19 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:60759 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbZCBIiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:38:18 -0500
In-Reply-To: <200903021115.23878.rusty@rustcorp.com.au>
References: <20090227170105.GA22304@schmichrtp.de.ibm.com> <200903021115.23878.rusty@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: Command line parameter not passed to module in linux-next
X-KeepSent: B8E1FABA:52FC2AD3-C125756D:002F300A;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
From: Christof Schmitt <christof.schmitt@de.ibm.com>
X-MIMETrack: S/MIME Sign by Notes Client on Christof Schmitt/Germany/IBM(Release 8.5|December
 05, 2008) at 03/02/2009 09:37:01 AM,
	Serialize by Notes Client on Christof Schmitt/Germany/IBM(Release 8.5|December
 05, 2008) at 03/02/2009 09:37:01 AM,
	Serialize complete at 03/02/2009 09:37:01 AM,
	S/MIME Sign failed at 03/02/2009 09:37:01 AM: The cryptographic key was not
 found,
	Serialize by Router on D12ML072/12/M/IBM(Release 8.0.1|February 07, 2008) at
 02/03/2009 09:38:10,
	Serialize complete at 02/03/2009 09:38:10
Message-ID: <OFB8E1FABA.52FC2AD3-ONC125756D.002F300A-C125756D.002F7086@de.ibm.com>
Date: Mon, 2 Mar 2009 09:38:09 +0100
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote on 03/02/2009 01:45:23 AM:

> On Saturday 28 February 2009 03:31:05 Christof Schmitt wrote:
> > The linux-next kernel does not pass charp parameters from the kernel
> > command line to modules:
> > 
> > # cat /proc/cmdline 
> > dasd=4d70-4d73 root=/dev/dasdc1 zfcp.device=0.0.181d,
> 0x500507630310c562,0x401040C300000000 zfcp.dbfsize=4096  BOOT_IMAGE=0 
> > 
> > # cat /sys/module/zfcp/parameters/device 
> > <NULL>
> 
> Thanks:
> 
> param: fix charp parameters set via sysfs: FIX
> 
> We can't kmalloc at early cmdline parsing.
> 
> Reported-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/kernel/params.c b/kernel/params.c
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -223,10 +223,16 @@ int param_set_charp(const char *val, str
>     if (kp->perm & KPARAM_KMALLOCED)
>        kfree(*(char **)kp->arg);
> 
> -   kp->perm |= KPARAM_KMALLOCED;
> -   *(char **)kp->arg = kstrdup(val, GFP_KERNEL);
> -   if (!kp->arg)
> -      return -ENOMEM;
> +   /* This is a hack.  We can't need to strdup in early boot, and we
> +    * don't need to; this mangled commandline is preserved. */
> +   if (slab_is_available()) {
> +      kp->perm |= KPARAM_KMALLOCED;
> +      *(char **)kp->arg = kstrdup(val, GFP_KERNEL);
> +      if (!kp->arg)
> +         return -ENOMEM;
> +   } else
> +      *(const char **)kp->arg = val;
> +
>     return 0;
>  }

Thanks, the patch works for me.
Tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>

--
Christof Schmitt
