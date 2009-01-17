Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbZAQCaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbZAQCaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZAQC3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:29:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20669 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbZAQC3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:29:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=EQEHzgCnE9Ganx8CVEHOn5HGW7IqyDolRoOR/72jZv5/SiGB1ccYCoooxVfNckZ9I
	NQYVsBkfz57CnEBN1E/fw==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:29:36 -0800
Message-ID: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've noticed that at times it can become very easy to have a system begin to
livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) when
a lot of dentries are getting finalized at the same time (massive delete and
large fdtable destructions are two paths I've seen cause problems).

This patchset is an attempt to try and reduce the locking overheads associated
with final dput() and final iput().  This is done by batching dentries and
inodes into per-process queues and processing them in 'parallel' to consolidate
some of the locking.

Besides various workload testing, I threw together a load (at the end of this
email) that causes massive fdtables (50K sockets by default) to get destroyed
on each cpu in the system.  It also populates the dcache for procfs on those
tasks for good measure.  Comparing lock_stat results (hardware is a Sun x4600
M2 populated with 8 4-core 2.3GHz packages (32 CPUs) + 128GiB RAM):

BEFORE PATCHSET:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                             dcache_lock:       5666485       10086172          11.16     2274036.47  3821690090.32       11042789       14926411           2.78       42138.28    65887138.46
                             -----------
                             dcache_lock        3016578          [<ffffffff810bd7e7>] d_alloc+0x190/0x1e1
                             dcache_lock        1844569          [<ffffffff810bcdfc>] d_instantiate+0x2c/0x51
                             dcache_lock        4223784          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c
                             dcache_lock         207544          [<ffffffff810bc36a>] d_rehash+0x1b/0x43
                             -----------
                             dcache_lock        2305449          [<ffffffff810bcdfc>] d_instantiate+0x2c/0x51
                             dcache_lock        1954160          [<ffffffff810bd7e7>] d_alloc+0x190/0x1e1
                             dcache_lock        4169163          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c
                             dcache_lock         866247          [<ffffffff810bc36a>] d_rehash+0x1b/0x43

...............................................................................................................................................................................................

                              inode_lock:        202813         203064          12.91      376655.85    37696597.26        5136095        8001156           3.37       15142.77     5033144.13
                              ----------
                              inode_lock          20192          [<ffffffff810bfdbc>] new_inode+0x27/0x63
                              inode_lock              1          [<ffffffff810c6f58>] sync_inode+0x19/0x39
                              inode_lock              5          [<ffffffff810c76b5>] __mark_inode_dirty+0xe2/0x165
                              inode_lock              2          [<ffffffff810c6e92>] __writeback_single_inode+0x1bf/0x26c
                              ----------
                              inode_lock          20198          [<ffffffff810bfdbc>] new_inode+0x27/0x63
                              inode_lock              1          [<ffffffff810c76b5>] __mark_inode_dirty+0xe2/0x165
                              inode_lock              5          [<ffffffff810c70fc>] generic_sync_sb_inodes+0x33/0x31a
                              inode_lock         165016          [<ffffffff8119bd88>] _atomic_dec_and_lock+0x3c/0x5c

...............................................................................................................................................................................................

                       &sbsec->isec_lock:         34428          34431          16.77       67593.54     3780131.15        1415432        3200261           4.06       13357.96     1180726.21






AFTER PATCHSET [Note that inode_lock doesn't even show up anymore]:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                             dcache_lock:       2732103        5254824          11.04     1314926.88  2187466928.10        5551173        9751332           2.43       78012.24    42830806.29
                             -----------
                             dcache_lock        3015590          [<ffffffff810bdb04>] d_alloc+0x190/0x1e1
                             dcache_lock        1966978          [<ffffffff810bd118>] d_instantiate+0x2c/0x51
                             dcache_lock         258657          [<ffffffff810bc3cd>] d_rehash+0x1b/0x43
                             dcache_lock             30          [<ffffffff810b7ad4>] __link_path_walk+0x42d/0x665
                             -----------
                             dcache_lock        2493589          [<ffffffff810bd118>] d_instantiate+0x2c/0x51
                             dcache_lock        1862921          [<ffffffff810bdb04>] d_alloc+0x190/0x1e1
                             dcache_lock         882054          [<ffffffff810bc3cd>] d_rehash+0x1b/0x43
                             dcache_lock          15504          [<ffffffff810bc5e1>] process_postponed_dentries+0x3e/0x29f

...............................................................................................................................................................................................


ChangeLog:
  [v1] - Jan 16, 2009
    - Initial version

Patches in series:

  1)  Deferred batching of dput()
  2)  Parallel dput()
  3)  Deferred batching of iput()
  4)  Fixing iput called from put_super path
  5)  Parallelize iput()
  6)  hugetlbfs drop_inode update
  7)  Make drop_caches flush pending dput()s and iput()s
  8)  Make the sync path drain dentries and inodes

Caveats:

  * It's not clear to me how to make 'sync(2)' do what it should.  Currently we
flush pending dputs and iputs before writing anything out, but presumably,
there may be hidden iputs in the do_sync path that really ought to be
synchronous.
  * I don't like the changes in patch 4 and it should probably be changed to
have the ->put_super callback paths call a synchronous version of iput()
(perhaps sync_iput()?) instead of having to tag the inodes with S_SYNCIPUT.
  * cramfs, gfs2, ocfs2 need to be updated for the new drop_inode semantics.
---

 fs/block_dev.c         |    2 
 fs/dcache.c            |  374 +++++++++++++++++++++++++++++++++++++----
 fs/drop_caches.c       |    1 
 fs/ext2/super.c        |    2 
 fs/gfs2/glock.c        |    2 
 fs/gfs2/ops_fstype.c   |    2 
 fs/hugetlbfs/inode.c   |   72 +++++---
 fs/inode.c             |  441 +++++++++++++++++++++++++++++++++++++++++-------
 fs/ntfs/super.c        |    2 
 fs/smbfs/inode.c       |    2 
 fs/super.c             |    6 -
 fs/sync.c              |    5 +
 include/linux/dcache.h |    1 
 include/linux/fs.h     |   18 ++
 14 files changed, 787 insertions(+), 143 deletions(-)

-- 
// Copyright 2008 Google Inc. All Rights Reserved.
// Author: mikew@google.com (Mike Waychison)
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// Description: Meant to make a kernel go nuts by stressing dcache with
// implosion.

#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <dirent.h>
#include <fcntl.h>
#include <inttypes.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#include <iostream>
#include <string>

using std::cout;
using std::string;

static char *who_am_i;

static bool wait_on_kids = true;
static int files_per_cpu = 50000;
static int wait_before_slaughter = 0;

static const int kMagicSignal = SIGUSR2;

static const int kMaxCPUs = __NCPUBITS;

typedef struct { volatile int counter; } atomic_t;
#define LOCK_PREFIX "lock "
static inline void atomic_inc(atomic_t *v)
{
  __asm__ __volatile__(
    LOCK_PREFIX "incl %0"
    :"=m" (v->counter)
    :"m" (v->counter));
}
#define atomic_read(v)		((v)->counter)
#define atomic_set(v,i)		(((v)->counter) = (i))

static void *shared_area;

static atomic_t *children_done;

#define Abort() DoAbort(__LINE__)
static void DoAbort(int line) {
  cout << "Aborted at line " << line << " errno=" << errno << "\n";
  exit(1);
}

static void InitSharedArea() {
  shared_area = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_SHARED, 0, NULL);
  if (shared_area == MAP_FAILED)
    Abort();
  children_done = static_cast<atomic_t *>(shared_area);
  atomic_set(children_done, 0);
}

static void get_cpu_bitmap(cpu_set_t *bitmap) {
  CPU_ZERO(bitmap);
  if (sched_getaffinity(0, sizeof(*bitmap), bitmap) < 0)
    Abort();
}

static void run_child(int cpu) {
  // Start by setting our own SIGTERM handler to avoid google3 fallout
  signal(SIGTERM, SIG_DFL);

  // Pin ourselves to the cpu
  cpu_set_t cpumask;
  CPU_ZERO(&cpumask);
  CPU_SET(cpu, &cpumask);
  if (sched_setaffinity(0, sizeof(cpumask), &cpumask) < 0)
    Abort();

  // Start off by creating tons of open sockets.  Well just make dummy sockets
  // for now.
  printf("Making sockets\n");
  for (int i = 0; i < files_per_cpu; i++) {
    if (socket(PF_INET, SOCK_STREAM, 0) < 0) {
      printf("Ran out of file descriptors? errno == %d\n", errno);
      kill(getppid(), SIGABRT);
      exit(0);
    }
  }
  printf("Done making sockets\n");

  // Now populate the proc_inode_cache
  pid_t my_pid = getpid();
  char fd_path[100];
  sprintf(fd_path, "/proc/%d/fd", my_pid);
  struct stat stat_dat2;
  if (lstat(fd_path, &stat_dat2) < 0)
    Abort();
  cout << "Mode : " << stat_dat2.st_mode << "\n";
  DIR *dir = opendir(fd_path);
  if (dir == static_cast<DIR *>(NULL))
    Abort();

  printf("Done opening fd directory\n");
  dirent *dirent;
  while ((dirent = readdir(dir)) != NULL) {
    // Now stat it to make sure it gets populated in dcache
    char file_path[100];
    sprintf(file_path, "/proc/%d/fd/%s", my_pid, dirent->d_name);
    struct stat stat_dat;
    if (lstat(file_path, &stat_dat) < 0)
      Abort();
  }
  closedir(dir);
  printf("Done looking at directory\n");

  // Now tell the parent that we are done
  atomic_inc(children_done);

  // And wait around to die
  for (;;) {
    timeval tv = {1, 0};
    // Poke the parent
    if (atomic_read(children_done) != 0)
      kill(getppid(), kMagicSignal);
    select(0, NULL, NULL, NULL, &tv);
  }

  Abort();
}

static void handle_sigusr1(int signum) {
}

static void make_child(int cpu, pid_t *child_pids) {
  // Set up signal so that we know when the child is done.
  if (signal(kMagicSignal, handle_sigusr1) == SIG_ERR)
    Abort();

  pid_t pid;
  if ((pid = fork()) < 0)
    Abort();
  if (pid == 0) {
    run_child(cpu);
    return;
  }

  // Parent
  child_pids[cpu] = pid;

  // Nothing left to do for this child
}

static void crank_up_filemax() {
  int fd;
  if ((fd = open("/proc/sys/fs/file-max", O_RDWR)) < 0)
    Abort();
  char msg[100];
  sprintf(msg, "%d\n", files_per_cpu * kMaxCPUs);
  write(fd, msg, strlen(msg));
  close(fd);
}

static void UsageAndDie() {
  cout << "Usage: Hurt a kernel with fd implosion\n";
  cout << who_am_i << " [options]\n";
  cout << "  --dont_wait_on_kids : Exit before kids are dead\n";
  cout << "  --files_per_cpu <n> : How many files should be created per cpu"
          " (default 50000)\n";
  cout << "  --wait_before_slaugther <secs> : Do we sleep before killing "
          "children? (default 0)";
  exit(1);
}

static int ParseInt(char *arg)
{
  char *endp;
  int ret;
  ret = (int)strtol(arg, &endp, 0);
  if (*endp) {
    cout << "Argument '" << arg << "' not an integer\n";
    UsageAndDie();
  }
  return ret;
}

static void ParseArgs(int argc, char **argv)
{
  who_am_i = argv[0];
  argc--;
  argv++;

  while (argc) {
    if (!strcmp(argv[0], "--wait_on_kids")) {
      if (argc < 2)
        UsageAndDie();
      wait_on_kids = ParseInt(argv[1]);
      argc -= 2;
      argv += 2;
      continue;
    }
    if (!strcmp(argv[0], "--files_per_cpu")) {
      if (argc < 2)
        UsageAndDie();
      files_per_cpu = ParseInt(argv[1]);
      argc -= 2;
      argv += 2;
      continue;
    }
    if (!strcmp(argv[0], "--dont_wait_on_kids")) {
      wait_on_kids = false;
      argc -= 1;
      argv += 1;
      continue;
    }
    cout << "Don't understand option " << argv[0] << "\n";
    UsageAndDie();
  }
}
int main(int argc, char **argv) {
  ParseArgs(argc, argv);
  if (getuid() != 0) {
    cout << "This program must be run as root\n";
    Abort();
  }

  InitSharedArea();

  crank_up_filemax();

  // Up our count of allowable open files
  struct rlimit new_limits = {files_per_cpu + 20,
                              files_per_cpu + 20};
  if (setrlimit(RLIMIT_NOFILE, &new_limits) < 0)
    Abort();

  cpu_set_t cpu_bitmap;
  get_cpu_bitmap(&cpu_bitmap);

  pid_t child_pids[kMaxCPUs];

  // Build all the children
  int childCount = 0;
  for (int i = 0; i < kMaxCPUs; i++) {
    if (CPU_ISSET(i, &cpu_bitmap)) {
      cout << "About to run child on cpu" << i << "\n";
      make_child(i, child_pids);
      childCount++;
    }
  }

  // Wait for all the children to finish
  for (;;) {
    if (atomic_read(children_done) == childCount) {
      atomic_set(children_done, 0);
      break;
    }
    timeval tv = {1, 0};
    select(0, NULL, NULL, NULL, &tv);
  }

  sleep(wait_before_slaughter);

  cout << "About to start killing children\n";

  timeval before_tv;
  gettimeofday(&before_tv, NULL);

  // Now kill all the children
  for (int i = 0; i < kMaxCPUs; i++) {
    if (CPU_ISSET(i, &cpu_bitmap)) {
      kill(child_pids[i], SIGTERM);
    }
  }

  // Wait on em
  if (wait_on_kids) {
    for (int i = 0; i < kMaxCPUs; i++) {
      if (CPU_ISSET(i, &cpu_bitmap)) {
        int status;
        waitpid(child_pids[i], &status, 0);
      }
    }
  }

  timeval after_tv;
  gettimeofday(&after_tv, NULL);

  int seconds = after_tv.tv_sec - before_tv.tv_sec;
  uint64_t millisecs = seconds * 1000;
  millisecs += (after_tv.tv_usec - before_tv.tv_usec) / 1000;
  seconds = millisecs / 1000;
  millisecs %= 1000;

  char buf[100];
  sprintf(buf, "%d.%03" PRIu64, seconds, millisecs);
  cout << "do_exit path for run took " << buf << " seconds\n";

  return 0;
}
