Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbXHCEGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbXHCEGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXHCEGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:06:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43590 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbXHCEGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:06:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: vgoyal@in.ibm.com
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] Handling kernel stack overflows
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 03 Aug 2007 14:05:53 +1000
Message-ID: <31700.1186113953@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First a bit of background for people who are not familiar with kernel
stack constructs.

* Every process has a dedicated kernel stack.  In this context,
  'process' includes user space processes and threads, plus those
  processes that only exist inside the kernel (e.g. kswapd, xfslogd).

* When a process is sleeping, there is some state in its kernel stack
  to let the scheduler wake it up, that stack does not change until the
  scheduler assigns the task to a cpu.  When a processing is running
  and is scheduled on a cpu, it is actively reading and writing its
  stack.

* Kernel stacks are a fixed size.  Unlike user space stacks, they do
  not expand as required.  Also unlike user space stacks, kernel stacks
  are not swappable.

* Each architecture uses different size kernel stacks (defined by
  THREAD_SIZE).  THREAD_SIZE is typically (always?) a multiple of the
  kernel page size.

* When a kernel stack occupies multiple pages, the pages assigned to
  that stack must be physically contiguous and in memory.

* Kernel stacks are typically aligned on a THREAD_SIZE boundary so
  (stack_pointer & ~(THREAD_SIZE - 1)) gives you the start of the
  stack.

* If you overflow the kernel stack for a process then you corrupt the
  next page, with undefined results.  This usually causes very strange
  kernel oops.

* Historically (up to 2.4/2.5 kernels), 'struct task' for a process was
  embedded in the kernel stack for that process, reducing the usable
  amount of stack space.  Variable 'current' pointed to both the
  'struct task' and the kernel stack.

* In more recent kernels, almost all architectures separate 'struct
  task' from the stack.  'struct task' is created via a slab allocator,
  the stack is created from a page allocator.  'current' now points to
  'struct task' which in turn points to the active kernel stack.

* Separating 'struct task' from the stack means that a single 'struct
  task' can point to different kernel stacks throughout its lifetime.
  This makes it possible to use additional kernel stacks for special
  processing like interrupt handling.

* IA64 is different (isn't it always?).  It is the only architecture
  that still embeds 'struct task' within the kernel stack.  I wish that
  it separated the two, it would make MCA/INIT handling so much easier.
  Alas David Mosberger vetoed that approach for IA64.  On IA64,
  'current' still points to both 'struct task' and the kernel stack,
  making it impossible to use specialized kernel stacks on IA64.

* On i386, kernel stacks were historically 8K in size, with all
  processing being done on that single 8K stack (no additional
  specialized stacks).  On i386 boxes with large numbers of processes,
  it became difficult to kmalloc() a kernel stack when forking a new
  process.  Each new process required two physically contiguous pages,
  starting on an 8K boundary.  i386 boxes would often get into a state
  where there were enough free pages, but they were not contiguous and
  8K aligned.

* Interrupt processing can be separated into hard and soft IRQ
  contexts.  Hard IRQ context is when the kernel is servicing the
  hardware, e.g. talking to a disk controller.  To minimize the amount
  of time that the hardware is disabled, most drivers will grab some
  data from the hardware, store the data in a kernel structure,
  schedule some work to be done later then re-enable the hardware.  When
  the kernel returns from a hard interrupt it checks for any scheduled
  work then runs that work in a soft IRQ context.

* Even when an 8K kernel stack could be allocated, 8K was not always
  enough room to cope with an interrupt arriving while a process was
  active.  Normal processing could be interrupted by a hard IRQ which
  could schedule a soft IRQ which could in turn be interrupted by
  another hard IRQ.  Those three levels of processing all had to fit
  into 8K.

* Enter CONFIG_4KSTACKS for i386.  It recognizes that activity on the
  kernel stack only occurs while the process is running, and that much
  of that activity occurs in response to an interrupt, either in hard
  or soft IRQ context.

* By reducing the per-process stack to 4K, CONFIG_4KSTACKS makes it
  easier to allocate the kernel stack for a new process when the system
  is under heavy memory pressure.

* If an interrupt occurs while a CONFIG_4KSTACKS process is running,
  the kernel retains the current task but switches the stack to a
  separate specialized stack.  There are two additional 4K stacks on
  each cpu, for soft and hard IRQ processing.  The combination of the
  normal process stack plus the soft and hard IRQ stacks gives up to
  12K of stack for an active process, instead of the previous total of
  8K.

* By definition, processes cannot sleep in interrupt context.
  Therefore when a process does sleep, it is guaranteed that the soft
  and hard IRQ stacks on that cpu are not in use.  The process state is
  saved in its dedicated 4K stack and the per cpu IRQ stacks are now
  free for the next process which runs on that cpu.

* The downside of CONFIG_4KSTACKS is that the available space for
  normal (non-interrupt) work is now only 4K, down from the 5K to 7.5K
  that was available under the 8K stacks.  Into that 4K space we have
  to fit _ALL_ of the non-interrupt processing, including the VFS
  common code, XFS and the I/O subsystem.

* The block device targeted by the I/O subsystem can be a raw device,
  such as a disk partition or a hardware RAID, in which case the I/O
  path is fairly short.  OTOH, the block device can be network based or
  it can using a device mapper of some kind (including loopback, DM,
  LVM, XVM and software RAID), in which case the kernel has to do more
  work to process the I/O.  That extra work all needs more stack space,
  and it still has to fit into 4K.

* Rule of thumb: somebody will always build an I/O configuration that
  requires multiple levels of nested I/O processing and eventually
  overflows the kernel stack, no matter how big the kernel stack is.

* XFS on 4K stacks on i386 is not the only problem, it is just the most
  prominent outcrop of a very large iceberg.  x86_64 always has an 8K
  normal stack plus separate interrupt stacks (not a config option) but
  even on x86_64, XFS can use up to 55% of the normal stack before it
  submits the I/O.

=====================================================================

Still awake?  Good - now for the RFC.

Short answer:

* Selectively switch to a new stack when the normal stack is in danger
  of filling up.

Long answer:

* Define a config option to control whether or not extra kernel stacks
  are to be used.  Set this config option by default on i386 and
  x86_64, unless EMBEDDED is set, in which case it becomes a user
  selectable option.  It can never be set on IA64, the 'struct task'
  embedded in the stack prevents that.  Decide about other
  architectures as required.

* Create a tunable number of extra kernel stacks on each cpu as it
  boots.  They are created on each cpu to avoid taking all the memory
  from any one node.

* Chain all the extra stacks onto a global free list and set a counting
  semaphore to the total number of extra kernel stacks.  The initial
  design uses a global free list, if necessary we can optimize later
  using per cpu lists for NUMA.

* Pick a _very_ small number of critical points in the kernel where we
  are executing normal code that can sleep and can return an error.
  More on this below.

* At each critical point, if the config option is true we check how
  much of the current stack is in use.  If that figure is less than a
  threshold value then continue with normal processing on the current
  stack, no change.  Checking the stack usage requires an arch specific
  routine.

* If the usage threshold has been reached, do down_trylock() on the
  counting semaphore.  If all of the extra stacks are in use then
  down_trylock() will fail, log a rate limited error and return -EIO.
  The caller will get an I/O error, but that is far better than
  overflowing the kernel stack and crashing the entire machine.

* If the semaphore was non-zero then disable interrupts and take the
  first extra stack off the free list.  Use an arch specific routine to
  switch to this extra stack, maintaining a pointer to the previous
  stack.  Enable interrupts then continue normal processing on the new
  stack.

* On return from the bottom function on the extra stack, that stack
  becomes free.  Disable interrupts, switch back to the previous stack,
  put the extra stack back on the free list, increment the semaphore,
  reenable interrupts and return to your caller, now on the previous
  stack.

* Export the number of extra stacks for reporting, both total and free.

* Allow the total number of extra stacks to be changed at run time.  If
  the value is increased then kmalloc() round each cpu until the
  additional number of stacks have been added to the free list.  If the
  value is decreased then remove entries from the free list and kfree()
  them.  If the new value is less than the number of extra stacks
  currently in use then refuse to honour the new value, it would
  guarantee immediate I/O errors, which is almost certainly a mistake.

=====================================================================

Notice that, unlike the IRQ stacks on i386, it is possible to sleep
while using an extra normal stack.  The vast majority of tasks will
have a very small stack usage when they sleep, so they would only be
using the per-process normal stack.  Processes that are doing heavy I/O
on nested filesystems and I/O paths will sleep deeper into their stack
usage, so they may sleep while they own an extra stack.

Users can tune the number of extra stacks depending on their I/O
workload and configuration.  Low amounts of I/O issued to a non-nested
filesystem on a raw device need a very small number of extra stacks.  A
configuration with high I/O rates, using nested filesystems on software
emulated devices would assign a higher number of extra stacks.  Even if
you set the number too low, the worst case is an I/O error, which is a
huge improvment on stack overflow and a system crash.

I am in two minds about returning -EIO when all the extra stacks are in
use.  Allocating more stacks at that point is not a good idea, high
stack usage is closely correlated with running low on memory, as the
filesystems try to flush memory out to hardware.  An alternative is
just to sleep until an extra stack is freed, but I cannot persuade
myself that this is deadlock free.  Could two processes get into the
state where they both need an extra stack and they are holding other
resources so neither can proceed until either of them has finished?

=====================================================================

Pick a _very_ small number of critical points in the kernel where we
are executing normal code that can sleep and can return an error.

Obviously we do not want to check for stack usage in hundreds of
places, it would complicate the kernel and slow down normal processing.
Changing every single filesystem to add this check is not an option
either, although changing just the network based filesystems might be.

I am currently thinking about checking the stack at a few points in the
common VFS layer, paths which would do I/O and are not holding the BKL.
The first level call to one of these routines would have low stack
usage (just the syscall overhead) so there would be no stack switch.
But when one filesystem is nested on another then the second entry to
VFS would use more stack and could switch if the current usage was too
high.

Alternatively the check could be made when we submit a bio.  The
problem with this approach is that it guarantees that a significant
amount of the stack be already used by the filesystem code.  The trick
there would be deciding if the bio was going to be issued directly to a
device (use the current stack) or if it was going to call back into a
software layer (use an extra stack).

