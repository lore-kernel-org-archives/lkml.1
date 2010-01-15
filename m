Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0AODlW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251Ab0AODlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:41:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:49635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0AODlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:41:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="484162740"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
        Dave Hansen <haveblue@us.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Date: Fri, 15 Jan 2010 11:41:14 +0800
Subject: RE: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Topic: [PATCH-RESEND v4] memory-hotplug: create /sys/firmware/memmap
 entry for new memory
Thread-Index: AcqUn8xoJAtaKJw1TPS3kXsbWbFA3wA8HhhA
Message-ID: <DA586906BA1FFC4384FCFD6429ECE86034FF8354@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560F92@shzsmsx502.ccr.corp.intel.com>
 <20100113142827.26b2269e.akpm@linux-foundation.org>
In-Reply-To: <20100113142827.26b2269e.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 10:00:11 +0800
"Zheng, Shaohui" <shaohui.zheng@intel.com> wrote:

> Resend the memmap patch v4 to mailing-list after follow up fengguang's review 
> comments. 
> 
> memory-hotplug: create /sys/firmware/memmap entry for hot-added memory
> 
> Interface firmware_map_add was not called in explict, Remove it and add function
> firmware_map_add_hotplug as hotplug interface of memmap.
> 
> When we hot-add new memory, sysfs does not export memmap entry for it. we add
>  a call in function add_memory to function firmware_map_add_hotplug.
> 
> Add a new function add_sysfs_fw_map_entry to create memmap entry, it can avoid 
> duplicated codes.
> 
> Thanks for the careful review from Fengguang Wu and Dave Hansen.
> 

Please describe the format of the proposed sysfs file.  Example output
would be suitable.

> @@ -123,20 +123,40 @@ static int firmware_map_add_entry(u64 start, u64 end,
>  }
>  
>  /**
> - * firmware_map_add() - Adds a firmware mapping entry.
> + * Add memmap entry on sysfs
> + */
> +static int add_sysfs_fw_map_entry(struct firmware_map_entry *entry)
> +{
> +	static int map_entries_nr;
> +	static struct kset *mmap_kset;
> +
> +	if (!mmap_kset) {
> +		mmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
> +		if (!mmap_kset)
> +			return -ENOMEM;
> +	}

This is a bit racy if two threads execute it at the same time.  I guess
it doesn't matter.
[Zheng, Shaohui] function add_sysfs_fw_map_entry will be called when OS boots up and we hot-add memory, it never has chance to be execute in two threads, it should be okay.


> +	entry->kobj.kset = mmap_kset;
> +	if (kobject_add(&entry->kobj, NULL, "%d", map_entries_nr++))
> +		kobject_put(&entry->kobj);

hm.  Is this refcounting correct?
[Zheng, Shaohui] all objects of firmware_map_entry shares the same kset, I use a static pointer to store it. When create next entry, we can get the reference easier. I already test it, it works fine.

> +
> +	return 0;
> +}

One caller of add_sysfs_fw_map_entry() is __meminit and the other is
__init.  So this function can be __meminit?
[Zheng, Shaohui] function add_sysfs_fw_map_entry() should be still here after booting up, it will be called when we hot-add new memory, so it can not be _init. __meminit should be the correct since this function is related memory hot-plug.

> +/**
> + * firmware_map_add_early() - Adds a firmware mapping entry.
>   * @start: Start of the memory range.
>   * @end:   End of the memory range (inclusive).
>   * @type:  Type of the memory range.
>   *
> - * This function uses kmalloc() for memory
> - * allocation. Use firmware_map_add_early() if you want to use the bootmem
> - * allocator.
> + * Adds a firmware mapping entry. This function uses the bootmem allocator
> + * for memory allocation.
>   *
>   * That function must be called before late_initcall.
>   *
>   * Returns 0 on success, or -ENOMEM if no memory could be allocated.
>   **/
> -int firmware_map_add(u64 start, u64 end, const char *type)
> +int __init firmware_map_add_early(u64 start, u64 end, const char *type)
>  {
>  	struct firmware_map_entry *entry;
>  
> @@ -148,27 +168,31 @@ int firmware_map_add(u64 start, u64 end, const char *type)
>  }
>  
>  /**
> - * firmware_map_add_early() - Adds a firmware mapping entry.
> + * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
> + * memory hotplug.
>   * @start: Start of the memory range.
>   * @end:   End of the memory range (inclusive).
>   * @type:  Type of the memory range.
>   *
> - * Adds a firmware mapping entry. This function uses the bootmem allocator
> - * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
> - *
> - * That function must be called before late_initcall.
> + * Adds a firmware mapping entry. This function is for memory hotplug, it is
> + * simiar with function firmware_map_add_early. the only difference is that

s/simiar/similar/
s/with/to/
s/the/The/
s/function firmware_map_add_early/firmware_map_add_early()/
[Zheng, Shaohui] sorry for my carelessness.
	
> + * it will create the syfs entry dynamically.
>   *
>   * Returns 0 on success, or -ENOMEM if no memory could be allocated.
>   **/
> -int __init firmware_map_add_early(u64 start, u64 end, const char *type)
> +int __meminit firmware_map_add_hotplug(u64 start, u64 end, const char *type)
>  {
>  	struct firmware_map_entry *entry;
>  
> -	entry = alloc_bootmem(sizeof(struct firmware_map_entry));
> -	if (WARN_ON(!entry))
> +	entry = kzalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
> +	if (!entry)
>  		return -ENOMEM;
>  
> -	return firmware_map_add_entry(start, end, type, entry);
> +	firmware_map_add_entry(start, end, type, entry);
> +	/* create the memmap entry */
> +	add_sysfs_fw_map_entry(entry);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -214,18 +238,10 @@ static ssize_t memmap_attr_show(struct kobject *kobj,
>   */
>  static int __init memmap_init(void)
>  {
> -	int i = 0;
>  	struct firmware_map_entry *entry;
> -	struct kset *memmap_kset;
> -
> -	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
> -	if (WARN_ON(!memmap_kset))
> -		return -ENOMEM;
>  
>  	list_for_each_entry(entry, &map_entries, list) {
> -		entry->kobj.kset = memmap_kset;
> -		if (kobject_add(&entry->kobj, NULL, "%d", i++))
> -			kobject_put(&entry->kobj);
> +		add_sysfs_fw_map_entry(entry);
>  	}

The braces are now unneeded.  checkpatch used to warn about this I
think.  Either someone broke checkpatch or it doesn't understand
list_for_each_entry().
[Zheng, Shaohui] I will remove the unneeded braces.

>
> ...
>
