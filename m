Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZG1KWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZG1KWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZG1KV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:21:59 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38470 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZG1KV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hpvRGsY3m54n3XIVv5ZclBuXLbHNPxmZBK5O9/uM1j8tEhNXjkU6dUSB6uLO1zVS3x
         CXkWX+Z0odA7SsjwPoZONd794U+B+2hGIBKIXOMhHyAyo7XnqpkcUO7BVoOv3SGdtpWh
         pD0Idr2jpvlTLQ72ZTsMiNfvqfUxiK0V80aIs=
Date: Tue, 28 Jul 2009 18:24:11 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: Re: [RFC][PATCH 5/6] kcore: check physical memory range  in
	correct way.
Message-ID: <20090728102411.GG6036@cr0.nay.redhat.com>
References: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com> <20090724171927.f663cacc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724171927.f663cacc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 05:19:27PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>For /proc/kcore, each arch registers its memory range by kclist_add().
>In usual,
>	- range of physical memory
>	- range of vmalloc area
>	- text, etc...
>are registered but "range of physical memory" has some troubles.
>
>It doesn't updated at memory hotplug and it tend to include
>unnecessary memory holes. Now, /proc/iomem (kernel/resource.c)
>includes required physical memory range information and it's
>properly updated at memory hotplug. Then, it's good to avoid
>using its own code(duplicating information) and to rebuild
>kclist for physical memory based on /proc/iomem.
>
>Note: IIUC, /proc/iomem information is used for kdump.
>
>Changelog: v2 -> v3
> - fixed HIGHMEM codes.(At least, no compile error)
> - enhnanced sanity chesk in !HIGHMEM codes. (See kclist_add_private())
> - after this, x86-32, ia64, sh, powerpc has no private kclist codes.
>   x86-64 and mips still have some.


<snip>



>Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h
>+++ mmotm-2.6.31-Jul16/include/linux/ioport.h
>@@ -186,5 +186,13 @@ extern void __devm_release_region(struct
> extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
> extern int iomem_is_exclusive(u64 addr);
> 
>+/*
>+ * Walk through all SYSTEM_RAM which is registered as resource.
>+ * arg is (start_pfn, nr_pages, private_arg_pointer)
>+ */
>+extern int walk_memory_resource(unsigned long start_pfn,
>+			unsigned long nr_pages, void *arg,
>+			int (*func)(unsigned long, unsigned long, void *));
>+
> #endif /* __ASSEMBLY__ */
> #endif	/* _LINUX_IOPORT_H */
>Index: mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/include/linux/memory_hotplug.h
>+++ mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>@@ -191,13 +191,6 @@ static inline void register_page_bootmem
> 
> #endif /* ! CONFIG_MEMORY_HOTPLUG */
> 
>-/*
>- * Walk through all memory which is registered as resource.
>- * arg is (start_pfn, nr_pages, private_arg_pointer)
>- */
>-extern int walk_memory_resource(unsigned long start_pfn,
>-			unsigned long nr_pages, void *arg,
>-			int (*func)(unsigned long, unsigned long, void *));


Why moving it? :)

> 
> #ifdef CONFIG_MEMORY_HOTREMOVE
> 
>Index: mmotm-2.6.31-Jul16/kernel/resource.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
>+++ mmotm-2.6.31-Jul16/kernel/resource.c
>@@ -234,7 +234,7 @@ int release_resource(struct resource *ol
> 
> EXPORT_SYMBOL(release_resource);
> 
>-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> /*
>  * Finds the lowest memory reosurce exists within [res->start.res->end)
>  * the caller must specify res->start, res->end, res->flags.


Shouldn't this part be in patch 6/6 instead of this one?
