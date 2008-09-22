Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYIVVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYIVVi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYIVVit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:38:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33093 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYIVVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:38:47 -0400
Date: Mon, 22 Sep 2008 15:38:45 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080922213845.GD3035@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio> <20080909130716.GV2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909130716.GV2772@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

Thanks for the review. I've pretty much incorporated all your
comments with a few exceptions...

> static char *make_slot_name(const char *name)
> {
> 	char *new_name;
> 	int len, max, dup;
> 
> 	new_name = kstrdup(name, GFP_KERNEL);
> 	if (!new_name)
> 		return NULL;
> 
> 	/*
> 	 * Make sure we hit the realloc case the first time through the
> 	 * loop.  'len' will be strlen(name) + 3 at that point which is
> 	 * enough space for "name-X" and the trailing NUL.
> 	 */
> 	len = strlen(name) + 2;
> 	max = 1;
> 	dup = 1;
> 
> 	for (;;) {
> 		struct kobject *dup_slot;
> 		dup_slot = kset_find_obj(pci_slots_kset, new_name);
> 		if (!dup_slot)
> 			break;
> 		kobject_put(dup_slot);
> 		if (dup == max) {
> 			len++;
> 			max *= 10;
> 			new_name = krealloc(new_name, len, GFP_KERNEL);

As Rolf Eike Beer pointed out, a failed krealloc() will leak the
old version of new_name, so I did this instead:

			kfree(new_name);
			new_name = kmalloc(len, GFP_KERNEL);

This is better than krealloc() in several ways:

	1. we avoid the unneeded memcpy that krealloc() does for
	us. we don't need it because we're going to sprintf over
	it anyway.

	2. the explicit kfree(new_name) means we won't leak
	anything.

> 			if (!new_name)
> 				break;
> 		}
> 		sprintf(new_name, "%s-%d", name, dup++);
> 	}
> 
> 	return new_name;
> }
>
> > -void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
> > +void pci_renumber_slot(struct pci_slot *slot, int slot_nr)
> >  {
> > -	int name_count = 0;
> >  	struct pci_slot *tmp;
> >  
> >  	down_write(&pci_bus_sem);
> >  
> > -	list_for_each_entry(tmp, &slot->bus->slots, list) {
> > +	list_for_each_entry(tmp, &slot->bus->slots, list)
> >  		WARN_ON(tmp->number == slot_nr);
> > -		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
> > -			name_count++;
> > -	}
> > -
> > -	if (name_count > 1)
> > -		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
> 
> Are you going to get enough information to debug problems with just this
> WARN_ON?  And do we want to decline to renumber a slot to the same
> number as an existing one?

I think this should be sufficient for the following reasons:

	1. This API was added for ppc; I can't imagine any other
	arch actually needing to renumber a slot after create.

	2. I added this check at BenH's request as a "belt and
	suspenders" sort of thing; neither of us expects to
	really get a collision here ever, and if we do, it's an
	OFW error (iirc).

	3. I think I will return early though, because otherwise,
	the refcounting will get very confused.

> Anyway, looks good, and I really like the name-change for this function.

Thanks.

/ac

