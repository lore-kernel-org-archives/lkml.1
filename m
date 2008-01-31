Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbYAaXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbYAaXpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYAaXpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:45:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40280 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYAaXpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:45:06 -0500
Date: Thu, 31 Jan 2008 16:45:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Pull request: TASK_KILLABLE
Message-ID: <20080131234504.GB25967@parisc-linux.org>
References: <20080129000447.GC31101@parisc-linux.org> <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 10:41:24PM +1100, Linus Torvalds wrote:
> On Mon, 28 Jan 2008, Matthew Wilcox wrote:
> > 
> > I'd like you to pull the task_killable branch of 
> > git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git
> 
> Well, Andrew already pointed out some of this, but I do want more 
> information. There's a "git request-pull" script that even comes with git 
> and that generates a shortlog, a proper url+branch description, and a 
> diffstat of the changes.
> 
> So that is already much more descriptive, but in addition to that, if this 
> isn't one of the "regular" pulls (which it obviously isn't), I really want 
> a human description too so that I know what I'm pulling and what it's all 
> about.
> 
> I do *not* want to be in the position of having to fetch first, just to be 
> able to look at what I'm fetching. By the time I pull a branch, I want to 
> basically know (a) what I'm pulling and (b) why I _want_ to pull it.

OK.  Hopefully this satisfies you:


Introduce TASK_KILLABLE.

The basic idea was Linus', back in 2002.  We can't normally return a
short read because it breaks applications.  But if a task has received
a fatal signal, it doesn't have a chance to notice that it didn't get
all the data it asked for.

To allow tasks to be interrupted by fatal signals, we introduce a new
TASK_* bit; TASK_WAKEKILL.  We also add a predicate fatal_signal_pending;
the counterpart of signal_pending().  Then we add killable versions
of lock_page(), mutex_lock(), schedule_timeout(), wait_event(), and
wait_for_completion().  Finally, we can make the NFS 'intr' mount option
a no-op.

At the end of this patch set, you can now kill a task in readdir(), read()
and write(), at least most of the time.  There is still much more work
that can (and should) be done, such as implementing down_killable(),
lock_kernel_killable() and even spin_lock_killable().

While my main motivation has been to fix problems I have with flaky
wireless networks and/or NFS servers, people like Ingo and Nick Piggin
want to see this infrastructure for helping them improve the OOM killer.

The following changes since commit 8af03e782cae1e0a0f530ddd22301cdd12cf9dc0:
  Linus Torvalds (1):
        Merge branch 'for-2.6.25' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git task_killable

Liam R. Howlett (2):
      Add mutex_lock_killable
      Use mutex_lock_killable in vfs_readdir

Matthew Wilcox (20):
      Use wake_up_locked() in eventpoll
      Add macros to replace direct uses of TASK_ flags
      perfmon: Use task_is_*
      proc/array.c: Use TASK_REPORT
      proc/base.c: Use task_is_*
      wait: Use TASK_NORMAL
      power: Use task_is_*
      ptrace: Use task_is_*
      sched: Use task_contributes_to_load, TASK_ALL and TASK_NORMAL
      signal: Use task_is_*
      exit: Use task_is_*
      Add TASK_WAKEKILL
      Add fatal_signal_pending
      Add lock_page_killable
      Use lock_page_killable
      Add schedule_timeout_killable
      Add wait_event_killable
      Add wait_for_completion_killable
      NFS: Switch from intr mount option to TASK_KILLABLE
      Remove commented-out code copied from NFS

 arch/ia64/kernel/perfmon.c   |    4 +-
 fs/eventpoll.c               |   11 ++---
 fs/nfs/client.c              |    6 +--
 fs/nfs/direct.c              |   10 +----
 fs/nfs/inode.c               |    6 +--
 fs/nfs/mount_clnt.c          |    2 +-
 fs/nfs/nfs3proc.c            |    7 +--
 fs/nfs/nfs4proc.c            |   27 +++---------
 fs/nfs/nfsroot.c             |    3 -
 fs/nfs/pagelist.c            |   18 ++------
 fs/nfs/read.c                |    5 --
 fs/nfs/super.c               |    4 --
 fs/nfs/write.c               |    7 +---
 fs/proc/array.c              |    7 +---
 fs/proc/base.c               |    2 +-
 fs/readdir.c                 |    5 ++-
 fs/smbfs/request.c           |    2 +-
 include/linux/completion.h   |    1 +
 include/linux/mutex.h        |    5 ++
 include/linux/nfs_fs.h       |    9 +----
 include/linux/nfs_mount.h    |    2 +-
 include/linux/pagemap.h      |   14 +++++++
 include/linux/sched.h        |   36 ++++++++++++++++-
 include/linux/sunrpc/clnt.h  |    2 -
 include/linux/sunrpc/sched.h |    2 -
 include/linux/wait.h         |   52 ++++++++++++++++++++++--
 kernel/exit.c                |   88 ++++++++++++++++++-----------------------
 kernel/mutex.c               |   36 ++++++++++++++++-
 kernel/power/process.c       |    6 +-
 kernel/ptrace.c              |    8 ++--
 kernel/sched.c               |   28 +++++++++-----
 kernel/signal.c              |   19 ++++++---
 kernel/timer.c               |    7 +++
 kernel/wait.c                |    2 +-
 mm/filemap.c                 |   25 ++++++++++--
 net/sunrpc/clnt.c            |   47 +---------------------
 net/sunrpc/rpcb_clnt.c       |    3 +-
 net/sunrpc/sched.c           |   15 +++----
 net/sunrpc/sunrpc_syms.c     |    2 -
 39 files changed, 281 insertions(+), 254 deletions(-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
