Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0BLAAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:00:21 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49484 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0BLAAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:00:19 -0500
Date: Thu, 11 Feb 2010 16:00:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/13] rcu: add lockdep checking, doc update,
	dyntick GP acceleration
Message-ID: <20100212000016.GA25781@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The first 11 patches extend lockdep to check for proper protection
of rcu_dereference(), described in http://lwn.net/Articles/371986/,
and apply these lockdep extensions in a number of areas in the kernel.
There are likely more such changes required, as I am limited to those
located by the systems I have access to.

The twelfth patch is a documentation update, and the last patch
accelerates grace periods when the current CPU is the last
non-dyntick-idle CPU in the system, which is important for some
multi-core battery-powered devices.

 b/Documentation/RCU/00-INDEX      |    2 
 b/Documentation/RCU/RTFP.txt      |    6 +
 b/Documentation/RCU/checklist.txt |   34 ++++++----
 b/Documentation/RCU/lockdep.txt   |   67 ++++++++++++++++++++
 b/Documentation/RCU/whatisRCU.txt |   14 ++--
 b/fs/file.c                       |    2 
 b/fs/proc/array.c                 |    2 
 b/fs/proc/base.c                  |    6 +
 b/include/linux/cgroup.h          |    5 +
 b/include/linux/cpumask.h         |   14 ++++
 b/include/linux/cred.h            |    2 
 b/include/linux/fdtable.h         |    9 +-
 b/include/linux/lockdep.h         |    4 +
 b/include/linux/rculist.h         |   14 ++--
 b/include/linux/rculist_nulls.h   |    5 -
 b/include/linux/rcupdate.h        |  126 ++++++++++++++++++++++++++++++++++----
 b/include/linux/rtnetlink.h       |    3 
 b/include/linux/srcu.h            |   87 +++++++++++++++++++++++++-
 b/include/net/addrconf.h          |    4 -
 b/init/Kconfig                    |   16 ++++
 b/init/main.c                     |    2 
 b/kernel/cgroup.c                 |   12 +++
 b/kernel/exit.c                   |   14 +++-
 b/kernel/fork.c                   |    1 
 b/kernel/lockdep.c                |   19 +++++
 b/kernel/notifier.c               |    6 -
 b/kernel/pid.c                    |    2 
 b/kernel/rcupdate.c               |   10 +++
 b/kernel/rcutorture.c             |   12 +++
 b/kernel/rcutree.c                |    5 -
 b/kernel/rcutree_plugin.h         |   70 ++++++++++++++++++++-
 b/kernel/sched.c                  |   12 ++-
 b/kernel/srcu.c                   |   50 +++++++++------
 b/lib/Kconfig.debug               |   12 +++
 b/lib/debug_locks.c               |    2 
 b/lib/idr.c                       |    9 +-
 b/lib/radix-tree.c                |   25 +++----
 b/net/core/dev.c                  |    2 
 b/net/core/filter.c               |    6 -
 b/net/core/rtnetlink.c            |    8 ++
 b/net/core/sock.c                 |    3 
 b/net/decnet/dn_route.c           |   14 ++--
 b/net/ipv4/route.c                |   14 ++--
 b/net/packet/af_packet.c          |    3 
 b/security/keys/gc.c              |    3 
 b/security/keys/keyring.c         |    5 -
 include/linux/rcupdate.h          |   45 ++++++++++---
 include/linux/srcu.h              |    9 ++
 48 files changed, 657 insertions(+), 140 deletions(-)
