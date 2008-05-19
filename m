Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYESIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYESIoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYESIoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:44:08 -0400
Received: from mail.suse.de ([195.135.220.2]:45035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398AbYESIoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:44:05 -0400
Subject: Re: [PATCH 11/15] rfkill: add notifier chains support
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
In-Reply-To: <1211136485-19878-12-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
	 <1211136485-19878-12-git-send-email-hmh@hmh.eng.br>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 19 May 2008 10:44:03 +0200
Message-Id: <1211186644.21269.274.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 15:48 -0300, Henrique de Moraes Holschuh wrote:
> Add a notifier chain for use by the rfkill class.  This notifier chain
> signals the following events (more to be added when needed):
> 
>   1. rfkill: rfkill device state has changed
> 
> A pointer to the rfkill struct will be passed as a parameter.
> 
> The notifier message types have been added to include/linux/rfkill.h
> instead of to include/linux/notifier.h in order to avoid the madness of
> modifying a header used globally (and that triggers an almost full tree
> rebuild every time it is touched) with information that is of interest only
> to code that includes the rfkill.h header.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  include/linux/rfkill.h |    7 +++++
>  net/rfkill/rfkill.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index c0cab7d..98667be 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -117,4 +117,11 @@ static inline char *rfkill_get_led_name(struct rfkill *rfkill)
>  #endif
>  }
>  
> +/* rfkill notification chain */
> +#define RFKILL_STATE_CHANGED		0x0001	/* state of a normal rfkill
> +						   switch has changed */
> +
> +int register_rfkill_notifier(struct notifier_block *nb);
> +int unregister_rfkill_notifier(struct notifier_block *nb);
> +
>  #endif /* RFKILL_H */
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index f11220b..251defe 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -46,6 +46,49 @@ MODULE_PARM_DESC(default_state,
>  
>  static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
>  
> +static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
> +
> +
> +/**
> + * register_rfkill_notifier - Add notifier to rfkill notifier chain
> + * @nb: pointer to the new entry to add to the chain
> + *
> + * See blocking_notifier_chain_register() for return value and further
> + * observations.
> + *
> + * Adds a notifier to the rfkill notifier chain.  The chain will be
> + * called with a pointer to the relevant rfkill structure as a parameter,
> + * refer to include/linux/rfkill.h for the possible events.
> + *
> + * Notifiers added to this chain are to always return NOTIFY_DONE.  This
> + * chain is a blocking notifier chain: notifiers can sleep.
> + *
> + * Calls to this chain may have been done through a workqueue.  One must
> + * one must assume unordered assynchronous behaviour, there is no way to
One must, one must...,         asynchronous
...

   Thomas



