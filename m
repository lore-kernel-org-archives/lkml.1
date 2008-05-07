Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYEGK6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYEGK6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 06:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYEGK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 06:58:15 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:40822 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYEGK6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 06:58:08 -0400
Message-ID: <48218B1D.2040808@de.ibm.com>
Date: Wed, 07 May 2008 12:57:33 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] gcov: add gcov profiling infrastructure
References: <481F26BE.2060706@de.ibm.com> <20080505224333.d3299a28.akpm@linux-foundation.org>
In-Reply-To: <20080505224333.d3299a28.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 May 2008 17:24:46 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> +config GCOV_PROFILE_ALL
>> +	bool "Profile entire Kernel"
>> +	depends on GCOV_PROFILE
>> +	---help---
>> +	This options activates profiling for the entire kernel.
>> +
>> +	If unsure, say Y.
>> +
>> +	Note that a kernel compiled with profiling flags will be larger and
>> +	slower. Also be sure to exclude files from profiling which are not
>> +	linked to the kernel image to prevent linker errors.
>> +
>> +endmenu
> 
> So this appears under the "kenrel hacking" menu.  Whereas oprofile and
> markers and other such things appear under "General setup".  hm.

I wasn't sure if there was anything remotely similar in the kernel to
place the gcov stuff next to, but General setup seems to be a good
place (and there's "[ ] optimize for size" so that makes sense as well
in a twisted kind of way :) I'm assuming the code can still be kept
under kernel/gcov.

> 
>> Index: linux-2.6.26-rc1/kernel/gcov/base.c
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6.26-rc1/kernel/gcov/base.c
>> @@ -0,0 +1,157 @@
>> +/*
>> + *  Base functions for profiling.
>> + *
>> + *    Copyright IBM Corp. 2008
>> + *    Author(s): Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> + *
>> + *    Uses gcc-internal data definitions.
>> + *    Based on the gcov-kernel patch by:
>> + *		 Hubertus Franke <frankeh@us.ibm.com>
>> + *		 Nigel Hinds <nhinds@us.ibm.com>
>> + *		 Rajan Ravindran <rajancr@us.ibm.com>
>> + *		 Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> + *		 Paul Larson
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/syscalls.h>
>> +#include "gcov.h"
>> +
>> +static gcov_callback_t gcov_callback;
>> +static struct gcov_info *gcov_info_head;
>> +static DEFINE_MUTEX(gcov_lock);
>> +
>> +static void gcov_register_info(struct gcov_info *info)
>> +{
>> +	info->next = gcov_info_head;
>> +	gcov_info_head = info;
>> +	if (gcov_callback)
>> +		gcov_callback(gcov_add, info);
>> +}
>> +
>> +#if GCC_VERSION_LOWER(3, 4)
>> +
>> +#error "GCOV profiling support for gcc versions below 3.4 not included"
>> +
>> +#else
> 
> The #else isn't needed here.
> 
> Traditionally we put gcc version checking into init/main.c, so you could do
> the above test over in that file, inside #ifdef CONFIG_GCOV_PROFILE.

All these GCC_VERSION_LOWER constructs date back to when the gcov kernel
patch included support for several different versions of gcc. My
original intention of keeping them here was to allow for easy extension
when gcc changes its gcov format (yet again). I agree though that the
code will look cleaner when this is consolidated in one place.

>> +/* Functions needed by profiling code for gcc 3.4 and above. */
>> +
>> +unsigned int gcov_version;
>> +
>> +void __gcov_init(struct gcov_info *info)
>> +{
>> +	mutex_lock(&gcov_lock);
>> +	/* Check for compatible gcc version. */
>> +	if (gcov_version == 0) {
>> +		gcov_version = info->version;
>> +		printk(KERN_INFO TAG "gcc version %x\n", gcov_version);
> 
> hm, what does the output from this look like?  "gcc version 42", which is
> really gcc version 66 only we didn't tell the user that we printed it in
> hex?
> 
> Might need a bit more thought here?

Quote from gcc/gcov-io.h:

   The version number
   consists of the single character major version number, a two
   character minor version number (leading zero for versions less than
   10), and a single character indicating the status of the release.
   [...]
   For gcc 3.4 experimental, it would be '304e' (0x33303465).

This number really is meant for debugging purposes: when a user
encounters problems, a copy of this line can tell exactly which version
of gcc's gcov data structures were used during compilation.

Maybe a modified message text "gcov data version magic: %x" would be
more descriptive.

>> +	} else if (info->version != gcov_version) {
>> +		printk(KERN_WARNING TAG "version mismatch in %s\n",
>> +		       info->filename);
>> +		goto out;
>> +	}
>> +	gcov_register_info(info);
>> +out:
>> +	mutex_unlock(&gcov_lock);
>> +}
>> +EXPORT_SYMBOL(__gcov_init);
> 
> We have an exported-to-modules symbol which is completely unreferenced from
> within the kernel source code.  You might want to add a comment in this
> file explaining what's going on; otherwise people will try to delete your
> code ;)

Good point. I'll add that.

>> +int gcov_register_callback(gcov_callback_t callback)
>> +{
>> +	struct gcov_info *info;
>> +	int rc;
>> +
>> +	mutex_lock(&gcov_lock);
>> +	if (gcov_callback) {
>> +		rc = -EBUSY;
>> +		goto out;
>> +	}
>> +	rc = 0;
>> +	gcov_callback = callback;
>> +	/* Perform callback for previously registered entries. */
>> +	for (info = gcov_info_head; info; info = info->next)
>> +		gcov_callback(gcov_add, info);
>> +out:
>> +	mutex_unlock(&gcov_lock);
>> +
>> +	return rc;
>> +}
> 
> Please add a (good) comment above the definition of gcov_callback
> explaining what it does.  For this is quite unobvious from the
> implementation.
> 
> It is also unobvious why we will only ever need to support a
> single callback.

This callback serves as interface between the part that keeps track of
gcov data structures as they come and go and the part that creates sysfs
files for each structure. The callback construct is a bit of a leftover
from when the latter part was compiled as a module. This could possibly
be reduced to a simple function call.

>> +static inline int within(void *addr, void *start, unsigned long size)
>> +{
>> +        return (addr >= start && (void *) addr < start + size);
>> +}
> 
> That is at least our fourth implementation of within(), and not all of them
> have the same semantics.

I'll see if these can be merged. What would be the right place,
linux/kernel.h?

>> +static struct notifier_block gcov_nb = {
>> +	.notifier_call	= gcov_module_notifier,
>> +};
>> +
>> +static int __init gcov_init(void)
>> +{
>> +	return register_module_notifier(&gcov_nb);
>> +}
>> +__initcall(gcov_init);
> 
> This code fails to compile with CONFIG_MODULES=n.

Ugh.

>> +#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
>> +					 (__GNUC__ == major) && \
>> +					 (__GNUC_MINOR__ < minor))
> 
> It is inappropriate that this helper macro be buried down in kernel/gcov/
> 
> <linux/compiler-gcc.h> might be a suitable place.  Ideally as a standalone
> patch.

Ok, will do that.

>> +/* Profiling data types used for gcc 3.4 and above. */
>> +
>> +#define GCOV_COUNTERS		5
>> +#define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
>> +#define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
>> +#define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
>> +#define GCOV_TAG_FOR_COUNTER(count)					\
>> +	(GCOV_TAG_COUNTER_BASE + ((unsigned int) (count) << 17))
>> +
>> +#if BITS_PER_LONG >= 64
>> +typedef long gcov_type;
>> +#else
>> +typedef long long gcov_type;
>> +#endif
> 
> Can we zap gcov_type completely and use u64?

gcc defines these types so I don't think there's another way to stay
compatible than to copy their definitions.

>> +struct gcov_fn_info {
>> +	unsigned int ident;
>> +	unsigned int checksum;
>> +	unsigned int n_ctrs[0];
>> +};
>> +
>> +struct gcov_ctr_info {
>> +	unsigned int num;
>> + 	gcov_type *values;
>> +	void (*merge)(gcov_type *, unsigned int);
>> +};
>> +
>> +struct gcov_info {
>> +	unsigned int version;
>> +	struct gcov_info *next;
>> +	unsigned int stamp;
>> +	const char *filename;
>> +	unsigned int n_functions;
>> +	const struct gcov_fn_info *functions;
>> +	unsigned int ctr_mask;
>> +	struct gcov_ctr_info counts[0];
>> +};
> 
> It'd be nice to document the core data structures.

Ok.

>> +extern unsigned int gcov_version;
>> +
>> +#endif /* GCC_VERSION_LOWER */
>> +
>> +/* Base interface. */
>> +enum gcov_action {
>> +	gcov_add,
>> +	gcov_remove,
>> +};
>> +
>> +typedef void (*gcov_callback_t)(enum gcov_action, struct gcov_info *);
>> +
>> +int gcov_register_callback(gcov_callback_t);
>> +
>> +/* Iterator control. */
>> +struct seq_file;
>> +
>> +void *gcov_iter_new(struct gcov_info *);
>> +void gcov_iter_start(void *);
>> +int gcov_iter_next(void *);
> 
> Not very nice, sorry.  These take a type-unsafe void* when their arguments
> must be of type `struct iterator_t *' (hopefully to become `struct
> gcov_iterator *').  This is because they happen to be passed
> seq_file.private, but who is to say that this will be the case for all
> callers in the future.
> 
> In fact if these are given a properly typed argument we can rely upon the
> compiler's automatic void*-to-anything* conversion to avoid a typecast at
> the calling sites.  And we can avoid a local and a typecast within the
> implementation of these functions.

Originally, iterator_t was to be isolated to gcov/gcc_x_x.c so that
support for new gcov versions could be easily added. I'm not even sure
how the iterator_t usage ended up in gcov/fs.c (and why gcc doesn't
warn about this). I guess it can be converted to a type-safe construct
using an opaque forward declaration of gcov_iterator and some duct tape.

>> +int gcov_iter_write(void *, struct seq_file *);
>> +struct gcov_info *gcov_iter_get_info(void *);
>> +
>> +/* gcov_info control. */
>> +void gcov_info_reset(struct gcov_info *);
>> +int gcov_info_is_compatible(struct gcov_info *, struct gcov_info *);
>> +void gcov_info_add(struct gcov_info *, struct gcov_info *);
>> +struct gcov_info *gcov_info_dup(struct gcov_info *);
>> +void gcov_info_free(struct gcov_info *);
> 
> Adding the names of the variables in prototypes can sometimes add a little
> documentarty benefit.

Agreed.

>> +struct gcov_link_t {
>> +	enum {
>> +		obj_tree,
>> +		src_tree,
>> +	} dir;
>> +	const char *ext;
>> +};
> 
> `struct gcov_link', please.

Ok.

>> +++ linux-2.6.26-rc1/kernel/gcov/fs.c

>> +struct node_t {
>> +	struct list_head list;
>> +	struct list_head children;
>> +	struct list_head all;
>> +	struct node_t *parent;
>> +	struct gcov_info *info;
>> +	struct gcov_info *ghost;
>> +	struct dentry *dentry;
>> +	struct dentry **links;
>> +	char name[0];
>> +};
> 
> Should be `struct node', but that is too generic a name.  gcov_node, perhaps?

gcov_node it is then.

>> +static const char objtree[] = OBJTREE;
>> +static const char srctree[] = SRCTREE;
>> +static struct node_t root_node;
>> +static struct list_head all_head;
> 
> Use LIST_HEAD() here, remove the runtime INIT_LIST_HEAD() from
> gcov_fs_init().

Ok.

>> +static struct dentry *reset_dentry;
>> +static DEFINE_MUTEX(node_lock);
>> +
>> +/* If non-zero, keep copies of profiling data for unloaded modules. */
>> +static int gcov_persist = 1;
>> +
>> +static int __init gcov_persist_setup(char *str)
>> +{
>> +	int val;
>> +	char delim;
>> +
>> +	if (sscanf(str, "%d %c", &val, &delim) != 1) {
>> +		printk(KERN_WARNING TAG "invalid gcov_persist parameter '%s'\n",
>> +		       str);
>> +		return 0;
>> +	}
>> +	printk(KERN_INFO TAG "setting gcov_persist to %d\n", val);
>> +	gcov_persist = val;
>> +
>> +	return 1;
>> +}
>> +__setup("gcov_persist=", gcov_persist_setup);
> 
> Please document kernel parameters in Documentation/kernel-parameters.txt.

Ok.

>> +static struct node_t *get_node_by_name(const char *name)
>> +{
>> +	struct node_t *node;
>> +	struct gcov_info *info;
>> +
>> +	list_for_each_entry(node, &all_head, all) {
>> +		info = get_node_info(node);
>> +		if (info && (strcmp(info->filename, name) == 0))
>> +			return node;
>> +	}
>> +
>> +	return NULL;
>> +}
> 
> Caller must take node_lock.  That's worth a comment.

Agreed.

>> +static void remove_node(struct node_t *node);
>> +
>> +static ssize_t gcov_seq_write(struct file *file, const char __user *addr,
>> +			      size_t len, loff_t *pos)
>> +{
>> +	struct seq_file *seq = file->private_data;
>> +	struct gcov_info *info = gcov_iter_get_info(seq->private);
>> +	struct node_t *node;
>> +
>> +	mutex_lock(&node_lock);
>> +	node = get_node_by_name(info->filename);
>> +	if (node) {
>> +		/* Reset counts or remove node for unloaded modules. */
>> +		if (node->ghost)
>> +			remove_node(node);
>> +		else
>> +			gcov_info_reset(node->info);
>> +	}
>> +	/* Reset counts for open file. */
>> +	gcov_info_reset(info);
>> +	mutex_unlock(&node_lock);
>> +
>> +	return len;
>> +}
>> +
>> +static char *build_target(const char *dir, const char *rel, const char *ext)
>> +{
>> +	char *target;
>> +	char *old_ext;
>> +
>> +	if (dir) {
>> +		/* DIR + '/' + REL + '.' + EXT + '\0' */
>> +		target = kmalloc(strlen(dir) + strlen(rel) + strlen(ext) + 3,
>> +				 GFP_KERNEL);
>> +		if (!target)
>> +			return NULL;
>> +		sprintf(target, "%s/%s", dir, rel);
>> +	} else {
>> +		/* REL + '.' + EXT + '\0' */
>> +		target = kmalloc(strlen(rel) + strlen(ext) + 2, GFP_KERNEL);
>> +		if (!target)
>> +			return NULL;
>> +		sprintf(target, "%s", rel);
>> +	}
>> +	old_ext = strrchr(target, '.');
>> +	if (!old_ext)
>> +		old_ext = target + strlen(target);
>> +	sprintf(old_ext, ".%s", ext);
>> +
>> +	return target;
>> +}
> 
> Again, some comments explaining what the code does wouldn't hurt.
> 
> The above might look a bit neater and more maintainable were it to use
> kasprintf() (would need a bit of reorganising of the extension part).

Interesting - using kasprintf() this function should be 1/3 its size..

>> +char *get_link_target(const char *filename, const struct gcov_link_t *ext)
>> +{
>> +	const char *rel;
>> +	char *result;
>> +
>> +	if (strncmp(filename, objtree, strlen(objtree)) == 0) {
>> +		rel = filename + strlen(objtree) + 1;
>> +		if (ext->dir == src_tree)
>> +			result = build_target(srctree, rel, ext->ext);
>> +		else
>> +			result = build_target(objtree, rel, ext->ext);
>> +	} else {
>> +		/* External compilation. */
>> +		result = build_target(NULL, filename, ext->ext);
>> +	}
>> +	return result;
>> +}
> 
> <wonders what this is for>

Ok, ok, I get it - more documentation :)

>> +static struct node_t *get_child_by_name(struct node_t *parent, const char *name)
>> +{
>> +	struct node_t *node;
>> +
>> +	list_for_each_entry(node, &parent->children, list) {
>> +		if (strcmp(node->name, name) == 0)
>> +			return node;
>> +	}
>> +
>> +	return NULL;
>> +}
> 
> I trust this won't be called very frequently.

get_child_by_name() will be called multiple times for each gcov data
structure when it is initialized. I don't see a problem with that
though..

>> +static ssize_t reset_write(struct file *file, const char __user *addr,
>> +			   size_t len, loff_t *pos)
>> +{
>> +	struct node_t *node;
>> +	struct node_t *r;
>> +
>> +	mutex_lock(&node_lock);
>> +	list_for_each_entry_safe(node, r, &all_head, all) {
>> +		if (node->info)
>> +			gcov_info_reset(node->info);
>> +		else
>> +			remove_node(node);
>> +	}
>> +	mutex_unlock(&node_lock);
>> +
>> +	return len;
>> +}
>> +
>> +static ssize_t reset_read(struct file *file, char __user *addr, size_t len,
>> +			  loff_t *pos)
>> +{
>> +	/* Allow read operation so that a recursive copy won't fail. */
>> +	return 0;
>> +}
>> +
>> +static struct file_operations reset_fops = {
>> +	.write = reset_write,
>> +	.read = reset_read,
>> +};
> 
> So... there's a reset file which resets something?
> 
> The proposed user interfaces should be documented, please. 
> Documentation/gcov.txt, perhaps.

Sounds like a good place for such a description.

>> +static void add_node(struct gcov_info *info)
>> +{
>> +	char *filename;
>> +	char *curr;
>> +	char *next;
>> +	struct node_t *parent;
>> +	struct node_t *node;
>> +
>> +	filename = kstrdup(info->filename, GFP_KERNEL);
>> +	if (!filename)
>> +		return;
>> +	parent = &root_node;
>> +	/* Create path nodes. */
>> +	for (curr = filename; (next = strchr(curr, '/')); curr = next + 1) {
>> +		if (curr == next)
>> +			continue;
>> +		*next = 0;
>> +		node = get_child_by_name(parent, curr);
>> +		if (!node) {
>> +			node = new_node(parent, NULL, curr);
>> +			if (!node)
>> +				goto out_err;
>> +		}
>> +		parent = node;
>> +	}
>> +	/* Create file node. */
>> +	node = new_node(parent, info, curr);
>> +	if (node)
>> +		goto out;
>> +out_err:
>> +	remove_node(parent);
>> +out:
>> +	kfree(filename);
>> +}
>> +
>> +static int ghost_node(struct node_t *node)
>> +{
>> +	node->ghost = gcov_info_dup(node->info);
>> +	if (!node->ghost) {
>> +		printk(KERN_WARNING TAG "could not save data for '%s' (out of "
>> +		       "memory)\n", node->info->filename);
>> +		return -ENOMEM;
>> +	}
>> +	node->info = NULL;
>> +
>> +	return 0;
>> +}
> 
> I don't know what all this ghosting stuff is.  Perhaps it is obvious to
> those who know gcov internals (ie: approximately 0% of kernel developers).

I think the pun may have gone missing once I removed ghost_bust(). Will
add some documentation here as well.

>> +static void revive_node(struct node_t *node, struct gcov_info *info)
>> +{
>> +	if (gcov_info_is_compatible(node->ghost, info))
>> +		gcov_info_add(info, node->ghost);
>> +	else {
>> +		printk(KERN_WARNING TAG "could not add data for '%s' "
>> +		       "(incompatible data)\n", info->filename);
>> +	}
>> +	kfree(node->ghost);
>> +	node->ghost = NULL;
>> +	node->info = info;
>> +}
>> +
>> +static void gcov_cb(enum gcov_action action, struct gcov_info *info)
>> +{
>> +	struct node_t *node;
>> +
>> +	mutex_lock(&node_lock);
>> +	node = get_node_by_name(info->filename);
>> +	switch (action) {
>> +	case gcov_add:
>> +		if (!node) {
>> +			add_node(info);
>> +			break;
>> +		}
>> +		if (gcov_persist)
>> +			revive_node(node, info);
>> +		else
>> +			printk(KERN_WARNING TAG "could not add '%s' "
>> +			       "(already exists)\n", info->filename);
>> +		break;
>> +	case gcov_remove:
>> +		if (!node) {
>> +			printk(KERN_WARNING TAG "could not remove '%s' (not "
>> +			       "found)\n", info->filename);
>> +			break;
>> +		}
>> +		if (gcov_persist) {
>> +			if (!ghost_node(node))
>> +				break;
>> +		}
>> +		remove_node(node);
>> +		break;
>> +	}
>> +	mutex_unlock(&node_lock);
>> +}
> 
> This is our callback!
> 
> Given that the code only supports a single callback, and that a few lines
> below we register gcov_cb() to consume that callback, why do we need a
> callback indirect pointer at all?

I will try to eliminate the callback.

>> +++ linux-2.6.26-rc1/kernel/gcov/gcc_3_4.c

>> +/* Return the number of active counter types for info. */
>> +static unsigned int num_counter_active(struct gcov_info *info)
>> +{
>> +	unsigned int i;
>> +	unsigned int result = 0;
>> +
>> +	for (i = 0; i < GCOV_COUNTERS; i++)
>> +		if (counter_active(info, i))
>> +			result++;
>> +	return result;
>> +}
> 
> Might be able to use hweight32() here, although that's a bit pointless and
> presumptuous.

I'm not sure if hweight() can be restricted to the first n bits of
a word. Also I'd like to keep this as close to the gcc code as possible
to help avoid compatibility issues.

>> +/**
>> + * gcov_info_reset - reset profiling data
>> + * @info: profiling data address
>> + */
>> +void gcov_info_reset(struct gcov_info *info)
>> +{
>> +	struct gcov_ctr_info *ctr = info->counts;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < GCOV_COUNTERS; i++) {
>> +		if (counter_active(info, i)) {
>> +			memset(ctr->values, 0, ctr->num * sizeof(gcov_type));
>> +			ctr++;
>> +		}
>> +	}
>> +}
> 
> I'm wondering if there might be races here with counters becoming active
> while this code is running.  But I know nothing about what determines when
> a counter becomes active.  What governs this?

All of gcov_info, gcov_ctr_info and gcov_fn_info is generated by gcc at
compile time. From a kernel perspective it is static data with the
exception of gcov_info.next and gcov_info.counts. Maybe it would make
sense to define all other members as const.

>> +/**
>> + * gcov_info_dup - duplicate profiling data
>> + * @info: address of profiling data to duplicate
>> + *
>> + * Return the address of the newly allocated duplicate on success, %NULL on
>> + * error.
>> + */
>> +struct gcov_info *gcov_info_dup(struct gcov_info *info)
>> +{
>> +	struct gcov_info *result;
>> +	size_t len;
>> +	unsigned int active;
>> +	unsigned int i;
>> +	char *name;
>> +	struct gcov_fn_info *func;
>> +	gcov_type *values;
>> +
>> +	/* Allocate memory for struct gcov_info */
>> +	active = num_counter_active(info);
>> +	len = sizeof(struct gcov_info) + sizeof(struct gcov_ctr_info) * active +
>> +	      strlen(info->filename) + 1;
>> +	for (i = 0; i < active; i++)
>> +		len += sizeof(gcov_type) * info->counts[i].num;
>> +	result = kzalloc(len, GFP_KERNEL);
>> +	if (!result)
>> +		return NULL;
>> +	/* Allocate memory for array of struct gcov_fn_info */
>> +	len = info->n_functions * get_fn_size(info);
>> +	func = kmalloc(len, GFP_KERNEL);
>> +	if (!func) {
>> +		kfree(result);
>> +		return NULL;
>> +	}
>> +	/* Copy function data */
>> +	memcpy(func, info->functions, len);
>> +	result->functions = func;
>> +	/* Copy counts */
>> +	values = (gcov_type *) &result->counts[active];
> 
> The typecast worries me.  We have a `struct gcov_ctr_info *' and we cast
> that to a gcov_type*?  But we just cast a pointer to `unsigned int num', I
> think.

The intention here was to use a single kmalloc() to get memory for
gcov_info, gcov_ctr infos, the filename and count data. The cast is
just used to get the address of the next component. Seeing the confusion
this approach can cause I guess it would be better to use multiple
kmallocs().

>> +struct type_info {
>> +	int num;
>> +	unsigned int offset;
>> +};
>> +
>> +struct iterator_t {
> 
> struct gcov_iterator?

Agreed.

>> +static int seq_write_gcov_int(struct seq_file *seq, size_t size, u64 v)
>> +{
>> +	u32 data[2];
>> +
>> +	switch (size) {
>> +	case 8:
>> +		data[1] = (u32) (v >> 32);
>> +		/* fall through */
>> +	case 4:
>> +		data[0] = (u32) (v & 0xffffffffUL);
> 
> the casts and the masking aren't strictly needed here.

The casts can go but I'd rather leave the masking to document that the
switch in word length is desired.

>> +		return seq_write(seq, data, size);
>> +	}
>> +	return -EINVAL;
>> +}
> 
> I guess we don't have any endianness concerns here.

This format is dictated by gcc:

   Numbers are recorded in the 32 bit unsigned binary form of the
   endianness of the machine generating the file. 64 bit numbers are
   stored as two 32 bit numbers, the low part first.

Hm, this might even fit a comment.. :)

Anyway, thanks for the extensive comments. I'll get back with a modified
version of this patch set.


Regards,
  Peter
