Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbZATORu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbZATORu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbZATOQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:16:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762323AbZATOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:16:35 -0500
Date: Tue, 20 Jan 2009 09:15:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, hbabu@us.ibm.com, kexec@lists.infradead.org,
       horms@verge.net.au, akpm@linux-foundation.org
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090120141551.GA5125@redhat.com>
References: <20090119212127.GA13157@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119212127.GA13157@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 04:21:27PM -0500, Neil Horman wrote:
> Hey all-
> 	It would be nice to be able to extract the dmesg log from a vmcore file
> without needing to keep the debug symbols for the running kernel handy all the
> time.  We have a facility to do this in /proc/vmcore.  This patch adds the
> log_buf and log_end symbols to the vmcoreinfo area so that tools (like
> makedumpfile) can easily extract the dmesg logs from a vmcore image.
> 

It would be nice to get dmesg log if debug symbols are not around. Can't
we use System.map for getting symbol addresses? vmcoreinfo had started
small and seems to be growing now. I am thinking down the line will making
use of System.map for such cases make sense?

> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  include/linux/kernel.h |    2 ++
>  kernel/kexec.c         |    3 +++
>  kernel/printk.c        |    8 ++++++++
>  3 files changed, 13 insertions(+)
> 
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 343df9e..a7f3e8a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -242,6 +242,7 @@ extern struct ratelimit_state printk_ratelimit_state;
>  extern int printk_ratelimit(void);
>  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  				   unsigned int interval_msec);
> +void log_buf_kexec_setup(void);
>  #else
>  static inline int vprintk(const char *s, va_list args)
>  	__attribute__ ((format (printf, 1, 0)));
> @@ -253,6 +254,7 @@ static inline int printk_ratelimit(void) { return 0; }
>  static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
>  					  unsigned int interval_msec)	\
>  		{ return false; }
> +#define log_buf_kexec_setup() do {} while(0)
>  #endif
>  
>  extern int printk_needs_cpu(int cpu);
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 8a6d7b0..bee284d 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1409,6 +1409,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_OFFSET(list_head, prev);
>  	VMCOREINFO_OFFSET(vm_struct, addr);
>  	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
> +#ifdef CONFIG_PRINTK
> +	log_buf_kexec_setup();
> +#endif
>  	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
>  	VMCOREINFO_NUMBER(NR_FREE_PAGES);
>  	VMCOREINFO_NUMBER(PG_lru);
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 69188f2..79e9e05 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -32,6 +32,7 @@
>  #include <linux/security.h>
>  #include <linux/bootmem.h>
>  #include <linux/syscalls.h>
> +#include <linux/kexec.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -136,6 +137,13 @@ static char *log_buf = __log_buf;
>  static int log_buf_len = __LOG_BUF_LEN;
>  static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
>  
> +void log_buf_kexec_setup(void)
> +{
> +	VMCOREINFO_SYMBOL(log_buf);
> +	VMCOREINFO_SYMBOL(log_end);
> +}
> +

Will it be an issue if we make log_buf and log_end non static and directly
access these in kexec.c?

Thanks
Vivek
