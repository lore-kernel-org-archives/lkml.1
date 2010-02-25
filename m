Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0BYFuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 00:50:22 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51259 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0BYFuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 00:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=EIwW7SqUT9JgSP6K/7j4473SfM0V8CxZBIjgfZuwk29i2vdjZrUl4NO4KUkMy2xFMk
         wA5ol0DUfoFHiLGlaCWNH7Ow1h2P2Q44zXbMbKMUMMpjo3zXf17FjIdR15ajTBzGf/Ko
         Hs1TqIQpBG2mVFw8O2zKn4UwruT5UrdwbF8i8=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: Re: [PATCH] failslab: add ability to filter slab caches
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org>
	<alpine.DEB.2.00.1002231432530.8693@chino.kir.corp.google.com>
	<87bpfe8ooj.fsf_-_@openvz.org>
	<alpine.DEB.2.00.1002241312250.6379@chino.kir.corp.google.com>
Date: Thu, 25 Feb 2010 08:50:15 +0300
In-Reply-To: <alpine.DEB.2.00.1002241312250.6379@chino.kir.corp.google.com>
	(David Rientjes's message of "Wed, 24 Feb 2010 13:21:00 -0800 (PST)")
Message-ID: <87r5o9yico.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> On Wed, 24 Feb 2010, Dmitry Monakhov wrote:
>
>> >> Example:
>> >> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
>> >> echo 1 > /sys/kernel/debug/failslab/cache-filter
>> >> 
>> >
>> > Where's the changelog?
>> I've hoped than subject is enough. But if you want more verbose
>> changelog, take following version.
>> 
Ohh... i'm sorry i've missed other comments in your previous review.
It will be fixed in second version. Also see major note about
slab flags later in the text.
>
> Please do not attach patches to emails when sending to LKML, they are 
> preferred to be inline.  See Documentation/SubmittingPatches.
Yeah, In fact i've chose inline option but my mailer by unknown reason
change it.
>
>> This patch allow to inject faults only for specific slabs.
>> In order to preserve default behavior cache filter is off by
>> default (all caches are faulty).
>> 
>> One may define specific set of slabs like this:
>> # mark skbuff_head_cache as faulty
>> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
>> # Turn on cache filter (off by default)
>> echo 1 > /sys/kernel/debug/failslab/cache-filter
>> # Turn on fault injection
>> echo 1 > /sys/kernel/debug/failslab/times
>> echo 1 > /sys/kernel/debug/failslab/probability
>> 
>
> Please describe your new slub_debug=a option here as well as in an update 
> to Documentation/vm/slub.txt.
Done
>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  include/linux/fault-inject.h |    4 ++--
>>  include/linux/slab.h         |    4 +++-
>>  mm/failslab.c                |   18 +++++++++++++++---
>>  mm/slab.c                    |    2 +-
>>  mm/slub.c                    |   31 +++++++++++++++++++++++++++++--
>>  5 files changed, 50 insertions(+), 9 deletions(-)
>> 
>> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
>> index 06ca9b2..d935647 100644
>> --- a/include/linux/fault-inject.h
>> +++ b/include/linux/fault-inject.h
>> @@ -82,9 +82,9 @@ static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
>>  #endif /* CONFIG_FAULT_INJECTION */
>>  
>>  #ifdef CONFIG_FAILSLAB
>> -extern bool should_failslab(size_t size, gfp_t gfpflags);
>> +extern bool should_failslab(size_t size, gfp_t gfpflags, unsigned long c_flags);
>>  #else
>> -static inline bool should_failslab(size_t size, gfp_t gfpflags)
>> +static inline bool should_failslab(size_t size, gfp_t gfpflags, unsigned long f)
>>  {
>>  	return false;
>>  }
>
> As I said in the first review, these need to be more descriptive: 'flags' 
> would be better.
done
>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 2da8372..9e03a81 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -70,7 +70,9 @@
>>  #else
>>  # define SLAB_NOTRACK		0x00000000UL
>>  #endif
>> -
>> +#ifdef CONFIG_FAILSLAB
>> +# define SLAB_FAILSLAB	0x02000000UL	/* Fault injection filter mark */
>> +#endif 
>
> Trailing whitespace on your #endif.
Sorry. fixed
>
>>  /* The following flags affect the page allocator grouping pages by mobility */
>>  #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
>>  #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
>> diff --git a/mm/failslab.c b/mm/failslab.c
>> index 9339de5..bb41f98 100644
>> --- a/mm/failslab.c
>> +++ b/mm/failslab.c
>> @@ -1,18 +1,22 @@
>>  #include <linux/fault-inject.h>
>>  #include <linux/gfp.h>
>> +#include <linux/slab.h>
>>  
>>  static struct {
>>  	struct fault_attr attr;
>>  	u32 ignore_gfp_wait;
>> +	int cache_filter;
>>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
>>  	struct dentry *ignore_gfp_wait_file;
>> +	struct dentry *cache_filter_file;
>>  #endif
>>  } failslab = {
>>  	.attr = FAULT_ATTR_INITIALIZER,
>>  	.ignore_gfp_wait = 1,
>> +	.cache_filter = 0,
>>  };
>>  
>> -bool should_failslab(size_t size, gfp_t gfpflags)
>> +bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
>>  {
>>  	if (gfpflags & __GFP_NOFAIL)
>>  		return false;
>> @@ -20,6 +24,9 @@ bool should_failslab(size_t size, gfp_t gfpflags)
>>          if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
>>  		return false;
>>  
>> +	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
>> +		return false;
>> +
>>  	return should_fail(&failslab.attr, size);
>>  }
>>  
>> @@ -30,7 +37,6 @@ static int __init setup_failslab(char *str)
>>  __setup("failslab=", setup_failslab);
>>  
>>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
>> -
>>  static int __init failslab_debugfs_init(void)
>>  {
>>  	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
>> @@ -46,8 +52,14 @@ static int __init failslab_debugfs_init(void)
>>  		debugfs_create_bool("ignore-gfp-wait", mode, dir,
>>  				      &failslab.ignore_gfp_wait);
>>  
>> -	if (!failslab.ignore_gfp_wait_file) {
>> +	failslab.cache_filter_file =
>> +		debugfs_create_bool("cache-filter", mode, dir,
>> +				      &failslab.cache_filter);
>> +
>> +	if (!failslab.ignore_gfp_wait_file ||
>> +	    !failslab.cache_filter_file) {
>>  		err = -ENOMEM;
>> +		debugfs_remove(failslab.cache_filter_file);
>>  		debugfs_remove(failslab.ignore_gfp_wait_file);
>>  		cleanup_fault_attr_dentries(&failslab.attr);
>>  	}
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 7451bda..33496b7 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3101,7 +3101,7 @@ static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
>>  	if (cachep == &cache_cache)
>>  		return false;
>>  
>> -	return should_failslab(obj_size(cachep), flags);
>> +	return should_failslab(obj_size(cachep), flags, cachep->flags);
>>  }
>>  
>
> cachep->flags for CONFIG_SLAB is of type unsigned int and 
> should_failslab() takes an unsigned long.
Strange story, seems that flag definition in slab_def.h is differ
from slub_def.h and slob_def.h (unsigned long long)
Need to be fixed. Will send as separate patch.
>
>>  static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 8d71aaf..64114fa 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -151,7 +151,8 @@
>>   * Set of flags that will prevent slab merging
>>   */
>>  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
>> -		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
>> +		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
>> +		SLAB_FAILSLAB)
>>  
>>  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
>>  		SLAB_CACHE_DMA | SLAB_NOTRACK)
>
> As I mentioned in my first review of your patch, this breaks for 
> CONFIG_FAILSLAB=n.  Please make sure your patch compiles for the 
> defconfig.
fixed.
