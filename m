Return-Path: <linux-kernel-owner+w=401wt.eu-S1761758AbXEUKFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758AbXEUKFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbXEUKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:04:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbXEUKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:04:50 -0400
Date: Mon, 21 May 2007 11:04:00 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Davi Arnaut <davi@haxent.com.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shrink task_struct by 16 bytes
Message-ID: <20070521100400.GA11351@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Davi Arnaut <davi@haxent.com.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <464FC31B.9000609@haxent.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464FC31B.9000609@haxent.com.br>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 12:40:11AM -0300, Davi Arnaut wrote:
> Hi,
> 
> Shrink task_struct by replacing the notifier callback with a
> notifier list. The block_all_signals() function (and the signal
> notifier mechanism) has only one user at the moment, which is drm.

This looks like a nice improvement.  Some comments below:

> -	int (*notifier)(void *priv);
> -	void *notifier_data;
> -	sigset_t *notifier_mask;
> -	
> +	/* signal notifier list */
> +	struct list_head notifier_list;
> +

This filed should have a more descripvtive name, e.g. singal_notifier_list.
Also it's probably fine to use a hlist to save another pointer in
struct task_struct.

> +	struct signal_notifier *tmp, *notifier;
>  	int sig = next_signal(pending, mask);
>  
> -	if (sig) {
> -		if (current->notifier) {
> -			if (sigismember(current->notifier_mask, sig)) {
> -				if (!(current->notifier)(current->notifier_data)) {
> -					clear_thread_flag(TIF_SIGPENDING);
> -					return 0;
> -				}
> +	if (unlikely(!sig))
> +		return 0;
> +
> +	list_for_each_entry_safe(notifier, tmp, &current->notifier_list, list) {
> +		if (sigismember(&notifier->mask, sig)) {
> +			if (!(notifier->func)(notifier->data)) {

	Normal kernel stile would be

			if (!notifier->func(notifier->data)) {


The function to add/remove the notifier should grow kerneldoc comments
while you're at it, and maybe more descriptive names.

Also the patch does an actual functional change because it allows for
multiple clients to register the notification, which is probably useful.
