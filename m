Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXBUUih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXBUUih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161178AbXBUUih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:38:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:48979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161173AbXBUUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:38:36 -0500
Date: Wed, 21 Feb 2007 12:36:52 -0800
From: Greg KH <greg@kroah.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux 2.6.21-rc1)
Message-ID: <20070221203652.GB17830@kroah.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070222.012356.27907445.yoshfuji@linux-ipv6.org> <87ps8372bf.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ps8372bf.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 04:12:04AM +0900, OGAWA Hirofumi wrote:
> YOSHIFUJI Hideaki / ?$B5HF#1QL@ <yoshfuji@linux-ipv6.org> writes:
> 
> > In article <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> (at Tue, 20 Feb 2007 20:53:45 -0800 (PST)), Linus Torvalds <torvalds@linux-foundation.org> says:
> >
> >> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
> >> name it), ACPI updates, and lots of driver work. And just a lot of 
> >> cleanups.
> >
> > I cannot boot 2.6.21-rc1; it falls into OOM-Killer.
> >
> > Interesting error message I can see is:
> >    request_module: runaway loop modprobe net-pf-1
> >
> > After bisecting, the commit
> >   Driver core: let request_module() send a /sys/modules/kmod/-uevent
> > (id c353c3fb0700a3c17ea2b0237710a184232ccd7f) is to blame.
> >
> > Reverting it fixes the issue to me.
> 
> /sbin/hotplug needs some module, but request_module() call /sbin/hotplug loop?
> Hm.. does the patch fix the problem?

How does it loop?

> BTW, mod_request_helper alias of /proc/sys/kernel/modprobe is really needed?

What do you mean?

> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> 
> Don't use uevent until udevd or something like other setup done.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  kernel/kmod.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff -puN kernel/kmod.c~kmod-uevent-fix kernel/kmod.c
> --- linux-2.6/kernel/kmod.c~kmod-uevent-fix	2007-02-22 03:42:37.000000000 +0900
> +++ linux-2.6-hirofumi/kernel/kmod.c	2007-02-22 03:42:48.000000000 +0900
> @@ -90,11 +90,11 @@ int request_module(const char *fmt, ...)
>  	if (ret >= MODULE_NAME_LEN)
>  		return -ENAMETOOLONG;
>  
> -	strcpy(&modalias[strlen("MODALIAS=")], module_name);
> -	kobject_uevent_env(&kmod_mk.kobj, KOBJ_CHANGE, uevent_envp);
> -
> -	if (modprobe_path[0] == '\0')
> +	if (modprobe_path[0] == '\0') {
> +		strcpy(&modalias[strlen("MODALIAS=")], module_name);
> +		kobject_uevent_env(&kmod_mk.kobj, KOBJ_CHANGE, uevent_envp);
>  		goto out;
> +	}

No, we want to still emit these messgages, even if we have a real
"helper" application.  I don't see how this would fix the problem.

thanks,

greg k-h
