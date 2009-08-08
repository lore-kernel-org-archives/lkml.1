Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZHHTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZHHTe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZHHTe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 15:34:27 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:11620 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbZHHTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 15:34:27 -0400
X-Trace: 239550669/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.43.183/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.43.183
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgFAIhwfUpPRSu3/2dsb2JhbACBUo4cAb8ehBcF
X-IronPort-AV: E=Sophos;i="4.43,346,1246834800"; 
   d="scan'208";a="239550669"
Date: Sat, 8 Aug 2009 20:34:03 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Is CONFIG_PREEMPT_RCU=y expected to be working in -next (or mmotm)?

I ask because it appears to break down on PowerPC G5 when I try two
"make -j20" kernel builds in parallel.  The "filp" slab which usually
contains a couple of thousand objects or so, jumps up to a couple of
hundred thousand before the builds complete, and continues rising
from then on - I think that's a sign of RCU in disgrace?
And rebooting hangs thereafter.

And I notice that include/linux/rcupreempt.h currently says:
static inline void synchronize_rcu_expedited(void)
{
	synchronize_rcu();  /* Placeholder for new rcupreempt implementation. */
}
which gives an impression of work in progress?

CONFIG_PREEMPT_TREE=y seems okay on PowerPC; and when I briefly tried
CONFIG_PREEMPT_RCU=y on x86_64, it didn't show above symptoms there.

I did try bisecting yesterday's linux-next git, but that led me to

commit 8ca17c6082feee5841a7b0e91d00e18c3f85f063
Merge: dafcc6e... 7256cf0...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Aug 3 15:50:37 2009 +0200

    Merge branch 'core/rcu' into auto-sched-next

rather than to any particular patch of yours which that merges:
which seemed odd, but I'm not accustomed to bisecting next.

Another odd thing is that mmotm .DATE=2009-07-30-05-01, the last
I tried before Thursday's, showed no such symptoms: yet appears to
contain all the larger RCU changes, just lacking some more recent
on/offline race fixes.  I didn't notice any likely difference
between those mmotm trees down in arch/powerpc either.

My guess is that there's some other issue which is triggering
the RCU disgrace, but that is just a guess.

Config attached.  Any suggestions?

Thanks,
Hugh
