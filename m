Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbXHJHXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbXHJHXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXHJHWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:22:55 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36675 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXHJHWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:22:54 -0400
Date: Fri, 10 Aug 2007 11:22:48 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + sysctl-factor-out-sysctl_data.patch added to -mm tree
Message-ID: <20070810072247.GB6639@localhost.sw.ru>
References: <200708092211.l79MBmr8022134@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708092211.l79MBmr8022134@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:11:48PM -0700, akpm@linux-foundation.org wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> There as been no easy way to wrap the default sysctl strategy routine except
> for returning 0.  Which is not always what we want.  The few instances I have
> seen that want different behaviour have written their own version of
> sysctl_data.  While not too hard it is unnecessary code and has the potential
> for extra bugs.
> 
> So to make these situations easier and make that part of sysctl more symetric
> I have factord sysctl_data out of do_sysctl_strategy and exported as a
> function everyone can use.
> 
> Further having sysctl_data be an explicit function makes checking for badly
> formed sysctl tables much easier.

OK with idea, though naming sucks. generic_sysctl_strategy is much better.

> --- a/include/linux/sysctl.h~sysctl-factor-out-sysctl_data
> +++ a/include/linux/sysctl.h
> @@ -972,6 +972,7 @@ extern int do_sysctl_strategy (struct ct
>  			       void __user *oldval, size_t __user *oldlenp,
>  			       void __user *newval, size_t newlen);
>  
> +extern ctl_handler sysctl_data;
>  extern ctl_handler sysctl_string;
>  extern ctl_handler sysctl_intvec;
>  extern ctl_handler sysctl_jiffies;
> diff -puN kernel/sysctl.c~sysctl-factor-out-sysctl_data kernel/sysctl.c
> --- a/kernel/sysctl.c~sysctl-factor-out-sysctl_data
> +++ a/kernel/sysctl.c
> @@ -1457,7 +1457,6 @@ int do_sysctl_strategy (struct ctl_table
>  			void __user *newval, size_t newlen)
>  {
>  	int op = 0, rc;
> -	size_t len;
>  
>  	if (oldval)
>  		op |= 004;
> @@ -1478,25 +1477,10 @@ int do_sysctl_strategy (struct ctl_table
>  	/* If there is no strategy routine, or if the strategy returns
>  	 * zero, proceed with automatic r/w */
>  	if (table->data && table->maxlen) {
> -		if (oldval && oldlenp) {
> -			if (get_user(len, oldlenp))
> -				return -EFAULT;
> -			if (len) {
> -				if (len > table->maxlen)
> -					len = table->maxlen;
> -				if(copy_to_user(oldval, table->data, len))
> -					return -EFAULT;
> -				if(put_user(len, oldlenp))
> -					return -EFAULT;
> -			}
> -		}
> -		if (newval && newlen) {
> -			len = newlen;
> -			if (len > table->maxlen)
> -				len = table->maxlen;
> -			if(copy_from_user(table->data, newval, len))
> -				return -EFAULT;
> -		}
> +		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
> +				 newval, newlen);
> +		if (rc < 0)
> +			return rc;
>  	}
>  	return 0;
>  }
> @@ -2395,6 +2379,40 @@ int proc_doulongvec_ms_jiffies_minmax(st
>   * General sysctl support routines 
>   */
>  
> +/* The generic sysctl data routine (used if no strategy routine supplied) */
> +int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
> +		void __user *oldval, size_t __user *oldlenp,
> +		void __user *newval, size_t newlen)
> +{
> +	size_t len;
> +
> +	/* Get out of I don't have a variable */
> +	if (!table->data || !table->maxlen)
> +		return -ENOTDIR;
> +
> +	if (oldval && oldlenp) {
> +		if (get_user(len, oldlenp))
> +			return -EFAULT;
> +		if (len) {
> +			if (len > table->maxlen)
> +				len = table->maxlen;
> +			if (copy_to_user(oldval, table->data, len))
> +				return -EFAULT;
> +			if (put_user(len, oldlenp))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	if (newval && newlen) {
> +		if (newlen > table->maxlen)
> +			newlen = table->maxlen;
> +
> +		if (copy_from_user(table->data, newval, newlen))
> +			return -EFAULT;
> +	}
> +	return 1;
> +}
> +
>  /* The generic string strategy routine: */
>  int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
>  		  void __user *oldval, size_t __user *oldlenp,
> @@ -2583,6 +2601,13 @@ out:
>  	return -ENOSYS;
>  }
>  
> +int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
> +		  void __user *oldval, size_t __user *oldlenp,
> +		  void __user *newval, size_t newlen)
> +{
> +	return -ENOSYS;
> +}
> +
>  int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
>  		  void __user *oldval, size_t __user *oldlenp,
>  		  void __user *newval, size_t newlen)
> @@ -2630,4 +2655,5 @@ EXPORT_SYMBOL(sysctl_intvec);
>  EXPORT_SYMBOL(sysctl_jiffies);
>  EXPORT_SYMBOL(sysctl_ms_jiffies);
>  EXPORT_SYMBOL(sysctl_string);
> +EXPORT_SYMBOL(sysctl_data);

