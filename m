Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0CHPyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:54:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:48007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0CHPyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:54:19 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, oleg@redhat.com, akpm@linux-foundation.org
Subject: [PATCHSET] cpuhog: implement and use cpuhog
Date: Tue,  9 Mar 2010 00:53:19 +0900
Message-Id: <1268063603-7425-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 15:53:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset implements cpuhog which is a simplistic cpu
monopolization mechanism and reimplements stop_machine() and replaces
migration_thread with it.

This allows stop_machine() to be simpler and much more efficient on
very large machines without using more resources while also making the
rather messy overloaded migration_thread usages cleaner.

This should solve the slow boot problem[1] caused by repeated
stop_machine workqueue creation/destruction reported by Dimitri
Sivanich.

The patchset is currently on top of v2.6.33 and contains the following
patches.

 0001-cpuhog-implement-cpuhog.patch
 0002-stop_machine-reimplement-using-cpuhog.patch
 0003-scheduler-replace-migration_thread-with-cpuhog.patch
 0004-scheduler-kill-paranoia-check-in-synchronize_sched_e.patch

0001 implements cpuhog.  0002 converts stop_machine.  0003 converts
migration users and 0004 removes paranoia checks in
synchronize_sched_expedited().  0004 is done separately so that 0003
can serve as a debug/bisection point.

Tested cpu on/offlining, shutdown, all migration usage paths including
RCU torture test at 0003 and 004 and everything seems to work fine
here.  Dimitri, can you please test whether this solves the problem
you're seeing there?

The tree is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpuhog

diffstat follows.

 Documentation/RCU/torture.txt |   10 -
 arch/s390/kernel/time.c       |    1 
 drivers/xen/manage.c          |   14 -
 include/linux/cpuhog.h        |   24 ++
 include/linux/rcutiny.h       |    2 
 include/linux/rcutree.h       |    1 
 include/linux/stop_machine.h  |   20 --
 kernel/Makefile               |    2 
 kernel/cpu.c                  |    8 
 kernel/cpuhog.c               |  362 ++++++++++++++++++++++++++++++++++++++++++
 kernel/module.c               |   14 -
 kernel/rcutorture.c           |    2 
 kernel/sched.c                |  327 +++++++++----------------------------
 kernel/stop_machine.c         |  162 ++++--------------
 14 files changed, 509 insertions(+), 440 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/957726
