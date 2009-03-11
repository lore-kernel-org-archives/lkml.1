Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZCKNK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZCKNK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZCKNKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:10:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZCKNKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:10:46 -0400
Date: Wed, 11 Mar 2009 14:10:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090311131007.GB1074@elte.hu>
References: <20090310172605.GA28767@elte.hu> <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org> <20090311121220.GI2282@elte.hu> <20090311125013.GA9547@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311125013.GA9547@in.ibm.com>
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


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> Even if #3 was implemented as described, we would still retain 
> a majority of the complexity in balance_kernel_vs_user() to 
> check newer tasks with requests for breakpoint registers.

Not if it's implemented in a really simple way:

Kernel gets debug registers in db4..db3..db2..db1 order, and its 
allocation is essentially hardcoded - i.e. we dont try to be 
fancy.

User-space (gdb) on the other hand will try to allocate in the 
db1..db2..db3..db4 order.

Maintain a 'max debug register index' value driven by ptrace and 
maintain a 'min debug register index' driven by kernel-space 
hw-breakpoint allocations.

If they meet somewhere inbetween then we have overcommit which 
we dont allow. In all other cases (which i proffer covers 100% 
of the sane cases) they will mix amicably.

Sure, user-space can in principle do db4..db3..db2..db1 
allocations as well, but it would be silly and GDB does not do 
that.

So there's no real overlap between register usage - hence no 
need for any complex scheduling smarts. Keep it simple first, 
and only add complexity when it's justified.

[ for the special case of an architecture having just a single 
  debug register this will bring the expected behavior of either 
  allowing gdb to use the breakpoint or allowing the kernel to 
  use it. ]

	Ingo
