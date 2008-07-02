Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYGBPej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYGBPej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 11:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbYGBPeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 11:34:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:37952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYGBPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 11:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=R23GCdSK3jKKnQ/6YqFQoIm+hlq6sssaTAunGtXnYnCx1CwpLyTG99xZ/VJE3w9q7j
         5hMDIKTtJaPZkBq+63c4lt1vjmYroJvotzQVvprRkMHieY7z/sI2E4gCe2hinuZ815Kg
         VewnP03feLG2DL+T0EHpu3BrjMDA8vqczHgaU=
Message-ID: <7c86c4470807020834p5f17fb83rbcaf80042f5ea052@mail.gmail.com>
Date: Wed, 2 Jul 2008 17:34:28 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: linux-kernel@vger.kernel.org
Subject: perfmon2 syscall interface rationale
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been asked several times to provide an explanation of the
syscall interface
currently implemented in perfmon2. This is the goal of the text that
follows. It describes
the structure of a monitoring session and some of the basic
expectations. Those have
driven the current design which is explained in the second part.

The design is not fixed, it can certainly evolve. In the very last
section, I try to elaborate
on how we could make the interface easier and safer to extend.

Feedback welcomed.
Thanks.

----------------------------------------------------------------------------------------------------------------------------

1) monitoring session breakdown

A monitoring session can be decomposed into a sequence of fundamental
actions which
are as follows:
       - create the session
       - program registers
       - attach to target thread or CPU
       - start monitoring
       - stop monitoring
       - read results
       - detach from thread or CPU
       - terminate session

The order may not necessarily be like shown. For instance, the
programming may happen
after the session has been attached. Obviously, the start/stop operations may be
repeated before results are read and results can be read multiple times.

In the next sections, we examine each action separately.

2) session creation

  Perfmon2 supports 2 types of sessions: per-thread or per-CPU (so
called system-wide)

  During the creation of the session, certain attributes are set, they
remain until the
  session is terminated. For instance, the per-cpu attribute cannot be changed.

  During creation, the kernel state to support the session is
allocated and initialized.
  No PMU hardware is actually accessed. Permissions to create a
session may be checked.
  Resource limits are also validated and memory consumption is accounted for.

  The software state of the PMU is initialized, i.e., all
configuration registers are
  set to a quiescent value. Data registers are initialized to zero
whenever possible.

  Upon return, the kernel returns a unique identifier which is to be
used for all
  subsequent actions on the session.

3) programming the registers

  Programming of the PMU registers can occur at any time during the
lifetime of a session,
  the session does not need to be attached to a thread of CPU.

  It may be necessary to change the settings, e.g., monitor another
event or reset the counts
  when sampling at the user level. Thus, the writing of the registers
MUST be decoupled from
  the creation of the session.

  Similarly, writing of configuration and data registers must also be
decoupled. Data
  registers may be reprogrammed independently of their configuration
registers, such as
  when sampling, for instance.

  The number of registers varies a lot from one PMU to the other. The
relationships between
  configuration and data registers can be more complex than just
one-to-one. On most PMU,
  writing of the PMU registers requires running at the most privileged
level, i.e., in the
  kernel. To amortize the cost of a system call, it is interesting to
program multiple
  registers in one call. Thus, it must be possible to pass vector
arguments. Of course,
  for security reasons, the system administrator may impose a limit on
how big vectors can
  actually be. The advantage is that vectors can vary in size and thus
the amount of data
  passed between application and kernel can be optimized to be just
the minimal needed.
  System call data needs to be copied into the kernel memory space
before it can be used.

4) attachment and detachment

 A session can be attached to a kernel-visible thread or a CPU. If
there is attachment,
 then it must be possible to detach the session to possibly re-attach
it to another thread
 or CPU. Detachment should not require destroying the session.

 There are 3 possibilities for attachment:
       - when the session is created
       - when the monitoring is activated
       - with a dedicated call

 If the attachment is done during the creation of the session, then it
means the target (thread or CPU)
 must to exist at that time. For a per-cpu session, this means that
the session must be created while
 executing on that CPU. This does not seem unreasonable especially on
NUMA systems.

 For a per-thread session however, this is a bit more problematic as
this means it is not possible
 to prepare the session and the PMU registers before the thread
exists. When monitoring across fork
 and pthread_create, it is important to minimize overhead. Creation of
a session can trigger complex
 memory allocations in the kernel. Thus, it may be interesting to
prepare a batch of ready-to-go sessions,
 which just need to be attached when the fork or pthread_create
notification arrives.

 If the attachment is coupled with the creation of the session, it
implies that the detachment is coupled
 with its destruction, by symmetry. Coupling of detachment with
termination is problematic for both
 per-thread and CPU-wide mode. With the former, the termination of a
thread is usually totally asynchronous
 with the termination of the session by the monitoring tool. The only
case where they are synchronized is for
 self-monitored threads. When a tool is monitoring a thread in another
process, the termination of that thread
 will cause the kernel to detach the session. But the session must not
be closed because the tool likely wants
 to read the results. For CPU-wide, there is also an issue when a
monitored CPU is put off-line dynamically as
 the session is detached by the kernel,  but it could not be destroyed
because the tool still exists.
 Although it is conceivable to let the session is this transient state
of detached but not destroyed, there
 would be no possibility for the tool to re-attach the session
elsewhere. The only operation possible would
 be read the results and terminate.

 If the attachment is done when monitoring is activated, then the
detachment is done when monitoring
 is deactivated. The following relationships are therefore enforced:

       attached => activated
       stopped  => detached

 It is expected that start/stop operations could be very frequent for
self-monitored workloads. When used
 to monitor small sections of critical code, e.g., loop kernels, it is
important to minimize overhead, thus
 the start/stop should be as simple as possible.

 Attaching requires loading the PMU machine state onto the PMU
hardware. Conversely, detaching implies flushing
 the PMU state to memory so results can be read even after the
termination of a thread, for instance.  Both
 operations are expensive due to the high cost of accessing the PMU registers.

 Furthermore, there are certain PMU models, e.g., Intel Itanium, where
it is possible to let user level code
 start/stop monitoring with a single instruction. To minimize
overhead, it is very important to allow this
 mechanism for self-monitored programs. Yet the session would have to
be attached/detached somehow. With
 dedicated attach/detach calls, this can be supported transparently.
One possible work-around with the coupled
 calls would be to require a system call to attach the session and do
the initial activation, subsequent
 start/stop could use the lightweight instruction. The session would
be stopped and detached with a system call.

 The dedicated attach/detach calls offer a maximum level of
flexibility. The let applications create sessions
 in advance or on-demand. The actions on the session, start/stop and
attach/detach, are perfectly symmetrical.
 The termination of the monitored target can cause its detachment, but
the session remains accessible. Issuing
 of the detach call on a session already detached by the kernel is
harmless. The cost of start/stop is not
 impacted. The following properties are enforced:

       attachment => monitoring stopped
       detachment => monitoring stopped

5) start and stop

 It must be possible for an application to start and stop monitoring
at will and at any moment.
 Start and stop can be called very frequently and not just at the
beginning and end of a session.
 This is especially likely for self-monitored threads where it is
customary to monitor execution of
 only one function or loop. Thus those operations can be on the
critical path and they must therefore
 by as lightweight as possible. See the discussion in the section
about attachment and detachment.


6) reading the results

 The results are extracted by reading the PMU registers containing
data (as opposed to configuration).
 The number of registers of interest can vary based on the PMU model,
the type of measurement, the events
 measured.

 Reading can occur at regular interval, e.g., time-based user level
sampling, and can therefore be on the
 critical path. Thus it must as lightweight as possible. Given that
the cost of dominated by the latency
 of accessing the PMU registers, it is important to only read the
registers that are used. Thus, the call
 must provide vector arguments just like for the calls to program the PMU.

 It must be possible to read the registers while the session is
detached but also when it is attached to a
 thread or CPU.

7) termination

 Termination of a session means all the associated resources are
either released to the free pool or destroyed.
 After termination, no state remains. Termination implies, stopping
monitoring and detaching the session if
 necessary.

 For the purpose of termination, one has to differentiate between the
monitored entity and the controlling entity.
 When a tool monitors a thread in another process, all the threads
from the tool are controlling entities, and the
 monitored thread is the monitored entity. Any entity can vanish at any time.

 If the monitored entity terminates voluntarily, i.e., normal exit, or
involuntarily, e.g., core dump, the kernel
 simply detaches the session but it is not destroyed.

 Until the last controlling entity disappears, the session remains accessible.

 There are situations where all the controlling entities disappear
before the monitored entity. In this case, the
 session becomes useless, results cannot be extracted, thus the
session enters the zombie state. It will
 eventually be detached and its resources will be reclaimed by the
kernel, i.e., the session will be terminated.

8) extensibility

  There is already a vast diversity with existing PMU models, this is
unlikely to change, quite to the contrary
  it is envisioned that the PMU will become a true valid-add and that
vendors will therefore try to differentiate
  one from the other. Moreover, the PMU will remain closely tied to
the underlying micro-architecture. Therefore,
  it is very important to ensure that the monitoring interface will be
able to adapt easily to future PMU models
  and their extended features, i.e., what is offered beyond counting events.

  It is important to realize that extensibility is not limited to
supporting more PMU registers. It also includes
  supporting advanced sampling features or socket-level PMUs as
opposed to just core-level PMUs.

  It may be necessary to extend the system calls with new generic or
architecture specific parameters, and this
  without simply adding new system calls.

9) current perfmon2 interface

  The perfmon2 interface design is guided by the principles described
in the previous sections.
  We now explain each call is details.

  As requested by the LKML community, the interface uses multiple
system calls, one per action, instead
  of a single multiplexing call, similar to ioctl(). Conseaquently,
the number of syscalls is fairly large.
  It should be possible, however, to mix the two as certain operations
are similar in nature.

  a) session creation

     int pfm_create_session(struct pfarg_ctx *ctx, char *smpl_name,
void *smpl_arg, size_t arg_size);

     The function creates the perfmon session and returns a file
descriptor used to manipulate the session
     thereafter.

     The calls takes several parameters which are as follows:
        - pfarg_ctx: encapsulates all session parameters (see below)
        - smpl_name: used when sampling to designate which format to use
        - smpl_arg:  point to format-specific arguments
        - smpl_size:  size of the structure passed in smpl_arg

     The pfarg_ctx structure is defined as follows:
        - flags: generic and arch-specific flags for the session
        - reserved: reserved for future extensions

     To provide for future extensions, the pfarg_ctx structure
contains reserved fields. Reserved fields
     must be zeroed.

     To create a per-cpu session, the value PFM_CTX_SYSTEM_WIDE must
be passed in flags.

     When in-kernel sampling is not used smpl_name, smpl_arg, arg_size
must be 0.

  b) programming the registers

     int pfm_write_pmcs(int fd, struct pfarg_pmc *pmcs, int n);
     int pfm_write_pmds(int fd, struct pfarg_pmd *pmds, int n);

     The calls are provided to program the configuration and data
registers respectively. The parameters are
     as follows:
        - fd: file descriptor identifying the session
        - pmc: pointer to parg_pmc structures
        - pmd: pointer to parg_pmd structures
        - n : number of elements in the pmc or pmd vector

     It is possible to pass vector of parg_pmc or pfarg_pmd registers.
The minimal size is 1, maximum size is
     determined by system administrator.

     The pfarg_pmc structure is defined as follows:
     struct pfarg_pmc {
        u16 reg_num;
        u64 reg_value;
        u64 reserved[];
     };

     The pfarg_pmd structure is defined as follows:
     struct pfarg_pmd {
        u16 reg_num;
        u64 reg_value;
        u64 reserved[];
     };

     Although both structures are currently identical, they will
differ as more functionalities are added so better
     to create two versions from the start.

     Provisions for extensions are provided by the reserved field in
each structure.


  c) attachment and detachment

     int pfm_load_context(int fd, struct pfarg_load *ld);
     int pfm_unload_context(int fd);

     The session is identified by the file descriptor, fd.

     To attach, the targeted thread or CPU must be provided. For
extensibility purposes, the target is passed in
     in structure which is defined as follows:
     struct pfarg_load {
        u32 target;
        u64 reserved[];
     };
     In per-thread mode, the target field must be set to the kernel
thread identification (gettid()).

     In per-cpu mode, the target field must be set to the logical CPU
identification as seen by the kernel.
     Furthermore, the caller must be running on the CPU to monitor
otherwise the call fails.

     Extensions can be implemented using the reserved field.


  d) start and stop

     int pfm_start(int fd);
     int pfm_stop(int fd);

     The session is identified by the file descriptor fd.

     Currently no other parameters are supported for those calls.


   e) reading results

     int pfm_read_pmds(int fd, struct pfarg_pmd *pmds, int n);


     The session is identified by the file descriptor fd.

     Just like for programming the registers, it is possible to pass
vectors of structures in pmds. The number
     of elements is passed in n.


   f) termination

     int close(fd);

     To terminate a session, the file descriptor has to be closed. The
semantics of file descriptor sharing
     applies, so if another reference to the session, i.e., another
file descriptor exists, the session will
     only be effectively destroyed, once that reference disappears.

     Of course, the kernel does close all file descriptor on process
termination, thus the associated sessions
     will eventually be destroyed.

     In per-cpu mode, it is not necessary, though recommended, to be
on the monitored CPU to issue this call.


   g) addressing extensibility issues

      Most data structure have provisions for reserved fields which
can be used to support new features.
      Reserved fields are supposed to be set to 0. This works as long
as 0 means 'do nothing' in the future
      extensions.

      It was suggested to us (Anrd Bergmann) that we could
introduce/leverage a flags field in each struct to indicate
      explicitly that a new feature is actually used. Such flag could
be in the data structure, but it could also be
      introduced at the syscall level whenever it makes sense. The
idea is similar to what is going on today with the
      open() syscall and the O_CREAT flag which triggers the lookup of
the 3rd argument to the syscall. Note that such
      mechanism would not alleviate the need for reserved fields in
structure. At the syscall level, there is no
      reserved parameters, however, the mechanism would allow
introducing new paramters to a syscall.

      If such mechanism is agreed upon by most people, then it should
not be too hard to make the changes, though it
      would possibly break existing applications.
