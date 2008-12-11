Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYLKFmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYLKFmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYLKFlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:41:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbYLKFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:41:51 -0500
Date: Wed, 10 Dec 2008 21:41:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Nguyen Anh Quynh <aquynh@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-Id: <20081210214142.9e7b2298.akpm@linux-foundation.org>
In-Reply-To: <adatz9b2thy.fsf@cisco.com>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	<20081211040118.GK28946@ZenIV.linux.org.uk>
	<20081210201455.0c611484.akpm@linux-foundation.org>
	<20081211044901.GL28946@ZenIV.linux.org.uk>
	<adatz9b2thy.fsf@cisco.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 21:03:37 -0800 Roland Dreier <rdreier@cisco.com> wrote:

> The kernel has such code eg in init/main.c, which does
> 
> 	printk(linux_banner);
> 
> when linux_banner is only visible to the compiler as
> 
> extern const char linux_banner[];
> 
> however the trivial fix
> 
> diff --git a/init/main.c b/init/main.c
> index 7e117a2..e471598 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -568,7 +568,7 @@ asmlinkage void __init start_kernel(void)
>  	boot_cpu_init();
>  	page_address_init();
>  	printk(KERN_NOTICE);
> -	printk(linux_banner);
> +	printk("%s", linux_banner);
>  	setup_arch(&command_line);
>  	mm_init_owner(&init_mm, &init_task);
>  	setup_command_line(command_line);
> 
> doesn't seem that appealing, since it bloats the object code for a
> non-bug -- 7 bytes for me on x86_64:
> 
> add/remove: 0/0 grow/shrink: 1/0 up/down: 7/0 (7)
> function                                     old     new   delta
> start_kernel                                 680     687      +7
> 
> given the number of such warnings I see in a typical compile, this would
> be a fairly hefty amount of bloat just to shut up gcc.

yes, that would suck.  otoh, our current warning spew actually causes bugs.

I wonder if we could add a printk_stfu() which isn't declared
attribute(printf) and which simply calls printk.  We might still get a
single warning at the interface point.

> On the other hand, gcc warning on such code (untrusted format string
> passed into a printf-like function) seems quite legitimate as well.

Yes, we've had actual bugs in the kernel from this, where the control
string was user-provided.  root-only user, fortunately.

