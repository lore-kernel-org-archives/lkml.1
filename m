Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZFBWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZFBWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZFBWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:04:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZFBWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:04:12 -0400
Date: Tue, 2 Jun 2009 15:03:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-Id: <20090602150324.c706b1d2.akpm@linux-foundation.org>
In-Reply-To: <20090602114402.951631599@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	<20090602114402.951631599@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jun 2009 13:44:02 +0200
Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Enable the use of GCC's coverage testing tool gcov [1] with the Linux
> kernel. gcov may be useful for:
> 
>  * debugging (has this code been reached at all?)
>  * test improvement (how do I change my test to cover these lines?)
>  * minimizing kernel configurations (do I need this option if the
>    associated code is never run?)
> 
> The profiling patch incorporates the following changes:
> 
>  * change kbuild to include profiling flags
>  * provide functions needed by profiling code
>  * present profiling data as files in debugfs
> 
> Note that on some architectures, enabling gcc's profiling option
> "-fprofile-arcs" for the entire kernel may trigger compile/link/
> run-time problems, some of which are caused by toolchain bugs and
> others which require adjustment of architecture code.
> 
> For this reason profiling the entire kernel is initially restricted
> to those architectures for which it is known to work without changes.
> This restriction can be lifted once an architecture has been tested
> and found compatible with gcc's profiling. Profiling of single files
> or directories is still available on all platforms (see config help
> text).
> 
> 
> [1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
> 
>
> ...
>
> +/*
> + * __gcov_init is called by gcc-generated constructor code for each object
> + * file compiled with -fprofile-arcs.
> + */

How does this work?  At what time does gcc call the constructors, and
in what context are they called, etc?

IOW, please teach me about -fprofile-arcs :)


> +void __gcov_init(struct gcov_info *info)
> +{
> +	static unsigned int gcov_version;
> +
> +	mutex_lock(&gcov_lock);
> +	if (gcov_version == 0) {
> +		gcov_version = info->version;
> +		/*
> +		 * Printing gcc's version magic may prove useful for debugging
> +		 * incompatibility reports.
> +		 */
> +		pr_info("version magic: 0x%x\n", gcov_version);

Will this be spat out as simply

version magic: 0x1234

?  If so, that'll be rather obscure because people won't know what
subsystem printed it.  Prefixing this (and all other printks) with
"gcov: " would fix that.

> +	}
> +	/*
> +	 * Add new profiling data structure to list and inform event
> +	 * listener.
> +	 */
> +	info->next = gcov_info_head;
> +	gcov_info_head = info;
> +	if (gcov_events_enabled)
> +		gcov_event(GCOV_ADD, info);
> +	mutex_unlock(&gcov_lock);
> +}
> +EXPORT_SYMBOL(__gcov_init);
> +
>
> ...
>
> +#ifdef CONFIG_MODULES
> +static inline int within(void *addr, void *start, unsigned long size)
> +{
> +	return ((addr >= start) && (addr < start + size));
> +}

That's our fourth implementation of within() (at least).  All basically
identical.  Whine.

>
> ...
>
> +static int __init gcov_persist_setup(char *str)
> +{
> +	int val;
> +	char delim;
> +
> +	if (sscanf(str, "%d %c", &val, &delim) != 1) {
> +		pr_warning("invalid gcov_persist parameter '%s'\n", str);
> +		return 0;
> +	}
> +	pr_info("setting gcov_persist to %d\n", val);
> +	gcov_persist = val;
> +
> +	return 1;
> +}
> +__setup("gcov_persist=", gcov_persist_setup);

hm, what's the input format here?  It looks like

	gcov_persist=1 x

and " x" is checked for, but ignored.

Confused.  What's this all for?  Can't we just us plain old strtoul(), etc?

> +/*
> + * seq_file.start() implementation for gcov data files. Note that the
> + * gcov_iterator interface is designed to be more restrictive than seq_file
> + * (no start from arbitrary position, etc.), to simplify the iterator
> + * implementation.
> + */
> +static void *gcov_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	loff_t i;
> +
> +	gcov_iter_start(seq->private);
> +	for (i = 0; i < *pos; i++) {
> +		if (gcov_iter_next(seq->private))
> +			return NULL;
> +	}
> +	return seq->private;
> +}

This looks like it could be very expensive if used inappropriately.  I
guess the answer to that is "don't use it inapprpriately", yes?

>
> ...
>
> +struct gcov_info *gcov_info_dup(struct gcov_info *info)
> +{
> +	struct gcov_info *dup;
> +	unsigned int i;
> +	unsigned int active;
> +
> +	/* Duplicate gcov_info. */
> +	active = num_counter_active(info);
> +	dup = kzalloc(sizeof(struct gcov_info) +
> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);

How large can this allocation be?

> +	if (!dup)
> +		return NULL;
> +	dup->version		= info->version;
> +	dup->stamp		= info->stamp;
> +	dup->n_functions	= info->n_functions;
> +	dup->ctr_mask		= info->ctr_mask;
> +	/* Duplicate filename. */
> +	dup->filename		= kstrdup(info->filename, GFP_KERNEL);
> +	if (!dup->filename)
> +		goto err_free;
> +	/* Duplicate table of functions. */
> +	dup->functions = kmemdup(info->functions, info->n_functions *
> +				 get_fn_size(info), GFP_KERNEL);
> +	if (!dup->functions)
> +		goto err_free;
> +	/* Duplicate counter arrays. */
> +	for (i = 0; i < active ; i++) {
> +		struct gcov_ctr_info *ctr = &info->counts[i];
> +		size_t size = ctr->num * sizeof(gcov_type);
> +
> +		dup->counts[i].num = ctr->num;
> +		dup->counts[i].merge = ctr->merge;
> +		dup->counts[i].values = kmemdup(ctr->values, size, GFP_KERNEL);
> +		if (!dup->counts[i].values)
> +			goto err_free;
> +	}
> +	return dup;
> +
> +err_free:
> +	gcov_info_free(dup);
> +	return NULL;
> +}
> +

It all looks very nice to me.
