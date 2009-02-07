Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbZBGCh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbZBGCh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 21:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZBGCg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 21:36:59 -0500
Received: from ozlabs.org ([203.10.76.45]:56813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbZBGCg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 21:36:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 7/7] Ksplice: Support updating x86-32 and x86-64
Date: Sat, 7 Feb 2009 13:06:43 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-7-git-send-email-jbarnold@mit.edu> <1228521840-3886-8-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-8-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071306.45546.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:34:00 Jeff Arnold wrote:
...
> +1. Concepts: Updates, packs, helper modules, primary modules
> +------------------------------------------------------------
> +
> +A Ksplice update (struct update) contains one or more Ksplice packs, one for
> +each target kernel module that should be changed by the update.  Ksplice packs
> +are grouped together into a Ksplice update in order to allow multiple
> +compilation units to be changed atomically.

Hi Jeff et al.

   The temptation to invent new nomenclature is one we geeks constantly
wrestle with.  But when you have a *genuinely* good idea, it's not necessary.
Unfortunately, changing names is a PITA, but it's not going to get easier.

   ksplice_update is a good name, but the rest of your nomenclature is
horribly general.  So before I become so experienced with it I can't see the
flaws, let me suggest:

	pack -> ksplice_mod_change
	helper module -> old_code
	primary module -> new_code

> +ksplice_123abc_vmlinux (the "primary" module for the vmlinux pack)
> +ksplice_123abc_vmlinux_helper (the "helper" module for the vmlinux pack)
> +ksplice_123abc_isdn (the "primary" module for the vmlinux pack)
> +ksplice_123abc_isdn_helper (the "helper" module for the vmlinux pack)

  Or, ksplice_123abc_vmlinux_new, ksplice_123abc_vmlinux_old, etc.

This has the advantage that it's pretty clear that _old can be removed
afterwards, for example.

> +unexpected_running_task (P->A, A->R): Ksplice aborted the operation because
> +Ksplice observed a running task during the kernel stack check, at a time when
> +Ksplice expected all tasks to be stopped by stop_machine.

I'll have to check the code, but this should now just be a subset of
"unexpected", no?

> +++ b/arch/x86/kernel/ksplice-arch.c
> @@ -0,0 +1,125 @@
> +/*  Copyright (C) 2007-2008  Jeff Arnold <jbarnold@mit.edu>
> + *  Copyright (C) 2008  Anders Kaseorg <andersk@mit.edu>,
> + *                      Tim Abbott <tabbott@mit.edu>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License, version 2.

Just in case you copied this boilerplate without thinking about it, I'll just
note that my code is all GPLv2 or later.

(Rest of ksplice-arch.c skipped... it's hard to review until I understand the
 core).

> +/**
> + * struct ksplice_symbol - Ksplice's analogue of an ELF symbol
> + * @name:	The ELF name of the symbol
> + * @label:	A unique Ksplice name for the symbol
> + * @vals:	A linked list of possible values for the symbol, or NULL
> + * @value:	The value of the symbol (valid when vals is NULL)
> + **/
> +struct ksplice_symbol {
> +	const char *name;
> +	const char *label;
> +/* private: */
> +	struct list_head *vals;
> +	unsigned long value;
> +};

I'd have to look at the usage, but might this be neater as a standard
linked list, eg:

struct ksplice_symval {
	struct list_head list;
	unsigned long val;
};

struct ksplice_symbol {
	...
	struct list_head vals;
	/* We always have one, so this saves dynamic alloc in common case? */
	struct ksplice_symval first_val;
};

(You could link off the first_val.list, but it we don't have iterators for
such a "headless" list).

> +/**
> + * struct ksplice_reloc - Ksplice's analogue of an ELF relocation
> + * @blank_addr:		The address of the relocation's storage unit
> + * @symbol:		The ksplice_symbol associated with this relocation
> + * @howto:		The information regarding the relocation type
> + * @addend:		The ELF addend of the relocation
> + **/
> +struct ksplice_reloc {
> +	unsigned long blank_addr;
> +	struct ksplice_symbol *symbol;
> +	const struct ksplice_reloc_howto *howto;

howto is an interesting name.  I *think* this is what we usually call "ops"?

> +enum ksplice_reloc_howto_type {
> +	KSPLICE_HOWTO_RELOC,
> +	KSPLICE_HOWTO_RELOC_PATCH,
> +	KSPLICE_HOWTO_DATE,
> +	KSPLICE_HOWTO_TIME,
> +	KSPLICE_HOWTO_BUG,
> +	KSPLICE_HOWTO_EXTABLE,
> +};

OK, there are two problems with really reviewing this code.  (1) it does
everything; it's not in stages.  (2) it isn't complete unless you see a
ksplice module which interacts with it.

Could we start with something really simple and work up?  I know it's a
serious amount of work to split like this.  How about a version which just
patches time and date?  Should also be easy to manually create a ksplice
module to test that as well, no?  Then say, substitute a new function.
Finally work up to what you have now, with handling alternatives and
everything.

Otherwise the important review (design, not spelling and style) is not
really possible in finite time.

But trivial comments follow:

> +/* List of all ksplice modules and the module they patch */
> +extern struct list_head ksplice_module_list;

Just call it ksplice_modules.  It's obvious from its usage that it's a list.

> +/**
> + * init_ksplice_pack() - Initializes a pack
> + * @pack:	The pack to be initialized.  All of the public fields of the
> + * 		pack and its associated data structures should be populated
> + * 		before this function is called.  The values of the private
> + * 		fields will be ignored.
> + **/
> +int init_ksplice_pack(struct ksplice_pack *pack);

I think would more usually be called "register_ksplice_pack"?

> +
> +/**
> + * cleanup_ksplice_pack() - Cleans up a pack

unregister... ?

> +typedef int __bitwise__ abort_t;
> +
> +#define OK ((__force abort_t) 0)
> +#define NO_MATCH ((__force abort_t) 1)
> +#define CODE_BUSY ((__force abort_t) 2)
> +#define MODULE_BUSY ((__force abort_t) 3)
> +#define OUT_OF_MEMORY ((__force abort_t) 4)
> +#define FAILED_TO_FIND ((__force abort_t) 5)
> +#define ALREADY_REVERSED ((__force abort_t) 6)
> +#define MISSING_EXPORT ((__force abort_t) 7)
> +#define UNEXPECTED_RUNNING_TASK ((__force abort_t) 8)
> +#define UNEXPECTED ((__force abort_t) 9)
> +#define TARGET_NOT_LOADED ((__force abort_t) 10)
> +#define CALL_FAILED ((__force abort_t) 11)

Yech... I'm not sold on abort_t; how about standard errno?  Yes, you have
to get a bit creative, say: -ENOENT, -EBUSY, -ETXTBSY, -ENOMEM, -ENOENT,
-EEXIST, -ENOEXEC, *, *, -ENODEV, (whatever that call returned).

> +static struct update *init_ksplice_update(const char *kid);
> +static void cleanup_ksplice_update(struct update *update);
> +static void maybe_cleanup_ksplice_update(struct update *update);
> +static void add_to_update(struct ksplice_pack *pack, struct update *update);
> +static int ksplice_sysfs_init(struct update *update);

Please don't talk about what you're going to talk about: order properly
and don't keep up in suspense :)

[ cut 170 more lines of introduction ]

> +#include "ksplice-arch.c"

Hmm, that's a little unclean.  include/linux/ksplice_arch.h
and treat it as a normal .o I'd say.

> +int init_ksplice_pack(struct ksplice_pack *pack)
...
> +	sort(pack->helper_relocs,
> +	     pack->helper_relocs_end - pack->helper_relocs,
> +	     sizeof(*pack->helper_relocs), compare_relocs, NULL);
> +	sort(pack->primary_relocs,
> +	     pack->primary_relocs_end - pack->primary_relocs,
> +	     sizeof(*pack->primary_relocs), compare_relocs, NULL);
> +	sort(pack->helper_sections,
> +	     pack->helper_sections_end - pack->helper_sections,
> +	     sizeof(*pack->helper_sections), compare_section_labels, NULL);

Can't be sorted in userspace?

> +static bool starts_with(const char *str, const char *prefix)
> +{
> +	return strncmp(str, prefix, strlen(prefix)) == 0;
> +}

Hmm, I call this strstarts() in CCAN.  Turns out it's a fairly common need,
I'll implement a common version as a separate patch.

Cheers,
Rusty.
