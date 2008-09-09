Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYIINHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYIINHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIINHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:07:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55428 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYIINHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:07:36 -0400
Date: Tue, 9 Sep 2008 07:07:16 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080909130716.GV2772@parisc-linux.org>
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909100012.29542.62582.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 04:00:12AM -0600, Alex Chiang wrote:
> If firmware assigns the name N to multiple slots, then:
> 
> 	The first registered slot is assigned N
> 	The second registered slot is assigned N-1
> 	The third registered slot is assigned N-2
> 	The Mth registered slot becomes N-M

Not quite true ... the Mth registered slot becomes N-(M-1).  With the
first '-' being a literal and the second being a minus sign ;-)

> -	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
> +	 * Allow pcihp drivers to override existing slot name.

I would leave "the" in here.

> +static char *make_slot_name(const char *name)
> +{
> +	char *new_name;
> +	int len, width, dup = 1;
> +	struct kobject *dup_slot;
> +
> +	new_name = kstrdup(name, GFP_KERNEL);
> +	if (!new_name)
> +		goto out;
> +
> +	/*
> +	 * Start off allocating enough room for "name-X"
> +	 */
> +	len = strlen(name) + 2;
> +	width = 1;
> +
> +try_again:
> +	dup_slot = kset_find_obj(pci_slots_kset, new_name);
> +	if (!dup_slot)
> +		goto out;
> +	kobject_put(dup_slot);
> +
> +	/*
> +	 * We hit this the first time through, which gives us
> +	 * space for terminating NULL, and then every power of 10
> +	 * afterwards, which gives us space to add another digit
> +	 * to "name-XX..."
> +	 */
> +	if (dup % width == 0) {
> +		len++;
> +		width *= 10;
> +	}
> +
> +	new_name = krealloc(new_name, len, GFP_KERNEL);
> +	if (!new_name)
> +		goto out;
> +
> +	memset(new_name, 0, len);
> +	scnprintf(new_name, len, "%s-%d", name, dup++);
> +	goto try_again;
> +
> +out:
> +	return new_name;
> +}

I don't like the goto-loop style (yes, I know we do it elsewhere), and I
think we only need to krealloc inside the 'if' condition.  Something
like this, perhaps:

static char *make_slot_name(const char *name)
{
	char *new_name;
	int len, max, dup;

	new_name = kstrdup(name, GFP_KERNEL);
	if (!new_name)
		return NULL;

	/*
	 * Make sure we hit the realloc case the first time through the
	 * loop.  'len' will be strlen(name) + 3 at that point which is
	 * enough space for "name-X" and the trailing NUL.
	 */
	len = strlen(name) + 2;
	max = 1;
	dup = 1;

	for (;;) {
		struct kobject *dup_slot;
		dup_slot = kset_find_obj(pci_slots_kset, new_name);
		if (!dup_slot)
			break;
		kobject_put(dup_slot);
		if (dup == max) {
			len++;
			max *= 10;
			new_name = krealloc(new_name, len, GFP_KERNEL);
			if (!new_name)
				break;
		}
		sprintf(new_name, "%s-%d", name, dup++);
	}

	return new_name;
}
	

> @@ -89,7 +134,19 @@ static struct kobj_type pci_slot_ktype = {
>   * either return a new &struct pci_slot to the caller, or if the pci_slot
>   * already exists, its refcount will be incremented.
>   *
> - * Slots are uniquely identified by a @pci_bus, @slot_nr, @name tuple.
> + * Slots are uniquely identified by a @pci_bus, @slot_nr tuple.
> + *
> + * The kobject API imposes a restriction on us, and does not allow sysfs
> + * entries with duplicate names. There are known platforms with broken
> + * firmware that assign the same name to multiple slots.
> + *
> + * We workaround these broken platforms by renaming the slots on behalf
> + * of the caller. If firmware assigns name N to multiple slots:
> + *
> + * The first slot is assigned N
> + * The second slot is assigned N-1
> + * The third slot is assigned N-2
> + * The Mth slot is assigned N-M

How about simply replacing this last line with:

> + * etc.

>  struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
>  				 const char *name)
>  {
>  	struct pci_dev *dev;
>  	struct pci_slot *slot;
> -	int err;
> +	int err = 0;
> +	char *slot_name = NULL;
>  
>  	down_write(&pci_bus_sem);
>  
> @@ -144,12 +201,18 @@ placeholder:
>  
>  	slot->bus = parent;
>  	slot->number = slot_nr;
> -
>  	slot->kobj.kset = pci_slots_kset;
> +
> +	slot_name = make_slot_name(name);
> +	if (!slot_name) {
> +		slot = ERR_PTR(-ENOMEM);
> +		goto err;
> +	}

I think you need to kfree() slot before you assign an ERR_PTR to it.
Actually, since the 'err' label does that, just make that:

	if (!slot_name) {
		err = -ENOMEM;
		goto err;
	}

> -void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
> +void pci_renumber_slot(struct pci_slot *slot, int slot_nr)
>  {
> -	int name_count = 0;
>  	struct pci_slot *tmp;
>  
>  	down_write(&pci_bus_sem);
>  
> -	list_for_each_entry(tmp, &slot->bus->slots, list) {
> +	list_for_each_entry(tmp, &slot->bus->slots, list)
>  		WARN_ON(tmp->number == slot_nr);
> -		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
> -			name_count++;
> -	}
> -
> -	if (name_count > 1)
> -		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));

Are you going to get enough information to debug problems with just this
WARN_ON?  And do we want to decline to renumber a slot to the same
number as an existing one?

Anyway, looks good, and I really like the name-change for this function.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
