Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZEBFNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZEBFNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 01:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZEBFNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 01:13:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:57156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750746AbZEBFNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 01:13:42 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18P6uoaM8MPpmxil0QApzgmS/d3bkaB3kke0VllQL
	lWxNOKuuLa8f/m
Message-ID: <49FBD681.9080605@gmx.de>
Date: Sat, 02 May 2009 07:13:37 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@MIT.EDU>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu> <1241135719-9286-2-git-send-email-tabbott@mit.edu> <1241135719-9286-3-git-send-email-tabbott@mit.edu> <1241135719-9286-4-git-send-email-tabbott@mit.edu>
In-Reply-To: <1241135719-9286-4-git-send-email-tabbott@mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> .data.init_task should not need a separate output section; this change
> moves it into the .data section.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org


I think this patch is wrong, although it is theoretically correct.

IIRC, gcc on hppa is not able to provide an alignment >= 8k, which is
why we have done the 16k alignment inside the linker script.
So, I think this change will prevent the parisc kernel to boot up.
Needs testing.

Helge

> ---
>  arch/parisc/kernel/init_task.c   |    2 +-
>  arch/parisc/kernel/vmlinux.lds.S |   10 ++--------
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
> index 1e25a45..8ee17ea 100644
> --- a/arch/parisc/kernel/init_task.c
> +++ b/arch/parisc/kernel/init_task.c
> @@ -48,7 +48,7 @@ EXPORT_SYMBOL(init_mm);
>   * "init_task" linker map entry..
>   */
>  union thread_union init_thread_union
> -	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
> +	__attribute__((aligned(128))) __init_task_data =
>  		{ INIT_THREAD_INFO(init_task) };
>  
>  #if PT_NLEVELS == 3
> diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
> index b5936c9..c8a528d 100644
> --- a/arch/parisc/kernel/vmlinux.lds.S
> +++ b/arch/parisc/kernel/vmlinux.lds.S
> @@ -103,6 +103,8 @@ SECTIONS
>  	. = ALIGN(L1_CACHE_BYTES);
>  	/* Data */
>  	.data : {
> +		/* assembler code expects init_task to be 16k aligned */
> +		INIT_TASK_DATA(16384)
>  		NOSAVE_DATA
>  		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
>  		DATA_DATA
> @@ -133,14 +135,6 @@ SECTIONS
>  	}
>  	__bss_stop = .;
>  
> -
> -	/* assembler code expects init_task to be 16k aligned */
> -	. = ALIGN(16384);
> -	/* init_task */
> -	.data.init_task : {
> -		*(.data.init_task)
> -	}
> -
>  #ifdef CONFIG_64BIT
>  	. = ALIGN(16);
>  	/* Linkage tables */

