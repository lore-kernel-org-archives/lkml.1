Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZJaCmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZJaCmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 22:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757647AbZJaCmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 22:42:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46517 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633AbZJaCml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 22:42:41 -0400
Date: Fri, 30 Oct 2009 19:42:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/3] rcu: clean up locking for ->completed and
	->gpnum fields
Message-ID: <20091031024242.GA9620@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series imposes a clear locking model on accesses to the
->completed and ->gpnum fields, significantly increasing the reliability
of RCU.  To be fair, in order to induce failures in current -tip,
you have to run long rcutorture tests on particular hardware with
particular kernel configuration parameters, while having modified the RCU
implementation itself to invoke force_quiescent_state() several times as
often as normal.  By "particular hardware", I do mean specific machines
that appear otherwise identical to other machines with much lower (and
sometimes even nonexistent) failure rates.  After all, these are race
conditions, and as such can be affected by very subtle factors.

That said, RCU really needs to stand up to whatever abuse shows up,
hence these patches.

1.	The first patch puts non-NO_HZ accesses to the ->completed field
	under a well-defined locking design, eliminating the
	unsynchronized accesses to rsp->completed from the
	dyntick_recall_completed() function.

2.	The second patch puts the rcu_process_gp_end() function's use
	of the ->completed field under a well-defined locking design,
	eliminating its previously unsynchronized accesses to
	rsp->completed.

3.	The third and final patch puts accesses to the ->gpnum field
	under a well-defined locking design, eliminating the
	unsynchronized accesses to rsp->gpnum from the note_new_gpnum()
	function.

A number of unsynchronized accesses remain, but these are of the form
of an unsynchronized check followed by a lock acquisition followed by
a repeat of the check.

							Thanx, Paul
