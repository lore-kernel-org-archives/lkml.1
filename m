Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZFCL7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZFCL7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZFCL7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:59:04 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:61010 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZFCL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:59:03 -0400
Message-ID: <4A266546.5080601@linux.vnet.ibm.com>
Date: Wed, 03 Jun 2009 13:57:58 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org>
In-Reply-To: <20090602150324.c706b1d2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 02 Jun 2009 13:44:02 +0200
> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>> +/*
>> + * __gcov_init is called by gcc-generated constructor code for each object
>> + * file compiled with -fprofile-arcs.
>> + */
> 
> How does this work?  At what time does gcc call the constructors, and
> in what context are they called, etc?
> 
> IOW, please teach me about -fprofile-arcs :)

No problem :) -fprofile-arcs cause gcc to insert profiling code which 
relies on gcc's constructor mechanism for initialization purposes (so 
the two are separate things while the former makes use of the latter). 
gcc's constructor mechanism also has uses besides -fprofile-arcs, such 
as calling C++ object constructors and the like.

In userland, constructor functions are called by one of the gcc 
libraries just before the main() function. For the kernel, the kernel 
constructor patch mimics a similar behavior:
* for code which was compiled in, constructor functions are called
   in do_basic_setup(), just before processing initcalls
* for modules, init_module() calls them before mod->init().
The context is in both cases that of the calling functions.

Note that any function can be made a constructor function by tagging it 
with __attribute__((constructor)), though I'm not sure if that has any 
feasible use.

>> +void __gcov_init(struct gcov_info *info)
>> +{
>> +	static unsigned int gcov_version;
>> +
>> +	mutex_lock(&gcov_lock);
>> +	if (gcov_version == 0) {
>> +		gcov_version = info->version;
>> +		/*
>> +		 * Printing gcc's version magic may prove useful for debugging
>> +		 * incompatibility reports.
>> +		 */
>> +		pr_info("version magic: 0x%x\n", gcov_version);
> 
> Will this be spat out as simply
> 
> version magic: 0x1234
> 
> ?  If so, that'll be rather obscure because people won't know what
> subsystem printed it.  Prefixing this (and all other printks) with
> "gcov: " would fix that.

As Michael already pointed out that's already being taken care of by the 
  #define pr_fmt.

> 
>> +	}
>> +	/*
>> +	 * Add new profiling data structure to list and inform event
>> +	 * listener.
>> +	 */
>> +	info->next = gcov_info_head;
>> +	gcov_info_head = info;
>> +	if (gcov_events_enabled)
>> +		gcov_event(GCOV_ADD, info);
>> +	mutex_unlock(&gcov_lock);
>> +}
>> +EXPORT_SYMBOL(__gcov_init);
>> +
>>
>> ...
>>
>> +#ifdef CONFIG_MODULES
>> +static inline int within(void *addr, void *start, unsigned long size)
>> +{
>> +	return ((addr >= start) && (addr < start + size));
>> +}
> 
> That's our fourth implementation of within() (at least).  All basically
> identical.  Whine.

I know, I know.. and I will try to come up with another patch that 
consolidates all those within() implementations - but seeing that this 
might take more discussions to get right, I'd rather only start with 
that after making sure that the gcov code is finalized.

> 
>> ...
>>
>> +static int __init gcov_persist_setup(char *str)
>> +{
>> +	int val;
>> +	char delim;
>> +
>> +	if (sscanf(str, "%d %c", &val, &delim) != 1) {
>> +		pr_warning("invalid gcov_persist parameter '%s'\n", str);
>> +		return 0;
>> +	}
>> +	pr_info("setting gcov_persist to %d\n", val);
>> +	gcov_persist = val;
>> +
>> +	return 1;
>> +}
>> +__setup("gcov_persist=", gcov_persist_setup);
> 
> hm, what's the input format here?  It looks like
> 
> 	gcov_persist=1 x
> 
> and " x" is checked for, but ignored.
> 
> Confused.  What's this all for?  Can't we just us plain old strtoul(), etc?

Right - the sscanf would make sense if kernel parameters could contain 
spaces (in that case it catches <number><blanks><garbage> input) which 
it can't so strtoul() would indeed make more sense. I'll prepare an 
updated patch and send it out later today.

>> +/*
>> + * seq_file.start() implementation for gcov data files. Note that the
>> + * gcov_iterator interface is designed to be more restrictive than seq_file
>> + * (no start from arbitrary position, etc.), to simplify the iterator
>> + * implementation.
>> + */
>> +static void *gcov_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +	loff_t i;
>> +
>> +	gcov_iter_start(seq->private);
>> +	for (i = 0; i < *pos; i++) {
>> +		if (gcov_iter_next(seq->private))
>> +			return NULL;
>> +	}
>> +	return seq->private;
>> +}
> 
> This looks like it could be very expensive if used inappropriately.  I
> guess the answer to that is "don't use it inapprpriately", yes?

Yes :) The expensiveness is more than made up for by the reduced code 
complexity of the iterator interface. Also the extra effort is only 
spent when actually reading coverage files, i.e. not while performing a 
test.

>> ...
>>
>> +struct gcov_info *gcov_info_dup(struct gcov_info *info)
>> +{
>> +	struct gcov_info *dup;
>> +	unsigned int i;
>> +	unsigned int active;
>> +
>> +	/* Duplicate gcov_info. */
>> +	active = num_counter_active(info);
>> +	dup = kzalloc(sizeof(struct gcov_info) +
>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
> 
> How large can this allocation be?

Hm, good question. Having a look at my test system, I see coverage data 
files of up to 60kb size. With counters making up the largest part of 
those, I'd guess the allocation size can be around ~55kb. I assume that 
makes it a candidate for vmalloc?

>> +	if (!dup)
>> +		return NULL;
>> +	dup->version		= info->version;
>> +	dup->stamp		= info->stamp;
>> +	dup->n_functions	= info->n_functions;
>> +	dup->ctr_mask		= info->ctr_mask;
>> +	/* Duplicate filename. */
>> +	dup->filename		= kstrdup(info->filename, GFP_KERNEL);
>> +	if (!dup->filename)
>> +		goto err_free;
>> +	/* Duplicate table of functions. */
>> +	dup->functions = kmemdup(info->functions, info->n_functions *
>> +				 get_fn_size(info), GFP_KERNEL);
>> +	if (!dup->functions)
>> +		goto err_free;
>> +	/* Duplicate counter arrays. */
>> +	for (i = 0; i < active ; i++) {
>> +		struct gcov_ctr_info *ctr = &info->counts[i];
>> +		size_t size = ctr->num * sizeof(gcov_type);
>> +
>> +		dup->counts[i].num = ctr->num;
>> +		dup->counts[i].merge = ctr->merge;
>> +		dup->counts[i].values = kmemdup(ctr->values, size, GFP_KERNEL);
>> +		if (!dup->counts[i].values)
>> +			goto err_free;
>> +	}
>> +	return dup;
>> +
>> +err_free:
>> +	gcov_info_free(dup);
>> +	return NULL;
>> +}
>> +
> 
> It all looks very nice to me.

Thanks :)

