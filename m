Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbZBCE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbZBCE4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZBCE40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:56:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbZBCE4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:56:25 -0500
Date: Mon, 2 Feb 2009 20:55:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: Negative values in /proc/latency_stats
Message-Id: <20090202205545.4e1a32ea.akpm@linux-foundation.org>
In-Reply-To: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
References: <4e5e476b0901310542n796dafbem5c656da07a2f8a56@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 14:42:20 +0100 Corrado Zoccolo <czoccolo@gmail.com> wrote:

> Hello,
> I found negative numbers sometimes appear in /proc/latency_stats
> (vanilla kernel 2.6.29-rc3, on x86 cpu, configuration attached)
> 
> [corrado@localhost ~]$ while sleep 1; do grep -- - /proc/latency_stats
> >> neg_stats; done
> ^Z
> [1]+  Stopped                 sleep 1
> [corrado@localhost ~]$ cat neg_stats
> 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> 1 -486373534 -486373534 sys_rt_sigsuspend sysenter_do_call
> 
> 
> I suspect this can be the cause for
> https://bugs.launchpad.net/ubuntu/+source/latencytop/+bug/297776 , as
> I saw it happening on my machine during a kernel recompilation.
> 

<discovers kernel/latencytop.c>

- It implements a kernel/userspace interface yet it has zero documentation.

- It was committed with a 2-line changelog which tells us practically
  nothing.

- It implements an up-to-1536-loops loop followed by an
  up-to-384-loops loop on a scheduler hotpath.

  All under spin_lock_irqsave()!

- store_stacktrace() unnecessarily initalises trace.skip.

- account_scheduler_latency() should be an inline:

	if (unlikely(latencytop_enabled))
		__account_scheduler_latency(...);

- ditto clear_all_latency_tracing()

- it's schizophrenic in its placement of spaces around semicolons in
  `for' statements.

- it seems to only be implemented if CONFIG_FAIR_GROUP_SCHED=y.

- lstats_fops should be const.


And it emits negative numbers too ;)
