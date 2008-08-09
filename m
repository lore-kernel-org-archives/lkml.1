Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbYHICoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbYHICoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYHICn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:43:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38148 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbYHICn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:43:56 -0400
Date: Fri, 8 Aug 2008 19:38:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-Id: <20080808193851.24210bc4.randy.dunlap@oracle.com>
In-Reply-To: <20080808215153.GA16729@redhat.com>
References: <20080715213108.GB23331@redhat.com>
	<20080717070103.GA21961@kroah.com>
	<20080717212040.GB13252@redhat.com>
	<20080717223222.GA28016@kroah.com>
	<20080808215153.GA16729@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 17:51:53 -0400 Jason Baron wrote:

> Few notes...there is still one control file: <debugfs>/dynamic_printk/modules
> We can split this up now or later, but I kind of like being able to see all
> the controls in one file. Also, i've used a djb2 hash function in the code,
> which i'm not sure is under the correct license/copyright, so i just wanted
> to point that out as well. see: scripts/basic/hash.c. If its an issue, i can
> find another hash function. 

What license does it have?  I don't see one.

> ---
> 
>  Documentation/kernel-parameters.txt |    5 
>  include/asm-generic/vmlinux.lds.h   |   10 +
>  include/linux/device.h              |    6 -
>  include/linux/dynamic_printk.h      |   94 ++++++++
>  include/linux/kernel.h              |    7 +
>  include/linux/module.h              |    4 
>  kernel/module.c                     |   22 ++
>  lib/Kconfig.debug                   |   56 +++++
>  lib/Makefile                        |    2 
>  lib/dynamic_printk.c                |  409 +++++++++++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_pptp.c   |    2 
>  scripts/Makefile.lib                |   11 +
>  scripts/basic/Makefile              |    2 
>  scripts/basic/hash.c                |   64 +++++
>  14 files changed, 688 insertions(+), 6 deletions(-)
>  create mode 100644 include/linux/dynamic_printk.h
>  create mode 100644 lib/dynamic_printk.c
>  create mode 100644 scripts/basic/hash.c



> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 623ef24..6664783 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -632,6 +632,62 @@ config FIREWIRE_OHCI_REMOTE_DMA
>  
>  	  If unsure, say N.
>  
> +config DYNAMIC_PRINTK_DEBUG
> +	bool "Enable dynamic printk() call support"
> +	default n
> +	depends on PRINTK
> +	select PRINTK_DEBUG
> +	help
> +	 
> +	  Compiles debug level messages into the kernel, which would not
> +	  otherwise be available at runtime. These messages can then be
> +	  enabled/disabled on a per module basis. This mechanism, implicitly 

no comma.  Don't end lines with whitespace.

> +	  enables all pr_debug() and dev_dbg() calls. The impact of this 
> +	  compile option is a larger kernel text size ~2%.

	                                         size of about 2%.

> +
> +	  Usage:
> +
> +	  Dynamic debugging is controlled by the debugfs file, 
> +	  dynamic_printk/modules. This file contains a list of the modules that
> +	  can be enabled. The format of the file is the module name, followed
> +	  by a set of flags that can be enabled. The first flags is always the

	                                             first flag is

> +	  'enabled' flags. For example:

	            flag.

> +
> +		<module_name> <enabled=0/1>
> +				.
> +				.
> +				.
> +
> +	  <module_name> : Name of the module in which the debug call resides
> +	  <enabled=0/1> : whether the the messages are enabled or not

	                          the

> +
> +	  From a live system:
> +
> +		snd_hda_intel enabled=0
> +
> +		fixup enabled=0
> +
> +		driver enabled=0

including the apparently extraneous blank lines??

> +
> +	  Enable a module:
> +
> +	  	$echo "set enabled=1 <module_name>" > dynamic_printk/modules
> +
> +	  Disable a module:
> +
> +	  	$echo "set enabled=0 <module_name>" > dynamic_printk/modules
> +
> +	  Enable all modules:
> +	
> +		$echo "set enabled=1 all" > dynamic_printk/modules
> +
> +	  Disable all modules:
> +
> +		$echo "set enabled=0 all" > dynamic_printk/modules
> +
> +	  Finally, passing "dynamic_printk" at the command line enables all 
> +	  modules. This mode can be turned off by disabling modules.

What does "can be turned off by disabling modules" mean, please?
CONFIG_MODULES=n or something else?

> +	
>  source "samples/Kconfig"
>  
>  source "lib/Kconfig.kgdb"
> diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
> new file mode 100644
> index 0000000..04ae7e2
> --- /dev/null
> +++ b/lib/dynamic_printk.c
> @@ -0,0 +1,409 @@
> +
> +extern struct mod_debug __start___verbose[];
> +extern struct mod_debug __stop___verbose[];

put these into a header file.

> +
> +struct debug_name {
> +	struct hlist_node hlist;
> +	struct hlist_node hlist2;
> +	int hash1;
> +	int hash2;
> +	char *name;
> +	int enable;
> +	int type;
> +};
> +
> +static int nr_entries;
> +static int num_enabled;
> +int dynamic_enabled = DYNAMIC_ENABLED_NONE;
> +static struct hlist_head module_table[DEBUG_HASH_TABLE_SIZE] =
> +	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
> +static struct hlist_head module_table2[DEBUG_HASH_TABLE_SIZE] =
> +	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
> +static DECLARE_MUTEX(debug_list_mutex);
> +
> +long long dynamic_printk_enabled;
> +EXPORT_SYMBOL_GPL(dynamic_printk_enabled);
> +long long dynamic_printk_enabled2;
> +EXPORT_SYMBOL_GPL(dynamic_printk_enabled2);
> +
> +/* returns the debug module pointer. caller must locking */

      caller must ___ locking ??

> +static struct debug_name *find_debug_module(char *module_name)
> +{
> +	int i;
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct debug_name *element;
> +
> +	element = NULL;
> +	for (i = 0; i < DEBUG_HASH_TABLE_SIZE; i++) {
> +		head = &module_table[i];
> +		hlist_for_each_entry_rcu(element, node, head, hlist)
> +			if (!strcmp(element->name, module_name))
> +				return element;
> +	}
> +	return NULL;
> +}
> +
> +/* returns the debug module pointer. caller must locking */

ditto, check comment.

> +static struct debug_name *find_debug_module_hash(char *module_name, int hash)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct debug_name *element;
> +
> +	element = NULL;
> +	head = &module_table[hash];
> +	hlist_for_each_entry_rcu(element, node, head, hlist)
> +		if (!strcmp(element->name, module_name))
> +			return element;
> +	return NULL;
> +}
> +

Please add kernel-doc comments for the exported/public interfaces.

> +int unregister_dynamic_debug_module(char *mod_name)
> +{
> +	struct debug_name *element;
> +	int ret = 0;
> +
> +	down(&debug_list_mutex);
> +	element = find_debug_module(mod_name);
> +	if (!element) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	hlist_del_rcu(&element->hlist);
> +	hlist_del_rcu(&element->hlist2);
> +	synchronize_rcu();
> +	if (element->name)
> +		kfree(element->name);
> +	if (element->enable)
> +		num_enabled--;
> +	kfree(element);
> +	nr_entries--;
> +out:
> +	up(&debug_list_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(unregister_dynamic_debug_module);
> +
> +int register_dynamic_debug_module(char *mod_name, int type, char *share_name,
> +					char *flags, int hash, int hash2)
> +{
> +	struct debug_name *elem;
> +	int ret = 0;
> +
> +	down(&debug_list_mutex);
> +	elem = find_debug_module(mod_name);
> +	if (!elem) {
> +		if (__add_debug_module(mod_name, hash, hash2))
> +			goto out;
> +		elem = find_debug_module(mod_name);
> +		if (dynamic_enabled == DYNAMIC_ENABLED_ALL &&
> +				!strcmp(mod_name, share_name)) {
> +			elem->enable = true;
> +			num_enabled++;
> +		}
> +	}
> +	elem->type |= type;
> +out:
> +	up(&debug_list_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(register_dynamic_debug_module);
> +

> diff --git a/scripts/basic/hash.c b/scripts/basic/hash.c
> new file mode 100644
> index 0000000..3299ad7
> --- /dev/null
> +++ b/scripts/basic/hash.c
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (C) 2008 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
> + *
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#define DYNAMIC_DEBUG_HASH_BITS 6
> +
> +static const char *program;
> +
> +static void usage(void)
> +{
> +	printf("Usage: %s <djb2|r5> <modname>\n", program);
> +	exit(1);
> +}
> +
> +/* djb2 hashing algorithm by Dan Bernstein. From:
> + * http://www.cse.yorku.ca/~oz/hash.html
> + */
> +
> +unsigned int djb2_hash(char *str)
> +{
> +	unsigned long hash = 5381;
> +	int c;
> +
> +	c = *str;
> +	while (c) {
> +		hash = ((hash << 5) + hash) + c;
> +		c = *++str;
> +	}
> +	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
> +}
> +
> +unsigned int r5_hash(char *str)
> +{
> +	unsigned long hash = 0;
> +	int c;
> +
> +	c = *str;
> +	while (c) {
> +		hash = (hash + (c << 4) + (c >> 4)) * 11;
> +		c = *++str;
> +	}
> +	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	program = argv[0];
> +
> +	if (argc != 3)
> +		usage();
> +	if (!strcmp(argv[1], "djb2"))
> +		printf("%d\n", djb2_hash(argv[2]));
> +	else if (!strcmp(argv[1], "r5"))
> +		printf("%d\n", r5_hash(argv[2]));
> +	else
> +		usage();
> +	exit(0);
> +}


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
