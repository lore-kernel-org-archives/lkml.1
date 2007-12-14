Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbXLNTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbXLNTNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXLNTND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:13:03 -0500
Received: from waste.org ([66.93.16.53]:60772 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbXLNTNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:13:01 -0500
Date: Fri, 14 Dec 2007 13:12:15 -0600
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk_ratelimit functions should use CONFIG_PRINTK
Message-ID: <20071214191215.GI19691@waste.org>
References: <1197658835.4861.45.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197658835.4861.45.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 11:00:35AM -0800, Joe Perches wrote:
> Makes an embedded image a bit smaller

Looks good to me. This should probably go to Andrew first though. And
it wouldn't hurt to see some size(1) results.

Acked-by: Matt Mackall <mpm@selenic.com>

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/kernel.h |   20 +++++++++++++++-----
>  kernel/printk.c        |    2 ++
>  kernel/sysctl.c        |   20 ++++++++++----------
>  3 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 94bc996..db2d5e7 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -182,6 +182,13 @@ asmlinkage int printk(const char * fmt, ...)
>  extern int log_buf_get_len(void);
>  extern int log_buf_read(int idx);
>  extern int log_buf_copy(char *dest, int idx, int len);
> +
> +extern int printk_ratelimit_jiffies;
> +extern int printk_ratelimit_burst;
> +extern int printk_ratelimit(void);
> +extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
> +extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
> +				   unsigned int interval_msec);
>  #else
>  static inline int vprintk(const char *s, va_list args)
>  	__attribute__ ((format (printf, 1, 0)));
> @@ -192,15 +199,18 @@ static inline int __cold printk(const char *s, ...) { return 0; }
>  static inline int log_buf_get_len(void) { return 0; }
>  static inline int log_buf_read(int idx) { return 0; }
>  static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
> +
> +static inline int printk_ratelimit(void) { return 0; }
> +static inline int __printk_ratelimit(int ratelimit_jiffies, \
> +				     int ratelimit_burst) { return 0; }
> +static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
> +					  unsigned int interval_msec)	\
> +		{ return false; }
> +
>  #endif
>  
>  unsigned long int_sqrt(unsigned long);
>  
> -extern int printk_ratelimit(void);
> -extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
> -extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
> -				unsigned int interval_msec);
> -
>  static inline void console_silent(void)
>  {
>  	console_loglevel = 0;
> diff --git a/kernel/printk.c b/kernel/printk.c
> index a30fe33..2259540 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1235,6 +1235,7 @@ void tty_write_message(struct tty_struct *tty, char *msg)
>  	return;
>  }
>  
> +#if defined CONFIG_PRINTK
>  /*
>   * printk rate limiting, lifted from the networking subsystem.
>   *
> @@ -1304,3 +1305,4 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  	return false;
>  }
>  EXPORT_SYMBOL(printk_timed_ratelimit);
> +#endif
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 8ac5171..f60b9e4 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -72,8 +72,6 @@ extern int suid_dumpable;
>  extern char core_pattern[];
>  extern int pid_max;
>  extern int min_free_kbytes;
> -extern int printk_ratelimit_jiffies;
> -extern int printk_ratelimit_burst;
>  extern int pid_max_min, pid_max_max;
>  extern int sysctl_drop_caches;
>  extern int percpu_pagelist_fraction;
> @@ -462,14 +460,6 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> -	{
> -		.ctl_name	= KERN_PRINTK,
> -		.procname	= "printk",
> -		.data		= &console_loglevel,
> -		.maxlen		= 4*sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= &proc_dointvec,
> -	},
>  #ifdef CONFIG_KMOD
>  	{
>  		.ctl_name	= KERN_MODPROBE,
> @@ -616,6 +606,15 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +#if defined CONFIG_PRINTK
> +	{
> +		.ctl_name	= KERN_PRINTK,
> +		.procname	= "printk",
> +		.data		= &console_loglevel,
> +		.maxlen		= 4*sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
>  	{
>  		.ctl_name	= KERN_PRINTK_RATELIMIT,
>  		.procname	= "printk_ratelimit",
> @@ -633,6 +632,7 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +#endif
>  	{
>  		.ctl_name	= KERN_NGROUPS_MAX,
>  		.procname	= "ngroups_max",
> 

-- 
Mathematics is the supreme nostalgia of our time.
