Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYDYM4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYDYM4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYDYM4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:56:12 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:58587 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYDYM4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:56:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEANBwEUhMROPA/2dsb2JhbACBUqp4
Date: Fri, 25 Apr 2008 08:56:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 34/37] LTTng instrumentation ipc
Message-ID: <20080425125607.GC28411@Krystal>
References: <20080424150324.802695381@polymtl.ca> <20080424151407.622943449@polymtl.ca> <20080424230238.GA11699@martell.zuzino.mipt.ru> <y0mve26r874.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mve26r874.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:56:06 up 56 days,  8:07,  4 users,  load average: 0.17, 0.54,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> 
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 

Alexey, I'll reply to Frank's email, but first let me thank you for
looking into this.

> > [...]
> > Can I write
> > 	if (rv < 0)
> > 		trace_mark(foo, "rv %d", rv);
> 
> Sure.
> 
> > Looks like i could. But people want also want to see success, so what?
> > Two markers per exit?
> >
> > 	rv = ipc_get(...);
> > 	if (rv < 0)
> > 		trace_marker(foo_err, ...);
> > 	trace_marker(foo_all, ...);
> 
> That seems excessive.  Just pass "rv" value and let the consumer
> decide whether they care about < 0.
> 
> You seem to be operating under the mistaken assumption that marker
> consumers will simply have to pass on the full firehose flow without
> filtering.  That is not so.  I suspect lttng can do it, but I know
> that with systemtap, it's trivial to encode conditions on the marker
> parameters and other state (e.g., recent events of interest), so that
> only finely tuned events actually get sent to the end user.
> 

The preferred way to do it would be

  trace_mark(foo, "rv %d", rv);

And let the probe deal with rv. The main reason is that by adding

if (test)
  trace_mark()

you will add a branch in the normal kernel code flow and slow down the
kernel a bit when disabled compared to the optimized markers.

> 
> > Also everything inserted so far is static. Sometimes only one bit in
> > mask is interesting and to save time to parse nibbles people do:
> > 	printk("foo = %d\n", !!(mask & foo));
> > And interesting bits vary.
> 
> OK, perhaps pass both mask & foo, and let the consumer perform the
> arithmetic they deem appropriate.
> 

Agreed. However, adding stuff like

!!(mask & foo)

as parameter to a marker won't add to the disabled marker runtime cost,
since it's evaluated within the "marker enabled" block. So, if all you
really need is !!(mask & foo) (and never other information about foo),
then it could make sense to use the most restrictive version so we don't
export internal details about the kernel implementation.

> 
> > Again, all events aren't interesting:
> > 	if (file && file->f_op == &shm_file_operations)
> > 		printk("%s: file = %p: START\n", __func__, file);
> > Can I write this with markers?
> 
> Of course, if you really want to.
> 

__func__ is not really interesting here, because you can name your
marker. A useful trick can be to use __builtin_return_address(0) when
needed though.

for the rest, a way that would not export too much information about
kernel's internals :

trace_mark(shm_start, "is_shm_fop %d file %p",
  file->f_op == &shm_file_operations, file);

And yes, there is a small runtime cost added here when the marker is
enabled: the test is done in the probe called rather that in the spot.
On the other hand, the impact is nearly zero when the marker is
disabled.

If you really really want to, I could modify the markers to make this
even easier by doing something like :

trace_mark_cond(file->f_op == &shm_file_operations,
  shm_start, "file %p", file);

Where the first argument would be a supplementary condition tested in
the marker block. That would make the active marker case faster. How do
you like that ? (see patch appended at the end of the email)



> > So what is proposed? Insert markers at places that look strategic? 
> 
> "strategic" is the wrong term.  Choose those places that reflect
> internal occurrences that are useful but difficult to reverse-engineer
> from other visible interface points like system calls.  Data that
> helps answer questions like "Why did (subtle internal phenomenon)
> happen?" in a live system.
> 

I totally agree. And we need to do some work in the system call tracing
area as a starting point. That will help remove some unnecessary
instrumentation I have in LTTng.

> 
> > mm/ patch is full if "file %p". Do you realize that pointers are
> > only sometimes interesting and sometimes you want dentry (not pointer,
> > but name!):
> > 	printk("file = '%s'\n", file->f_dentry->d_name.name);
> 
> It may not be excessive to put both file and the dname.name as marker
> parameters.
> 

eek, well, if we really want to identify a file, we need more than its
name. mount points, full path and file name are required. It brings me a
few years back, but I don't think the dentry name gives us that. This is
why I extract information about all opened files to my tracer once
(mapping the mount point, path and file name to file pointer) and then I
don't have to do the lookup each time the marker is encountered. Yes,
this involved a file pointers dumping at tracer start and keeping track
of open/close events.

> 
> > So, let me say even more explicitly. Looking at proposed places elite
> > enough to be blessed with marker...
> >
> > Those which are close enough to system call boundary are essentially
> > strace(1).
> 
> Those may not sound worthwhile to put a marker for, BUT, you're
> ignoring the huge differences of impact and scope.  A system-wide
> marker-based trace (filtered a la systemtap if desired) can be done
> with a tiny fraction of system load and none of the disruption caused
> by an strace of all the processes.
> 

I agree with both ;) Actually we need a low-overhead hook in
syscall_trace(), so we can perform efficient system-wide tracing of
system calls. I'll dig in this as soon as I find time.

Basic ideas :

- I already have the TIF_KERNEL_TRACE thread flag added to all
  architectures in another patchset.
- We add a function called on TIF_KERNEL_TRACE, from do_syscall_trace(),
  which is architecture-specific. It's basically a big switch() for all
  system calls. syscalls which takes similar types could be grouped
  together, but I don't think it would be useful at all. It might be
  better just to add a trace_mark for each so we extract the syscall
  fields in the marker string.
- We perform the page fault (caused by strings and structures) reads on
  the spot, because we prefer not to do this in atomic context.
- We put a marker, e.g., for x86_32, a pseudo-code like :

syscall_trace_enter()
{
  ...
  if (test_thread_flag(TIF_KERNEL_TRACE))
    do_marker_syscall_trace();
  ...
}

do_marker_syscall_trace()
{
  char *tmpbuf;

  switch(regs->orig_ax) {

  case SYS_OPEN:
    tmpbuf = vmalloc(4096); /* what size is needed ? */
    copy_from_user(tmpbuf, regs->bx);
    trace_mark(sys_open, "filename %p flags %d mode %d",
      tmpbuf, regs->cx, regs->dx);
    vfree(tmpbuf);
    break;
  }
}

Modulo some optimization, what do you think of this ? If someone is
willing to implement this, I can provide the patchset for
TIF_KERNEL_TRACE.

> 
> > [...]  Markers points won't be removed, only accumulated -- somebody
> > _might_ be interested in this information.
> 
> We all (data producers and consumers) need to use good judgment and
> accept moderate change.
> 
> 
> - FChE

Yes, and I see more and more that we need the in-kernel syscall tracing
infrastructure as a starting point. Then, the only markers left will
deal with useful inner-kernel information like scheduler change, vmalloc
memory allocation, and so on.

Mathieu


Markers condition

> 
> > Again, all events aren't interesting:
> >   if (file && file->f_op == &shm_file_operations)
> >     printk("%s: file = %p: START\n", __func__, file);
> > Can I write this with markers?
> 
> Of course, if you really want to.
> 

__func__ is not really interesting here, because you can name your
marker. A useful trick can be to use __builtin_return_address(0) when
needed though.

for the rest, a way that would not export too much information about
kernel's internals :

trace_mark(shm_start, "is_shm_fop %d file %p",
  file->f_op == &shm_file_operations, file);

And yes, there is a small runtime cost added here when the marker is
enabled: the test is done in the probe called rather that in the spot.
On the other hand, the impact is nearly zero when the marker is
disabled.

If you really really whant to, I could modify the markers to make this
even easier by doing something like :

trace_mark_cond(file->f_op == &shm_file_operations,
  shm_start, "file %p", file);

Where the first argument would be a supplementary condition tested in
the marker block. That would make the active marker case faster. How do
you like that ?

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org
---
 include/linux/marker.h |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-04-25 08:16:21.000000000 -0400
+++ linux-2.6-lttng/include/linux/marker.h	2008-04-25 08:21:27.000000000 -0400
@@ -64,7 +64,7 @@ struct marker {
  * If generic is true, a variable read is used.
  * If generic is false, immediate values are used.
  */
-#define __trace_mark(generic, name, call_private, format, args...)	\
+#define __trace_mark(generic, cond, name, call_private, format, args...)\
 	do {								\
 		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
@@ -76,12 +76,12 @@ struct marker {
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
 		if (!generic) {						\
-			if (unlikely(imv_cond(__mark_##name.state)))	\
+			if (unlikely(imv_cond(__mark_##name.state) && (cond))) \
 				(*__mark_##name.call)			\
 					(&__mark_##name, call_private,	\
 					## args);			\
 		} else {						\
-			if (unlikely(_imv_read(__mark_##name.state)))	\
+			if (unlikely(_imv_read(__mark_##name.state) && (cond)))\
 				(*__mark_##name.call)			\
 					(&__mark_##name, call_private,	\
 					## args);			\
@@ -108,7 +108,7 @@ static inline void marker_update_probe_r
  * to be enabled when immediate values are present.
  */
 #define trace_mark(name, format, args...) \
-	__trace_mark(0, name, NULL, format, ## args)
+	__trace_mark(0, 1, name, NULL, format, ## args)
 
 /**
  * _trace_mark - Marker using variable read
@@ -122,7 +122,31 @@ static inline void marker_update_probe_r
  * lockdep, some traps, printk).
  */
 #define _trace_mark(name, format, args...) \
-	__trace_mark(1, name, NULL, format, ## args)
+	__trace_mark(1, 1, name, NULL, format, ## args)
+
+/**
+ * trace_mark_cond - Marker using code patching, testing a condition
+ * @cond: condition to test
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Like trace_mark(), but tests if cond is true to execute the trace mark.
+ */
+#define trace_mark_cond(cond, name, format, args...) \
+	__trace_mark(0, cond, name, NULL, format, ## args)
+
+/**
+ * _trace_mark_cond - Marker using variable read, testing a condition
+ * @cond: condition to test
+ * @name: marker name, not quoted.
+ * @format: format string
+ * @args...: variable argument list
+ *
+ * Like _trace_mark(), but tests if cond is true to execute the trace mark.
+ */
+#define _trace_mark_cond(cond, name, format, args...) \
+	__trace_mark(1, cond, name, NULL, format, ## args)
 
 /**
  * MARK_NOARGS - Format string for a marker with no argument.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
