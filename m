Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYJVTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYJVTKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJVTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:10:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYJVTKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:10:23 -0400
Date: Wed, 22 Oct 2008 12:09:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 04/11] ftrace: comment arch ftrace code
Message-Id: <20081022120951.11665534.akpm@linux-foundation.org>
In-Reply-To: <20081022185136.134729572@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
	<20081022185136.134729572@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 14:43:17 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Add comments to explain what is happening in the x86 arch ftrace code.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/ftrace.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-compile.git/arch/x86/kernel/ftrace.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 13:15:36.000000000 -0400
> +++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 13:16:35.000000000 -0400
> @@ -66,18 +66,23 @@ ftrace_modify_code(unsigned long ip, uns
>  	/*
>  	 * Note: Due to modules and __init, code can
>  	 *  disappear and change, we need to protect against faulting
> -	 *  as well as code changing.
> +	 *  as well as code changing. We do this by using the
> +	 *  __copy_*_user functions.
>  	 *
>  	 * No real locking needed, this code is run through
>  	 * kstop_machine, or before SMP starts.
>  	 */
> +
> +	/* read the text we want to modify */
>  	if (__copy_from_user_inatomic(replaced, (char __user *)ip,
>  				      MCOUNT_INSN_SIZE))
>  		return -1;
>  
> +	/* Make sure it is what we expect it to be */
>  	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
>  		return -1;
>  
> +	/* replace the text with the new text */
>  	if (__copy_to_user_inatomic((char __user *)ip, new_code,
>  				    MCOUNT_INSN_SIZE))
>  		return -1;
> 

I dunno.

__copy_to_user_inatomic() is for "copying memory from userspace while
in an atomic context".

But what you're doing here is "modifying some kernel text which might
generate a fault".  It seems somewhat interface-abusive to use a
userspace access function for that just because it happens right now to
do the right thing.

I'd suggest that for clarity and for future-safety, you create some new
interface function which does that thing.  Right now it can be a simple
wrapper around __copy_from_user_inatomic().

<looks>

oh, someone added one - probe_kernel_write().  Why not use that?

<wonders why he doesn't know what's going on any more>


Also, I hope that the above code is called from within a
pagefault_disable()d region?  Or are relying upon some magical
side-effect of something which happens to do the same thing as
pagefault_disable()?  IOW: by what means does the above code ensure
that do_page_fault() will see in_atomic()==true?



