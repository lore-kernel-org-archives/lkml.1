Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZF2WBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZF2WBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2WBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:01:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbZF2WBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:01:37 -0400
Date: Mon, 29 Jun 2009 15:01:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, amwang@redhat.com
Subject: Re: [Patch] sysctl: forbid too long numbers
Message-Id: <20090629150123.43f79091.akpm@linux-foundation.org>
In-Reply-To: <20090619072212.6519.10915.sendpatchset@localhost.localdomain>
References: <20090619072212.6519.10915.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 03:19:57 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> For some file under /proc/sys/kernel, the valid values for them
> are < ULONG_MAX if they don't have they own max value defined. Thus,
> numbers longer than are invalid.
> 
> So use strict_strtoul() instead of simple_strtoul(), and
> make strict_strtoul() more strict.
> 

The changelog is a bit puzzling.

I think that what you're saying is that we can do

	echo 9999999999999999999999999999999999999999999 > /proc/whatever

and that the kernel will take the lower 32 (or 64) bits of that number
and will accept this without error?

If so then I expect there are zillions of procfs/sysfs/debugfs/etc
files which have the same problem?


Also, fixing this is a non-backward-compatible change which could break
existing userspace.  Although the chances of this seem fairly small.

Or are they?  One could imagine a script which was tested and developed
on a 64-bit system, which writes a >4G number into a pseudo file.  That
script happens to work on 32-bit systems (it might not work _well_, but
it'll work).  With this change, the write will fail on the 32-bit
system and the entire application could bale out or something.

I'm not saying that this is a reason to avoid making the change, but
it's all a worry and needs consideration.


> ---
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ab462b9..bc27e00 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2331,7 +2331,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
>  			if (*p < '0' || *p > '9')
>  				break;
>  
> -			lval = simple_strtoul(p, &p, 0);
> +			if (strict_strtoul(p, 0, &lval))
> +				return -EINVAL;
>  
>  			len = p-buf;
>  			if ((len < left) && *p && !isspace(*p))

The other worrisome thing about this change is that there may well be
existing userspace which does

	echo 42foo > /proc/whatever

and the conversion to strict_strtoul() will cause that script to
newly fail.

And the chances that there are scripts which do this are pretty darned
good - it's fairly easy to accidentally leave junk like this in strings
when hacking stuff together in scripting languages.



> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 756ccaf..ff2ca5c 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -163,11 +163,14 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
>  	char *tail;
>  	unsigned long val;
>  	size_t len;
> +	char tmp[32];
>  
>  	*res = 0;
>  	len = strlen(cp);
>  	if (len == 0)
>  		return -EINVAL;
> +	if (len > snprintf(tmp, "%ld", ULONG_MAX))
> +		return -EINVAL;
>  
>  	val = simple_strtoul(cp, &tail, base);
>  	if (tail == cp)

And here we're doing a check for that overflow, yes?

- We don't need tmp[].  vsnprintf(NULL, ...) can be used to query the
  length of an sprintf.  See how kvasprintf() does this.

- The strict_strtoul() documentation should be updated?

- The above change affects strict_strtol() too.

- The same change should be made to strict_strtoull() and hence
  strict_strtoll()?


