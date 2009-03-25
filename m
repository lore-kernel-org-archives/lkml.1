Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZCYCL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZCYCL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZCYCLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:11:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbZCYCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:11:47 -0400
Date: Tue, 24 Mar 2009 19:11:34 -0700 (PDT)
Message-Id: <20090324.191134.05205089.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: mingo@elte.hu, r.schwebel@pengutronix.de, torvalds@linux-foundation.org,
       blaschka@linux.vnet.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090325002303.GA2219@gondor.apana.org.au>
References: <20090324150928.GB30224@gondor.apana.org.au>
	<20090324.143622.186562202.davem@davemloft.net>
	<20090325002303.GA2219@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 25 Mar 2009 08:23:03 +0800

> On Tue, Mar 24, 2009 at 02:36:22PM -0700, David Miller wrote:
> >
> > I think the problem is that we need to do the GRO flush before the
> > list delete and clearing the NAPI_STATE_SCHED bit.
> 
> Well first of all GRO shouldn't even be on in Ingo's case, unless
> he enabled it by hand with ethtool.  Secondly the only thing that
> touches the GRO state for the legacy path is process_backlog, and
> since this is per-cpu, I can't see how another instance can run
> while the first is still going.

Right.

I think the conditions Ingo is running under is that both
loopback (using legacy paths) and his NAPI based device
(forcedeth) are processing a lot of packets at the same
time.

Another thing that seems to be critical is he can only trigger this on
UP, which means that we don't have the damn APIC potentially moving
the cpu target of the forcedeth interrupts around.  And this means
also that all the processing will be on one cpu's backlog queue only.
