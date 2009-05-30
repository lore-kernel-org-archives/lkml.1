Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZE3C2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZE3C2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZE3C2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 22:28:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZE3C2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 22:28:09 -0400
Date: Fri, 29 May 2009 22:28:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name
  to mount debugfs filesystem.
In-Reply-To: <49b7c2350905291843i402b7161xf05fdb87eb77f73f@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905292204280.14994@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>  <1243613134.20635.14.camel@centos51>  <alpine.DEB.2.00.0905291240150.31247@gandalf.stny.rr.com> <49b7c2350905291843i402b7161xf05fdb87eb77f73f@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-457053817-1243650488=:14994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-457053817-1243650488=:14994
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Sat, 30 May 2009, GeunSik Lim wrote:

> Thanks your advice. I agree with your reply about this patch.
> I updated contents that you advised like belows.
> If I mistake, Please correct me.
>=20
> And, I also need your review  about below 2 contents in the ftrace.txt fi=
le.
>=20
> Thanks,
> GeunSik Lim.
>=20
>=20
> 1)
> @@ -1146,7 +1158,7 @@ int trace_fd;
>  [...]
>  int main(int argc, char *argv[]) {
>  =09[...]
> -=09trace_fd =3D open("/debug/tracing/tracing_enabled", O_WRONLY);
> +=09trace_fd =3D open("/sys/kernel/debug/tracing/tracing_enabled", O_WRON=
LY);
>  =09[...]
>  =09if (condition_hit()) {
>  =09=09write(trace_fd, "0", 1);
> @@ -1154,26 +1166,23 @@ int main(int argc, char *argv[]) {
>  =09[...]
>  }
>=20
>=20
> @@ -1217,12 +1226,12 @@ int main (int argc, char **argv)
>                  char line[64];
>                  int s;
>=20
> -                ffd =3D open("/debug/tracing/current_tracer", O_WRONLY);
> +                ffd =3D
> open("/sys/kernel/debug/tracing/current_tracer", O_WRONLY);
>                  if (ffd < 0)
>                          exit(-1);
>                  write(ffd, "nop", 3);
>=20
> -                fd =3D open("/debug/tracing/set_ftrace_pid", O_WRONLY);
> +                fd =3D open("/sys/kernel/debug/tracing/set_ftrace_pid",
> O_WRONLY);
>                  s =3D sprintf(line, "%d\n", getpid());
>                  write(fd, line, s);
> -Note: Here we hard coded the path name. The debugfs mount is not
> -guaranteed to be at /debug (and is more commonly at
> -/sys/kernel/debug). For simple one time traces, the above is
> -sufficent. For anything else, a search through /proc/mounts may
> +Note: Here we hard coded the path name. A search through /proc/mounts ma=
y
>  be needed to find where the debugfs file-system is mounted.

Here's the function I use:

#define _STR(x) x
#define STR(x) _STR(x)
#define MAX_PATH 256

const char *find_debugfs(void)
{
=09static char debugfs[MAX_PATH+1];
=09static int debugfs_found;
=09char type[100];
=09FILE *fp;

=09if (debugfs_found)
=09=09return debugfs;


=09if ((fp =3D fopen("/proc/mounts","r")) =3D=3D NULL) {
=09=09perror("/proc/mounts");
=09=09return NULL;
=09}

=09while (fscanf(fp, "%*s %"
=09=09      STR(MAX_PATH)
=09=09      "s %99s %*s %*d %*d\n",
=09=09      debugfs, type) =3D=3D 2) {
=09=09if (strcmp(type, "debugfs") =3D=3D 0)
=09=09=09break;
=09}
=09fclose(fp);

=09if (strcmp(type, "debugfs") !=3D 0) {
=09=09fprintf(stderr, "debugfs not mounted");
=09=09return NULL;
=09}

=09debugfs_found =3D 1;

=09return debugfs;
}

This might be a good idea to show it. This is the most robust since it=20
does not hard code the debugfs directory.

>=20
> 2)
> More details can be found in the source code, in the
> -kernel/tracing/*.c files.
> +kernel/trace/*.c files
>=20
>=20
>=20
> * about ftrace.txt file
> ---
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.=
txt
> index fd9a3e6..790199b 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -7,7 +7,6 @@ Copyright 2008 Red Hat Inc.
>                 (dual licensed under the GPL v2)
>  Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
>  =09     John Kacur, and David Teigland.
> -
>  Written for: 2.6.28-rc2
>=20
>  Introduction
> @@ -33,13 +32,26 @@ The File System
>  Ftrace uses the debugfs file system to hold the control files as
>  well as the files to display output.
>=20
> -To mount the debugfs system:
> +When debugfs is configured into the kernel (which selecting any ftrace
> +option will do) the directory /sys/kernel/debug will be created. To moun=
t
> +this directory, you can add to your /etc/fstab file:
> +
> + debugfs       /sys/kernel/debug          debugfs defaults        0     =
  0
> +
> +Or you can mount it at run time with:
> +
> + mount -t debugfs nodev /sys/kernel/debug
> +
> +For quicker access to that directory you may want to make a soft link to
> +it:
>=20
> -  # mkdir /debug
> -  # mount -t debugfs nodev /debug
> + ln -s /sys/kernel/debug /debug
>=20
> -( Note: it is more common to mount at /sys/kernel/debug, but for
> -  simplicity this document will use /debug)
> +Any selected ftrace option will also create a directory called tracing
> +within the debugfs. The rest of the document will assume that you are in
> +the ftrace directory (cd /sys/kernel/debug/tracing) and will only concen=
trate
> +on the files within that directory and not distract from the content wit=
h
> +the extended "/sys/kernel/debug/tracing" path name.
>=20
>  That's it! (assuming that you have ftrace configured into your kernel)
>=20
> @@ -389,18 +401,18 @@ trace_options
>  The trace_options file is used to control what gets printed in
>  the trace output. To see what is available, simply cat the file:
>=20
> -  cat /debug/tracing/trace_options
> +  cat ./trace_options

Please remove the "./", it is also distracting. We state that we "cd" to=20
the location. "cat trace_options" is good enough.

Same for the all the others below.

Also, since I'm the most picky about this, you may want to remove the=20
ftrace files from the patch and move it to another patch. That way the=20
owners of the other files can ack them and get those changes in. When we=20
have something for ftrace, I'll give my ack. But lets not hold up the=20
other changes because of me ;-)

-- Steve

>    print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
>    noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
>=20
>  To disable one of the options, echo in the option prepended with
>  "no".
>=20
> -  echo noprint-parent > /debug/tracing/trace_options
> +  echo noprint-parent > ./trace_options
>=20
>  To enable an option, leave off the "no".
>=20
> -  echo sym-offset > /debug/tracing/trace_options
> +  echo sym-offset > ./trace_options
>=20
>  Here are the available options:
>=20
> @@ -476,11 +488,11 @@ sched_switch
>  This tracer simply records schedule switches. Here is an example
>  of how to use it.
>=20
> - # echo sched_switch > /debug/tracing/current_tracer
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo sched_switch > ./current_tracer
> + # echo 1 > ./tracing_enabled
>   # sleep 1
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/trace
> + # echo 0 > ./tracing_enabled
> + # cat ./trace
>=20
>  # tracer: sched_switch
>  #
> @@ -574,13 +586,13 @@ new trace is saved.
>  To reset the maximum, echo 0 into tracing_max_latency. Here is
>  an example:
>=20
> - # echo irqsoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo irqsoff > ./current_tracer
> + # echo 0 > ./tracing_max_latency
> + # echo 1 > ./tracing_enabled
>   # ls -ltr
>   [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> + # echo 0 > ./tracing_enabled
> + # cat ./latency_trace
>  # tracer: irqsoff
>  #
>  irqsoff latency trace v1.1.5 on 2.6.26
> @@ -681,13 +693,13 @@ Like the irqsoff tracer, it records the maximum
> latency for
>  which preemption was disabled. The control of preemptoff tracer
>  is much like the irqsoff tracer.
>=20
> - # echo preemptoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo preemptoff > ./current_tracer
> + # echo 0 > ./tracing_max_latency
> + # echo 1 > ./tracing_enabled
>   # ls -ltr
>   [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> + # echo 0 > ./tracing_enabled
> + # cat ./latency_trace
>  # tracer: preemptoff
>  #
>  preemptoff latency trace v1.1.5 on 2.6.26-rc8
> @@ -828,13 +840,13 @@ tracer.
>  Again, using this trace is much like the irqsoff and preemptoff
>  tracers.
>=20
> - # echo preemptirqsoff > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo preemptirqsoff > ./current_tracer
> + # echo 0 > ./tracing_max_latency
> + # echo 1 > ./tracing_enabled
>   # ls -ltr
>   [...]
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> + # echo 0 > ./tracing_enabled
> + # cat ./latency_trace
>  # tracer: preemptirqsoff
>  #
>  preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
> @@ -990,12 +1002,12 @@ slightly differently than we did with the
> previous tracers.
>  Instead of performing an 'ls', we will run 'sleep 1' under
>  'chrt' which changes the priority of the task.
>=20
> - # echo wakeup > /debug/tracing/current_tracer
> - # echo 0 > /debug/tracing/tracing_max_latency
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo wakeup > ./current_tracer
> + # echo 0 > ./tracing_max_latency
> + # echo 1 > ./tracing_enabled
>   # chrt -f 5 sleep 1
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/latency_trace
> + # echo 0 > ./tracing_enabled
> + # cat ./latency_trace
>  # tracer: wakeup
>  #
>  wakeup latency trace v1.1.5 on 2.6.26-rc8
> @@ -1105,11 +1117,11 @@ can be done from the debug file system. Make sure=
 the
>  ftrace_enabled is set; otherwise this tracer is a nop.
>=20
>   # sysctl kernel.ftrace_enabled=3D1
> - # echo function > /debug/tracing/current_tracer
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo function > ./current_tracer
> + # echo 1 > ./tracing_enabled
>   # usleep 1
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/trace
> + # echo 0 > ./tracing_enabled
> + # cat ./trace
>  # tracer: function
>  #
>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> @@ -1146,7 +1158,7 @@ int trace_fd;
>  [...]
>  int main(int argc, char *argv[]) {
>  =09[...]
> -=09trace_fd =3D open("/debug/tracing/tracing_enabled", O_WRONLY);
> +=09trace_fd =3D open("/sys/kernel/debug/tracing/tracing_enabled", O_WRON=
LY);
>  =09[...]
>  =09if (condition_hit()) {
>  =09=09write(trace_fd, "0", 1);
> @@ -1154,26 +1166,23 @@ int main(int argc, char *argv[]) {
>  =09[...]
>  }
>=20
> -Note: Here we hard coded the path name. The debugfs mount is not
> -guaranteed to be at /debug (and is more commonly at
> -/sys/kernel/debug). For simple one time traces, the above is
> -sufficent. For anything else, a search through /proc/mounts may
> +Note: Here we hard coded the path name. A search through /proc/mounts ma=
y
>  be needed to find where the debugfs file-system is mounted.
>=20
>=20
>  Single thread tracing
>  ---------------------
>=20
> -By writing into /debug/tracing/set_ftrace_pid you can trace a
> +By writing into ./set_ftrace_pid you can trace a
>  single thread. For example:
>=20
> -# cat /debug/tracing/set_ftrace_pid
> +# cat ./set_ftrace_pid
>  no pid
> -# echo 3111 > /debug/tracing/set_ftrace_pid
> -# cat /debug/tracing/set_ftrace_pid
> +# echo 3111 > ./set_ftrace_pid
> +# cat ./set_ftrace_pid
>  3111
> -# echo function > /debug/tracing/current_tracer
> -# cat /debug/tracing/trace | head
> +# echo function > ./current_tracer
> +# cat ./trace | head
>   # tracer: function
>   #
>   #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> @@ -1184,8 +1193,8 @@ no pid
>       yum-updatesd-3111  [003]  1637.254683: lock_hrtimer_base
> <-hrtimer_try_to_cancel
>       yum-updatesd-3111  [003]  1637.254685: fget_light <-do_sys_poll
>       yum-updatesd-3111  [003]  1637.254686: pipe_poll <-do_sys_poll
> -# echo -1 > /debug/tracing/set_ftrace_pid
> -# cat /debug/tracing/trace |head
> +# echo -1 > ./set_ftrace_pid
> +# cat ./trace |head
>   # tracer: function
>   #
>   #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> @@ -1217,12 +1226,12 @@ int main (int argc, char **argv)
>                  char line[64];
>                  int s;
>=20
> -                ffd =3D open("/debug/tracing/current_tracer", O_WRONLY);
> +                ffd =3D
> open("/sys/kernel/debug/tracing/current_tracer", O_WRONLY);
>                  if (ffd < 0)
>                          exit(-1);
>                  write(ffd, "nop", 3);
>=20
> -                fd =3D open("/debug/tracing/set_ftrace_pid", O_WRONLY);
> +                fd =3D open("/sys/kernel/debug/tracing/set_ftrace_pid",
> O_WRONLY);
>                  s =3D sprintf(line, "%d\n", getpid());
>                  write(fd, line, s);
>=20
> @@ -1374,22 +1383,22 @@ want, depending on your needs.
>    tracing_cpu_mask file) or you might sometimes see unordered
>    function calls while cpu tracing switch.
>=20
> -=09hide: echo nofuncgraph-cpu > /debug/tracing/trace_options
> -=09show: echo funcgraph-cpu > /debug/tracing/trace_options
> +=09hide: echo nofuncgraph-cpu > ./trace_options
> +=09show: echo funcgraph-cpu > ./trace_options
>=20
>  - The duration (function's time of execution) is displayed on
>    the closing bracket line of a function or on the same line
>    than the current function in case of a leaf one. It is default
>    enabled.
>=20
> -=09hide: echo nofuncgraph-duration > /debug/tracing/trace_options
> -=09show: echo funcgraph-duration > /debug/tracing/trace_options
> +=09hide: echo nofuncgraph-duration > ./trace_options
> +=09show: echo funcgraph-duration > ./trace_options
>=20
>  - The overhead field precedes the duration field in case of
>    reached duration thresholds.
>=20
> -=09hide: echo nofuncgraph-overhead > /debug/tracing/trace_options
> -=09show: echo funcgraph-overhead > /debug/tracing/trace_options
> +=09hide: echo nofuncgraph-overhead > ./trace_options
> +=09show: echo funcgraph-overhead > ./trace_options
>  =09depends on: funcgraph-duration
>=20
>    ie:
> @@ -1418,8 +1427,8 @@ want, depending on your needs.
>  - The task/pid field displays the thread cmdline and pid which
>    executed the function. It is default disabled.
>=20
> -=09hide: echo nofuncgraph-proc > /debug/tracing/trace_options
> -=09show: echo funcgraph-proc > /debug/tracing/trace_options
> +=09hide: echo nofuncgraph-proc > ./trace_options
> +=09show: echo funcgraph-proc > ./trace_options
>=20
>    ie:
>=20
> @@ -1442,8 +1451,8 @@ want, depending on your needs.
>    system clock since it started. A snapshot of this time is
>    given on each entry/exit of functions
>=20
> -=09hide: echo nofuncgraph-abstime > /debug/tracing/trace_options
> -=09show: echo funcgraph-abstime > /debug/tracing/trace_options
> +=09hide: echo nofuncgraph-abstime > ./trace_options
> +=09show: echo funcgraph-abstime > ./trace_options
>=20
>    ie:
>=20
> @@ -1540,7 +1549,7 @@ listed in:
>=20
>     available_filter_functions
>=20
> - # cat /debug/tracing/available_filter_functions
> + # cat ./available_filter_functions
>  put_prev_task_idle
>  kmem_cache_create
>  pick_next_task_rt
> @@ -1552,12 +1561,12 @@ mutex_lock
>  If I am only interested in sys_nanosleep and hrtimer_interrupt:
>=20
>   # echo sys_nanosleep hrtimer_interrupt \
> -=09=09> /debug/tracing/set_ftrace_filter
> - # echo ftrace > /debug/tracing/current_tracer
> - # echo 1 > /debug/tracing/tracing_enabled
> +=09=09> ./set_ftrace_filter
> + # echo ftrace > ./current_tracer
> + # echo 1 > ./tracing_enabled
>   # usleep 1
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/trace
> + # echo 0 > ./tracing_enabled
> + # cat ./trace
>  # tracer: ftrace
>  #
>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> @@ -1568,7 +1577,7 @@ If I am only interested in sys_nanosleep and
> hrtimer_interrupt:
>=20
>  To see which functions are being traced, you can cat the file:
>=20
> - # cat /debug/tracing/set_ftrace_filter
> + # cat ./set_ftrace_filter
>  hrtimer_interrupt
>  sys_nanosleep
>=20
> @@ -1588,7 +1597,7 @@ Note: It is better to use quotes to enclose the
> wild cards,
>        otherwise the shell may expand the parameters into names
>        of files in the local directory.
>=20
> - # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
> + # echo 'hrtimer_*' > ./set_ftrace_filter
>=20
>  Produces:
>=20
> @@ -1609,7 +1618,7 @@ Produces:
>=20
>  Notice that we lost the sys_nanosleep.
>=20
> - # cat /debug/tracing/set_ftrace_filter
> + # cat ./set_ftrace_filter
>  hrtimer_run_queues
>  hrtimer_run_pending
>  hrtimer_init
> @@ -1635,17 +1644,17 @@ To append to the filters, use '>>'
>  To clear out a filter so that all functions will be recorded
>  again:
>=20
> - # echo > /debug/tracing/set_ftrace_filter
> - # cat /debug/tracing/set_ftrace_filter
> + # echo > ./set_ftrace_filter
> + # cat ./set_ftrace_filter
>   #
>=20
>  Again, now we want to append.
>=20
> - # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
> - # cat /debug/tracing/set_ftrace_filter
> + # echo sys_nanosleep > ./set_ftrace_filter
> + # cat ./set_ftrace_filter
>  sys_nanosleep
> - # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
> - # cat /debug/tracing/set_ftrace_filter
> + # echo 'hrtimer_*' >> ./set_ftrace_filter
> + # cat ./set_ftrace_filter
>  hrtimer_run_queues
>  hrtimer_run_pending
>  hrtimer_init
> @@ -1668,7 +1677,7 @@ hrtimer_init_sleeper
>  The set_ftrace_notrace prevents those functions from being
>  traced.
>=20
> - # echo '*preempt*' '*lock*' > /debug/tracing/set_ftrace_notrace
> + # echo '*preempt*' '*lock*' > ./set_ftrace_notrace
>=20
>  Produces:
>=20
> @@ -1758,13 +1767,13 @@ the effect on the tracing is different. Every rea=
d from
>  trace_pipe is consumed. This means that subsequent reads will be
>  different. The trace is live.
>=20
> - # echo function > /debug/tracing/current_tracer
> - # cat /debug/tracing/trace_pipe > /tmp/trace.out &
> + # echo function > ./current_tracer
> + # cat ./trace_pipe > /tmp/trace.out &
>  [1] 4153
> - # echo 1 > /debug/tracing/tracing_enabled
> + # echo 1 > ./tracing_enabled
>   # usleep 1
> - # echo 0 > /debug/tracing/tracing_enabled
> - # cat /debug/tracing/trace
> + # echo 0 > ./tracing_enabled
> + # cat ./trace
>  # tracer: function
>  #
>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> @@ -1800,7 +1809,7 @@ number listed is the number of entries that can
> be recorded per
>  CPU. To know the full size, multiply the number of possible CPUS
>  with the number of entries.
>=20
> - # cat /debug/tracing/buffer_size_kb
> + # cat ./buffer_size_kb
>  1408 (units kilobytes)
>=20
>  Note, to modify this, you must have tracing completely disabled.
> @@ -1808,21 +1817,21 @@ To do that, echo "nop" into the current_tracer. I=
f the
>  current_tracer is not set to "nop", an EINVAL error will be
>  returned.
>=20
> - # echo nop > /debug/tracing/current_tracer
> - # echo 10000 > /debug/tracing/buffer_size_kb
> - # cat /debug/tracing/buffer_size_kb
> + # echo nop > ./current_tracer
> + # echo 10000 > ./buffer_size_kb
> + # cat ./buffer_size_kb
>  10000 (units kilobytes)
>=20
>  The number of pages which will be allocated is limited to a
>  percentage of available memory. Allocating too much will produce
>  an error.
>=20
> - # echo 1000000000000 > /debug/tracing/buffer_size_kb
> + # echo 1000000000000 > ./buffer_size_kb
>  -bash: echo: write error: Cannot allocate memory
> - # cat /debug/tracing/buffer_size_kb
> + # cat ./buffer_size_kb
>  85
>=20
>  ---
>=20
> On Sat, May 30, 2009 at 1:48 AM, Steven Rostedt <rostedt@goodmis.org> wro=
te:
> >
> >
> >
> > On Sat, 30 May 2009, GeunSik Lim wrote:
> >
> >>
> >>
> >> Dear Greg and Steen,
> >>
> >> Thanks your advices and opinions about a confusion according to
> >> too many mount directory names for debugfs. I made rfc v2 patch file a=
gain like belows.
> >> Can I hear your advices about below patch contents?.
> >>
> >> * ref:
> >> http://groups.google.com/group/linux.kernel/browse_thread/thread/c34e3=
86587979340/dc52317f888e78b6?#dc52317f888e78b6
> >>
> >>
> >> Regards,
> >> GeunSik Lim.
> >>
> >> Subject: [PATCH] =C2=A0 Fix terminology inconsistency of dir name to m=
ount debugfs filesystem.
> >>
> >> =C2=A0 =C2=A0 =C2=A0 Many developers use "/debug/" or "/debugfs/ direc=
tory name to mount
> >> =C2=A0 =C2=A0 =C2=A0 debugfs filesystem for ftrace according to
> >> =C2=A0 =C2=A0 =C2=A0 ./Documentation/tracers/ftrace.txt file.
> >>
> >> =C2=A0 =C2=A0 =C2=A0 And, three directory names(ex:/debug/, /debugfs/,=
 /sys/kernel/debug/) is
> >> =C2=A0 =C2=A0 =C2=A0 existed in kernel source like ftrace, DRM, Wirele=
ss, Network[sky2]files
> >> =C2=A0 =C2=A0 =C2=A0 to mount debugfs filesystem.
> >>
> >> =C2=A0 =C2=A0 =C2=A0 debugfs means debug filesystem for debugging easy=
 to use by greg kroah
> >> =C2=A0 =C2=A0 =C2=A0 hartman. "/sys/kernel/debug/" name is suitable as=
 directory name
> >> =C2=A0 =C2=A0 =C2=A0 of debugfs filesystem.
> >> =C2=A0 =C2=A0 =C2=A0 -debugfs related reference: http://lwn.net/Articl=
es/115405/
> >
> > Note, LWN has an update this week:
> >
> > =C2=A0http://lwn.net/Articles/334546/
> >
> > But it currently is subscriber only. Others would need to either buy a
> > subscription (plug) or wait a week for it to become open.
> >
> > Still for some aspects, just having "debugfs" without the leading "/"
> > might just be self explanatory. We can assume the user already knows wh=
ere
> > debugfs is mounted.
> >
> > -- Steve
> >
> >
> >>
> >> =C2=A0 =C2=A0 =C2=A0 Fix inconsistency of directory name to mount debu=
gfs filesystem.
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Signed-off-by: GeunSik Lim <geunsik.=
lim@samsung.com>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Acked-By: Inaky Perez-Gonzalez <inak=
y@linux.intel.com>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CC: Greg KH <greg@kroah.com>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CC: Steven Rostedt <rostedt@goodmis.=
org>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CC: linux-kernel <linux-kernel@vger.=
kernel.org>
> >
>=20
>=20
>=20
> --=20
> Regards,
> GeunSik Lim ( SAMSUNG ELECTRONICS)
> Blog : http://blog.naver.com/invain/
> e-Mail: geunsik.lim@samsung.com
>            leemgs@gmail.com , leemgs1@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20
--8323328-457053817-1243650488=:14994--
