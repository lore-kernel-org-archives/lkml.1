Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYFZW0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYFZW0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYFZW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:26:38 -0400
Received: from mail.suse.de ([195.135.220.2]:45171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYFZW0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:26:37 -0400
Date: Thu, 26 Jun 2008 15:24:58 -0700
From: Greg KH <gregkh@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626222458.GA18981@suse.de>
References: <1214511542-28458-1-git-send-email-bwalle@suse.de> <1214511542-28458-2-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214511542-28458-2-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:19:01PM +0200, Bernhard Walle wrote:
> This patch adds /sys/firmware/memmap interface that represents the BIOS
> (or Firmware) provided memory map. The tree looks like:
> 
>     /sys/firmware/memmap/0/start   (hex number)
>                            end     (hex number)
>                            type    (string)
>     ...                 /1/start
>                            end
>                            type

Please provide new entries in Documentation/ABI/ for these new sysfs
files with all of this information.

> +/*
> + * Firmware memory map entries
> + */
> +LIST_HEAD(map_entries);

Should this be static?

> +int firmware_map_add(resource_size_t start, resource_size_t end,
> +		     const char *type)
> +{
> +	struct firmware_map_entry *entry;
> +
> +	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
> +	WARN_ON(!entry);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	return firmware_map_add_entry(start, end, type, entry);

Where is the kobject initialized properly?

Ah, later on, that's scary...

> +static struct kobj_type memmap_ktype = {
> +	.sysfs_ops	= &memmap_attr_ops,
> +	.default_attrs	= def_attrs,
> +};

Do you really need your own kobj_type here?  What you want is just a
directory, and some attributes assigned to the kobject, can't you use
the default kobject attributes for them?

I'm not saying this is incorrect, it looks implemented properly, just
curious.

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
> +
> +	list_for_each_entry(entry, &map_entries, list) {

So the list is supposed to be set up before this function is called?  Is
that because of early boot issues?

You should document this somehow.

> +/*
> + * Firmware map entry. Because firmware memory maps are flat and not
> + * hierarchical, it's ok to organise them in a linked list. No parent
> + * information is necessary as for the resource tree.
> + */
> +struct firmware_map_entry {
> +	resource_size_t		start;	/* start of the memory range */
> +	resource_size_t		end;	/* end of the memory range (incl.) */
> +	const char		*type;	/* type of the memory range */
> +	struct list_head	list;	/* entry for the linked list */
> +	struct kobject		kobj;   /* kobject for each entry */
> +};

Does this really need to be in the .h file?

thanks,

greg k-h
