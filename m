Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYDATCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYDATCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYDATBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:01:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbYDATBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:01:53 -0400
Date: Tue, 1 Apr 2008 12:00:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, mpm@selenic.com,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org,
       Reynes Philippe <tremyfr@yahoo.fr>
Subject: Re: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
Message-Id: <20080401120036.2254d7eb.akpm@linux-foundation.org>
In-Reply-To: <20080212100418.5de764da@crazy>
References: <20080212100418.5de764da@crazy>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Question for Ingo...

On Tue, 12 Feb 2008 10:04:18 +0100
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Hi,
> 
> Enclosed patch is an updated version, with proper credits to Matt
> Mackall and the Linux Tiny project.
> 
> Sincerly,
> 
> Thomas
> 
> ---
> 
> Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
> order to be able to remove the DMI table scanning code if it's not
> needed, and then reduce the kernel code size.
> 
> With CONFIG_DMI (i.e before) :
> 
>    text    data     bss     dec     hex filename
> 1076076  128656   98304 1303036  13e1fc vmlinux
> 
> Without CONFIG_DMI (i.e after) :
> 
>    text    data     bss     dec     hex filename
> 1068092  126308   98304 1292704  13b9a0 vmlinux
> 
> Result:
> 
>    text    data     bss     dec     hex filename
>   -7984   -2348       0  -10332   -285c vmlinux
> 
> The new option appears in "Processor type and features", only when
> CONFIG_EMBEDDED is defined.
> 
> This patch is part of the Linux Tiny project, and is based on previous
> work done by Matt Mackall <mpm@selenic.com>.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> ---
>  arch/x86/Kconfig    |   12 +++++++++---
>  include/linux/dmi.h |    1 +
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/Kconfig
> ===================================================================
> --- linux.orig/arch/x86/Kconfig	2008-02-11 16:51:50.000000000 +0100
> +++ linux/arch/x86/Kconfig	2008-02-11 17:48:15.000000000 +0100
> @@ -88,9 +88,6 @@
>  config ARCH_MAY_HAVE_PC_FDC
>  	def_bool y
>  
> -config DMI
> -	def_bool y
> -
>  config RWSEM_GENERIC_SPINLOCK
>  	def_bool !X86_XADD
>  
> @@ -433,6 +430,15 @@
>  
>  # Mark as embedded because too many people got it wrong.
>  # The code disables itself when not needed.
> +config DMI
> +	default y
> +	bool "Enable DMI scanning" if EMBEDDED
> +	help
> +	  Enabled scanning of DMI to identify machine quirks. Say Y
> +	  here unless you have verified that your setup is not
> +	  affected by entries in the DMI blacklist. Required by PNP
> +	  BIOS code.
> +

This introduces a build error in drivers/acpi/thermal.c, because that code
does:

#ifdef CONFIF_DMI
<define some tables>
#endif

	...
	dmi_check_system(<those tables>);


Now, the approved fix here is to just remove the ifdefs.  The !CONFIG_DMI
version of dmi_check_system() won't generate any references to the tables
and the build system is then supposed to remove the generated code and data
from vmlinux.

But this doesn't work.

When I add an ifdef around the dmi_check_system() call, I get

   text    data     bss     dec     hex filename
1614279  210524  159992 1984795  1e491b vmlinux

but when I remove the ifdefs around the tables and rely on the compiler
removing the code and data I get

   text    data     bss     dec     hex filename
1614447  210972  159992 1985411  1e4b83 vmlinux

An additional 616 bytes of useless stuff.

Ingo, I think there was some trick to making this work right.  Do you
recall?

