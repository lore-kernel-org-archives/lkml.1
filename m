Return-Path: <linux-kernel-owner+w=401wt.eu-S1767919AbXEEAEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767919AbXEEAEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767922AbXEEAEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:04:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767919AbXEEAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:04:31 -0400
Date: Fri, 4 May 2007 17:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Patch] Fix section mismatch of memory hotplug related code.
Message-Id: <20070504170421.b1ab2d16.akpm@linux-foundation.org>
In-Reply-To: <20070405163028.4248.Y-GOTO@jp.fujitsu.com>
References: <20070405163028.4248.Y-GOTO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 17:01:02 +0900
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> Hello.
> 
> This is to fix many section mismatches of code related to memory hotplug.
> I checked compile with memory hotplug on/off on ia64 and x86-64 box.
> 
> ..
>
> ===================================================================
> --- meminit.orig/drivers/acpi/numa.c	2007-04-04 20:15:58.000000000 +0900
> +++ meminit/drivers/acpi/numa.c	2007-04-04 20:56:34.000000000 +0900
> @@ -228,7 +228,7 @@ int __init acpi_numa_init(void)
>  	return 0;
>  }
>  
> -int acpi_get_pxm(acpi_handle h)
> +int __meminit acpi_get_pxm(acpi_handle h)
>  {
>  	unsigned long pxm;
>  	acpi_status status;
> @@ -246,7 +246,7 @@ int acpi_get_pxm(acpi_handle h)
>  }
>  EXPORT_SYMBOL(acpi_get_pxm);
>  
> -int acpi_get_node(acpi_handle *handle)
> +int __meminit acpi_get_node(acpi_handle *handle)
>  {
>  	int pxm, node = -1;

It doesn't make a lot of sense to export an __init symbol to modules.  I
guess it's OK in this case, but we get warnings:

WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:acpi_get_node from __ksymtab between '__ksymtab_acpi_get_node' (at offset 0x1040) and '__ksymtab_acpi_get_pxm'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:acpi_get_pxm from __ksymtab between '__ksymtab_acpi_get_pxm' (at offset 0x1050) and '__ksymtab_acpi_unlock_battery_dir'

One fix would be to statically link them again.  Another fix would be to
wrap the exports in #ifdef CONFIG_ACPI_HOTPLUG_MEMORY_MODULE.  Neither is
very attractive.

Coold you have a think about it please?  The config is at
http://userweb.kernel.org/~akpm/config-akpm2.txt

Thanks.
