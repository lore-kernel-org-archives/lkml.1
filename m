Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYFQJ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYFQJ1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYFQJ1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:27:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbYFQJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:27:37 -0400
Date: Tue, 17 Jun 2008 11:27:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, vgusev@openvz.org, mcmanus@ducksong.com,
       xemul@openvz.org, netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       rjw@sisk.pl
Subject: Re: [TCP]: TCP_DEFER_ACCEPT causes leak sockets
Message-ID: <20080617092706.GB20621@elte.hu>
References: <20080617.003832.130616157.davem@davemloft.net> <20080617080958.GC12535@elte.hu> <20080617083220.GA11393@elte.hu> <20080617.020840.169830916.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617.020840.169830916.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 17 Jun 2008 10:32:20 +0200
> 
> > those up to 1000 msec delays can be 'felt' via ssh too, if this 
> > problem triggers then the system is almost unusable via the network. 
> > Local latencies are perfect so it's an e1000 problem.
> 
> Or some kind of weird interrupt problem.
> 
> Such an interrupt level bug would also account for the TX timeout's 
> you're seeing btw.

when i originally reported it i debugged it back to missing e1000 TX 
completion IRQs. I tried various versions of the driver to figure out 
whether new workarounds for e1000 cover it but it was fruitless. There 
is a 1000 msec internal watchdog timer IRQ within e1000 that gets things 
going if it's stuck.

But the line sch_generic.c:222 problem is new. It could be an 
escallation of this same problem - not even the hw-internal watchdog 
timeout fixing up things? So basically two levels of completion failed, 
the third fallback level (a hard reset of the interface) helped things 
get going. High score from me for networking layer robustness :-)

	Ingo
