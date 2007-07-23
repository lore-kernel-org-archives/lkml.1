Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbXGWBiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbXGWBiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbXGWBil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:38:41 -0400
Received: from smtpout.mac.com ([17.250.248.174]:56862 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbXGWBij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:38:39 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 21:38:39 EDT
Date: Sun, 22 Jul 2007 21:32:02 -0400
From: Kyle Moffett <mrlinuxman@mac.com>
To: Lars Ellenberg <lars@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-Id: <20070722213202.1f5d1cab.mrlinuxman@mac.com>
In-Reply-To: <20070721203819.GA10706@mail.linbit.com>
References: <20070721203819.GA10706@mail.linbit.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.13; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I didn't have a chance to get through anywhere near all of it, but
here's my comments so far.  I didn't really go through things in any
particular order but most of these comments are about your drbd_int.h
header file.  Hopefully a lot of the comments will be useful to fix
similar/identical problems in your C files.

First of all, if you could break this up into chunks (even if they
aren't useful individually) just to make it easier to review.
Divisions like "This code does on-disk bitmap management", and "This
code does network protocol encoding/decoding" would be extremely
helpful when digging through this stuff.  I ended up only really doing
a cursory review for low-level/style issues, since without the bigger
picture (and without the fixed style issues and macro cleanups) it's
very hard to really give a good high-level review.

Cheers,
Kyle Moffett


+drbd-objs  :=  drbd_buildtag.o drbd_bitmap.o drbd_proc.o \
+               drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o \
+               lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o
+
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o

Don't use foo-objs, use foo-y instead.


+#undef DEVICE_NAME
+#define DEVICE_NAME "drbd"

This is never actually defined/redefined anywhere else.  Just hardcode the
"drbd" in your printk strings and save yourself 5-6 characters per use.


+/* I don't remember why XCPU ...
+ * This is used to wake the asender,
+ * and to interrupt sending the sending task
+ * on disconnect.
+ */
+#define DRBD_SIG SIGXCPU
+
+/* This is used to stop/restart our threads.
+ * Cannot use SIGTERM nor SIGKILL, since these
+ * are sent out by init on runlevel changes
+ * I choose SIGHUP for now.
+ *
+ * FIXME btw, we should register some reboot notifier.
+ */
+#define DRBD_SIGKILL SIGHUP

Don't use signals between kernel threads, use proper primitives like
notifiers and waitqueues, which means you should also probably switch away
from kernel_thread() to the kthread_*() APIs.  Also you should fix this
FIXME or remove it if it no longer applies:-D.


+#ifdef PARANOIA
+# define PARANOIA_BUG_ON(x) BUG_ON(x)
+#else
+# define PARANOIA_BUG_ON(x)
+#endif

This is only ever used in one place for a simple != test:
+       PARANOIA_BUG_ON(w != &mdev->resync_work);

Just delete PARANOIA_BUG_ON and convert the above to a straight BUG_ON()


+#define STATIC
+#define STATIC static

These two lines are found in different files, but the symbol "STATIC" isn't
used anywhere.  Just get rid of it.


+/* handy macro: DUMPP(somepointer) */
+#define DUMPP(A)   ERR( #A " = %p in %s:%d\n", (A), __FILE__, __LINE__);
[...]
+/* Info: do not remove the spaces around the "," before ##
+ *      Otherwise this is not portable from gcc-2.95 to gcc-3.3 */
+#define PRINTK(level, fmt, args...) \
+       printk(level DEVICE_NAME "%d: " fmt, \
+               mdev->minor , ##args)
+
+#define ALERT(fmt, args...) PRINTK(KERN_ALERT, fmt , ##args)
[...]

No more custom debugging macros please, we have plenty of standardized ones
in the kernel already (and all togther too many nonstandardized ones).
Please take a good look at dev_printk, etc to make some of your printk()s
shorter, but don't add more icky macros.  Also gcc < 3.1 is now unsupported,
so please remove gcc-2.95 portability comments/cruft (although in this case
the code itself doesn't need changing, just the comments).


+/* see kernel/printk.c:printk_ratelimit
+ * macro, so it is easy do have independend rate limits at different locations
+ * "initializer element not constant ..." with kernel 2.4 :(
+ * so I initialize toks to something large
+ */
+#define DRBD_ratelimit(ratelimit_jiffies, ratelimit_burst)     \

Any particular reason you can't just use printk_ratelimit for this?  Also you
should remove any linux 2.4-related code/comments as they won't apply for
code submitted to 2.6 mainline.


+#ifdef DBG_ASSERTS
+extern void drbd_assert_breakpoint(struct drbd_conf *, char *, char *, int );
+# define D_ASSERT(exp) if (!(exp)) \
+        drbd_assert_breakpoint(mdev, #exp, __FILE__, __LINE__)
+#else
+# define D_ASSERT(exp) if (!(exp)) \
+        ERR("ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
+#endif
+#define ERR_IF(exp) if (({ \
+       int _b = (exp) != 0; \
+       if (_b) ERR("%s: (" #exp ") in %s:%d\n", \
+               __func__, __FILE__, __LINE__); \
+        _b; \
+       }))

Yuck, more debugging macros.


+/* Defines to control fault insertion */
+enum {
+    DRBD_FAULT_MD_WR = 0,      /* meta data write */
+    DRBD_FAULT_MD_RD,          /*           read  */
+    DRBD_FAULT_RS_WR,          /* resync          */
+    DRBD_FAULT_RS_RD,
+    DRBD_FAULT_DT_WR,          /* data            */
+    DRBD_FAULT_DT_RD,
+    DRBD_FAULT_DT_RA,          /* data read ahead */
+
+    DRBD_FAULT_MAX,
+};

We have some existing failure-injection code, any chance you could rip out
your custom logic and just plug that?  I haven't looked over it, though, so
I can't really offer any useful suggestions about it.


+#include <linux/stringify.h>

Put the include at the top of the file, please?


+/* integer division, round _UP_ to the next integer */
+#define div_ceil(A, B) ( (A)/(B) + ((A)%(B) ? 1 : 0) )
+/* usual integer division */
+#define div_floor(A, B) ( (A)/(B) )

Your div_ceil function looks OK but I think we already have a standard one
somewhere.  You might remove that div_floor function, though, as it isn't
used anywhere.

+/*
+ * Compatibility Section
+ *************************/
+
+#define LOCK_SIGMASK(task, flags)   spin_lock_irqsave(&task->sighand->siglock, flags)
+#define UNLOCK_SIGMASK(task, flags) spin_unlock_irqrestore(&task->sighand->siglock, flags)
+#define RECALC_SIGPENDING()        recalc_sigpending();

These aren't used anywhere, remove please?


+#if defined(DBG_SPINLOCKS) && defined(__SMP__)
+# define MUST_HOLD(lock) if (!spin_is_locked(lock)) { ERR("Not holding lock! in %s\n", __FUNCTION__ ); }
+#else
+# define MUST_HOLD(lock)
+#endif

Why not just open-code "WARN_ON_SMP(!spin_is_locked(lock))" in the few places
this is used?  Alternatively if you need this to actually BUG(), you might
either add a BUG_ON_SMP() to include/asm-generic/bug.h or add a helper to
include/linux/spinlock.h:

#if defined(CONFIG_SMP) && defined(CONFIG_DEBUG_SPINLOCK)
# define spin_lock_musthold(lock) BUG_ON(!spin_is_locked(lock))
#else
# define spin_lock_musthold(lock) do { } while(0)
#endif


+#define SET_MDEV_MAGIC(x) \
+       ({ typecheck(struct drbd_conf*, x); \
+         (x)->magic = (long)(x) ^ DRBD_MAGIC; })
+#define IS_VALID_MDEV(x)  \
+       ( typecheck(struct drbd_conf*, x) && \
+         ((x) ? (((x)->magic ^ DRBD_MAGIC) == (long)(x)):0))

SET_MDEV_MAGIC is only used in one place, can't you open-code it there?  Even
if it were used lots of places a little inline function would handle the
"typecheck" for you and be easier to read.  The IS_VALID_MDEV() isn't used
anywhere, so delete it.


+enum Drbd_thread_state {
+       None,
+       Running,
+       Exiting,
+       Restarting
+};
+
+struct Drbd_thread {
+       spinlock_t t_lock;
+       struct task_struct *task;
+       struct completion startstop;
+       enum Drbd_thread_state t_state;
+       int (*function) (struct Drbd_thread *);
+       struct drbd_conf *mdev;
+};

As somebody already mentioned, you need to switch from kernel_thread to
kthread_* helpers.


+/*
+ * Having this as the first member of a struct provides sort of "inheritance".
+ * "derived" structs can be "drbd_queue_work()"ed.
+ * The callback should know and cast back to the descendant struct.
+ * drbd_request and Tl_epoch_entry are descendants of drbd_work.
+ */
+struct drbd_work;
+typedef int (*drbd_work_cb)(struct drbd_conf *, struct drbd_work *, int cancel);
+struct drbd_work {
+       struct list_head list;
+       drbd_work_cb cb;
+};
+
+struct drbd_barrier;
+struct drbd_request {
+       struct drbd_work w;


Eww, please don't do opencoded casting of these.  You should use the proper
container_of() macro instead:

> struct foo {
>         int a;
> };
> struct bar {
>         int b;
>         struct foo thefoo;
> };
> void mycallback(struct foo *myfoo)
> {
>         struct bar *mybar = container_of(myfoo, struct bar, thefoo);
>         process_a_bar(mybar);
> }

It's not *much* better typechecking, but it's at least a little.  It also
lets you put a struct drbd_work at a non-zero offset inside of some other
struct, as container_of() does internal subtraction of the offsetof().


+/* THINK maybe we actually want to use the default "event/%s" worker threads
+ * or similar in linux 2.6, which uses per cpu data and threads.
+ *
+ * To be general, this might need a spin_lock member.
+ * For now, please use the mdev->req_lock to protect list_head,
+ * see drbd_queue_work below.
+ */
+struct drbd_work_queue {
+       struct list_head q;
+       struct semaphore s; /* producers up it, worker down()s it */
+       spinlock_t q_lock;  /* to protect the list. */
+};

Umm, how about fixing this to actually use proper workqueues or something
instead of this open-coded mess?


+/* for sync_conf and other types... */
+#define PACKET(name, number, fields) struct name { fields };
+#define INTEGER(pn, pr, member) int member;
+#define INT64(pn, pr, member) __u64 member;
+#define BIT(pn, pr, member) unsigned member : 1;
+#define STRING(pn, pr, member, len) \
+       unsigned char member[len]; int member ## _len;
+#include "linux/drbd_nl.h"

The only light at the end of this tunnel is the greedily burning fires of
Macro Hell(TM).  Isn't there any better way to do this than all those horrid
macros?  I can sorta see what drbd_nl.h is trying to do, but the way it's
included multiple times with all those insane macros defined makes it really
hard to mentally parse.


+#ifdef PARANOIA
+       long magic;
+#endif

Any particular reason you can't just unconditionally use a magic number?
It's little more than an extra word per device and a couple simple integer
tests.


+/* returns 1 if it was successfull,
+ * returns 0 if there was no data socket.
+ * so wherever you are going to use the data.socket, e.g. do
+ * if (!drbd_get_data_sock(mdev))
+ *     return 0;
+ *     CODE();
+ * drbd_put_data_sock(mdev);
+ */
+static inline int drbd_get_data_sock(struct drbd_conf *mdev)
+{
+       down(&mdev->data.mutex);
+       /* drbd_disconnect() could have called drbd_free_sock()
+        * while we were waiting in down()... */
+       if (unlikely(mdev->data.socket == NULL)) {
+               up(&mdev->data.mutex);
+               return 0;
+       }
+       return 1;
+}

Any reason this can't be open-coded?  The extra unlock logic should just be
moved into the cleanup handlers for the appropriate function.  It looks like
you are using the semaphore as a simple binary mutex, so please switch this
to "struct mutex" as well.


+#if BITS_PER_LONG == 32
+#define LN2_BPL 5
+#define cpu_to_lel(A) cpu_to_le32(A)
+#define lel_to_cpu(A) le32_to_cpu(A)
+#elif BITS_PER_LONG == 64
+#define LN2_BPL 6
+#define cpu_to_lel(A) cpu_to_le64(A)
+#define lel_to_cpu(A) le64_to_cpu(A)
+#else
+#error "LN2 of BITS_PER_LONG unknown!"
+#endif

Hrm, any reason you can't just make the bitmap an array of __u64 and always
use the cpu_to_le64()/le64_to_cpu() functions?


+/* I want the packet to fit within one page
+ * THINK maybe use a special bitmap header,
+ * including offset and compression scheme and whatnot
+ * Do not use PAGE_SIZE here! Use a architecture agnostic constant!
+ */
+#define BM_PACKET_WORDS ((4096-sizeof(struct Drbd_Header))/sizeof(long))

Yuck.  Definitely use PAGE_SIZE here, so at least if it's broken on an arch
with multiple page sizes, somebody can grep for PAGE_SIZE to fix it.  It also
means that on archs/configs with 8k or 64k pages you won't waste a bunch of
memory.


+/* Dynamic tracing framework */
+#ifdef ENABLE_DYNAMIC_TRACE
+
+extern int trace_type;
+extern int trace_devs;
[...]

AGH!! Not another dynamic tracing framework!  Please use one of the existing
solutions like kprobes or something.  Maybe define some static tracepoints
if that would be useful?


+static inline void drbd_tcp_cork(struct socket *sock)
+{
+#if 1
+       mm_segment_t oldfs = get_fs();
+       int val = 1;
+
+       set_fs(KERNEL_DS);
+       tcp_setsockopt(sock->sk, SOL_TCP, TCP_CORK, (char *)&val, sizeof(val) );
+       set_fs(oldfs);
+#else
+       tcp_sk(sock->sk)->nonagle |= TCP_NAGLE_CORK;
+#endif
+}

Yuck, why'd you do it this way?  Probably because your tcp_sk(sock->sk) stuff
doesn't have proper locking, I'll bet.  You can avoid all the extra wrapper
crap by just looking in "do_tcp_setsockopt" and taking the appropriate lock:

static inline void drbd_tcp_cork(struct socket *sock)
{
	struct sock *sk = sock->sk;

	lock_sock(sk);
	tcp_sk(sk)->nonagle |= TCP_NAGLE_CORK;
	release-sock(sk);
}

On the other hand, none of the currently in-tree network block devices or
network filesystems seem to feel the need to try to TCP_CORK their output, 
why does drbd?


+#define peer_mask role_mask
+#define pdsk_mask disk_mask
+#define susp_mask 1
+#define user_isp_mask 1
+#define aftr_isp_mask 1
+
+#define NS(T, S) \
+       ({ union drbd_state_t mask; mask.i = 0; mask.T = T##_mask; mask; }), \
+       ({ union drbd_state_t val; val.i = 0; val.T = (S); val; })
+#define NS2(T1, S1, T2, S2) \
+       ({ union drbd_state_t mask; mask.i = 0; mask.T1 = T1##_mask; \
+         mask.T2 = T2##_mask; mask; }), \
+       ({ union drbd_state_t val; val.i = 0; val.T1 = (S1); \
+         val.T2 = (S2); val; })
+#define NS3(T1, S1, T2, S2, T3, S3) \
+       ({ union drbd_state_t mask; mask.i = 0; mask.T1 = T1##_mask; \
+         mask.T2 = T2##_mask; mask.T3 = T3##_mask; mask; }), \
+       ({ union drbd_state_t val; val.i = 0; val.T1 = (S1); \
+         val.T2 = (S2); val.T3 = (S3); val; })
+
+#define _NS(D, T, S) \
+       D, ({ union drbd_state_t ns; ns.i = D->state.i; ns.T = (S); ns; })
+#define _NS2(D, T1, S1, T2, S2) \
+       D, ({ union drbd_state_t ns; ns.i = D->state.i; ns.T1 = (S1); \
+       ns.T2 = (S2); ns; })
+#define _NS3(D, T1, S1, T2, S2, T3, S3) \
+       D, ({ union drbd_state_t ns; ns.i = D->state.i; ns.T1 = (S1); \
+       ns.T2 = (S2); ns.T3 = (S3); ns; })

Grumble.  When I earlier said I thought I was in macro hell, well, I was
wrong.  *THIS* is macro hell.  What the fsck is that supposed to do?  And it
doesn't even include a *SINGLE* comment!!!


+static inline void drbd_state_lock(struct drbd_conf *mdev)
+{
+       wait_event(mdev->misc_wait,
+                  !test_and_set_bit(CLUSTER_ST_CHANGE, &mdev->flags));
+}

Umm, what's wrong with a mutex here?


+static inline int semaphore_is_locked(struct semaphore *s)
+{
+       if (!down_trylock(s)) {
+               up(s);
+               return 0;
+       }
+       return 1;
+}

This would be better implemented in the mutex/semaphore generic code, instead
of stuffed in a network blockdev.  On the other hand, since the only user is
this:
+       D_ASSERT(semaphore_is_locked(&mdev->md_io_mutex));

Can't you just either get rid of the check or open-code it?  It would also
give you a chance to substitute D_ASSERT(foo) for a proper BUG_ON(!foo) :-D


+static inline void
+_drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
[...]

Yeah, this stuff should really be fixed to use generic workqueues or
something.


+#define ERR_IF_CNT_IS_NEGATIVE(which)                          \
+       if (atomic_read(&mdev->which) < 0)                      \
+               ERR("in %s:%d: " #which " = %d < 0 !\n",        \
+                   __func__ , __LINE__ ,                       \
+                   atomic_read(&mdev->which))

Another macro with an implicit parameter (mdev).  Please fix all of these


+#define dec_unacked(mdev)      do {                            \
+       typecheck(struct drbd_conf *, mdev);                            \
+       atomic_dec(&mdev->unacked_cnt);                         \
+       ERR_IF_CNT_IS_NEGATIVE(unacked_cnt); } while (0)
[...]

More macros that should be inline functions.


+       if (!have_net_conf) dec_net(mdev);

There's lots of coding-style violations like these in there.  You should put
the "dec_net(mdev);" indented on the line *AFTER* the if statememt.  Please
read linux/Documentation/CodingStyle for full details.


+       int mxb = 1000000; /* arbitrary limit on open requests */

Arbitrary limits are usually bad.  Derive it from system properties, make it
user-configurable, etc.


+/* I'd like to use wait_event_lock_irq,
+ * but I'm not sure when it got introduced,
+ * and not sure when it has 3 or 4 arguments */
+static inline void inc_ap_bio(struct drbd_conf *mdev)
[...]
+       spin_lock_irq(&mdev->req_lock);
+       while (!__inc_ap_bio_cond(mdev)) {
+               prepare_to_wait(&mdev->misc_wait, &wait, TASK_UNINTERRUPTIBLE);
+               spin_unlock_irq(&mdev->req_lock);
+               schedule();
+               finish_wait(&mdev->misc_wait, &wait);
+               spin_lock_irq(&mdev->req_lock);
+       }
+       spin_unlock_irq(&mdev->req_lock);

Since you're submitting for upstream inclusion you can just delete the extra
backwards-compatible opencoded stuff and use the generic helper.


+#define ARRY_SIZE(A) (sizeof(A)/sizeof(A[0]))

There's a generic ARRAY_SIZE(foo) somewhere in the kernel sources.  Use that
one please.


+/* this is developers aid only! */
+#define PARANOIA_ENTRY() BUG_ON(test_and_set_bit(__LC_PARANOIA, &lc->flags))
+#define PARANOIA_LEAVE() do { clear_bit(__LC_PARANOIA, &lc->flags); smp_mb__after_clear_bit(); } while (0)
+#define RETURN(x...)     do { PARANOIA_LEAVE(); return x ; } while (0)

What is the PARANOIA flag intended to verify?  This needs better commenting
or removal.  Don't use macros which take implicit arguments (IE: the lc
value is used in the macro without it being passed as a parameter).  Since
it's debugging code you could also replace the open-coded bit trylock with a
blocking spinlock.  If something hangs, just turn on lockdep and it will
report *MUCH* more useful information about the deadlock.  Macros which do a
"return" are discouraged, but since this one is called RETURN() it might be
OK.  On the other hand, you should probably rename it as PARANOIA_RETURN().


+int _drbd_md_sync_page_io(struct drbd_conf *mdev,
+                         struct drbd_backing_dev *bdev,
+                         struct page *page, sector_t sector,
+                         int rw, int size)
+{
[...]
+       ok = (bio_add_page(bio, page, size, 0) == size);
+       if (!ok) goto out;

Ewwww, can somebody say "CodingStyle"?  Don't put an if() and its result
on a single line, and just use a straight if instead:
> if (bio_add_page(bio, page, size, 0) != size)
>         goto out;


+               mask = ( hardsect / MD_HARDSECT ) - 1;
+               D_ASSERT( mask == 1 || mask == 3 || mask == 7 );
+               D_ASSERT( hardsect == (mask+1) * MD_HARDSECT );

Problematic spaces and parentheses.  Again, see Documentation/CodingStyle
for the preferred forms.  On the other hand, sometimes little code-style
things like that are left to the maintainer if they really strongly prefer
it one particular way.
