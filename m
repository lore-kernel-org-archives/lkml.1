Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0CILZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:25:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:56318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0CILZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:25:53 -0500
Subject: Re: [PATCH] percpu,lockdep: implement and use
 is_static_percpu_address()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4B9610E5.4080805@kernel.org>
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>
	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>
	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Mar 2010 12:25:42 +0100
Message-ID: <1268133942.4162.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 18:12 +0900, Tejun Heo wrote:
> lockdep has custom code to check whether a pointer belongs to static
> percpu area which is somewhat broken.  Implement proper
> is_static_percpu_address() in percpu and replace the custom code.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
> This wasn't the cause this time but I'll queue the fix in percpu tree
> anyway.
> 
> Thanks.
> 
>  include/linux/percpu.h |    7 +++++++
>  kernel/lockdep.c       |   15 ++-------------
>  mm/percpu.c            |   26 ++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index a93e5bf..1eca064 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -137,6 +137,7 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
>  extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
>  extern void __percpu *__alloc_percpu(size_t size, size_t align);
>  extern void free_percpu(void __percpu *__pdata);
> +extern bool is_static_percpu_address(unsigned long addr);
>  extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
>  
>  #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
> @@ -163,6 +164,12 @@ static inline void free_percpu(void __percpu *p)
>  	kfree(p);
>  }
>  
> +/* can't distinguish from other static vars, always false */
> +static inline bool is_static_percpu_address(unsigned long addr)
> +{
> +	return false;
> +}

At this point it might make sense to simply fail to compile if lockdep
is enabled as well.

I'm not sure if there's many SMP archs that don't have this and do have
lockdep, but simply failing this test isn't really an option.

>  static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  {
>  	return __pa(addr);
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c

> diff --git a/mm/percpu.c b/mm/percpu.c
> index 768419d..ae4d058 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1304,6 +1304,32 @@ void free_percpu(void __percpu *ptr)
>  EXPORT_SYMBOL_GPL(free_percpu);
>  
>  /**
> + * is_static_percpu_address - test whether address is from static percpu area
> + * @addr: address to test
> + *
> + * Test whether @addr belongs to static percpu area.  Module static
> + * percpu areas allocated via __alloc_reserved_percpu() is not
> + * considered.  Use is_module_address() for those.
> + *
> + * RETURNS:
> + * %true if @addr is from static percpu area, %false otherwise.
> + */

So is_module_address() will only return true for static per-cpu module
storage, right?
