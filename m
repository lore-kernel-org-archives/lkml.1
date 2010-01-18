Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611Ab0ARA6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0ARA6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435Ab0ARA6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:58:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:54381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0ARAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:32 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: [PATCHSET] concurrency managed workqueue, take#3
Date: Mon, 18 Jan 2010 09:57:12 +0900
Message-Id: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the third take of cmwq (concurrency managed workqueue)
patchset.  It's on top of the current linus#master
066000dd856709b6980123eb39b957fe26993f7b (v2.6.33-rc3).  Git tree is
available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Quilt series is available at

  http://master.kernel.org/~tj/patches/review-cmwq.tar.gz

Changes from the last take[L]
=============================

* Scheduler code to select fallback cpu has changed and caused problem
  with kthread_bind()ing from CPU_DOWN_PREP.  It is fixed by adding
  0001-sched-consult-online-mask-instead-of-active-in-selec.patch.

* 0002-0028 haven't changed but included for completeness.

* 0029-0040 added to convert libata, async, fscache, cifs and gfs2 to
  use workqueue and kill slow-work which after conversion doesn't have
  any user left.

New patches in this series are

 0001-sched-consult-online-mask-instead-of-active-in-selec.patch
 0029-workqueue-add-system_wq-and-system_single_wq.patch
 0030-workqueue-implement-work_busy.patch
 0031-libata-take-advantage-of-cmwq-and-remove-concurrency.patch
 0032-async-introduce-workqueue-based-alternative-implemen.patch
 0033-async-convert-async-users-to-use-the-new-implementat.patch
 0034-async-kill-original-implementation.patch
 0035-fscache-convert-object-to-use-workqueue-instead-of-s.patch
 0036-fscache-convert-operation-to-use-workqueue-instead-o.patch
 0037-fscache-drop-references-to-slow-work.patch
 0038-cifs-use-workqueue-instead-of-slow-work.patch
 0039-gfs2-use-workqueue-instead-of-slow-work.patch
 0040-slow-work-kill-it.patch

0001 is the aforementioned scheduler fix.

0029-0030 prepare wq for conversions.

0031 converts libata to use cmwq and remove concurrency limitations.

0032-0034 reimplement async using two workqueues.

0035-0037 convert fscache to use workqueues instead of slow-work.

0038-0039 convert cifs and gfs2 to use workqueues instead of
slow-work.

0040 kills slow-work which doesn't have any user left.

Please note that slow-work conversion is missing a couple of
capabilities.

* sysctls to control concurrency level.

* workqueue business notification used to make fscache work to yield
  context and retry instead of waiting holding the context.

The former can easily be added.  The latter isn't difficult to add
either but I was a bit doubtful about its usefulness.  David, do you
think this is really needed?

With the above omissions and removal of slow-work documentation, the
the whole series ends up reducing line count by around a hundred
lines.  I'll append diffstat output at the end of this email.

The libata conversion reduces 13 lines of code while removing two
annoying concurrency limitations.

The new async implementation is shorter by about two hundred lines
while providing about the same capability and removing a dedicated
thread pool.

Although there are some minor differences, the capability provided by
slow-work is basically identical to that provided by cmwq.  Other than
few places where slow-work specific features are depended on, the
conversion of slow-work users to cmwq is fairly straight forward.  The
ref count is incremented on queue and decremented at the end of the
callback.  Module draining is replaced with workqueue flushing.
Concurrency limit is replaced with max_active.  The removal of
slow-work brings in the largest code reduction of about 2000 lines and
removes yet another dedicated thread pool.

slow-work is probably the largest chunk which can be replaced by cmwq
but as shown in the libata case small conversions can bring noticeable
benefits and there are other places which have had to deal with
similar limitations.

Please note that the slow-work conversions haven't been signed off
yet.  Those changes need careful review from David before going
anywhere.

Performance test
================

Another issue raised was the performance.  I tried a few things but
couldn't find a realistic and easy test scenario which could expose wq
performance difference.  As many have pointed out, wq just isn't a
very hot path.  I ended up writing a simplistic wq load generator.

wq workload is generated by perf-wq.c module which is a very simple
synthetic wq load generator (I'll post it as a reply to this message).
A work is described by five parameters - burn_usecs, mean_sleep_msecs,
mean_resched_msecs and factor.  It randomly splits burn_usecs into
two, burns the first part, sleeps for 0 - 2 * mean_sleep_msecs, burns
what's left of burn_usecs and then reschedules itself in 0 - 2 *
mean_resched_msecs.  factor is used to tune the number of cycles to
match execution duration.

It issues three types of works - short, medium and long, each with two
burn durations L and S.

	burn/L(us)	burn/S(us)	mean_sleep(ms)	mean_resched(ms) cycles
 short	50		1		1		10		 454
 medium	50		2		10		50		 125
 long	50		4		100		250		 42

And then these works are put into the following workloads.  The lower
numbered workloads have more short/medium works.

 workload 0
 * 12 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 1
 *  8 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 2
 *  4 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 3
 *  2 wqs with 4 short works
 *  2 wqs with 2 short  and 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 4
 *  2 wqs with 4 short works
 *  2 wqs with 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

 workload 5
 *  2 wqs with 2 medium works
 *  4 wqs with 2 medium and 1 long works
 *  8 wqs with 1 long work

The above wq loads are run in parallel with mencoder converting 76M
mjpeg file into mpeg4 which takes 25.59 seconds with standard
deviation of 0.19 without wq loading.  The CPU was intel netburst
celeron running at 2.66GHz (chosen for its small cache size and
slowness).  wl0 and 1 are only tested for burn/S.  Each test case was
run 11 times and the first run was discarded.

	 vanilla/L	cmwq/L		vanilla/S	cmwq/S
 wl0					26.18 d0.24	26.27 d0.29
 wl1					26.50 d0.45	26.52 d0.23
 wl2	26.62 d0.35	26.53 d0.23	26.14 d0.22	26.12 d0.32
 wl3	26.30 d0.25	26.29 d0.26	25.94 d0.25	26.17 d0.30
 wl4	26.26 d0.23	25.93 d0.24	25.90 d0.23	25.91 d0.29
 wl5	25.81 d0.33	25.88 d0.25	25.63 d0.27	25.59 d0.26

There is no significant difference between the two.  Maybe the code
overhead and benefits coming from context sharing are canceling each
other nicely.  With longer burns, cmwq looks better but it's nothing
significant.  With shorter burns, other than wl3 spiking up for
vanilla which probably would go away if the test is repeated, the two
are performing virtually identically.

The above is exaggerated synthetic test result and the performance
difference will be even less noticeable in either direction under
realistic workloads.

cmwq extends workqueue such that it can serve as robust async
mechanism which can be used (mostly) universally without introducing
any noticeable performance degradation.

Thanks.

diffstat
========
 Documentation/slow-work.txt   |  322 -----
 arch/ia64/kernel/smpboot.c    |    2 
 arch/ia64/kvm/Kconfig         |    1 
 arch/powerpc/kvm/Kconfig      |    1 
 arch/s390/kvm/Kconfig         |    1 
 arch/x86/kernel/smpboot.c     |    2 
 arch/x86/kvm/Kconfig          |    1 
 drivers/acpi/battery.c        |    4 
 drivers/acpi/osl.c            |   41 
 drivers/ata/libata-core.c     |   50 
 drivers/ata/libata-eh.c       |    4 
 drivers/ata/libata-scsi.c     |   11 
 drivers/ata/libata.h          |    1 
 drivers/ata/pata_legacy.c     |    2 
 drivers/base/core.c           |    2 
 drivers/base/dd.c             |    2 
 drivers/md/raid5.c            |    4 
 drivers/s390/block/dasd.c     |    4 
 drivers/scsi/sd.c             |    8 
 fs/cachefiles/namei.c         |   28 
 fs/cachefiles/rdwr.c          |    4 
 fs/cifs/Kconfig               |    1 
 fs/cifs/cifsfs.c              |    6 
 fs/cifs/cifsglob.h            |    8 
 fs/cifs/dir.c                 |    2 
 fs/cifs/file.c                |   22 
 fs/cifs/misc.c                |   15 
 fs/fscache/Kconfig            |    1 
 fs/fscache/internal.h         |    2 
 fs/fscache/main.c             |   25 
 fs/fscache/object-list.c      |   12 
 fs/fscache/object.c           |   67 -
 fs/fscache/operation.c        |   67 -
 fs/fscache/page.c             |   36 
 fs/gfs2/Kconfig               |    1 
 fs/gfs2/incore.h              |    3 
 fs/gfs2/main.c                |    9 
 fs/gfs2/ops_fstype.c          |    8 
 fs/gfs2/recovery.c            |   52 
 fs/gfs2/recovery.h            |    4 
 fs/gfs2/sys.c                 |    3 
 include/linux/async.h         |   17 
 include/linux/fscache-cache.h |   49 
 include/linux/kvm_host.h      |    4 
 include/linux/libata.h        |    2 
 include/linux/preempt.h       |   48 
 include/linux/sched.h         |   71 -
 include/linux/slow-work.h     |  163 --
 include/linux/stop_machine.h  |    6 
 include/linux/workqueue.h     |  109 +
 init/Kconfig                  |   28 
 init/do_mounts.c              |    2 
 init/main.c                   |    4 
 kernel/Makefile               |    2 
 kernel/async.c                |  393 +-----
 kernel/irq/autoprobe.c        |    2 
 kernel/module.c               |    4 
 kernel/power/process.c        |   21 
 kernel/sched.c                |  334 +++--
 kernel/slow-work-debugfs.c    |  227 ---
 kernel/slow-work.c            | 1068 ----------------
 kernel/slow-work.h            |   72 -
 kernel/stop_machine.c         |  151 +-
 kernel/sysctl.c               |    8 
 kernel/trace/Kconfig          |    4 
 kernel/workqueue.c            | 2697 ++++++++++++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c           |   26 
 67 files changed, 3120 insertions(+), 3231 deletions(-)

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/929641
