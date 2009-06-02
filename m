Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZFBViB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZFBViB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZFBVhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:37:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbZFBVhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:37:53 -0400
Date: Tue, 2 Jun 2009 14:32:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, xiyou.wangcong@gmail.com, sam@ravnborg.org,
       jdike@addtoit.com
Subject: Re: [PATCH 1/4] kernel: constructor support
Message-Id: <20090602143202.6cfcc4ce.akpm@linux-foundation.org>
In-Reply-To: <20090602114400.740271397@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	<20090602114400.740271397@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jun 2009 13:44:00 +0200
Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Call constructors (gcc-generated initcall-like functions) during
> kernel start and module load. Constructors are e.g. used for gcov data
> initialization.
> 
> Disable constructor support for usermode Linux to prevent conflicts
> with host glibc.
> 
> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Jeff Dike <jdike@addtoit.com>
>
> ...
>
> --- linux-2.6.30-rc7.orig/include/asm-generic/vmlinux.lds.h	2009-06-02 10:34:37.000000000 +0200
> +++ linux-2.6.30-rc7/include/asm-generic/vmlinux.lds.h	2009-06-02 10:35:20.000000000 +0200

Sam's tree has mucked with this file in linux-next.

> @@ -332,6 +332,14 @@
>  /* Section used for early init (in .S files) */
>  #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
>  
> +#ifdef CONFIG_CONSTRUCTORS
> +#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
> +			*(.ctors)			   \
> +			VMLINUX_SYMBOL(__ctors_end) = .;
> +#else
> +#define KERNEL_CTORS()
> +#endif
> +
>  /* init and exit section handling */
>  #define INIT_DATA							\
>  	*(.init.data)							\
> @@ -340,7 +348,8 @@
>  	CPU_DISCARD(init.data)						\
>  	CPU_DISCARD(init.rodata)					\
>  	MEM_DISCARD(init.data)						\
> -	MEM_DISCARD(init.rodata)
> +	MEM_DISCARD(init.rodata)					\
> +	KERNEL_CTORS()
>  

What we now have here is

#define INIT_DATA							\
	*(.init.data)							\
	DEV_DISCARD(init.data)						\
	CPU_DISCARD(init.data)						\
	MEM_DISCARD(init.data)						\
	*(.init.rodata)							\
	DEV_DISCARD(init.rodata)					\
	CPU_DISCARD(init.rodata)					\
	MEM_DISCARD(init.rodata)

and I don't think that you wanted KERNEL_DTORS() inside the .rodata
section, so I did this:

#define INIT_DATA							\
	*(.init.data)							\
	DEV_DISCARD(init.data)						\
	CPU_DISCARD(init.data)						\
	MEM_DISCARD(init.data)						\
	KERNEL_CTORS()							\
	*(.init.rodata)							\
	DEV_DISCARD(init.rodata)					\
	CPU_DISCARD(init.rodata)					\
	MEM_DISCARD(init.rodata)

Please check that?
