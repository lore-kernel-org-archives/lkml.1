Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYGCPgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYGCPgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYGCPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:36:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:10532 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYGCPg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=B1p80br+V/G1u11VXG39w+d+d79+Qxo1ws/69vLZZ60TNY0WiAL9lxhvjNvHvK5L6U
         kwXpFp87aOQxoIeK3zpaFfMa4Mqx/HA8bPHXleLzGSOktrj6ti/epAK+4kBptr9Stsjw
         N2WX+hcqbKs7hzWzuGadXbrRXRlmsZftME7hk=
Message-ID: <7c86c4470807030836w24450087p8fcde82c9f622a98@mail.gmail.com>
Date: Thu, 3 Jul 2008 17:36:25 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: linux-kernel@vger.kernel.org
Subject: perfmon2 syscall interface rationale v2
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Ingo Molnar" <mingo@elte.hu>, mtk.manpages@googlemail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following some of the comments I received, I have updated the
description of the perfmon2
syscall interface. In the new section 10, there is a proposal for a
revised interface which
takes more into account extensibility concerns and reduces the number
of syscalls. Note
that section 10 describes the full interface, including event set and
multiplexing, sampling.

If you've seen the previous version of this description, you can skip
to section 10.

Comments welcomed.

Thanks.

====================================================================================

1) monitoring session breakdown

A monitoring session can be decomposed into a sequence of fundamental actions
which are as follows:
       - create the session
       - program registers
       - attach to target thread or CPU
       - start monitoring
       - stop monitoring
       - read results
       - detach from thread or CPU
       - terminate session

The order may not necessarily be like shown. For instance, the programming may
happen after the session has been attached. Obviously, the start/stop
operations may be repeated before results are read and results can be read
multiple times.

In the next sections, we examine each action separately.

2) session creation

  Perfmon2 supports 2 types of sessions: per-thread or per-CPU (so called
  system-wide)

  During the creation of the session, certain attributes are set, they remain
  until the session is terminated. For instance, the per-cpu attribute cannot
  be changed.

  During creation, the kernel state to support the session is allocated and
  initialized. No PMU hardware is actually accessed. Permissions to create a
  session may be checked. Resource limits are also validated and memory
  consumption is accounted for.

  The software state of the PMU is initialized, i.e., all configuration
  registers are set to a quiescent value. Data registers are initialized to
  zero whenever possible.

  Upon return, the kernel returns a unique identifier which is to be used for
  all subsequent actions on the session.

3) programming the registers

  Programming of the PMU registers can occur at any time during the lifetime
  of a session, the session does not need to be attached to a thread of CPU.

  It may be necessary to change the settings, e.g., monitor another event or
  reset the counts when sampling at the user level. Thus, the writing of the
  registers MUST be decoupled from the creation of the session.

  Similarly, writing of configuration and data registers must also be
  decoupled. Data registers may be reprogrammed independently of their
  configuration registers, such as when sampling, for instance.

  The number of registers varies a lot from one PMU to the other. The
  relationships between configuration and data registers can be more complex
  than just one-to-one. On most PMU, writing of the PMU registers requires
  running at the most privileged level, i.e., in the kernel. To amortize the
  cost of a system call, it is interesting to program multiple registers in
  one call. Thus, it must be possible to pass vector arguments. Of course, for
  security reasons, the system administrator may impose a limit on how big
  vectors can actually be. The advantage is that vectors can vary in size and
  thus the amount of data passed between application and kernel can be
  optimized to be just the minimal needed.  System call data needs to be
  copied into the kernel memory space before it can be used.

4) attachment and detachment

 A session can be attached to a kernel-visible thread or a CPU. If there is
 attachment, then it must be possible to detach the session to possibly
 re-attach it to another thread or CPU. Detachment should not require
 destroying the session.

 There are 3 possibilities for attachment:
       - when the session is created
       - when the monitoring is activated
       - with a dedicated call

 If the attachment is done during the creation of the session, then it means
 the target (thread or CPU) must to exist at that time. For a per-cpu session,
 this means that the session must be created while executing on that CPU.
 This does not seem unreasonable especially on NUMA systems.

 For a per-thread session however, this is a bit more problematic as this
 means it is not possible to prepare the session and the PMU registers before
 the thread exists. When monitoring across fork and pthread_create, it is
 important to minimize overhead. Creation of a session can trigger complex
 memory allocations in the kernel. Thus, it may be interesting to prepare a
 batch of ready-to-go sessions, which just need to be attached when the fork
 or pthread_create notification arrives.

 If the attachment is coupled with the creation of the session, it implies
 that the detachment is coupled with its destruction, by symmetry. Coupling of
 detachment with termination is problematic for both per-thread and CPU-wide
 mode. With the former, the termination of a thread is usually totally
 asynchronous with the termination of the session by the monitoring tool. The
 only case where they are synchronized is for self-monitored threads. When a
 tool is monitoring a thread in another process, the termination of that
 thread will cause the kernel to detach the session. But the session must not
 be closed because the tool likely wants to read the results. For CPU-wide,
 there is also an issue when a monitored CPU is put off-line dynamically as
 the session is detached by the kernel,  but it could not be destroyed because
 the tool still exists.  Although it is conceivable to let the session is this
 transient state of detached but not destroyed, there would be no possibility
 for the tool to re-attach the session elsewhere. The only operation possible
 would be read the results and terminate.

 If the attachment is done when monitoring is activated, then the detachment
 is done when monitoring is deactivated. The following relationships are
 therefore enforced:

       attached => activated
       stopped  => detached

 It is expected that start/stop operations could be very frequent for
 self-monitored workloads. When used to monitor small sections of critical
 code, e.g., loop kernels, it is important to minimize overhead, thus the
 start/stop should be as simple as possible.

 Attaching requires loading the PMU machine state onto the PMU hardware.
 Conversely, detaching implies flushing the PMU state to memory so results
 can be read even after the termination of a thread, for instance.  Both
 operations are expensive due to the high cost of accessing the PMU registers.

 Furthermore, there are certain PMU models, e.g., Intel Itanium, where it is
 possible to let user level code start/stop monitoring with a single
 instruction. To minimize overhead, it is very important to allow this
 mechanism for self-monitored programs. Yet the session would have to be
 attached/detached somehow. With dedicated attach/detach calls, this can be
 supported transparently. One possible work-around with the coupled calls
 would be to require a system call to attach the session and do the initial
 activation, subsequent start/stop could use the lightweight instruction.
 The session would be stopped and detached with a system call.

 The dedicated attach/detach calls offer a maximum level of flexibility. The
 let applications create sessions in advance or on-demand. The actions on the
 session, start/stop and attach/detach, are perfectly symmetrical.  The
 termination of the monitored target can cause its detachment, but the session
 remains accessible. Issuing of the detach call on a session already detached
 by the kernel is harmless. The cost of start/stop is not impacted. The
 following properties are enforced:

       attachment => monitoring stopped
       detachment => monitoring stopped

5) start and stop

 It must be possible for an application to start and stop monitoring at will
 and at any moment.  Start and stop can be called very frequently and not just
 at the beginning and end of a session.  This is especially likely for
 self-monitored threads where it is customary to monitor execution of only one
 function or loop. Thus those operations can be on the critical path and they
 must therefore by as lightweight as possible. See the discussion in the
 section about attachment and detachment.


6) reading the results

 The results are extracted by reading the PMU registers containing data
 (as opposed to configuration).  The number of registers of interest can vary
 based on the PMU model, the type of measurement, the events measured.

 Reading can occur at regular interval, e.g., time-based user level sampling,
 and can therefore be on the critical path. Thus it must as lightweight as
 possible. Given that the cost of dominated by the latency of accessing the
 PMU registers, it is important to only read the registers that are used.
 Thus, the call must provide vector arguments just like for the calls to
 program the PMU.

 It must be possible to read the registers while the session is detached but
 also when it is attached to a thread or CPU.

7) termination

 Termination of a session means all the associated resources are either
 released to the free pool or destroyed.  After termination, no state remains.
 Termination implies, stopping monitoring and detaching the session if
 necessary.

 For the purpose of termination, one has to differentiate between the
 monitored entity and the controlling entity.  When a tool monitors a thread
 in another process, all the threads from the tool are controlling entities,
 and the monitored thread is the monitored entity. Any entity can vanish at
 any time.

 If the monitored entity terminates voluntarily, i.e., normal exit, or
 involuntarily, e.g., core dump, the kernel simply detaches the session but
 it is not destroyed.

 Until the last controlling entity disappears, the session remains accessible.

 There are situations where all the controlling entities disappear before the
 monitored entity. In this case, the session becomes useless, results cannot
 be extracted, thus the session enters the zombie state. It will eventually be
 detached and its resources will be reclaimed by the kernel, i.e., the session
 will be terminated.

8) extensibility

  There is already a vast diversity with existing PMU models, this is unlikely
  to change, quite to the contrary it is envisioned that the PMU will become a
  true valid-add and that vendors will therefore try to differentiate one from
  the other. Moreover, the PMU will remain closely tied to the underlying
  micro-architecture. Therefore, it is very important to ensure that the
  monitoring interface will be able to adapt easily to future PMU models
  and their extended features, i.e., what is offered beyond counting events.

  It is important to realize that extensibility is not limited to supporting
  more PMU registers. It also includes supporting advanced sampling features
  or socket-level PMUs as opposed to just core-level PMUs.

  It may be necessary to extend the system calls with new generic or
  architecture specific parameters, and this without simply adding new system
  calls.

9) current perfmon2 interface

  The perfmon2 interface design is guided by the principles described in the
  previous sections.  We now explain each call is details.

  As requested by the LKML community, the interface uses multiple system calls,
  one per action, instead of a single multiplexing call, similar to ioctl().
  Consequently, the number of syscalls is fairly large.  It should be possible,
  however, to mix the two as certain operations are similar in nature.

  a) session creation

     int pfm_create_session(struct pfarg_ctx *ctx, char *smpl_name,
void *smpl_arg, size_t arg_size);

     The function creates the perfmon session and returns a file descriptor
     used to manipulate the session thereafter.

     The calls takes several parameters which are as follows:
        - pfarg_ctx: encapsulates all session parameters (see below)
        - smpl_name: used when sampling to designate which format to use
        - smpl_arg:  point to format-specific arguments
        - smpl_size:  size of the structure passed in smpl_arg

     The pfarg_ctx structure is defined as follows:
        - flags: generic and arch-specific flags for the session
        - reserved: reserved for future extensions

     To provide for future extensions, the pfarg_ctx structure contains
     reserved fields. Reserved fields must be zeroed.

     To create a per-cpu session, the value PFM_CTX_SYSTEM_WIDE must
be passed in flags.

     When in-kernel sampling is not used smpl_name, smpl_arg, arg_size
must be 0.

  b) programming the registers

     int pfm_write_pmcs(int fd, struct pfarg_pmc *pmcs, int n);
     int pfm_write_pmds(int fd, struct pfarg_pmd *pmds, int n);

     The calls are provided to program the configuration and data registers
     respectively. The parameters are as follows:
        - fd: file descriptor identifying the session
        - pmc: pointer to parg_pmc structures
        - pmd: pointer to parg_pmd structures
        - n : number of elements in the pmc or pmd vector

     It is possible to pass vector of parg_pmc or pfarg_pmd registers. The
     minimal size is 1, maximum size is determined by system administrator.

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

     Although both structures are currently identical, they will differ as
     more functionalities are added so better to create two versions from the
     start.

     Provisions for extensions are provided by the reserved field in each
     structure.


  c) attachment and detachment

     int pfm_load_context(int fd, struct pfarg_load *ld);
     int pfm_unload_context(int fd);

     The session is identified by the file descriptor, fd.

     To attach, the targeted thread or CPU must be provided. For extensibility
     purposes, the target is passed in structure which is defined as follows:
     struct pfarg_load {
        u32 target;
        u64 reserved[];
     };

     In per-thread mode, the target field must be set to the kernel thread
     identification (gettid()).

     In per-cpu mode, the target field must be set to the logical CPU
     identification as seen by the kernel.  Furthermore, the caller must be
     running on the CPU to monitor otherwise the call fails.

     Extensions can be implemented using the reserved field.


  d) start and stop

     int pfm_start(int fd);
     int pfm_stop(int fd);

     The session is identified by the file descriptor fd.

     Currently no other parameters are supported for those calls.


   e) reading results

     int pfm_read_pmds(int fd, struct pfarg_pmd *pmds, int n);


     The session is identified by the file descriptor fd.

     Just like for programming the registers, it is possible to pass vectors
     of structures in pmds. The number of elements is passed in n.


   f) termination

     int close(fd);

     To terminate a session, the file descriptor has to be closed. The
     semantics of file descriptor sharing applies, so if another reference to
     the session, i.e., another file descriptor exists, the session will
     only be effectively destroyed, once that reference disappears.

     Of course, the kernel does close all file descriptor on process
     termination, thus the associated sessions will eventually be destroyed.

     In per-cpu mode, it is not necessary, though recommended, to be on the
     monitored CPU to issue this call.


   g) addressing extensibility issues

      Most data structure have provisions for reserved fields which can be
      used to support new features.  Reserved fields are supposed to be set
      to 0. This works as long as 0 means 'do nothing' in the future
      extensions.

      It was suggested to us (Anrd Bergmann) that we could introduce/leverage
      a flags field in each struct to indicate explicitly that a new feature
      is actually used. Such flag could be in the data structure, but it could
      also be introduced at the syscall level whenever it makes sense. The
      idea is similar to what is going on today with the open() syscall and
      the O_CREAT flag which triggers the lookup of the 3rd argument to the
      syscall. Note that such mechanism would not alleviate the need for
      reserved fields in structure. At the syscall level, there is no reserved
      parameters, however, the mechanism would allow introducing new
      parameters to a syscall.

      If such mechanism is agreed upon by most people, then it should not be
      too hard to make the changes, though it would possibly break existing
      applications.

========================================================================================================================
10) proposed new interface

   In the following sections, we are proposing a new version of the syscall
   interface which takes into account some of the elements brought forward by
   feedback from the various people on the mailing lists but especially from
   Arnd Bergmann (see section 9-g).

   The description includes support for more features than are currently
   available in the minimal quilt patch series. Starting from this series, it
   is possible to build what is described below and yet keep backward
   compatibility.

   a) session creation

      int pfm_create_context(int flags, ...);

      #define PFM_FL_NOTIFY_BLOCK  0x01   /* block task on user notifications */
      #define PFM_FL_SYSTEM_WIDE   0x02   /* create a system wide context */
      #define PFM_FL_SMPL_FMT      0x04   /* use sampling format */
      #define PFM_FL_OVFL_NO_MSG   0x08   /* no overflow msgs */

      When PFM_FL_SMPL_FMT is set, the format information must be passed:

      int pfm_create_context(int flags, char *smpl_name, void
*smpl_arg, size_t arg_size);

      Returns the file descriptor for the session.

      We did not encapsulate the 3 parameters for formats into a data
structure because
      2 out of 3 are pointers. Data structures shared between user and
kernel must have
      fixed size to simplify management of ILP32 binary on LP64 OS.

   b) programming the registers

      int pfm_write_pmcs(int fd, struct pfarg_pmc *req, size_t size);
      int pfm_write_pmds(int fd, struct pfarg_pmd *req, size_t size);

      Notice that we've switched to size instead of count. It may make it
      easier to flag invalid data structure passed, i.e., size is not multiple
      of expected structure size.

      struct pfarg_pmc {
          __u16 reg_num;               /* which register */
          __u16 reg_set;               /* event set for this register */
          __u32 reg_flags;             /* REGFL flags */
          __u64 reg_value;             /* pmc value */
          __u64 reg_reserved2[4];      /* for future use */
     }

     PMC flags:
        #define PFM_PMCFL_NO_EMUL64 0x1        /* disable 64-bit emulation */

        More bits will be used if reserved bytes are used for extensions.

     struct pfarg_pmd {
          __u16 reg_num;               /* which register */
          __u16 reg_set;               /* event set for this register */
          __u32 reg_flags;             /* REGFL flags */
          __u64 reg_value;             /* pmd value */
          __u64 reg_long_reset;        /* reset after overflow+notification */
          __u64 reg_short_reset;       /* reset after overflow */
          __u64 reg_last_reset_val;    /* PMD last used reset value */
          __u64 reg_ovfl_switch_cnt;   /* #overflows before switch */
          __u64 reg_reset_pmds[PFM_PMD_BV]; /* bitmask of PMD to reset
on ovfl */
          __u64 reg_smpl_pmds[PFM_PMD_BV];  /* bitmask of PMD to
record in sample */
          __u64 reg_smpl_eventid;      /* opaque event identifier(Oprofile) */
          __u64 reg_random_mask;       /* random value range */
          __u32 reg_reserved2[8];      /* for future use */
     }
     PFM_PMD_BV is defined per-architecture. Must be large enough to hold
     possible future registers.

     PMD flags:
        #define PFM_PMDFL_SMPL        0x1 /* pmd used for sampling */
        #define PFM_PMDFL_SWITCH      0x2 /* pmd used in overflow set
switching */
        #define PFM_PMDFL_OVFL_NOTIFY 0x4 /* send notification on event */
        #define PFM_PMDFL_RANDOM      0x8 /* randomize value after event */

    PFM_PMDFL_SMPL and PFM_PMDFL_SWITCH are new. They indicate that sampling
    or/and overflow-based set switching are in use for the register. Those
    bits provide for incremental progression from the minimal (minimal quilt)
    interface version. They could also be used to optmize kernel code by
    skipping the initialization of those fields in the corresponding kernel
    data structures.

   c) attachment and detachment

      int pfm_load_context(int fd, int flags,...);
      int pfm_unload_context(int fd, int flags,...);

      No flags defined at this point.

   d) start and stop

      int pfm_start(int fd, int flags, ...);
      int pfm_stop(int fd, int flags, ...);

      pfm_start flags:
         #define PFM_STARTFL_SET       0x1 /* starting event set is specified */
         #define PFM_STARTFL_RESTART   0x2 /* restart after notification */

      pfm_stop flags:
         none at this point

      With event set (PFM_STARTFL_SET), it may be interesting to specify which
      set to start from. If not specified whatever set was the last active set
      is used.  For first activation, the first set in the ordered list is used.

      The pfm_start() and pfm_restart() have been merged. When passed
      PFM_STARTFL_RESTART, the syscall behaves like pfm_restart() today, i.e.,
      resumes monitoring after a user level notification (subject to sampling
      format behavior). It seems natural to merge the two syscalls into one,
      as both operations are fairly similar.

      For pfm_stop(), the flags parameters is not yet used but is provide for
      extensibility purposes.

   e) reading results

      int pfm_read_pmds(int fd, struct pfarg_pmd *pmds, size_t sz);

      Compared to current version, we use the size instead of a count for
      sizing the vector.

      Enabling extensions is done by leveraging the flags field in pfarg_pmd.

   f) termination

      int close(int fd);

      Unchanged.

   g) user level notifications

   On overflow (or equivalent, e.g., IBS interrupts), it is possible to
   request that a notification be sent to the application. It is important to
   understand that 'overflow' means 64-bit overflow.  The interface exports all
   counters as 64-bits.

   The notification is encaspulated into a message which is appended to the
   queue of each session. Each notification message can be extracted with:

      ssize_t read(int fd, struct pfarg_msg *msg, size_t n);

   Where pfarg_msg_t is as follows:
   struct pfarg_ovfl_msg {
       __u32           msg_type;       /* message type: PFM_MSG_OVFL */
       __u32           msg_ovfl_pid;   /* process id */
       __u16           msg_active_set; /* active set at overflow */
       __u16           msg_ovfl_cpu;   /* cpu of PMU interrupt */
       __u32           msg_ovfl_tid;   /* thread id */
       __u64           msg_ovfl_ip;    /* IP on PMU intr */
       __u64           msg_ovfl_pmds[PFM_PMD_BV];/* overflowed PMDs */
   };
   union pfarg_msg {
       __u32   type;
       struct pfarg_ovfl_msg pfm_ovfl_msg;
   };

   With type:
      #define PFM_MSG_OVFL     1 /* an overflow happened */

   The size passed to read must be a multiple in size of pfarg_msg. No partial
   messages are returned.

    The overflow message contains enough information to figure out which
    counter(s) overflowed in which event set, which cpu, which process, which
    thread.

    It is possible to use poll() or select() to wait on a message.

    It is possible to request asynchronous notification with SIGIO or any
    other signal. This is useful for self-sampling threads.

   h) event set and multiplexing

    The motivations for adding event sets and multiplexing are:
       - work-around limited number of counters
       - work-around limitations on how events, registers can be used together

    The event set abstraction encapsulates the full PMU state. Only one set is
    active at a time. Sets are multiplexed onto the actual PMU hardware. By
    using this technique carefully, it is possible to obtain precise estimate
    a event counts as if they all have been measured for the entire duration
    of the monitoring session. The accuracy depends on the workloads, events
    measured, and switching frequency.

    Event sets and multiplexing can be completely implemented at the user
    level. However, it is beneficial to have kernel support especially in non
    self-monitoring per-thread mode, because switching always occur in the
    context of the monitored thread, thus the number of context switch to save
    and reprogram the registers are avoided.

    Each new session starts with a single set, namely set0. Sets are numbered
    between 0 and 65535.The number do not need to be contiguous. Sets are
    ordered in increasing value of their index.They are managed in a
    round-robin fashion. The initial set is the lowest indexed set.

    Each set encapsulates the full PMU machine state.

    Switching from one set to the other can be triggered by:
        - a timeout
        - overflows

    The granularity of the timer depends on the underlying OS timer
    granularity as returned by clock_getres(MONOTONIC). In per-thread mode,
    the timeout measures virtual time. In per-cpu mode, it measures wall-clock
    time.

    Overflow switch is defined per data register and is driven by a threshold.
    It is possible to switch after n overflow of a counter. This way, the
    counter is not just dedicated to switching, it can also be used for
    regular sampling. The threshold is defined per data register.

    It is possible to mix and match timeout and overflow switching.
    By default no switching occurs.

    Sets must be explicitly created, except for set0. Any set can be
    destroyed. Creation and destruction of set can only be done while the
    session is detached.

    Event sets and multiplexing introduce the following new system calls:

    int pfm_create_evtsets(int fd, struct pfm_setdesc *sets, size_t sz);

    struct pfarg_setdesc {
       __u16   set_id;           /* which set */
       __u16   set_reserved1;    /* for future use */
       __u32   set_flags;        /* SETFL flags  */
       __u64   set_timeout;      /* switch timeout in nsecs */
       __u64   reserved[6];      /* for future use */
    }

    This call create new sets. It is possible to pass a vector and create
    multiple sets in one call. If a set already exists, its properties are
    modified, but its registers are not reset.

    There are generic and arch-specific set flags.

    generic set flags are as follows:
      #define PFM_SETFL_OVFL_SWITCH    0x01 /* enable switch on overflow */
      #define PFM_SETFL_TIME_SWITCH    0x02 /* enable switch on timeout */


   Sets creation is not folded into session creation to allow set creation
   on-the-fly and also to allow destruction of sets without destroying the
   session (close) by symmetry.

   int pfm_delete_evtsets(int fd, struct pfm_setdesc *sets, size_t sz);

   Delete events sets. The call is useful to install a new chain of sets
   without destroying the session. It can also be used to shorten an
   existing chain.

   IMPORTANT: If static creation of sets and no possibility to destroy
   with destroying the session, is not a problem, then we could fold
   pfm_create_evttsets() into pfm_create_context() using a new flag.


   int pfm_getinfo_evtsets(int fd, struct pfm_setinfo *inf, size_t sz);

   Extract information about the sets. Information is structured as follows:
   struct pfarg_setinfo {
       __u16   set_id;                 /* which set */
       __u16   set_reserved1;          /* for future use */
       __u32   set_flags;              /* out: SETFL flags */
       __u64   set_ovfl_pmds[PFM_PMD_BV]; /* out: last ovfl PMDs */
       __u64   set_runs;               /* out: #times the set was active */
       __u64   set_timeout;            /* out: eff/leftover timeout (nsecs) */
       __u64   set_act_duration;       /* out: time set was active in nsecs */
       __u64   set_avail_pmcs[PFM_PMC_BV];/* out: available PMCs */
       __u64   set_avail_pmds[PFM_PMD_BV];/* out: available PMDs */
       __u64   set_reserved3[6];       /* for future use */
   };

   Of particular interest:
      - set_runs: number of times the set was activated
      - set_act_duration: total activation duration
      - avail_pmcs, avail_pmds: bitmasks of registers available to the set
