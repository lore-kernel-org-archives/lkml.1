Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYEJTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYEJTVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYEJTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:21:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYEJTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:21:13 -0400
Date: Sat, 10 May 2008 20:21:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 3/9] fs/compat.c: fix resource leaks and wrong goto's
Message-ID: <20080510192111.GC13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548033990-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12102548033990-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:28PM +0800, WANG Cong wrote:
> Use free_arg_pages() to free the pages allocated by copy_strings_kernel()
> on failure. And fix some related wrong goto pathes.

Kinda; free_arg_pages() is needed here, but there's no need to mess with
goto - just put it under out:

Note that it's essentially just a part of freeing bprm; it's _not_ a "clean
collected strings, so that we could add new ones".

> @@ -1403,6 +1403,7 @@ int compat_do_execve(char * filename,
>  	retval = search_binary_handler(bprm, regs);
>  	if (retval >= 0) {
>  		/* execve success */
> +		free_arg_pages(bprm);
>  		security_bprm_free(bprm);
>  		acct_update_integrals(current);
>  		kfree(bprm);
> @@ -1410,6 +1411,9 @@ int compat_do_execve(char * filename,
>  	}
>  
>  out:
> +	free_arg_pages(bprm);
> +
> +out_sec:
>  	if (bprm->security)
>  		security_bprm_free(bprm);
>  
