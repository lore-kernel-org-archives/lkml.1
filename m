Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZKJVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZKJVgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZKJVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:36:52 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55893 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbZKJVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:36:51 -0500
Date: Tue, 10 Nov 2009 13:36:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/4] rcu inline, expedited, ->completed
	cleanups
Message-ID: <20091110213651.GA21411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a few fixes from testing and review of treercu.
The review was spurred by the earlier bugs.

1.	Some compilers don't like forward references to inline functions.
	Make the compiler happy by removing "inline".

2.	Although synchronize_sched_expedited() was implemented with a
	fastpath to efficiently handle multiple concurrent calls,
	the counter increment that enabled this fastpath was omitted.
	Add it back in.  (And yes, this does make a big difference in
	performance and scalability for multiple concurrent calls to
	synchronize_sched_expedited(), not that such calls should happen
	all that often.  Still, no point in bringing the machine to its
	knees unnecessarily.)

3.	The field rsp->dynticks_completed is now used whether or not
	dynticks is enabled.  Rename it to rsp->completed_fqs to better
	document its new role.

4.	Much of the confusion leading to the bugs provoked by testing
	with long RCU grace periods was due to the method used to
	determine which grace period a given context-switch quiescent
	state is to be applied to.  This change provides a much more
	straightforward detection method for these quiescent states.
	The quiescent states induced by force_quiescent_state() still
	use the old method, and a separate patch for them is in the
	works.
