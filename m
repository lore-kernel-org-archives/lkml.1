Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZI2Ety@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZI2Ety (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 00:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZI2Etx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 00:49:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44883 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZI2Etx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 00:49:53 -0400
Date: Mon, 28 Sep 2009 21:49:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: simplify rcu_barrier() interaction
	with CPU hotplug
Message-ID: <20090929044955.GA12486@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset simplifies the interaction of rcu_barrier() with CPU
hotplug operations.  The main point of this patchset is to impose an
invariant: offline CPUs never have any RCU callbacks queued.  However,
rcutiny doesn't permit CPU hotplug (yes, I have worked in environments
where the last CPU could be offlined, but Linux is thankfully not one of
them), so the patchset goes as follows:

o	Replace the rcu_barrier enum with a pointer to the relevant
	call_rcu() function, thus eliminating any confusion about
	which .h file this enum should reside in.

o	Move the rcu_barrier() code to rcutree, and create a lightweight
	variant of rcu_barrier() that is suitable for rcutiny.  This
	lightweight variant is identical to rcutree's implementation of
	synchronize_rcu() and friends.

o	Create a list in the rcu_state structure that holds RCU
	callbacks that were "orphaned" by CPUs that just went offline.
	The CPU_DYING notifier moves all RCU callbacks from the outgoing
	CPU to the rcu_state lists, and the CPU_DEAD notifier and
	_rcu_barrier() function "adopt" these orphans.

 b/kernel/rcupdate.c       |   33 +++-------
 b/kernel/rcutiny.c        |   36 ++++++++++
 b/kernel/rcutree.c        |  120 ++++++++++++++++++++++++++++++++++++
 b/kernel/rcutree.h        |   11 +++
 b/kernel/rcutree_plugin.h |   34 ++++++++++
 b/kernel/rcutree_trace.c  |    5 -
 kernel/rcupdate.c         |  120 ------------------------------------
 kernel/rcutree.c          |  151 ++++++++++++++++++++++++----------------------
 8 files changed, 291 insertions(+), 219 deletions(-)
