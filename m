Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZG2Irv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZG2Irv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZG2Iru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:47:50 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:35162 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZG2Irt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u5cUGt29aRC6+3ivey/DrTnFwzjYKZUpmytdebBxn17Qb6pJCi1S7FWL2HsApkM2Uu
         NRp9tnDEPENUsfH8DufBxFMLE1e4N1ZBpJjBLFTBBxNrLwR5V9Kek5tWtB0XxZsh6bEk
         FoO1KlQukce8a6e6ViLs61kbg0aV2catTOTfY=
Date: Wed, 29 Jul 2009 16:50:03 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: Re: [RFC][PATCH 5/6] kcore: check physical memory range  in
	correct way.
Message-ID: <20090729085003.GD5856@cr0.nay.redhat.com>
References: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com> <20090724171927.f663cacc.kamezawa.hiroyu@jp.fujitsu.com> <20090728102411.GG6036@cr0.nay.redhat.com> <20090729085810.c1a6b75a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729085810.c1a6b75a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 08:58:10AM +0900, KAMEZAWA Hiroyuki wrote:
>On Tue, 28 Jul 2009 18:24:11 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Fri, Jul 24, 2009 at 05:19:27PM +0900, KAMEZAWA Hiroyuki wrote:
>> >From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> >For /proc/kcore, each arch registers its memory range by kclist_add().
>> >In usual,
>> >	- range of physical memory
>> >	- range of vmalloc area
>> >	- text, etc...
>> >are registered but "range of physical memory" has some troubles.
>> >
>> >It doesn't updated at memory hotplug and it tend to include
>> >unnecessary memory holes. Now, /proc/iomem (kernel/resource.c)
>> >includes required physical memory range information and it's
>> >properly updated at memory hotplug. Then, it's good to avoid
>> >using its own code(duplicating information) and to rebuild
>> >kclist for physical memory based on /proc/iomem.
>> >
>> >Note: IIUC, /proc/iomem information is used for kdump.
>> >
>> >Changelog: v2 -> v3
>> > - fixed HIGHMEM codes.(At least, no compile error)
>> > - enhnanced sanity chesk in !HIGHMEM codes. (See kclist_add_private())
>> > - after this, x86-32, ia64, sh, powerpc has no private kclist codes.
>> >   x86-64 and mips still have some.
>> 
>> 
>> <snip>
>> 
>> 
>> 
>> >Index: mmotm-2.6.31-Jul16/include/linux/ioport.h
>> >===================================================================
>> >--- mmotm-2.6.31-Jul16.orig/include/linux/ioport.h
>> >+++ mmotm-2.6.31-Jul16/include/linux/ioport.h
>> >@@ -186,5 +186,13 @@ extern void __devm_release_region(struct
>> > extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
>> > extern int iomem_is_exclusive(u64 addr);
>> > 
>> >+/*
>> >+ * Walk through all SYSTEM_RAM which is registered as resource.
>> >+ * arg is (start_pfn, nr_pages, private_arg_pointer)
>> >+ */
>> >+extern int walk_memory_resource(unsigned long start_pfn,
>> >+			unsigned long nr_pages, void *arg,
>> >+			int (*func)(unsigned long, unsigned long, void *));
>> >+
>> > #endif /* __ASSEMBLY__ */
>> > #endif	/* _LINUX_IOPORT_H */
>> >Index: mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>> >===================================================================
>> >--- mmotm-2.6.31-Jul16.orig/include/linux/memory_hotplug.h
>> >+++ mmotm-2.6.31-Jul16/include/linux/memory_hotplug.h
>> >@@ -191,13 +191,6 @@ static inline void register_page_bootmem
>> > 
>> > #endif /* ! CONFIG_MEMORY_HOTPLUG */
>> > 
>> >-/*
>> >- * Walk through all memory which is registered as resource.
>> >- * arg is (start_pfn, nr_pages, private_arg_pointer)
>> >- */
>> >-extern int walk_memory_resource(unsigned long start_pfn,
>> >-			unsigned long nr_pages, void *arg,
>> >-			int (*func)(unsigned long, unsigned long, void *));
>> 
>> 
>> Why moving it? :)
>> 
>Ah, this declaration is in memory_hotplug.h because it's only for memory
>hotplug. For generic use, it's better to move this to iomem.h as other
>resource related ops, I think.
>


Ok, it's better if you can put this in your changelog. ;)


>
>
>> > 
>> > #ifdef CONFIG_MEMORY_HOTREMOVE
>> > 
>> >Index: mmotm-2.6.31-Jul16/kernel/resource.c
>> >===================================================================
>> >--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
>> >+++ mmotm-2.6.31-Jul16/kernel/resource.c
>> >@@ -234,7 +234,7 @@ int release_resource(struct resource *ol
>> > 
>> > EXPORT_SYMBOL(release_resource);
>> > 
>> >-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>> >+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>> > /*
>> >  * Finds the lowest memory reosurce exists within [res->start.res->end)
>> >  * the caller must specify res->start, res->end, res->flags.
>> 
>> 
>> Shouldn't this part be in patch 6/6 instead of this one?
>> 
>Hmm, ok, I'll reorder 5/6 and 6/6 and define walk_system_ram_range() before
>this patch.

Thank you for keeping working on this! :)
