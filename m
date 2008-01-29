Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYA2Jyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYA2Jyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYA2Jyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:54:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYA2Jyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:54:44 -0500
Subject: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, vatsa <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Grubb <sgrubb@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Li, Tong N" <tong.n.li@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 10:53:48 +0100
Message-Id: <1201600428.28547.87.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Some of the fancy new scheduler features such as the cgroup load
balancer (load_balance_monitor) and the real-time load balancer are a
bit of an scalability issue. They all seem to want a rather strong
global bound to keep a global fairness (which is quite understandable).

[ my own interest is currently real-time group scheduling on multiple
  cpus, and that seems to require _very_ strong bonds ]

I think the current stuff would scale up to 8 maybe 16 cpus, but after
that I'd be real worried.

Now we want distributions to enable most of these features. Distros seem
to want containers, but distros also need to support 128+ cpu machines,
so how are we going to solve this.

My thoughts were to make stronger use of disjoint cpu-sets. cgroups and
cpusets are related, in that cpusets provide a property to a cgroup.
However, load_balance_monitor()'s interaction with sched domains
confuses me - it might DTRT, but I can't tell.

[ It looks to me it balances a group over the largest SD the current cpu
  has access to, even though that might be larger than the SD associated
  with the cpuset of that particular cgroup. ]

Also the RT load-balance needs to become aware of such these sets, I
think Paul J and Steven once talked about it, but can't quite remember
where that ended. From my POV there should be sched-domain based balance
information, not global.

By cutting the problem into smaller pieces, and adding tunables to
weaken to global fairness, I think we can give administrators enough
freedom to make use of these features, even on the largest of machines.

[ so I'd move the load_balance_monitor() tunables into cpusets as well,
  I can imagine a smaller cpuset wanting a stronger fairness than a much
  larger cpuset. ]

I understand its a somewhat hand-wavey email, but I wanted to start
discussion on the issue, or have someone show me I'm wrong and can stop
worrying :-).

Peter

