Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbYHTEKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbYHTEKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 00:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYHTEJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 00:09:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYHTEJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 00:09:53 -0400
Date: Tue, 19 Aug 2008 21:09:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-Id: <20080819210932.9bb348b9.akpm@linux-foundation.org>
In-Reply-To: <20080815152938.4bc9d48c@infradead.org>
References: <20080815152938.4bc9d48c@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 15:29:38 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] debug: add notifier chain debugging
> 
> during some development we suspected a case where we left something
> in a notifier chain that was from a module that was unloaded already...
> and that sort of thing is rather hard to track down.
> 
> This patch adds a very simple sanity check (which isn't all that
> expensive) to make sure the notifier we're about to call is
> actually from either the kernel itself of from a still-loaded
> module, avoiding a hard-to-chase-down crash.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/notifier.c |   16 ++++++++++++++++
>  lib/Kconfig.debug |   10 ++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index 823be11..143fdd7 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -21,6 +21,10 @@ BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
>  static int notifier_chain_register(struct notifier_block **nl,
>  		struct notifier_block *n)
>  {
> +	if (!kernel_text_address((unsigned long)n->notifier_call)) {
> +		WARN(1, "Invalid notifier registered!");
> +		return 0;
> +	}
>  	while ((*nl) != NULL) {
>  		if (n->priority > (*nl)->priority)
>  			break;
> @@ -34,6 +38,10 @@ static int notifier_chain_register(struct notifier_block **nl,
>  static int notifier_chain_cond_register(struct notifier_block **nl,
>  		struct notifier_block *n)
>  {
> +	if (!kernel_text_address((unsigned long)n->notifier_call)) {
> +		WARN(1, "Invalid notifier registered!");
> +		return 0;
> +	}

Seems strange to add checks to the registration functions.  What could
be that broken?

>  	while ((*nl) != NULL) {
>  		if ((*nl) == n)
>  			return 0;
> @@ -82,6 +90,14 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
>  
>  	while (nb && nr_to_call) {
>  		next_nb = rcu_dereference(nb->next);
> +
> +#ifdef CONFIG_DEBUG_NOTIFIERS
> +		if (!kernel_text_address((unsigned long)nb->notifier_call)) {
> +			WARN(1, "Invalid notifier called!");
> +			nb = next_nb;
> +			continue;
> +		}
> +#endif
>  		ret = nb->notifier_call(nb, val, v);
>  
>  		if (nr_calls)
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 800ac84..f4bb36e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -536,6 +536,16 @@ config DEBUG_SG
>  
>  	  If unsure, say N.
>  
> +config DEBUG_NOTIFIERS
> +	bool "Debug notifier call chains"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Enable this to turn on sanity checking for notifier call chains.
> +	  This is most useful for kernel developers to make sure that
> +	  modules properly unregister themselves from notifier chains.
> +	  This is a relatively cheap check but if you care about maximum
> +	  performance, say N.
> +

If we remove the first two checks then surely we can afford to add the
remaining check unconditionally and lose the new config option and its
ifdef.

