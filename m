Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0BBArK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:47:10 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:45604 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750915Ab0BBArI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:47:08 -0500
Message-ID: <4B6775F7.5000206@snapgear.com>
Date: Tue, 02 Feb 2010 10:46:47 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: gerg@uclinux.org, ysato@users.sourceforge.jp, monstr@monstr.eu,
       roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use ptrace_request in the remaining architectures
References: <20100201193301.GA12024@lst.de>
In-Reply-To: <20100201193301.GA12024@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Use ptrace_request in the three remaining architectures that didn't use it
> (m68knommu, h8300, microblaze).  This means:
> 
>  - ptrace_request now handles PTRACE_{PEEK,POKE}{TEXT,DATA} and PTRACE_DETATCH
>    calls that were previously called directly, or in case of h8300 even open
>    coded.
>  - adds new support for PTRACE_SETOPTIONS/PTRACE_GETEVENTMSG/
>    PTRACE_GETSIGINFO/PTRACE_SETSIGINFO
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> Index: linux-2.6/arch/microblaze/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.orig/arch/microblaze/kernel/ptrace.c	2010-02-01 19:59:02.981038462 +0100
> +++ linux-2.6/arch/microblaze/kernel/ptrace.c	2010-02-01 20:25:27.875284396 +0100
> @@ -78,26 +78,6 @@ long arch_ptrace(struct task_struct *chi
>  	unsigned long copied;
>  
>  	switch (request) {
> -	case PTRACE_PEEKTEXT: /* read word at location addr. */
> -	case PTRACE_PEEKDATA:
> -		pr_debug("PEEKTEXT/PEEKDATA at %08lX\n", addr);
> -		copied = access_process_vm(child, addr, &val, sizeof(val), 0);
> -		rval = -EIO;
> -		if (copied != sizeof(val))
> -			break;
> -		rval = put_user(val, (unsigned long *)data);
> -		break;
> -
> -	case PTRACE_POKETEXT: /* write the word at location addr. */
> -	case PTRACE_POKEDATA:
> -		pr_debug("POKETEXT/POKEDATA to %08lX\n", addr);
> -		rval = 0;
> -		if (access_process_vm(child, addr, &data, sizeof(data), 1)
> -		    == sizeof(data))
> -			break;
> -		rval = -EIO;
> -		break;
> -
>  	/* Read/write the word at location ADDR in the registers. */
>  	case PTRACE_PEEKUSR:
>  	case PTRACE_POKEUSR:
> @@ -167,13 +147,8 @@ long arch_ptrace(struct task_struct *chi
>  		wake_up_process(child);
>  		break;
>  
> -	case PTRACE_DETACH: /* detach a process that was attached. */
> -		pr_debug("PTRACE_DETACH\n");
> -		rval = ptrace_detach(child, data);
> -		break;
>  	default:
> -		/* rval = ptrace_request(child, request, addr, data); noMMU */
> -		rval = -EIO;
> +		rval = ptrace_request(child, request, addr, data);
>  	}
>  	return rval;
>  }
> Index: linux-2.6/arch/h8300/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.orig/arch/h8300/kernel/ptrace.c	2010-02-01 20:20:37.081006798 +0100
> +++ linux-2.6/arch/h8300/kernel/ptrace.c	2010-02-01 20:25:56.513254706 +0100
> @@ -42,14 +42,6 @@ extern void h8300_enable_trace(struct ta
>   * in exit.c or in signal.c.
>   */
>  
> -inline
> -static int read_long(struct task_struct * tsk, unsigned long addr,
> -	unsigned long * result)
> -{
> -	*result = *(unsigned long *)addr;
> -	return 0;
> -}
> -
>  void ptrace_disable(struct task_struct *child)
>  {
>  	h8300_disable_trace(child);
> @@ -60,17 +52,6 @@ long arch_ptrace(struct task_struct *chi
>  	int ret;
>  
>  	switch (request) {
> -		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
> -		case PTRACE_PEEKDATA: {
> -			unsigned long tmp;
> -
> -			ret = read_long(child, addr, &tmp);
> -			if (ret < 0)
> -				break ;
> -			ret = put_user(tmp, (unsigned long *) data);
> -			break ;
> -		}
> -
>  	/* read the word at location addr in the USER area. */
>  		case PTRACE_PEEKUSR: {
>  			unsigned long tmp = 0;
> @@ -109,11 +90,6 @@ long arch_ptrace(struct task_struct *chi
>  		}
>  
>        /* when I and D space are separate, this will have to be fixed. */
> -		case PTRACE_POKETEXT: /* write the word at location addr. */
> -		case PTRACE_POKEDATA:
> -			ret = generic_ptrace_pokedata(child, addr, data);
> -			break;
> -
>  		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
>  			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
>  				ret = -EIO;
> @@ -175,10 +151,6 @@ long arch_ptrace(struct task_struct *chi
>  			break;
>  		}
>  
> -		case PTRACE_DETACH:	/* detach a process that was attached. */
> -			ret = ptrace_detach(child, data);
> -			break;
> -
>  		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
>  		  	int i;
>  			unsigned long tmp;
> @@ -210,7 +182,7 @@ long arch_ptrace(struct task_struct *chi
>  		}
>  
>  		default:
> -			ret = -EIO;
> +			ret = ptrace_request(child, request, addr, data);
>  			break;
>  	}
>  	return ret;
> Index: linux-2.6/arch/m68knommu/kernel/ptrace.c
> ===================================================================
> --- linux-2.6.orig/arch/m68knommu/kernel/ptrace.c	2010-02-01 20:24:00.894003983 +0100
> +++ linux-2.6/arch/m68knommu/kernel/ptrace.c	2010-02-01 20:25:41.433023480 +0100
> @@ -116,12 +116,6 @@ long arch_ptrace(struct task_struct *chi
>  	int ret;
>  
>  	switch (request) {
> -		/* when I and D space are separate, these will need to be fixed. */
> -		case PTRACE_PEEKTEXT: /* read word at location addr. */ 
> -		case PTRACE_PEEKDATA:
> -			ret = generic_ptrace_peekdata(child, addr, data);
> -			break;
> -
>  		/* read the word at location addr in the USER area. */
>  		case PTRACE_PEEKUSR: {
>  			unsigned long tmp;
> @@ -160,12 +154,6 @@ long arch_ptrace(struct task_struct *chi
>  			break;
>  		}
>  
> -		/* when I and D space are separate, this will have to be fixed. */
> -		case PTRACE_POKETEXT: /* write the word at location addr. */
> -		case PTRACE_POKEDATA:
> -			ret = generic_ptrace_pokedata(child, addr, data);
> -			break;
> -
>  		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
>  			ret = -EIO;
>  			if ((addr & 3) || addr < 0 ||
> @@ -258,10 +246,6 @@ long arch_ptrace(struct task_struct *chi
>  			break;
>  		}
>  
> -		case PTRACE_DETACH:	/* detach a process that was attached. */
> -			ret = ptrace_detach(child, data);
> -			break;
> -
>  		case PTRACE_GETREGS: { /* Get all gp regs from the child. */
>  		  	int i;
>  			unsigned long tmp;
> @@ -320,7 +304,7 @@ long arch_ptrace(struct task_struct *chi
>  #endif
>  
>  		default:
> -			ret = -EIO;
> +			ret = ptrace_request(child, request, addr, data);
>  			break;
>  	}
>  	return ret;
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
