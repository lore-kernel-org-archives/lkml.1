Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbZEAUi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbZEAUi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763915AbZEAUiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:38:46 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:43726 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZEAUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:38:45 -0400
Date: Fri, 1 May 2009 16:28:55 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090501202400.GA20280@Krystal>
Message-ID: <alpine.DEB.1.10.0905011623450.16255@qirst.com>
References: <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com>
 <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090501202400.GA20280@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Mathieu Desnoyers wrote:

> So, back to my original point : do you agree on the usefulness of
> separating fallback irq-disabling from the per-cpu atomic construct ?

No. Percpu operations are used for statistics and are like atomic
operations. Aggregation of these leads to a can of worms that we better
leave unopened.

> x86 would map :
>
> percpu_irqsave/restore to "nothing".
> percpu_add_return_irq to xadd instruction. It is irq-safe by design.
>
> Other architectures (fallback) would map
>
> percpu_irqsave/restore to local_irq_save/restore.
> percpu_add_return_irq to var += value; return var;

Shudder.... We have explored those types of macros before (while doing
fastpath optimization for SLUB) and it significant increases the
complexity. People may add additional instructions in between and now
interrupts off could be on or off depending on the architecture. Sometimes
percpu_irqsave does nothing. Very difficult to ensure that the usage is
correct.

And we have barely any usage case for such macros.




