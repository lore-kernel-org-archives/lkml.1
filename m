Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZDJFPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZDJFPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZDJFPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:15:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZDJFPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:15:30 -0400
Date: Thu, 9 Apr 2009 22:14:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean up sys_shutdown
Message-Id: <20090409221416.9a74f7fa.akpm@linux-foundation.org>
In-Reply-To: <20090407223626.GA25557@basil.nowhere.org>
References: <20090407223626.GA25557@basil.nowhere.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 00:36:26 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Clean up sys_shutdown exit path
> 
> Impact: cleanup, fix
> 
> Clean up sys_shutdown exit path. Factor out common code.

OK.

> Return
> correct error code instead of always 0 on failure.

oh goody, that makes the patch a bugfix.

> --- linux.orig/kernel/sys.c	2009-04-07 16:09:58.000000000 +0200
> +++ linux/kernel/sys.c	2009-04-07 16:43:17.000000000 +0200
> @@ -360,6 +360,7 @@
>  		void __user *, arg)
>  {
>  	char buffer[256];
> +	int ret = 0;
>  
>  	/* We only trust the superuser with rebooting the system. */
>  	if (!capable(CAP_SYS_BOOT))
> @@ -397,7 +398,7 @@
>  		kernel_halt();
>  		unlock_kernel();
>  		do_exit(0);
> -		break;
> +		panic("cannot halt");
>  
>  	case LINUX_REBOOT_CMD_POWER_OFF:
>  		kernel_power_off();
> @@ -417,29 +418,22 @@
>  
>  #ifdef CONFIG_KEXEC
>  	case LINUX_REBOOT_CMD_KEXEC:
> -		{
> -			int ret;
> -			ret = kernel_kexec();
> -			unlock_kernel();
> -			return ret;
> -		}
> +		ret = kernel_kexec();
> +		break;
>  #endif
>  
>  #ifdef CONFIG_HIBERNATION
>  	case LINUX_REBOOT_CMD_SW_SUSPEND:
> -		{
> -			int ret = hibernate();
> -			unlock_kernel();
> -			return ret;
> -		}
> +		ret = hibernate();
> +		break;
>  #endif
>  
>  	default:
> -		unlock_kernel();
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		break;
>  	}
>  	unlock_kernel();
> -	return 0;
> +	return ret;
>  }

I wonder why this code uses lock_kernel().
