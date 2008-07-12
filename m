Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYGLAgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYGLAgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYGLAgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:36:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbYGLAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:36:43 -0400
Date: Fri, 11 Jul 2008 17:36:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, gregkh@suse.de, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-Id: <20080711173609.8310504d.akpm@linux-foundation.org>
In-Reply-To: <1214565175-21512-2-git-send-email-bwalle@suse.de>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
	<1214565175-21512-2-git-send-email-bwalle@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 13:12:54 +0200 Bernhard Walle <bwalle@suse.de> wrote:

> This patch adds /sys/firmware/memmap interface that represents the BIOS
> (or Firmware) provided memory map. The tree looks like:
> 
>     /sys/firmware/memmap/0/start   (hex number)
>                            end     (hex number)
>                            type    (string)
>     ...                 /1/start
>                            end
>                            type
> 
> With the following shell snippet one can print the memory map in the same form
> the kernel prints itself when booting on x86 (the E820 map).
> 
>   --------- 8< --------------------------
>     #!/bin/sh
>     cd /sys/firmware/memmap
>     for dir in * ; do
>         start=$(cat $dir/start)
>         end=$(cat $dir/end)
>         type=$(cat $dir/type)
>         printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
>     done
>   --------- >8 --------------------------
> 
> That patch only provides the needed interface:
> 
>  1. The sysfs interface.
>  2. The structure and enumeration definition.
>  3. The function firmware_map_add() and firmware_map_add_early()
>     that should be called from architecture code (E820/EFI, for
>     example) to add the contents to the interface.
> 
> If the kernel is compiled without CONFIG_FIRMWARE_MEMMAP, the interface does
> nothing without cluttering the architecture-specific code with #ifdef's.
> 
> The purpose of the new interface is kexec: While /proc/iomem represents
> the *used* memory map (e.g. modified via kernel parameters like 'memmap'
> and 'mem'), the /sys/firmware/memmap tree represents the unmodified memory
> map provided via the firmware. So kexec can:
> 
>  - use the original memory map for rebooting,
>  - use the /proc/iomem for setting up the ELF core headers for kdump
>    case that should only represent the memory of the system.
> 
> The patch has been tested on i386 and x86_64.
> 
> ...
>
> +/*
> + * Firmware memory map entries
> + */
> +static LIST_HEAD(map_entries);

Alarm bells.  Please add a comment explaining why no locking is needed
for this.

> +/**
> + * Common implementation of firmware_map_add() and firmware_map_add_early()
> + * which expects a pre-allocated struct firmware_map_entry.
> + *
> + * @start: Start of the memory range.
> + * @end:   End of the memory range (inclusive).
> + * @type:  Type of the memory range.
> + * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
> + *         entry.
> + */

Busted kerneldoc.  It should start with

/**
 * firmware_map_add_entry - <stuff>

> +static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
> +				  const char *type,
> +				  struct firmware_map_entry *entry)
> +{
> +	BUG_ON(start > end);
> +
> +	entry->start = start;
> +	entry->end = end;
> +	entry->type = type;
> +	INIT_LIST_HEAD(&entry->list);
> +	kobject_init(&entry->kobj, &memmap_ktype);
> +
> +	list_add_tail(&entry->list, &map_entries);
> +
> +	return 0;
> +}
> +
> +/*
> + * See <linux/firmware-map.h> for documentation.
> + */
> +int firmware_map_add(resource_size_t start, resource_size_t end,
> +		     const char *type)
> +{
> +	struct firmware_map_entry *entry;
> +
> +	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
> +	WARN_ON(!entry);

Actually, kmalloc() would have warned already.

> +	if (!entry)
> +		return -ENOMEM;
> +
> +	return firmware_map_add_entry(start, end, type, entry);
> +}
> +
> 
> ...
>
> +static ssize_t start_show(struct firmware_map_entry *entry, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->start);
> +}
> +
> +static ssize_t end_show(struct firmware_map_entry *entry, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->end);
> +}

Printing a resource_size_t needs a cast to `unsigned long long' to
avoid printk warnings.

> +static ssize_t type_show(struct firmware_map_entry *entry, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", entry->type);
> +}
> +
> +#define to_memmap_attr(_attr) container_of(_attr, struct memmap_attribute, attr)
> +#define to_memmap_entry(obj) container_of(obj, struct firmware_map_entry, kobj)
> +
> +static ssize_t memmap_attr_show(struct kobject *kobj,
> +				struct attribute *attr, char *buf)
> +{
> +	struct firmware_map_entry *entry = to_memmap_entry(kobj);
> +	struct memmap_attribute *memmap_attr = to_memmap_attr(attr);
> +
> +	return memmap_attr->show(entry, buf);
> +}
> +
> +/*
> + * Initialises stuff and adds the entries in the map_entries list to
> + * sysfs. Important is that firmware_map_add() and firmware_map_add_early()
> + * must be called before late_initcall.

Please update the comment to provide the reason why this is important.

> + */
> +static int __init memmap_init(void)
> +{
> +	int i = 0;
> +	struct firmware_map_entry *entry;
> +	struct kset *memmap_kset;
> +
> +	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
> +	WARN_ON(!memmap_kset);
> +	if (!memmap_kset)
> +		return -ENOMEM;

Actually, you can do

	if (WARN_ON(!memmap_kset))
		return -ENOMEM;

(multiple instances)

> +	list_for_each_entry(entry, &map_entries, list) {
> +		entry->kobj.kset = memmap_kset;
> +		kobject_add(&entry->kobj, NULL, "%d", i++);

kobject_add() can fail.

I'd suggest that you enable CONFIG_ENABLE_MUST_CHECK in your usualconfig.

> +	}
> +
> +	return 0;
> +}
> +late_initcall(memmap_init);
> +
> 
> ...
>
> +/**
> + * Adds a firmware mapping entry. This function uses kmalloc() for memory
> + * allocation. Use firmware_map_add_early() if you want to use the bootmem
> + * allocator.
> + *
> + * That function must be called before late_initcall.
> + *
> + * @start: Start of the memory range.
> + * @end:   End of the memory range (inclusive).
> + * @type:  Type of the memory range.
> + *
> + * Returns 0 on success, or -ENOMEM if no memory could be allocated.
> + */
> +int firmware_map_add(resource_size_t start, resource_size_t end,
> +		     const char *type);

More busted kernedoc (multiple instances)

Please document C functions at the definition site, not in the header file.

a) because otherwise the documentation gets splattered across
   different files (eg - static functions?)

b) principle of least surprise: that's where people expect to find it.

> +/**
> + * Adds a firmware mapping entry. This function uses the bootmem allocator
> + * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
> + *
> + * That function must be called before late_initcall.
> + *
> + * @start: Start of the memory range.
> + * @end:   End of the memory range (inclusive).
> + * @type:  Type of the memory range.
> + *
> + * Returns 0 on success, or -ENOMEM if no memory could be allocated.
> + */
> +int firmware_map_add_early(resource_size_t start, resource_size_t end,
> +			   const char *type);
> +
> +#else /* CONFIG_FIRMWARE_MEMMAP */
> +
> +static inline int firmware_map_add(resource_size_t start, resource_size_t end,
> +				   const char *type)
> +{
> +	return 0;
> +}
> +
> +static inline int firmware_map_add_early(resource_size_t start,
> +					 resource_size_t end, const char *type)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_FIRMWARE_MEMMAP */
> +
> +#endif /* _LINUX_FIRMWARE_MAP_H */

