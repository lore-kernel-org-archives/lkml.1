Return-Path: <linux-kernel-owner+w=401wt.eu-S1751375AbZL1Tri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbZL1Tri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 14:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZL1Trh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 14:47:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1441 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZL1Trg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 14:47:36 -0500
Subject: Re: [RFC/PATCH] x86: Use KERN_DEFAULT log-level in __show_regs()
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, vegard.nossum@gmail.com, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1261988819.4641.2.camel@penberg-laptop>
References: <1261988819.4641.2.camel@penberg-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 11:47:34 -0800
Message-ID: <1262029654.3352.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 10:26 +0200, Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Andrew Morton reported a strange looking kmemcheck warning:
> 
>   WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff88004fba6c20)
>   0000000000000000310000000000000000000000000000002413000000c9ffff
>    u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u
> 
>    [<ffffffff810af3aa>] kmemleak_scan+0x25a/0x540
>    [<ffffffff810afbcb>] kmemleak_scan_thread+0x5b/0xe0
>    [<ffffffff8104d0fe>] kthread+0x9e/0xb0
>    [<ffffffff81003074>] kernel_thread_helper+0x4/0x10
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The above printout is missing register dump completely. The problem here is
> that the output comes from syslog which doesn't show KERN_INFO log-level
> messages. We didn't see this before because both of us were testing on 32-bit
> kernels which use the _default_ log-level.
> 
> Fix that up by explicitly using KERN_DEFAULT log-level for __show_regs()
> printks.
> 
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/kernel/process.c    |    4 ++--
>  arch/x86/kernel/process_32.c |   14 +++++++-------
>  arch/x86/kernel/process_64.c |   24 ++++++++++++------------
>  3 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 98c2cde..c6ee241 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -103,8 +103,8 @@ void show_regs_common(void)
>  	if (!product)
>  		product = "";
>  
> -	printk("\n");
> -	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
> +	printk(KERN_CONT "\n");
> +	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",

What is the reason to convert KERN_INFO to KERN_DEFAULT here?

The original commit for KERN_DEFAULT said:

    This adds a KERN_DEFAULT loglevel marker, for when you cannot decide
    which loglevel you want, and just want to keep an existing printk
    with the default loglevel.
    
    The difference between having KERN_DEFAULT and having no log-level
    marker at all is two-fold:
    
     - having the log-level marker will now force a new-line if the
       previous printout had not added one (perhaps because it forgot,
       but perhaps because it expected a continuation)
    
     - having a log-level marker is required if you are printing out a
       message that otherwise itself could perhaps otherwise be mistaken
       for a log-level.


