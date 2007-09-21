Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXIUMCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXIUMCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXIUMC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:02:28 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65193 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368AbXIUMC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:02:27 -0400
Date: Fri, 21 Sep 2007 14:02:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
Message-ID: <20070921140221.000a416a@twins>
In-Reply-To: <1190313251.4518.14.camel@localhost.localdomain>
References: <1190313251.4518.14.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 14:34:11 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:


> +static inline void rcu_crc_check(struct rcu_head *head)
> +{
> +	static int once;
> +	if (unlikely(head->crc != rcu_crc_calc(head)) && !once) {
> +		once++;
> +		printk("BUG: RCU check failed!");
> +		if (head->caller)
> +			printk(" (caller=%p)",
> +			       head->caller);

		char sym[KSYM_SYMBOL_LEN];
		sprint_symbol(sym, head->caller);
		printk(" (caller: [<%p>] %s)", head->caller, sym);

> +		printk("\n");
> +		printk("  CRC was %08lx, expected %08lx\n",
> +		       head->crc, rcu_crc_calc(head));
> +		printk("  %p %p\n",
> +		       head->next, head->func);
> +		dump_stack();
> +	}
> +}
