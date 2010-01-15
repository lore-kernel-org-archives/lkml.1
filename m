Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528Ab0AOBDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0AOBDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 20:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495Ab0AOBDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:03:01 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47011 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0AOBDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:03:00 -0500
Date: Thu, 14 Jan 2010 17:01:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/9] rcu: v3 add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100115010157.GA28221@linux.vnet.ibm.com>
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
primitive in order to flag misuses of RCU.  The first three patches put
the RCU infrastructure in place, the next five use this infrastructure in
the net, sched, vfs, radix-tree, and idr subsystems, and the last patch
documents how to use the new lockdep-checked rcu_dereference() primitives.

The new (and default-disabled) CONFIG_PROVE_RCU makes this safe to include
in tip/core/rcu -- unlike v2, your system won't complain about RCU misuse
unless you ask it to.  There are still several situations that trigger
on systems I have access to (and I have email out on a couple of them),
some of the remaining will be triggered only by hardware I don't have
access to and kernel features I am unfamiliar with.  So this is ready
for some more-general testing.

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
