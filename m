Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYIJXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYIJXFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYIJXFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:05:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756681AbYIJXFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:05:41 -0400
Date: Wed, 10 Sep 2008 15:59:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC v2][PATCH] dynamically enable readprofile at runtime
Message-Id: <20080910155956.dce60eb4.akpm@linux-foundation.org>
In-Reply-To: <20080909180536.9F0C7BAB@kernel>
References: <20080909180536.9F0C7BAB@kernel>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 11:05:36 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> 
> Way too often, I have a machine that exhibits some kind of crappy
> behavior.  The CPU looks wedged in the kernel or it is spending
> way too much system time and I wonder what is responsible.
> 
> I try to run readprofile.  But, of course, Ubuntu doesn't enable
> it by default.  Dang!
> 
> The reason we boot-time enable it is that it takes a big bufffer
> that we generally can only bootmem alloc.  But, does it hurt to
> at least try and runtime-alloc it?
> 
> To use:
> echo 2 > /sys/kernel/profile
> 
> Then run readprofile like normal.
> 
> This should fix the compile issue with allmodconfig.  I've
> compile-tested on a bunch more configs now including a few
> more architectures.
> 

Can it be turned off again?  afaict: no?

> +#ifdef CONFIG_PROFILING
> +static ssize_t profiling_show(struct kobject *kobj,
> +				  struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d\n", prof_on);
> +}
> +static ssize_t profiling_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	if (prof_on)
> +		return -EEXIST;
> +	/*
> +	 * This eventually calls into get_option() which
> +	 * has a ton of callers and is not const.  It is
> +	 * easiest to cast it away here.
> +	 */
> +	profile_setup((char *)buf);
> +	ret = profile_init();
> +	if (ret)
> +		return ret;
> +	ret = create_proc_profile();
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +KERNEL_ATTR_RW(profiling);
> +#endif

Tested with CONFIG_SYSFS=n?

> -void __init profile_init(void)
> +int profile_init(void)
>  {
> +	int buffer_bytes;
>  	if (!prof_on)
> -		return;
> +		return 0;
>  
>  	/* only text is profiled */
>  	prof_len = (_etext - _stext) >> prof_shift;
> -	prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
> +	buffer_bytes = prof_len*sizeof(atomic_t);
> +	if (!slab_is_available()) {
> +		prof_buffer = alloc_bootmem(buffer_bytes);
> +		return 0;
> +	}
> +
> +	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
> +	if (prof_buffer)
> +		return 0;
> +
> +	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
> +	if (prof_buffer)
> +		return 0;
> +
> +	prof_buffer = vmalloc(buffer_bytes);
> +	if (prof_buffer)
> +		return 0;
> +
> +	return -ENOMEM;
>  }

Well that should cover it.

Did you check to see if any __GFP_NOWARNs are needed there?


alloc_bootmem() will (apparently undocumentedly and secretly) zero the
memory.

kzalloc() will zero the memory.

alloc_pages_exact(__GFP_ZERO) will zero the memory.

But what about vmalloc?  I see no documentation which says that it
zeroes the memory, although it seems that some flavours of it will do
this, but the nommu version does not.  Seems all messed up.

