Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZILACL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZILACL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 20:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbZILACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 20:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbZILACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 20:02:09 -0400
Date: Fri, 11 Sep 2009 17:00:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: mtosatti@redhat.com, gregkh@suse.de, broonie@opensource.wolfsonmicro.com,
       johannes@sipsolutions.net, avi@qumranet.com, fengguang.wu@intel.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] devmem: remove redundant test on len
Message-Id: <20090911170047.94de0896.akpm@linux-foundation.org>
In-Reply-To: <20090911023200.518171489@intel.com>
References: <20090911022333.324128054@intel.com>
	<20090911023200.518171489@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 10:23:34 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The len test in write_kmem() is always true, so can be reduced.
> 
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Avi Kivity <avi@qumranet.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> --- linux.orig/drivers/char/mem.c
> +++ linux/drivers/char/mem.c
> @@ -580,18 +580,16 @@ static ssize_t write_kmem(struct file * 
>  		while (count > 0) {
>  			int len = count;
>  
>  			if (len > PAGE_SIZE)
>  				len = PAGE_SIZE;
> -			if (len) {
> -				written = copy_from_user(kbuf, buf, len);
> -				if (written) {
> -					if (wrote + virtr)
> -						break;
> -					free_page((unsigned long)kbuf);
> -					return -EFAULT;
> -				}
> +			written = copy_from_user(kbuf, buf, len);
> +			if (written) {
> +				if (wrote + virtr)
> +					break;
> +				free_page((unsigned long)kbuf);
> +				return -EFAULT;
>  			}
>  			len = vwrite(kbuf, (char *)p, len);
>  			count -= len;
>  			buf += len;
>  			virtr += len;

humpf.  But take a closer look at what remains.


Local var `written' is unneeded here.


Which makes us look at what `written' _does_ do:

		if (written != wrote)
			return written;
		wrote = written;

lolwhowrotethat?

local var `written' can at least be made local to the first loop.

write_kmem() has a lot of typecasts which indicates that the choices of
types were inappropriate.


