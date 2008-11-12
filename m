Return-Path: <linux-kernel-owner+w=401wt.eu-S1751742AbYKLGxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbYKLGxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYKLGxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:53:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36015 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYKLGxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:53:33 -0500
Date: Wed, 12 Nov 2008 12:22:38 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH 5/7] kprobes: Remove called_from argument
Message-ID: <20081112065238.GB3081@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4919F1A9.5070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4919F1A9.5070601@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 03:57:13PM -0500, Masami Hiramatsu wrote:
> Remove called_from argument from kprobes which had been used for preventing
> self-refering of kernel module. However, since we don't keep module's refcount
> after registering kprobe any more, there is no reason to check that.
> 
> This patch also simplifies registering/unregistering functions because we don't
> need to use __builtin_return_address(0) which was passed to called_from.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/kprobes.c |   70 +++++++++++--------------------------------------------
>  1 file changed, 14 insertions(+), 56 deletions(-)
> 
> Index: 2.6.28-rc4/kernel/kprobes.c
> ===================================================================
> --- 2.6.28-rc4.orig/kernel/kprobes.c
> +++ 2.6.28-rc4/kernel/kprobes.c
> @@ -641,8 +641,7 @@ static kprobe_opcode_t __kprobes *kprobe
>  	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
>  }
> 
> -static int __kprobes __register_kprobe(struct kprobe *p,
> -	unsigned long called_from)
> +int __kprobes register_kprobe(struct kprobe *p)
>  {
>  	int ret = 0;
>  	struct kprobe *old_p;
> @@ -673,13 +672,10 @@ static int __kprobes __register_kprobe(s
>  		 * We must hold a refcount of the probed module while updating
>  		 * its code to prohibit unexpected unloading.
>  		 */
> -		if (calling_mod != probed_mod) {
> -			if (unlikely(!try_module_get(probed_mod))) {
> -				preempt_enable();
> -				return -EINVAL;
> -			}
> -		} else
> -			probed_mod = NULL;
> +		if (unlikely(!try_module_get(probed_mod))) {
> +			preempt_enable();
> +			return -EINVAL;
> +		}

You also need the following to get this to compile, don't you?

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Index: linux-2.6.28-rc4/kernel/kprobes.c
===================================================================
--- linux-2.6.28-rc4.orig/kernel/kprobes.c	2008-11-12 11:13:30.000000000 +0530
+++ linux-2.6.28-rc4/kernel/kprobes.c	2008-11-12 12:18:44.000000000 +0530
@@ -666,8 +666,6 @@
 	 */
 	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
-		struct module *calling_mod;
-		calling_mod = __module_text_address(called_from);
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
