Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYJBXcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYJBXcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJBXcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:32:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbYJBXcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:32:11 -0400
Date: Thu, 2 Oct 2008 16:31:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk.caller
Message-Id: <20081002163154.fd5f2a10.akpm@linux-foundation.org>
In-Reply-To: <20081002232115.8D2BB154212@magilla.localdomain>
References: <20081002232115.8D2BB154212@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Oct 2008 16:21:15 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> This adds the printk.caller=[0|1] boot parameter, default setting
> controlled by CONFIG_PRINTK_CALLER.  (This is modelled on printk.time
> and CONFIG_PRINTK_TIME.)
> 
> When this is set, each printk line is automagically prefixed with
> "{0x123abc} " giving the PC address of that printk call (actually
> the PC address just after the call).
> 
> As a kernel hacker, I always hate having to grep for some fragment
> of a message to find the code that generated it.  But I always have
> my -g vmlinux handy, so:
> 	(gdb) info line *(0x123abc - 1)
> is real handy (it pops the source up in an Emacs buffer).
> 

hm.  What do others think?

>
> ...
>
> +config PRINTK_CALLER
> +	bool "Show caller PC on printks"
> +	depends on PRINTK
> +	help
> +	  Selecting this option causes printk output to include
> +	  the PC address of the printk call.  This is useful for
> +	  kernels hackers to quickly locate the source code that
> +	  produced the message.
> +

This is quite misleading.  The config help implies that
CONFIG_PRINTK_CALLER will enable the feature at compile time.  But it
doesn't - it just sets the boot-time enable/disable default.

If you do this:

#ifdef CONFIG_PRINTK_CALLER
static int printk_caller = 1;
#else
#define printk_caller 0
#endif

then the implementation would somewhat reflect the config option.


But I'd suggest that this thing is so small that it doesn't need a
config option to enable the presence of the code - just make it
unconditional.

Also, I guess that the boot-time option is useful, but a runtime /proc
knob might also be needed?

