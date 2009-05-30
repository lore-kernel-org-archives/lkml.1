Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZE3Jip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZE3Jip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 05:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZE3Jih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 05:38:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:40865 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZE3Jif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 05:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eD0yari9YZnHsSNGkHdl3QuosP5D0KwjRWptLXd09zPk3yA2hIS3BjIw0UU7xYEk1R
         JWa0s8GTHJa+GgYR6k1s2cqGNGVmp77/kNCQHxyOlkBQjDJfzUO+0tcPmEWHYLNeGr8k
         KOsGwFi3lna8j6c1U7LyQxXI+5YsT8XpHtX2M=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905292204280.14994@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>
	 <1243613134.20635.14.camel@centos51>
	 <alpine.DEB.2.00.0905291240150.31247@gandalf.stny.rr.com>
	 <49b7c2350905291843i402b7161xf05fdb87eb77f73f@mail.gmail.com>
	 <alpine.DEB.2.00.0905292204280.14994@gandalf.stny.rr.com>
Date: Sat, 30 May 2009 18:38:36 +0900
Message-ID: <49b7c2350905300238k5f6259fne30ad94f8fbf7e20@mail.gmail.com>
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name 
	to mount debugfs filesystem.
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 11:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 30 May 2009, GeunSik Lim wrote:
>
>> Thanks your advice. I agree with your reply about this patch.
>> I updated contents that you advised like belows.
>> If I mistake, Please correct me.
>>
>> And, I also need your review  about below 2 contents in the ftrace.txt file.
>>
>> Thanks,
>> GeunSik Lim.
>>
>>
>> 1)
>> @@ -1146,7 +1158,7 @@ int trace_fd;
>>  [...]
>>  int main(int argc, char *argv[]) {
>>       [...]
>> -     trace_fd = open("/debug/tracing/tracing_enabled", O_WRONLY);
>> +     trace_fd = open("/sys/kernel/debug/tracing/tracing_enabled", O_WRONLY);
>>       [...]
>>       if (condition_hit()) {
>>               write(trace_fd, "0", 1);
>> @@ -1154,26 +1166,23 @@ int main(int argc, char *argv[]) {
>>       [...]
>>  }
>>
>>
>> @@ -1217,12 +1226,12 @@ int main (int argc, char **argv)
>>                  char line[64];
>>                  int s;
>>
>> -                ffd = open("/debug/tracing/current_tracer", O_WRONLY);
>> +                ffd =
>> open("/sys/kernel/debug/tracing/current_tracer", O_WRONLY);
>>                  if (ffd < 0)
>>                          exit(-1);
>>                  write(ffd, "nop", 3);
>>
>> -                fd = open("/debug/tracing/set_ftrace_pid", O_WRONLY);
>> +                fd = open("/sys/kernel/debug/tracing/set_ftrace_pid",
>> O_WRONLY);
>>                  s = sprintf(line, "%d\n", getpid());
>>                  write(fd, line, s);
>> -Note: Here we hard coded the path name. The debugfs mount is not
>> -guaranteed to be at /debug (and is more commonly at
>> -/sys/kernel/debug). For simple one time traces, the above is
>> -sufficent. For anything else, a search through /proc/mounts may
>> +Note: Here we hard coded the path name. A search through /proc/mounts may
>>  be needed to find where the debugfs file-system is mounted.
>
> Here's the function I use:
>
> #define _STR(x) x
> #define STR(x) _STR(x)
> #define MAX_PATH 256
>
> const char *find_debugfs(void)
> {
>        static char debugfs[MAX_PATH+1];
>        static int debugfs_found;
>        char type[100];
>        FILE *fp;
>
>        if (debugfs_found)
>                return debugfs;
>
>
>        if ((fp = fopen("/proc/mounts","r")) == NULL) {
>                perror("/proc/mounts");
>                return NULL;
>        }
>
>        while (fscanf(fp, "%*s %"
>                      STR(MAX_PATH)
>                      "s %99s %*s %*d %*d\n",
>                      debugfs, type) == 2) {
>                if (strcmp(type, "debugfs") == 0)
>                        break;
>        }
>        fclose(fp);
>
>        if (strcmp(type, "debugfs") != 0) {
>                fprintf(stderr, "debugfs not mounted");
>                return NULL;
>        }
>
>        debugfs_found = 1;
>
>        return debugfs;
> }
>
> This might be a good idea to show it. This is the most robust since it
> does not hard code the debugfs directory.
Yes, I think so. I have one opinion in the above find_debugfs() function.
Default directory  is "/sys/kernel/debug/tracing" in ftrace.txt file
as you mentioned.
I will append  below code for "***/tracing/" directory name.

         int size;
         [...]
         size = MAX_PATH - strlen(debugfs);
         strncat(debugfs, "/tracing/", size);
         return debugfs;
>
>>
>> 2)
>> More details can be found in the source code, in the
>> -kernel/tracing/*.c files.
>> +kernel/trace/*.c files
>>
>>
>>
>> * about ftrace.txt file
>> ---
>> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> index fd9a3e6..790199b 100644
>> --- a/Documentation/trace/ftrace.txt
>> +++ b/Documentation/trace/ftrace.txt
>> @@ -7,7 +7,6 @@ Copyright 2008 Red Hat Inc.
>>                 (dual licensed under the GPL v2)
>>  Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
>>            John Kacur, and David Teigland.
>> -
>>  Written for: 2.6.28-rc2
>>
>>  Introduction
>> @@ -33,13 +32,26 @@ The File System
>>  Ftrace uses the debugfs file system to hold the control files as
>>  well as the files to display output.
>>
>> -To mount the debugfs system:
>> +When debugfs is configured into the kernel (which selecting any ftrace
>> +option will do) the directory /sys/kernel/debug will be created. To mount
>> +this directory, you can add to your /etc/fstab file:
>> +
>> + debugfs       /sys/kernel/debug          debugfs defaults        0       0
>> +
>> +Or you can mount it at run time with:
>> +
>> + mount -t debugfs nodev /sys/kernel/debug
>> +
>> +For quicker access to that directory you may want to make a soft link to
>> +it:
>>
>> -  # mkdir /debug
>> -  # mount -t debugfs nodev /debug
>> + ln -s /sys/kernel/debug /debug
>>
>> -( Note: it is more common to mount at /sys/kernel/debug, but for
>> -  simplicity this document will use /debug)
>> +Any selected ftrace option will also create a directory called tracing
>> +within the debugfs. The rest of the document will assume that you are in
>> +the ftrace directory (cd /sys/kernel/debug/tracing) and will only concentrate
>> +on the files within that directory and not distract from the content with
>> +the extended "/sys/kernel/debug/tracing" path name.
>>
>>  That's it! (assuming that you have ftrace configured into your kernel)
>>
>> @@ -389,18 +401,18 @@ trace_options
>>  The trace_options file is used to control what gets printed in
>>  the trace output. To see what is available, simply cat the file:
>>
>> -  cat /debug/tracing/trace_options
>> +  cat ./trace_options
>
> Please remove the "./", it is also distracting. We state that we "cd" to
> the location. "cat trace_options" is good enough.
It's right. This is just my private style. I will  remove "./".
>
> Same for the all the others below.
>
> Also, since I'm the most picky about this, you may want to remove the
> ftrace files from the patch and move it to another patch. That way the
I am not think that you are the most picky about this. I like your advice and
review about my proposal for consensus.
> owners of the other files can ack them and get those changes in. When we
> have something for ftrace, I'll give my ack. But lets not hold up the
> other changes because of me ;-)
>
Don't care. Hope it helps. ;-)
I will modify  ftrace files from the patch according to your advice.

> -- Steve
>
>>    print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
>>    noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
>>
>>  To disable one of the options, echo in the option prepended with
>>  "no".
>>
>> -  echo noprint-parent > /debug/tracing/trace_options
>> +  echo noprint-parent > ./trace_options
>>
>>  To enable an option, leave off the "no".
>>
>> -  echo sym-offset > /debug/tracing/trace_options
>> +  echo sym-offset > ./trace_options
>>
>>  Here are the available options:
>>
>> @@ -476,11 +488,11 @@ sched_switch
>>  This tracer simply records schedule switches. Here is an example
>>  of how to use it.
>>
>> - # echo sched_switch > /debug/tracing/current_tracer
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo sched_switch > ./current_tracer
>> + # echo 1 > ./tracing_enabled
>>   # sleep 1
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./trace
>>
>>  # tracer: sched_switch
>>  #
>> @@ -574,13 +586,13 @@ new trace is saved.
>>  To reset the maximum, echo 0 into tracing_max_latency. Here is
>>  an example:
>>
>> - # echo irqsoff > /debug/tracing/current_tracer
>> - # echo 0 > /debug/tracing/tracing_max_latency
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo irqsoff > ./current_tracer
>> + # echo 0 > ./tracing_max_latency
>> + # echo 1 > ./tracing_enabled
>>   # ls -ltr
>>   [...]
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/latency_trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./latency_trace
>>  # tracer: irqsoff
>>  #
>>  irqsoff latency trace v1.1.5 on 2.6.26
>> @@ -681,13 +693,13 @@ Like the irqsoff tracer, it records the maximum
>> latency for
>>  which preemption was disabled. The control of preemptoff tracer
>>  is much like the irqsoff tracer.
>>
>> - # echo preemptoff > /debug/tracing/current_tracer
>> - # echo 0 > /debug/tracing/tracing_max_latency
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo preemptoff > ./current_tracer
>> + # echo 0 > ./tracing_max_latency
>> + # echo 1 > ./tracing_enabled
>>   # ls -ltr
>>   [...]
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/latency_trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./latency_trace
>>  # tracer: preemptoff
>>  #
>>  preemptoff latency trace v1.1.5 on 2.6.26-rc8
>> @@ -828,13 +840,13 @@ tracer.
>>  Again, using this trace is much like the irqsoff and preemptoff
>>  tracers.
>>
>> - # echo preemptirqsoff > /debug/tracing/current_tracer
>> - # echo 0 > /debug/tracing/tracing_max_latency
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo preemptirqsoff > ./current_tracer
>> + # echo 0 > ./tracing_max_latency
>> + # echo 1 > ./tracing_enabled
>>   # ls -ltr
>>   [...]
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/latency_trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./latency_trace
>>  # tracer: preemptirqsoff
>>  #
>>  preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
>> @@ -990,12 +1002,12 @@ slightly differently than we did with the
>> previous tracers.
>>  Instead of performing an 'ls', we will run 'sleep 1' under
>>  'chrt' which changes the priority of the task.
>>
>> - # echo wakeup > /debug/tracing/current_tracer
>> - # echo 0 > /debug/tracing/tracing_max_latency
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo wakeup > ./current_tracer
>> + # echo 0 > ./tracing_max_latency
>> + # echo 1 > ./tracing_enabled
>>   # chrt -f 5 sleep 1
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/latency_trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./latency_trace
>>  # tracer: wakeup
>>  #
>>  wakeup latency trace v1.1.5 on 2.6.26-rc8
>> @@ -1105,11 +1117,11 @@ can be done from the debug file system. Make sure the
>>  ftrace_enabled is set; otherwise this tracer is a nop.
>>
>>   # sysctl kernel.ftrace_enabled=1
>> - # echo function > /debug/tracing/current_tracer
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo function > ./current_tracer
>> + # echo 1 > ./tracing_enabled
>>   # usleep 1
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./trace
>>  # tracer: function
>>  #
>>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>> @@ -1146,7 +1158,7 @@ int trace_fd;
>>  [...]
>>  int main(int argc, char *argv[]) {
>>       [...]
>> -     trace_fd = open("/debug/tracing/tracing_enabled", O_WRONLY);
>> +     trace_fd = open("/sys/kernel/debug/tracing/tracing_enabled", O_WRONLY);
>>       [...]
>>       if (condition_hit()) {
>>               write(trace_fd, "0", 1);
>> @@ -1154,26 +1166,23 @@ int main(int argc, char *argv[]) {
>>       [...]
>>  }
>>
>> -Note: Here we hard coded the path name. The debugfs mount is not
>> -guaranteed to be at /debug (and is more commonly at
>> -/sys/kernel/debug). For simple one time traces, the above is
>> -sufficent. For anything else, a search through /proc/mounts may
>> +Note: Here we hard coded the path name. A search through /proc/mounts may
>>  be needed to find where the debugfs file-system is mounted.
>>
>>
>>  Single thread tracing
>>  ---------------------
>>
>> -By writing into /debug/tracing/set_ftrace_pid you can trace a
>> +By writing into ./set_ftrace_pid you can trace a
>>  single thread. For example:
>>
>> -# cat /debug/tracing/set_ftrace_pid
>> +# cat ./set_ftrace_pid
>>  no pid
>> -# echo 3111 > /debug/tracing/set_ftrace_pid
>> -# cat /debug/tracing/set_ftrace_pid
>> +# echo 3111 > ./set_ftrace_pid
>> +# cat ./set_ftrace_pid
>>  3111
>> -# echo function > /debug/tracing/current_tracer
>> -# cat /debug/tracing/trace | head
>> +# echo function > ./current_tracer
>> +# cat ./trace | head
>>   # tracer: function
>>   #
>>   #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>> @@ -1184,8 +1193,8 @@ no pid
>>       yum-updatesd-3111  [003]  1637.254683: lock_hrtimer_base
>> <-hrtimer_try_to_cancel
>>       yum-updatesd-3111  [003]  1637.254685: fget_light <-do_sys_poll
>>       yum-updatesd-3111  [003]  1637.254686: pipe_poll <-do_sys_poll
>> -# echo -1 > /debug/tracing/set_ftrace_pid
>> -# cat /debug/tracing/trace |head
>> +# echo -1 > ./set_ftrace_pid
>> +# cat ./trace |head
>>   # tracer: function
>>   #
>>   #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>> @@ -1217,12 +1226,12 @@ int main (int argc, char **argv)
>>                  char line[64];
>>                  int s;
>>
>> -                ffd = open("/debug/tracing/current_tracer", O_WRONLY);
>> +                ffd =
>> open("/sys/kernel/debug/tracing/current_tracer", O_WRONLY);
>>                  if (ffd < 0)
>>                          exit(-1);
>>                  write(ffd, "nop", 3);
>>
>> -                fd = open("/debug/tracing/set_ftrace_pid", O_WRONLY);
>> +                fd = open("/sys/kernel/debug/tracing/set_ftrace_pid",
>> O_WRONLY);
>>                  s = sprintf(line, "%d\n", getpid());
>>                  write(fd, line, s);
>>
>> @@ -1374,22 +1383,22 @@ want, depending on your needs.
>>    tracing_cpu_mask file) or you might sometimes see unordered
>>    function calls while cpu tracing switch.
>>
>> -     hide: echo nofuncgraph-cpu > /debug/tracing/trace_options
>> -     show: echo funcgraph-cpu > /debug/tracing/trace_options
>> +     hide: echo nofuncgraph-cpu > ./trace_options
>> +     show: echo funcgraph-cpu > ./trace_options
>>
>>  - The duration (function's time of execution) is displayed on
>>    the closing bracket line of a function or on the same line
>>    than the current function in case of a leaf one. It is default
>>    enabled.
>>
>> -     hide: echo nofuncgraph-duration > /debug/tracing/trace_options
>> -     show: echo funcgraph-duration > /debug/tracing/trace_options
>> +     hide: echo nofuncgraph-duration > ./trace_options
>> +     show: echo funcgraph-duration > ./trace_options
>>
>>  - The overhead field precedes the duration field in case of
>>    reached duration thresholds.
>>
>> -     hide: echo nofuncgraph-overhead > /debug/tracing/trace_options
>> -     show: echo funcgraph-overhead > /debug/tracing/trace_options
>> +     hide: echo nofuncgraph-overhead > ./trace_options
>> +     show: echo funcgraph-overhead > ./trace_options
>>       depends on: funcgraph-duration
>>
>>    ie:
>> @@ -1418,8 +1427,8 @@ want, depending on your needs.
>>  - The task/pid field displays the thread cmdline and pid which
>>    executed the function. It is default disabled.
>>
>> -     hide: echo nofuncgraph-proc > /debug/tracing/trace_options
>> -     show: echo funcgraph-proc > /debug/tracing/trace_options
>> +     hide: echo nofuncgraph-proc > ./trace_options
>> +     show: echo funcgraph-proc > ./trace_options
>>
>>    ie:
>>
>> @@ -1442,8 +1451,8 @@ want, depending on your needs.
>>    system clock since it started. A snapshot of this time is
>>    given on each entry/exit of functions
>>
>> -     hide: echo nofuncgraph-abstime > /debug/tracing/trace_options
>> -     show: echo funcgraph-abstime > /debug/tracing/trace_options
>> +     hide: echo nofuncgraph-abstime > ./trace_options
>> +     show: echo funcgraph-abstime > ./trace_options
>>
>>    ie:
>>
>> @@ -1540,7 +1549,7 @@ listed in:
>>
>>     available_filter_functions
>>
>> - # cat /debug/tracing/available_filter_functions
>> + # cat ./available_filter_functions
>>  put_prev_task_idle
>>  kmem_cache_create
>>  pick_next_task_rt
>> @@ -1552,12 +1561,12 @@ mutex_lock
>>  If I am only interested in sys_nanosleep and hrtimer_interrupt:
>>
>>   # echo sys_nanosleep hrtimer_interrupt \
>> -             > /debug/tracing/set_ftrace_filter
>> - # echo ftrace > /debug/tracing/current_tracer
>> - # echo 1 > /debug/tracing/tracing_enabled
>> +             > ./set_ftrace_filter
>> + # echo ftrace > ./current_tracer
>> + # echo 1 > ./tracing_enabled
>>   # usleep 1
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./trace
>>  # tracer: ftrace
>>  #
>>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>> @@ -1568,7 +1577,7 @@ If I am only interested in sys_nanosleep and
>> hrtimer_interrupt:
>>
>>  To see which functions are being traced, you can cat the file:
>>
>> - # cat /debug/tracing/set_ftrace_filter
>> + # cat ./set_ftrace_filter
>>  hrtimer_interrupt
>>  sys_nanosleep
>>
>> @@ -1588,7 +1597,7 @@ Note: It is better to use quotes to enclose the
>> wild cards,
>>        otherwise the shell may expand the parameters into names
>>        of files in the local directory.
>>
>> - # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
>> + # echo 'hrtimer_*' > ./set_ftrace_filter
>>
>>  Produces:
>>
>> @@ -1609,7 +1618,7 @@ Produces:
>>
>>  Notice that we lost the sys_nanosleep.
>>
>> - # cat /debug/tracing/set_ftrace_filter
>> + # cat ./set_ftrace_filter
>>  hrtimer_run_queues
>>  hrtimer_run_pending
>>  hrtimer_init
>> @@ -1635,17 +1644,17 @@ To append to the filters, use '>>'
>>  To clear out a filter so that all functions will be recorded
>>  again:
>>
>> - # echo > /debug/tracing/set_ftrace_filter
>> - # cat /debug/tracing/set_ftrace_filter
>> + # echo > ./set_ftrace_filter
>> + # cat ./set_ftrace_filter
>>   #
>>
>>  Again, now we want to append.
>>
>> - # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
>> - # cat /debug/tracing/set_ftrace_filter
>> + # echo sys_nanosleep > ./set_ftrace_filter
>> + # cat ./set_ftrace_filter
>>  sys_nanosleep
>> - # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
>> - # cat /debug/tracing/set_ftrace_filter
>> + # echo 'hrtimer_*' >> ./set_ftrace_filter
>> + # cat ./set_ftrace_filter
>>  hrtimer_run_queues
>>  hrtimer_run_pending
>>  hrtimer_init
>> @@ -1668,7 +1677,7 @@ hrtimer_init_sleeper
>>  The set_ftrace_notrace prevents those functions from being
>>  traced.
>>
>> - # echo '*preempt*' '*lock*' > /debug/tracing/set_ftrace_notrace
>> + # echo '*preempt*' '*lock*' > ./set_ftrace_notrace
>>
>>  Produces:
>>
>> @@ -1758,13 +1767,13 @@ the effect on the tracing is different. Every read from
>>  trace_pipe is consumed. This means that subsequent reads will be
>>  different. The trace is live.
>>
>> - # echo function > /debug/tracing/current_tracer
>> - # cat /debug/tracing/trace_pipe > /tmp/trace.out &
>> + # echo function > ./current_tracer
>> + # cat ./trace_pipe > /tmp/trace.out &
>>  [1] 4153
>> - # echo 1 > /debug/tracing/tracing_enabled
>> + # echo 1 > ./tracing_enabled
>>   # usleep 1
>> - # echo 0 > /debug/tracing/tracing_enabled
>> - # cat /debug/tracing/trace
>> + # echo 0 > ./tracing_enabled
>> + # cat ./trace
>>  # tracer: function
>>  #
>>  #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
>> @@ -1800,7 +1809,7 @@ number listed is the number of entries that can
>> be recorded per
>>  CPU. To know the full size, multiply the number of possible CPUS
>>  with the number of entries.
>>
>> - # cat /debug/tracing/buffer_size_kb
>> + # cat ./buffer_size_kb
>>  1408 (units kilobytes)
>>
>>  Note, to modify this, you must have tracing completely disabled.
>> @@ -1808,21 +1817,21 @@ To do that, echo "nop" into the current_tracer. If the
>>  current_tracer is not set to "nop", an EINVAL error will be
>>  returned.
>>
>> - # echo nop > /debug/tracing/current_tracer
>> - # echo 10000 > /debug/tracing/buffer_size_kb
>> - # cat /debug/tracing/buffer_size_kb
>> + # echo nop > ./current_tracer
>> + # echo 10000 > ./buffer_size_kb
>> + # cat ./buffer_size_kb
>>  10000 (units kilobytes)
>>
>>  The number of pages which will be allocated is limited to a
>>  percentage of available memory. Allocating too much will produce
>>  an error.
>>
>> - # echo 1000000000000 > /debug/tracing/buffer_size_kb
>> + # echo 1000000000000 > ./buffer_size_kb
>>  -bash: echo: write error: Cannot allocate memory
>> - # cat /debug/tracing/buffer_size_kb
>> + # cat ./buffer_size_kb
>>  85
>>
>>  ---
>>
>> On Sat, May 30, 2009 at 1:48 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> >
>> >
>> > On Sat, 30 May 2009, GeunSik Lim wrote:
>> >
>> >>
>> >>
>> >> Dear Greg and Steen,
>> >>
>> >> Thanks your advices and opinions about a confusion according to
>> >> too many mount directory names for debugfs. I made rfc v2 patch file again like belows.
>> >> Can I hear your advices about below patch contents?.
>> >>
>> >> * ref:
>> >> http://groups.google.com/group/linux.kernel/browse_thread/thread/c34e386587979340/dc52317f888e78b6?#dc52317f888e78b6
>> >>
>> >>
>> >> Regards,
>> >> GeunSik Lim.
>> >>
>> >> Subject: [PATCH]   Fix terminology inconsistency of dir name to mount debugfs filesystem.
>> >>
>> >>       Many developers use "/debug/" or "/debugfs/ directory name to mount
>> >>       debugfs filesystem for ftrace according to
>> >>       ./Documentation/tracers/ftrace.txt file.
>> >>
>> >>       And, three directory names(ex:/debug/, /debugfs/, /sys/kernel/debug/) is
>> >>       existed in kernel source like ftrace, DRM, Wireless, Network[sky2]files
>> >>       to mount debugfs filesystem.
>> >>
>> >>       debugfs means debug filesystem for debugging easy to use by greg kroah
>> >>       hartman. "/sys/kernel/debug/" name is suitable as directory name
>> >>       of debugfs filesystem.
>> >>       -debugfs related reference: http://lwn.net/Articles/115405/
>> >
>> > Note, LWN has an update this week:
>> >
>> >  http://lwn.net/Articles/334546/
>> >
>> > But it currently is subscriber only. Others would need to either buy a
>> > subscription (plug) or wait a week for it to become open.
>> >
>> > Still for some aspects, just having "debugfs" without the leading "/"
>> > might just be self explanatory. We can assume the user already knows where
>> > debugfs is mounted.
>> >
>> > -- Steve
>> >
>> >
>> >>
>> >>       Fix inconsistency of directory name to mount debugfs filesystem.
>> >>
>> >>          Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>> >>          Acked-By: Inaky Perez-Gonzalez <inaky@linux.intel.com>
>> >>          CC: Greg KH <greg@kroah.com>
>> >>          CC: Steven Rostedt <rostedt@goodmis.org>
>> >>          CC: linux-kernel <linux-kernel@vger.kernel.org>
>> >
>>
>>
>>
>> --
>> Regards,
>> GeunSik Lim ( SAMSUNG ELECTRONICS)
>> Blog : http://blog.naver.com/invain/
>> e-Mail: geunsik.lim@samsung.com
>>            leemgs@gmail.com , leemgs1@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>



-- 
Regards,
GeunSik Lim ( SAMSUNG ELECTRONICS)
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
