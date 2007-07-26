Return-Path: <linux-kernel-owner+w=401wt.eu-S1762342AbXGZKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbXGZKAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXGZKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:00:31 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:57575 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbXGZKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:00:28 -0400
Date: Thu, 26 Jul 2007 15:29:48 +0530
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726095948.GB19398@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726073520.GA12206@elte.hu> <20070726074957.GA19398@in.ibm.com> <20070726075353.GA19885@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20070726075353.GA19885@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: ankita@in.ibm.com (Ankita Garg)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2007 at 09:53:53AM +0200, Ingo Molnar wrote:
> 
> * Ankita Garg <ankita@in.ibm.com> wrote:
> 
> > > I'd suggest to not put a probe into a preempt-off section - put it 
> > > to the beginning and to the end of schedule() to capture 
> > > context-switches. _stp_print_flush() is in the systemtap-generated 
> > > module, right? Maybe the problem is resolved by changing that 
> > > spinlock to use raw_spinlock_t / DEFINE_RAW_SPIN_LOCK.
> > 
> > Yes, _stp_print_flush is in the systemtap-generated kprobe module. 
> > Placing the probe at the beginning of schedule() also has the same 
> > effect. Will try by changing the spinlock to raw_spinlock_t...
> 
> could you send us that module source ST generates? Perhaps there are 
> preempt_disable() (or local_irq_disable()) calls in it too.

Attaching the generated module as it is huge...

Looks like SystemTap makes use of relayfs for printing the buffer
contents. The _stp_print_flush() (line 269 in the attached module) implemented 
in the systemtap library function as calling the following:

static int _stp_relay_write (const void *data, unsigned length)
{
        unsigned long flags;
        struct rchan_buf *buf;

        if (unlikely(length == 0))
                return 0;

        local_irq_save(flags);
        buf = _stp_chan->buf[smp_processor_id()];
        if (unlikely(buf->offset + length > _stp_chan->subbuf_size))
                length = relay_switch_subbuf(buf, length);
        memcpy(buf->data + buf->offset, data, length);
        buf->offset += length;
        local_irq_restore(flags);

        if (unlikely(length == 0))
                return -1;

        return length;
}

The above does a local_irq_save().

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   

--sdtB3X0nJg68CQEu
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="trace.c"

#define TEST_MODE 0

#ifndef MAXNESTING
#define MAXNESTING 10
#endif
#ifndef MAXSTRINGLEN
#define MAXSTRINGLEN 128
#endif
#ifndef MAXACTION
#define MAXACTION 1000
#endif
#ifndef MAXACTION_INTERRUPTIBLE
#define MAXACTION_INTERRUPTIBLE (MAXACTION * 10)
#endif
#ifndef MAXTRYLOCK
#define MAXTRYLOCK MAXACTION
#endif
#ifndef TRYLOCKDELAY
#define TRYLOCKDELAY 100
#endif
#ifndef MAXMAPENTRIES
#define MAXMAPENTRIES 2048
#endif
#ifndef MAXERRORS
#define MAXERRORS 0
#endif
#ifndef MAXSKIPPED
#define MAXSKIPPED 100
#endif
#ifndef MINSTACKSPACE
#define MINSTACKSPACE 1024
#endif
#ifndef STP_OVERLOAD_INTERVAL
#define STP_OVERLOAD_INTERVAL 1000000000LL
#endif
#ifndef STP_OVERLOAD_THRESHOLD
#define STP_OVERLOAD_THRESHOLD 500000000LL
#endif
#ifndef STP_NO_OVERLOAD
#define STP_OVERLOAD
#endif
#include "runtime.h"
#include "regs.c"
#include "stack.c"
#include "regs-ia64.c"
#include "stat.c"
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/profile.h>
#include <linux/random.h>
#include <linux/utsname.h>
#include "loc2c-runtime.h" 
#ifndef read_trylock
#define read_trylock(x) ({ read_lock(x); 1; })
#endif
#if defined(CONFIG_MARKERS)
#include <linux/marker.h>
#endif
typedef char string_t[MAXSTRINGLEN];

#define STAP_SESSION_STARTING 0
#define STAP_SESSION_RUNNING 1
#define STAP_SESSION_ERROR 2
#define STAP_SESSION_STOPPING 3
#define STAP_SESSION_STOPPED 4
atomic_t session_state = ATOMIC_INIT (STAP_SESSION_STARTING);
atomic_t error_count = ATOMIC_INIT (0);
atomic_t skipped_count = ATOMIC_INIT (0);

struct context {
  atomic_t busy;
  const char *probe_point;
  int actionremaining;
  unsigned nesting;
  const char *last_error;
  const char *last_stmt;
  struct pt_regs *regs;
  struct kretprobe_instance *pi;
  va_list mark_va_list;
  #ifdef STP_TIMING
  Stat *statp;
  #endif
  #ifdef STP_OVERLOAD
  cycles_t cycles_base;
  cycles_t cycles_sum;
  #endif
  union {
    struct probe_1493_locals {
      string_t argstr;
      union {
        struct {
          string_t __tmp0;
          int64_t __tmp1;
          int64_t __tmp2;
          string_t __tmp3;
        };
      };
    } probe_1493;
    struct function_execname_locals {
      string_t __retvalue;
    } function_execname;
    struct function_pid_locals {
      int64_t __retvalue;
    } function_pid;
    struct function_tid_locals {
      int64_t __retvalue;
    } function_tid;
  } locals [MAXNESTING];
};

void *contexts = NULL; /* alloc_percpu */



static void function_execname (struct context * __restrict__ c);

static void function_pid (struct context * __restrict__ c);

static void function_tid (struct context * __restrict__ c);

void function_execname (struct context* __restrict__ c) {
  struct function_execname_locals *  __restrict__ l =
    & c->locals[c->nesting].function_execname;
  (void) l;
  #define CONTEXT c
  #define THIS l
  if (0) goto out;
  l->__retvalue[0] = '\0';
  {
     /* pure */
	strlcpy (THIS->__retvalue, current->comm, MAXSTRINGLEN);

  }
out:
  ;
  #undef CONTEXT
  #undef THIS
}


void function_pid (struct context* __restrict__ c) {
  struct function_pid_locals *  __restrict__ l =
    & c->locals[c->nesting].function_pid;
  (void) l;
  #define CONTEXT c
  #define THIS l
  if (0) goto out;
  l->__retvalue = 0;
  {
     /* pure */
	THIS->__retvalue = current->tgid;

  }
out:
  ;
  #undef CONTEXT
  #undef THIS
}


void function_tid (struct context* __restrict__ c) {
  struct function_tid_locals *  __restrict__ l =
    & c->locals[c->nesting].function_tid;
  (void) l;
  #define CONTEXT c
  #define THIS l
  if (0) goto out;
  l->__retvalue = 0;
  {
     /* pure */
	THIS->__retvalue = current->pid;

  }
out:
  ;
  #undef CONTEXT
  #undef THIS
}


#ifdef STP_TIMING
static __cacheline_aligned Stat time_probe_0;
#endif

static void probe_1493 (struct context * __restrict__ c) {
  struct probe_1493_locals * __restrict__ l =
    & c->locals[0].probe_1493;
  (void) l;
  #ifdef STP_TIMING
  c->statp = & time_probe_0;
  #endif
  {
    unsigned numtrylock = 0;
    (void) numtrylock;
    if (0) goto unlock_;
  }
  l->argstr[0] = '\0';
  {
    if (unlikely (c->last_error)) goto out;
    c->last_stmt = "identifier 'printf' at trace.stp:3:2";
    c->actionremaining -= 1;
    if (unlikely (c->actionremaining <= 0)) {
      c->last_error = "MAXACTION exceeded";
      goto out;
    }
    (void) 
    ({
      c->last_stmt = "identifier 'execname' at trace.stp:3:49";
      strlcpy (l->__tmp0, 
      ({
        
        if (unlikely (c->nesting+2 >= MAXNESTING)) {
          c->last_error = "MAXNESTING exceeded";
          c->last_stmt = "identifier 'execname' at trace.stp:3:49";
        } else if (likely (! c->last_error)) {
          c->nesting ++;
          function_execname (c);
          c->nesting --;
          if (c->last_error && ! c->last_error[0])
            c->last_error = 0;
        }
        c->locals[c->nesting+1].function_execname.__retvalue;
      }), MAXSTRINGLEN);
      c->last_stmt = "identifier 'pid' at trace.stp:3:61";
      l->__tmp1 = 
      ({
        
        if (unlikely (c->nesting+2 >= MAXNESTING)) {
          c->last_error = "MAXNESTING exceeded";
          c->last_stmt = "identifier 'pid' at trace.stp:3:61";
        } else if (likely (! c->last_error)) {
          c->nesting ++;
          function_pid (c);
          c->nesting --;
          if (c->last_error && ! c->last_error[0])
            c->last_error = 0;
        }
        c->locals[c->nesting+1].function_pid.__retvalue;
      });
      c->last_stmt = "identifier 'tid' at trace.stp:3:68";
      l->__tmp2 = 
      ({
        
        if (unlikely (c->nesting+2 >= MAXNESTING)) {
          c->last_error = "MAXNESTING exceeded";
          c->last_stmt = "identifier 'tid' at trace.stp:3:68";
        } else if (likely (! c->last_error)) {
          c->nesting ++;
          function_tid (c);
          c->nesting --;
          if (c->last_error && ! c->last_error[0])
            c->last_error = 0;
        }
        c->locals[c->nesting+1].function_tid.__retvalue;
      });
      c->last_stmt = "identifier 'argstr' at trace.stp:3:75";
      strlcpy (l->__tmp3, l->argstr, MAXSTRINGLEN);
      if (likely (! c->last_error)) {
        _stp_printf ("%s (pid: %lld, tid: %lld argstr: %s ) \n", l->__tmp0, l->__tmp1, l->__tmp2, l->__tmp3);
      }
      ((int64_t)0LL);
    });
    
    /* null */;
    
  }
out:
  _stp_print_flush();
unlock_: ;
}


/* ---- dwarf probes ---- */
#if ! defined(CONFIG_KPROBES)
#error "Need CONFIG_KPROBES!"
#endif

static int enter_kprobe_probe (struct kprobe *inst, struct pt_regs *regs);
static int enter_kretprobe_probe (struct kretprobe_instance *inst, struct pt_regs *regs);
struct stap_dwarf_probe {
  union { struct kprobe kp; struct kretprobe krp; } u;
  unsigned return_p:1;
  unsigned maxactive_p:1;
  unsigned registered_p:1;
  const char *module;
  const char *section;
  unsigned long address;
  unsigned long maxactive_val;
  const char *pp;
  void (*ph) (struct context*);
} stap_dwarf_probes[] = {
  { .address=0x2850deUL, .module="kernel", .section="_stext", .pp="kernel.function(\"schedule@kernel/sched.c:3792\")", .ph=&probe_1493 },
};

static int enter_kprobe_probe (struct kprobe *inst, struct pt_regs *regs) {
  struct stap_dwarf_probe *sdp = container_of(inst, struct stap_dwarf_probe, u.kp);
  struct context* __restrict__ c;
  unsigned long flags;
  #if defined(STP_TIMING) || defined(STP_OVERLOAD)
  cycles_t cycles_atstart = get_cycles ();
  #endif
  local_irq_save (flags);
  if (unlikely ((((unsigned long) (& c)) & (THREAD_SIZE-1))
    < (MINSTACKSPACE + sizeof (struct thread_info)))) {
    if (unlikely (atomic_inc_return (& skipped_count) > MAXSKIPPED)) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
    goto probe_epilogue;
  }
  if (atomic_read (&session_state) != STAP_SESSION_RUNNING)
    goto probe_epilogue;
  c = per_cpu_ptr (contexts, smp_processor_id());
  if (unlikely (atomic_inc_return (&c->busy) != 1)) {
    if (atomic_inc_return (& skipped_count) > MAXSKIPPED) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
    atomic_dec (& c->busy);
    goto probe_epilogue;
  }
  
  c->last_error = 0;
  c->nesting = 0;
  c->regs = 0;
  c->pi = 0;
  c->probe_point = 0;
  c->actionremaining = MAXACTION;
  #ifdef STP_TIMING
  c->statp = 0;
  #endif
  c->probe_point = sdp->pp;
  c->regs = regs;
  (*sdp->ph) (c);
  #if defined(STP_TIMING) || defined(STP_OVERLOAD)
  {
    cycles_t cycles_atend = get_cycles ();
    int32_t cycles_elapsed = ((int32_t)cycles_atend > (int32_t)cycles_atstart)
      ? ((int32_t)cycles_atend - (int32_t)cycles_atstart)
      : (~(int32_t)0) - (int32_t)cycles_atstart + (int32_t)cycles_atend + 1;
    #ifdef STP_TIMING
    if (likely (c->statp)) _stp_stat_add(*c->statp, cycles_elapsed);
    #endif
    #ifdef STP_OVERLOAD
    {
      cycles_t interval = (cycles_atend > c->cycles_base)
        ? (cycles_atend - c->cycles_base)
        : (STP_OVERLOAD_INTERVAL + 1);
      c->cycles_sum += cycles_elapsed;
      if (interval > STP_OVERLOAD_INTERVAL) {
        if (c->cycles_sum > STP_OVERLOAD_THRESHOLD) {
          _stp_error ("probe overhead exceeded threshold");
          atomic_set (&session_state, STAP_SESSION_ERROR);
          atomic_inc (&error_count);
        }
        c->cycles_base = cycles_atend;
        c->cycles_sum = 0;
      }
    }
    #endif
  }
  #endif
  if (unlikely (c->last_error && c->last_error[0])) {
    if (c->last_stmt != NULL)
      _stp_softerror ("%s near %s", c->last_error, c->last_stmt);
    else
      _stp_softerror ("%s", c->last_error);
    atomic_inc (& error_count);
    if (atomic_read (& error_count) > MAXERRORS) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
  }
  atomic_dec (&c->busy);
probe_epilogue:
  local_irq_restore (flags);
  return 0;
}

static int enter_kretprobe_probe (struct kretprobe_instance *inst, struct pt_regs *regs) {
  struct kretprobe *krp = inst->rp;
  struct stap_dwarf_probe *sdp = container_of(krp, struct stap_dwarf_probe, u.krp);
  struct context* __restrict__ c;
  unsigned long flags;
  #if defined(STP_TIMING) || defined(STP_OVERLOAD)
  cycles_t cycles_atstart = get_cycles ();
  #endif
  local_irq_save (flags);
  if (unlikely ((((unsigned long) (& c)) & (THREAD_SIZE-1))
    < (MINSTACKSPACE + sizeof (struct thread_info)))) {
    if (unlikely (atomic_inc_return (& skipped_count) > MAXSKIPPED)) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
    goto probe_epilogue;
  }
  if (atomic_read (&session_state) != STAP_SESSION_RUNNING)
    goto probe_epilogue;
  c = per_cpu_ptr (contexts, smp_processor_id());
  if (unlikely (atomic_inc_return (&c->busy) != 1)) {
    if (atomic_inc_return (& skipped_count) > MAXSKIPPED) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
    atomic_dec (& c->busy);
    goto probe_epilogue;
  }
  
  c->last_error = 0;
  c->nesting = 0;
  c->regs = 0;
  c->pi = 0;
  c->probe_point = 0;
  c->actionremaining = MAXACTION;
  #ifdef STP_TIMING
  c->statp = 0;
  #endif
  c->probe_point = sdp->pp;
  c->regs = regs;
  c->pi = inst;
  (*sdp->ph) (c);
  #if defined(STP_TIMING) || defined(STP_OVERLOAD)
  {
    cycles_t cycles_atend = get_cycles ();
    int32_t cycles_elapsed = ((int32_t)cycles_atend > (int32_t)cycles_atstart)
      ? ((int32_t)cycles_atend - (int32_t)cycles_atstart)
      : (~(int32_t)0) - (int32_t)cycles_atstart + (int32_t)cycles_atend + 1;
    #ifdef STP_TIMING
    if (likely (c->statp)) _stp_stat_add(*c->statp, cycles_elapsed);
    #endif
    #ifdef STP_OVERLOAD
    {
      cycles_t interval = (cycles_atend > c->cycles_base)
        ? (cycles_atend - c->cycles_base)
        : (STP_OVERLOAD_INTERVAL + 1);
      c->cycles_sum += cycles_elapsed;
      if (interval > STP_OVERLOAD_INTERVAL) {
        if (c->cycles_sum > STP_OVERLOAD_THRESHOLD) {
          _stp_error ("probe overhead exceeded threshold");
          atomic_set (&session_state, STAP_SESSION_ERROR);
          atomic_inc (&error_count);
        }
        c->cycles_base = cycles_atend;
        c->cycles_sum = 0;
      }
    }
    #endif
  }
  #endif
  if (unlikely (c->last_error && c->last_error[0])) {
    if (c->last_stmt != NULL)
      _stp_softerror ("%s near %s", c->last_error, c->last_stmt);
    else
      _stp_softerror ("%s", c->last_error);
    atomic_inc (& error_count);
    if (atomic_read (& error_count) > MAXERRORS) {
      atomic_set (& session_state, STAP_SESSION_ERROR);
      _stp_exit ();
    }
  }
  atomic_dec (&c->busy);
probe_epilogue:
  local_irq_restore (flags);
  return 0;
}

int systemtap_module_init (void) {
  int rc = 0;
  int i=0, j=0;
  const char *probe_point = "";
  down_read (& uts_sem);
  {
    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)
    const char* machine = utsname()->machine;
    const char* release = utsname()->release;
    #else
    const char* machine = system_utsname.machine;
    const char* release = system_utsname.release;
    #endif
    if (strcmp (machine, "x86_64")) {
      _stp_error ("module machine mismatch (%s vs %s)", machine, "x86_64");
      rc = -EINVAL;
    }
    if (strcmp (release, "2.6.22.1-rt3")) {
      _stp_error ("module release mismatch (%s vs %s)", release, "2.6.22.1-rt3");
      rc = -EINVAL;
    }
  }
  up_read (& uts_sem);
  if (rc) goto out;
  (void) probe_point;
  (void) i;
  (void) j;
  atomic_set (&session_state, STAP_SESSION_STARTING);
  if (sizeof (struct context) <= 131072)
    contexts = alloc_percpu (struct context);
  if (contexts == NULL) {
    _stp_error ("percpu context (size %lu) allocation failed", sizeof (struct context));
    rc = -ENOMEM;
    goto out;
  }
  #ifdef STP_TIMING
  time_probe_0 = _stp_stat_init (HIST_NONE);
  #endif
  for (i=0; i<1; i++) {
    struct stap_dwarf_probe *sdp = & stap_dwarf_probes[i];
    unsigned long relocated_addr = _stp_module_relocate (sdp->module, sdp->section, sdp->address);
    if (relocated_addr == 0) continue;
    probe_point = sdp->pp;
    if (sdp->return_p) {
      sdp->u.krp.kp.addr = (void *) relocated_addr;
      if (sdp->maxactive_p) {
        sdp->u.krp.maxactive = sdp->maxactive_val;
      } else {
        sdp->u.krp.maxactive = max(10, 4*NR_CPUS);
      }
      sdp->u.krp.handler = &enter_kretprobe_probe;
      rc = register_kretprobe (& sdp->u.krp);
    } else {
      sdp->u.kp.addr = (void *) relocated_addr;
      sdp->u.kp.pre_handler = &enter_kprobe_probe;
      rc = register_kprobe (& sdp->u.kp);
    }
    if (rc) {
      for (j=i-1; j>=0; j--) {
        struct stap_dwarf_probe *sdp2 = & stap_dwarf_probes[j];
        if (sdp2->return_p) unregister_kretprobe (&sdp2->u.krp);
        else unregister_kprobe (&sdp2->u.kp);
      }
      break;
    }
    else sdp->registered_p = 1;
  }
  if (rc) {
    _stp_error ("probe %s registration error (rc %d)", probe_point, rc);
    atomic_set (&session_state, STAP_SESSION_ERROR);
    goto out;
  }
  printk (KERN_DEBUG "%s: systemtap: 0.5.15/Red Hat elfutils 0.125, base: %p, memory: %lu+%lu+%lu+%lu+%lu data+text+ctx+io+glob, probes: 1\n", THIS_MODULE->name, THIS_MODULE->module_core, (unsigned long) (THIS_MODULE->core_size - THIS_MODULE->core_text_size), (unsigned long) THIS_MODULE->core_text_size, (unsigned long) (num_online_cpus() * sizeof(struct context)), (unsigned long) _stp_allocated_net_memory, (unsigned long) _stp_allocated_memory);
  atomic_set (&session_state, STAP_SESSION_RUNNING);
  return 0;
out:
  return rc;
}


void systemtap_module_exit (void) {
  int holdon;
  int i=0, j=0;
  (void) i;
  (void) j;
  if (atomic_read (&session_state) == STAP_SESSION_STARTING)
    return;
  if (atomic_read (&session_state) == STAP_SESSION_RUNNING)
    atomic_set (&session_state, STAP_SESSION_STOPPING);
  do {
    int i;
    holdon = 0;
    for (i=0; i < NR_CPUS; i++)
      if (cpu_possible (i) && atomic_read (& ((struct context *)per_cpu_ptr(contexts, i))->busy)) holdon = 1;
      cpu_relax ();
    } while (holdon);
  
  for (i=0; i<1; i++) {
    struct stap_dwarf_probe *sdp = & stap_dwarf_probes[i];
    if (! sdp->registered_p) continue;
    if (sdp->return_p) {
      unregister_kretprobe (&sdp->u.krp);
      atomic_add (sdp->u.krp.nmissed, & skipped_count);
      atomic_add (sdp->u.krp.kp.nmissed, & skipped_count);
    } else {
      unregister_kprobe (&sdp->u.kp);
      atomic_add (sdp->u.kp.nmissed, & skipped_count);
    }
    sdp->registered_p = 0;
  }
  free_percpu (contexts);
  #ifdef STP_TIMING
  {
    if (likely (time_probe_0)) {
      const char *probe_point = "kernel.function(\"schedule\")";
      const char *decl_location = "trace.stp:1:1";
      struct stat_data *stats = _stp_stat_get (time_probe_0, 0);
      const char *error;
      if (stats->count) {
        int64_t avg = _stp_div64 (&error, stats->sum, stats->count);
        _stp_printf ("probe %s (%s), hits: %lld, cycles: %lldmin/%lldavg/%lldmax\n",
        probe_point, decl_location, (long long) stats->count, (long long) stats->min, (long long) avg, (long long) stats->max);
      }
    }
    _stp_print_flush();
  }
  #endif
  if (atomic_read (& skipped_count) || atomic_read (& error_count)) {
    _stp_printf ("WARNING: Number of errors: %d, skipped probes: %d\n", (int) atomic_read (& error_count), (int) atomic_read (& skipped_count));
    _stp_print_flush();
  }
}


int probe_start () {
  return systemtap_module_init () ? -1 : 0;
}

void probe_exit () {
  systemtap_module_exit ();
}
MODULE_DESCRIPTION("systemtap probe");
MODULE_LICENSE("GPL");
/* filled in by runtime */
struct stap_symbol *stap_symbols;
unsigned stap_num_symbols;


--sdtB3X0nJg68CQEu--
