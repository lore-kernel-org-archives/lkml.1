Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbXA2LeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbXA2LeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXA2LeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:34:21 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:22046 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbXA2LeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:34:20 -0500
Date: Mon, 29 Jan 2007 12:33:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dmonakhov@openvz.org, Andrew Morton <akpm@osdl.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: + mm-search_binary_handler-mem-limit-fix.patch added to -mm tree
Message-ID: <20070129113328.GA9941@osiris.boeblingen.de.ibm.com>
References: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 01:09:18AM -0800, akpm@osdl.org wrote:
> 
> The patch titled
>      mm: search_binary_handler() mem limit fix
> has been added to the -mm tree.  Its filename is
>      mm-search_binary_handler-mem-limit-fix.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: mm: search_binary_handler() mem limit fix
> From: Dmitriy Monakhov <dmonakhov@openvz.org>
> 
> The function changes mem limit to USER_DS before possible modprobe, but
> never restored it again.
> 
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Andrew Morton <akpm@osdl.org>

This patch breaks s390. I haven't yet tried to figure out why, but does this
patch actually fix a real bug?
What happens is that the init process gets killed -> panic.

>  fs/exec.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff -puN fs/exec.c~mm-search_binary_handler-mem-limit-fix fs/exec.c
> --- a/fs/exec.c~mm-search_binary_handler-mem-limit-fix
> +++ a/fs/exec.c
> @@ -1018,6 +1018,7 @@ int search_binary_handler(struct linux_b
>  {
>  	int try,retval;
>  	struct linux_binfmt *fmt;
> +	mm_segment_t oldfs;
>  #ifdef __alpha__
>  	/* handle /sbin/loader.. */
>  	{
> @@ -1059,11 +1060,12 @@ int search_binary_handler(struct linux_b
> 
>  	/* kernel module loader fixup */
>  	/* so we don't try to load run modprobe in kernel space. */
> +	oldfs = get_fs();
>  	set_fs(USER_DS);
> 
>  	retval = audit_bprm(bprm);
>  	if (retval)
> -		return retval;
> +		goto out;
> 
>  	retval = -ENOENT;
>  	for (try=0; try<2; try++) {
> @@ -1084,7 +1086,7 @@ int search_binary_handler(struct linux_b
>  				bprm->file = NULL;
>  				current->did_exec = 1;
>  				proc_exec_connector(current);
> -				return retval;
> +				goto out;
>  			}
>  			read_lock(&binfmt_lock);
>  			put_binfmt(fmt);
> @@ -1092,7 +1094,7 @@ int search_binary_handler(struct linux_b
>  				break;
>  			if (!bprm->file) {
>  				read_unlock(&binfmt_lock);
> -				return retval;
> +				goto out;
>  			}
>  		}
>  		read_unlock(&binfmt_lock);
> @@ -1110,6 +1112,8 @@ int search_binary_handler(struct linux_b
>  #endif
>  		}
>  	}
> +out:
> +	set_fs(oldfs);
>  	return retval;
>  }
