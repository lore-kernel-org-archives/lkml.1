Return-Path: <linux-kernel-owner+w=401wt.eu-S937892AbXFGWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937892AbXFGWfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965447AbXFGWfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:35:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937718AbXFGWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:35:12 -0400
Date: Thu, 7 Jun 2007 15:34:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, liuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all
 threads in process group
Message-Id: <20070607153459.2a1b3230.akpm@linux-foundation.org>
In-Reply-To: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 12:48:32 -0500
Will Schmidt <will_schmidt@vnet.ibm.com> wrote:

> 
> When we get into a state where VM has ran out of memory, and it's time to
> thwack a process, we should take out the entire process group, rather than 
> just one thread.
> 
> Tested on i386
> 
> Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
> ---
> 
>  arch/i386/mm/fault.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
> index b8c4e25..82aec0e 100644
> --- a/arch/i386/mm/fault.c
> +++ b/arch/i386/mm/fault.c
> @@ -567,8 +567,10 @@ out_of_memory:
>  		goto survive;
>  	}
>  	printk("VM: killing process %s\n", tsk->comm);
> -	if (error_code & 4)
> +	if (error_code & 4) {
> +		zap_other_threads(tsk);
>  		do_exit(SIGKILL);
> +	}
>  	goto no_context;
>  

zap_other_threads() requires tasklist_lock.

If we're going to do this then we should probably create some new function
(with a better name) which takes tasklsit_lock and then calls
zap_other_threads().

Does this patch fix any observed-in-the-real-world problem?  If so, please
describe it.
