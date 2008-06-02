Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYFBSCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYFBSCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYFBSCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:02:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYFBSCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:02:31 -0400
Date: Mon, 2 Jun 2008 14:02:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ftrace: prevent freeing of all failed updates
In-Reply-To: <4842CB9A.1080800@gmail.com>
Message-ID: <Pine.LNX.4.58.0806021401340.10366@gandalf.stny.rr.com>
References: <4842CB9A.1080800@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2008, Abhishek Sagar wrote:
5B> @@ -611,18 +612,33 @@ static int __ftrace_update_code(void *ignore)
>
>  	/* No locks needed, the machine is stopped! */
>  	for (i = 0; i < FTRACE_HASHSIZE; i++) {
> -		if (hlist_empty(&ftrace_hash[i]))
> -			continue;
> +		/* all CPUS are stopped, we are safe to modify code */
> +		hlist_for_each_entry_safe(p, t, n, &ftrace_hash[i], node) {
> +			/* Skip over failed records which have not been
> +			 * freed. */
> +			if (p->flags & FTRACE_FL_FAILED)
> +				continue;
>
> -		head = ftrace_hash[i];
> -		INIT_HLIST_HEAD(&ftrace_hash[i]);
> +			/* Unconverted records are always at the head of the
> +			 * hash bucket. Once we encounter a converted record,
> +			 * simply skip over to the next bucket. Saves ftraced
> +			 * some processor cycles (ftrace does its bid for
> +			 * global warming :-p ). */
> +			if (p->flags & (FTRACE_FL_CONVERTED))
> +				break;

If we unload a module and reload it, will it ever get converted again?

-- Steve
