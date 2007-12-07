Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXLGTEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXLGTEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXLGTEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:04:00 -0500
Received: from picton.eecg.toronto.edu ([128.100.10.141]:53785 "EHLO
	picton.eecg.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXLGTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:04:00 -0500
X-Greylist: delayed 2730 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 14:03:59 EST
Date: Fri, 7 Dec 2007 13:18:17 -0500
From: Livio Soares <livio@eecg.toronto.edu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Mark rwsem functions as __sched for wchan/profiling
Message-ID: <20071207181817.GA16367@eecg.toronto.edu>
Mail-Followup-To: Livio Soares <livio@eecg.toronto.edu>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  This following commit

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fdf8cb0909b531f9ae8f9b9d7e4eb35ba3505f07

  un-inlined  a  low-level   rwsem  function,  but  did  not   mark  it  as
__sched. The  result is that  it now shows  up as thread wchan  (which also
affects  /proc/profile stats).  The  following simple  patch fixes  this by
properly marking rwsem_down_failed_common() as a __sched function.

  Also in  this patch,  which is up  for discussion, marks  down_read() and
down_write() proper as __sched. For profiling, it is pretty much useless to
know  that a  semaphore is  beig help  - it  is necessary  to  know _which_
one. By going  up another frame on the stack,  the information becomes much
more useful.

  In  summary, the  below  change  to lib/rwsem.c  should  be applied;  the
changes to  kernel/rwsem.c could be  applied if other kernel  hackers agree
with  my  proposal that  down_read()/down_write()  in  the  profile is  not
enough.

  Cheers,

			Livio

Signed-off-by: Livio Soares <livio@eecg.toronto.edu>

 kernel/rwsem.c |    4 ++--
 lib/rwsem.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc2.orig/lib/rwsem.c	2007-11-06 16:57:46.000000000 -0500
+++ linux-2.6.24-rc2/lib/rwsem.c	2007-12-05 20:03:43.000000000 -0500
@@ -146,7 +146,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 /*
  * wait for a lock to be granted
  */
-static struct rw_semaphore *
+static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
 			struct rwsem_waiter *waiter, signed long adjustment)
 {
--- linux-2.6.24-rc2.orig/kernel/rwsem.c	2007-11-06 16:57:46.000000000 -0500
+++ linux-2.6.24-rc2/kernel/rwsem.c	2007-12-05 21:09:55.000000000 -0500
@@ -15,7 +15,7 @@
 /*
  * lock for reading
  */
-void down_read(struct rw_semaphore *sem)
+void __sched down_read(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
@@ -42,7 +42,7 @@ EXPORT_SYMBOL(down_read_trylock);
 /*
  * lock for writing
  */
-void down_write(struct rw_semaphore *sem)
+void __sched down_write(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);

