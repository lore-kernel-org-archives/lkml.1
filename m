Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYFPNXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYFPNXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:23:24 -0400
Received: from [194.117.236.238] ([194.117.236.238]:43146 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756495AbYFPNXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:23:23 -0400
Date: Mon, 16 Jun 2008 16:22:12 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080616162212.27a8c119@linux360.ro>
In-Reply-To: <20080616122249.GB18561@Krystal>
References: <20080613040958.4f52ee29@linux360.ro>
	<1213417601.8237.37.camel@charm-linux>
	<20080614181103.17617db1@linux360.ro>
	<20080616122249.GB18561@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 08:22:49 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> Hi Eduard,

Hi.

> Two objections against this. First, taking a spinlock _is_ slow in SMP
> because it involves synchronized atomic operations.

In any case, if we use relay in a hot path, we are doing debugging, so
a couple of atomic operations won't be a big problem. Along with
setting affinity, this shouldn't be a problem.

> Second, Adding a spinlock to the relay write side is bad since it
> opens the door to deadly embrace between a trap handler and normal
> kernel code both running tracing code.

We disable IRQs. However, interrupts which cannot be disabled (AFAIK
this includes SMM, traps, probably NMIs (but they can be disabled at
least on x86)) either don't use kernel code (SMM) or run through safe
paths. But this is the case with all spinlocks used in interrupt context.

The only other option would be to try the lock and let relay_write fail
sometimes.

> Unless really-really needed, which does not seem to be the case, I
> would strongly recommend not merging this patch.

My question was if affinity setting offers any guarantees. If it does,
then maybe we could do without this patch.

BTW, I'm not saying affinity setting doesn't help. It helps
performance-wise and I'll use it, but it should also offer correctness.
 
> Mathieu

	Cheers,
	Eduard
