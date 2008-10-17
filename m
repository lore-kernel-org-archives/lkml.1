Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYJQSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYJQSIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYJQSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:08:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:14032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbYJQSIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:08:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,433,1220252400"; 
   d="scan'208";a="392868682"
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 17 Oct 2008 11:08:13 -0700
Subject: RE: [RFC patch 15/15] LTTng timestamp x86
Thread-Topic: [RFC patch 15/15] LTTng timestamp x86
Thread-Index: AckwfVdfd0BQShseR+WE1PM/OOHCHQAAzwjg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>
References: <20081016232729.699004293@polymtl.ca>
 <20081016234657.837704867@polymtl.ca>
 <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
 <20081017012835.GA30195@Krystal>
 <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
 <20081017172515.GA9639@goodmis.org>
In-Reply-To: <20081017172515.GA9639@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree that one cache line bouncer is devastating to performance. But
> as Mathieu said, it is better than a global tracer with lots of bouncing
> going on.

Scale up enough, and it becomes more than just a performance problem.
When SGI first tried to boot on 512 cpus they found the kernel hung
completely because of a single global atomic counter for how many
interrupts there were.  With HZ=1024 and 512 cpus the ensuing cache
line bouncing storm from each interrupt took longer to resolve than
the interval between interrupts.

With higher event rates (1KHz seems relatively low) this wall will
be a problem for smaller systems too.

> ftrace does not have a global counter, but on some boxes with out of
> sync TSCs, it could not find race conditions. I had to pull in logdev,
> which found the race right away, because of this atomic counter.

Perhaps this needs to be optional (and run-time switchable).  Some
users (tracking performance issues) will want the  tracer to have
the minumum possible effect on the system.  Others (chasing race
conditions) will want the best possible ordering of events between
cpus[*].

-Tony

[*] I'd still be concerned that a heavyweight strict ordering might
perturb the system enough to make the race disappear when tracing
is enabled.
