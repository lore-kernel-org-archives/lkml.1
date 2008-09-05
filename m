Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYIECHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYIECHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 22:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYIECHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 22:07:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20165 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYIECHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 22:07:20 -0400
Date: Thu, 4 Sep 2008 19:03:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] dynamically enable readprofile at runtime
Message-Id: <20080904190308.6d377ac6.randy.dunlap@oracle.com>
In-Reply-To: <20080829202713.348431DC@kernel>
References: <20080829202713.348431DC@kernel>
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

On Fri, 29 Aug 2008 13:27:13 -0700 Dave Hansen wrote:

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

I like it.

> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/kernel/ksysfs.c  |   29 +++++++++++++++++++++++++++++
>  linux-2.6.git-dave/kernel/profile.c |   33 ++++++++++++++++++++++++---------
>  2 files changed, 53 insertions(+), 9 deletions(-)
> 
> diff -puN kernel/ksysfs.c~dynamic-readprofile kernel/ksysfs.c
> --- linux-2.6.git/kernel/ksysfs.c~dynamic-readprofile	2008-08-29 13:15:52.000000000 -0700
> +++ linux-2.6.git-dave/kernel/ksysfs.c	2008-08-29 13:19:03.000000000 -0700
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kexec.h>
> +#include <linux/profile.h>
>  #include <linux/sched.h>
>  
>  #define KERNEL_ATTR_RO(_name) \
> @@ -53,6 +54,31 @@ static ssize_t uevent_helper_store(struc
>  KERNEL_ATTR_RW(uevent_helper);
>  #endif
>  
> +#ifdef CONFIG_PROFILING
> +/* uevent helper program, used during early boo */

s/boo/boot/ ??

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
> +	profile_setup(buf);
> +	profile_init();
> +	if (!prof_buffer)
> +		return -ENOMEM;
> +	ret = create_proc_profile();
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +KERNEL_ATTR_RW(profiling);
> +#endif
> +
>  #ifdef CONFIG_KEXEC
>  static ssize_t kexec_loaded_show(struct kobject *kobj,
>  				 struct kobj_attribute *attr, char *buf)
> @@ -109,6 +135,9 @@ static struct attribute * kernel_attrs[]
>  	&uevent_seqnum_attr.attr,
>  	&uevent_helper_attr.attr,
>  #endif
> +#ifdef CONFIG_PROFILING
> +	&profiling_attr.attr,
> +#endif
>  #ifdef CONFIG_KEXEC
>  	&kexec_loaded_attr.attr,
>  	&kexec_crash_loaded_attr.attr,
> diff -puN kernel/profile.c~dynamic-readprofile kernel/profile.c
> --- linux-2.6.git/kernel/profile.c~dynamic-readprofile	2008-08-29 13:15:52.000000000 -0700
> +++ linux-2.6.git-dave/kernel/profile.c	2008-08-29 13:18:50.000000000 -0700
> @@ -50,11 +50,11 @@ static DEFINE_PER_CPU(int, cpu_profile_f
>  static DEFINE_MUTEX(profile_flip_mutex);
>  #endif /* CONFIG_SMP */
>  
> -static int __init profile_setup(char *str)
> +int profile_setup(char *str)
>  {
> -	static char __initdata schedstr[] = "schedule";
> -	static char __initdata sleepstr[] = "sleep";
> -	static char __initdata kvmstr[] = "kvm";
> +	static char schedstr[] = "schedule";
> +	static char sleepstr[] = "sleep";
> +	static char kvmstr[] = "kvm";
>  	int par;
>  
>  	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
> @@ -100,14 +100,29 @@ static int __init profile_setup(char *st
>  __setup("profile=", profile_setup);
>  
>  
> -void __init profile_init(void)
> +void profile_init(void)
>  {
> +	int buffer_bytes;
>  	if (!prof_on)
>  		return;
>  
>  	/* only text is profiled */
>  	prof_len = (_etext - _stext) >> prof_shift;
> -	prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));
> +	buffer_bytes = prof_len*sizeof(atomic_t);
> +	if (!slab_is_available()) {
> +		prof_buffer = alloc_bootmem(buffer_bytes);
> +		return;
> +	}
> +
> +	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
> +	if (prof_buffer)
> +		return;
> +
> +	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
> +	if (prof_buffer)
> +		return;
> +
> +	prof_buffer = vmalloc(buffer_bytes);
>  }
>  
>  /* Profile event notifications */
> @@ -527,7 +542,7 @@ static void __init profile_nop(void *unu
>  {
>  }
>  
> -static int __init create_hash_tables(void)
> +static int create_hash_tables(void)
>  {
>  	int cpu;
>  
> @@ -575,14 +590,14 @@ out_cleanup:
>  #define create_hash_tables()			({ 0; })
>  #endif
>  
> -static int __init create_proc_profile(void)
> +int create_proc_profile(void)
>  {
>  	struct proc_dir_entry *entry;
>  
>  	if (!prof_on)
>  		return 0;
>  	if (create_hash_tables())
> -		return -1;
> +		return -ENOMEM;
>  	entry = proc_create("profile", S_IWUSR | S_IRUGO,
>  			    NULL, &proc_profile_operations);
>  	if (!entry)

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
