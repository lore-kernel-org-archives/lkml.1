Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYIHWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYIHWji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYIHWj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:39:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768AbYIHWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:39:26 -0400
Date: Mon, 8 Sep 2008 15:39:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, kirill@shutemov.name, xemul@openvz.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Allow recursion in binfmt_script and binfmt_misc
Message-Id: <20080908153921.94780d5c.akpm@linux-foundation.org>
In-Reply-To: <1220713795-5313-2-git-send-email-kirill@shutemov.name>
References: <20080902110648.GA5027@localhost.localdomain>
	<1220713795-5313-1-git-send-email-kirill@shutemov.name>
	<1220713795-5313-2-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Sep 2008 18:09:55 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> binfmt_script and binfmt_misc disallow recursion to avoid stack overflow
> using sh_bang and misc_bang. It causes problem in some cases:
> 
> $ echo '#!/bin/ls' > /tmp/t0
> $ echo '#!/tmp/t0' > /tmp/t1
> $ echo '#!/tmp/t1' > /tmp/t2
> $ chmod +x /tmp/t*
> $ /tmp/t2
> zsh: exec format error: /tmp/t2
> 
> Similar problem with binfmt_misc.
> 
> This patch introduces field 'recursion_depth' into struct linux_binprm
> to track recursion level in binfmt_misc and binfmt_script. If recursion
> level more then BINPRM_MAX_RECURSION it generates -ENOEXEC.
> 
>
> ...
>
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -34,8 +34,7 @@ struct linux_binprm{
>  #endif
>  	struct mm_struct *mm;
>  	unsigned long p; /* current top of mem */
> -	unsigned int sh_bang:1,
> -		     misc_bang:1;
> +	unsigned char recursion_depth;
>  #ifdef __alpha__
>  	unsigned int taso:1;
>  #endif

That's a strange position in which to add the new field.  It will prevent
the compiler from using the same word for sh_bang, misc_bang and taso.

I fixed that up while fixing linux-next rejects.

> @@ -61,6 +60,7 @@ struct linux_binprm{
>  #define BINPRM_FLAGS_EXECFD_BIT 1
>  #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
>  
> +#define BINPRM_MAX_RECURSION 4

Why "4"?

Why make linux_binprm.recursion_depth a u8?  There would be 
practically (or actually) zero cost to making it 32-bit.
Admittedly a depth >256 would be a bit odd, but did we gain 
anything from this restriction?
