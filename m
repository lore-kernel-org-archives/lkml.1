Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZILAFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZILAFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 20:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZILAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 20:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZILAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 20:05:52 -0400
Date: Fri, 11 Sep 2009 17:05:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: mtosatti@redhat.com, gregkh@suse.de, broonie@opensource.wolfsonmicro.com,
       johannes@sipsolutions.net, avi@qumranet.com, fengguang.wu@intel.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] devmem: cleanup unxlate_dev_mem_ptr() calls
Message-Id: <20090911170500.8db04cb7.akpm@linux-foundation.org>
In-Reply-To: <20090911023200.767391440@intel.com>
References: <20090911022333.324128054@intel.com>
	<20090911023200.767391440@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 10:23:36 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> No behavior change.
> 
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Avi Kivity <avi@qumranet.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> --- linux-mm.orig/drivers/char/mem.c	2009-09-10 21:59:39.000000000 +0800
> +++ linux-mm/drivers/char/mem.c	2009-09-10 22:00:12.000000000 +0800
> @@ -131,6 +131,7 @@ static ssize_t read_mem(struct file * fi
>  			size_t count, loff_t *ppos)
>  {
>  	unsigned long p = *ppos;
> +	unsigned long ret;
>  	ssize_t read, sz;
>  	char *ptr;
>  
> @@ -169,12 +170,10 @@ static ssize_t read_mem(struct file * fi
>  		if (!ptr)
>  			return -EFAULT;
>  
> -		if (copy_to_user(buf, ptr, sz)) {
> -			unxlate_dev_mem_ptr(p, ptr);
> -			return -EFAULT;
> -		}
> -
> +		ret = copy_to_user(buf, ptr, sz);
>  		unxlate_dev_mem_ptr(p, ptr);
> +		if (ret)
> +			return -EFAULT;
>  
>  		buf += sz;
>  		p += sz;

- local var `ret' didn't need function-wide scope.  I think it's
  better to reduce its scope if poss.

- conventionally the identifier `ret' refers to "the value which this
  function will return".  Ditto `retval' and `rc'.

  But that's not what `ret' does here so let's call it something
  else?  `remaining' is rather verbose and formal, but accurate.


--- a/drivers/char/mem.c~dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix
+++ a/drivers/char/mem.c
@@ -131,7 +131,6 @@ static ssize_t read_mem(struct file * fi
 			size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	unsigned long ret;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -156,6 +155,8 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
+		unsigned long remaining;
+
 		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
@@ -170,9 +171,9 @@ static ssize_t read_mem(struct file * fi
 		if (!ptr)
 			return -EFAULT;
 
-		ret = copy_to_user(buf, ptr, sz);
+		remaining = copy_to_user(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
-		if (ret)
+		if (remaining)
 			return -EFAULT;
 
 		buf += sz;
_

