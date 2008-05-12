Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYELDsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYELDsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYELDsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:48:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64575 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYELDsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GOkFFRJdFUXmCeGGiqbfOUq0EIdgUkxOninWEEiyN+Z/HTF8sSC+AKskL75CC6ZZIbAXUUr5iaLAbe2qvJsS7CfHPqXs1IcKPr26sQ+I3WejU6Vo+NQO9VboST+TKp1WcHNF2ol8bbw9NLA3ed7Sx53Ihe4pUupI3vCupL5i3h0=
Date: Mon, 12 May 2008 11:46:09 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 3/9] fs/compat.c: fix resource leaks and wrong goto's
Message-ID: <20080512034609.GB2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548033990-git-send-email-xiyou.wangcong@gmail.com> <20080510192111.GC13907@ZenIV.linux.org.uk> <20080510203543.GJ13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510203543.GJ13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 09:35:43PM +0100, Al Viro wrote:
>On Sat, May 10, 2008 at 08:21:11PM +0100, Al Viro wrote:
>> On Thu, May 08, 2008 at 09:52:28PM +0800, WANG Cong wrote:
>> > Use free_arg_pages() to free the pages allocated by copy_strings_kernel()
>> > on failure. And fix some related wrong goto pathes.
>> 
>> Kinda; free_arg_pages() is needed here, but there's no need to mess with
>> goto - just put it under out:
>> 
>> Note that it's essentially just a part of freeing bprm; it's _not_ a "clean
>> collected strings, so that we could add new ones".
>
>FWIW, I'd suggest this:


Hmm, looks fine. But, see below.

>
>diff --git a/fs/compat.c b/fs/compat.c
>index 332a869..ed43e17 100644
>--- a/fs/compat.c
>+++ b/fs/compat.c
>@@ -1405,7 +1405,7 @@ int compat_do_execve(char * filename,
> 		/* execve success */
> 		security_bprm_free(bprm);
> 		acct_update_integrals(current);
>-		kfree(bprm);
>+		free_bprm(bprm);
> 		return retval;
> 	}
> 
>@@ -1424,7 +1424,7 @@ out_file:
> 	}
> 
> out_kfree:
>-	kfree(bprm);
>+	free_bprm(bprm);
> 
> out_ret:
> 	return retval;
>diff --git a/fs/exec.c b/fs/exec.c
>index aeaa979..ad545b0 100644
>--- a/fs/exec.c
>+++ b/fs/exec.c
>@@ -1251,6 +1251,12 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
> 
> EXPORT_SYMBOL(search_binary_handler);
> 
>+void free_bprm(struct linux_binprm *bprm)
>+{
>+	free_arg_pages(bprm);
>+	kfree(bprm);
>+}
>+
> /*
>  * sys_execve() executes a new program.
>  */
>@@ -1320,17 +1326,15 @@ int do_execve(char * filename,
> 	retval = search_binary_handler(bprm,regs);
> 	if (retval >= 0) {
> 		/* execve success */
>-		free_arg_pages(bprm);
> 		security_bprm_free(bprm);
> 		acct_update_integrals(current);
>-		kfree(bprm);
>+		free_bprm(bprm);
> 		if (displaced)
> 			put_files_struct(displaced);
> 		return retval;
> 	}
> 
> out:
>-	free_arg_pages(bprm);


Why just drop this? No need to call free_bprm()?


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
