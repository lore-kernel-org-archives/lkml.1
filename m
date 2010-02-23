Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0BWBEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:04:42 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58517 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0BWBEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:04:40 -0500
Date: Mon, 22 Feb 2010 17:04:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100223010435.GA666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series adds lockdep-based checking to the rcu_dereference()
primitive in order to flag misuses of RCU.  The first four patches put
the RCU infrastructure in place, the next eight use this infrastructure
in the net, sched, vfs, radix-tree, idr, and security subsystems, and
patch 13 documents how to use the new lockdep-checked rcu_dereference()
primitives.  The remaining eight patches are other changes that also need
to be applied, including some relatively urgent RCU_STALL patches.

The new (and default-disabled) CONFIG_PROVE_RCU makes this safe to
include in tip/core/rcu -- unlike v2 and earlier, your system won't
complain about RCU misuse unless you ask it to.  There are still several
situations that trigger on systems I have access to (and I have email
out on a couple of them), some of the remaining will be triggered only by
hardware I don't have access to and kernel features I am unfamiliar with.
So this is ready for much wider testing.

Changes since v5 (http://lkml.org/lkml/2010/2/17/271)

o	Fix a deadlock located by Thomas Gleixner that affects
	TREE_PREEMPT_RCU in some CPU-stall detection scenarios.

o	Add Dan Carpenter's cleanup to a mod_timer() in rcutorture.

o	Add a RCU_CPU_STALL_VERBOSE to enable dumping more information
	on tasks stalling the current RCU grace period.

o	Applied Acked-by lines that people have sent (thank you all!).

Changes since v4 (http://lkml.org/lkml/2010/2/11/356)

o	Apply review comments from Peter Ziljstra.

o	Another documentation update.

o	Fixes that avoid overflowing signed integers.

o	Rebased Thomas Gleixner's raw-spinlock patch on this series.
	(Thomas's original at http://lkml.org/lkml/2010/2/17/182.)

Changes since v3 (http://lkml.org/lkml/2010/1/14/505)

o	Fix a few more issues identified by the checking.

o	Add a documentation update.

o	Accelerate RCU grace periods when the current CPU is the last
	non-dyntick-idle CPU in the system, which is important for
	some multi-core battery-powered devices.

Changes since v2 (http://lkml.org/lkml/2010/1/4/496):

o	Removed references to the check condition for the non-lockdep
	version of rcu_dereference_check(), thus preventing numerous
	build errors.

o	Create a CONFIG_PROVE_RCU (default disabled) so that developers
	who want to use lockdep only to debug locks aren't bothered 
	by RCU-specific lockdep complaints that will no doubt persist
	for a little bit while some of the more obscure uses of RCU
	are reverse-engineered.

o	Fix a few more issues identified by the checking.

o	Add documentation in Documentation/RCU/lockdep.txt.

Changes since v1 (http://lkml.org/lkml/2009/12/15/553):

o	Made SRCU have per-srcu_struct lockdep maps to prevent lockdep
	from conflating independent uses of SRCU, and updated the
	rcu_dereference() checking in rcutorture to match.

o	Fix a few issues identified by the checking.

o	Disable checking within RCU list macros, RCU radix trees, and
	IDR.
