Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZHXPos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZHXPos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZHXPop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:44:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59293 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbZHXPop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=iYOm4ksq/iZ2Ctn4UzuDnrRuRa6sqqwRA2twiZO595civ4vzBL+7GNNSVMz3xWafmy
         TdLeZvTXs7VpPjvcSY+XZdoWRBe+uUnacLngBSxsmy2FFCpJpYEIqP2relaFQqM5mBg/
         bzs0q4QSrQOiCihHMhieXxFxKnld/AHAMlHN4=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1251121618.7538.262.camel@twins>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <1251121618.7538.262.camel@twins>
Date: Mon, 24 Aug 2009 17:44:45 +0200
Message-ID: <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
Subject: Re: perf_counters issue with enable_on_exec
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 3:46 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Thu, 2009-08-20 at 15:49 +0200, stephane eranian wrote:
>> Hi,
>>
>> I am running into an issue trying to use enable_on_exec
>> in per-thread mode with an event group.
>>
>> My understanding is that enable_on_exec allows activation
>> of an event on first exec. This is useful for tools monitoring
>> other tasks and which you invoke as: tool my_program. In
>> other words, the tool forks+execs my_program. This option
>> allows developers to setup the events after the fork (to get
>> the pid) but before the exec(). Only execution after the exec
>> is monitored. This alleviates the need to use the
>> ptrace(PTRACE_TRACEME) call.
>>
>> My understanding is that an event group is scheduled only
>> if all events in the group are active (disabled=0). Thus, one
>> trick to activate a group  with a single ioctl(PERF_IOC_ENABLE)
>> is to enable all events in the group except the leader. This works
>> well. But once you add enable_on_exec on on the events,
>> things go wrong. The non-leader events start counting before
>> the exec. If the non-leader events are created in disabled state,
>> then they never activate on exec.
>>
>> The attached test program demonstrates the problem.
>> simply invoke with a program that runs for a few seconds.
>
> OK, lots of issues here
>
>  1) your code is broken ;-)

That's true. I knew about the missing synchro. But I think
the problem existed nonetheless.

>  2) enable_on_exec on !leader counters is undefined

then fail it.

>  3) there is something fishy non the less
>
True.

>
> 1. you fork() then create a counter group in both the parent and the
> child without sync, then read the parent group. This obviously doesn't
> do what is expected. See attached proglet for a better version.
>
I have modified the program based on your changes. See new version attached.

> 2. enable_on_exec only works on leaders, Paul, was that intended?
>
All events in a group are scheduled together. If one event is not enabled
in a group, then the group is not dispatched. Setting enable_on_exec
just on leader makes sense. Then to enable the group on exec, you
enabled all events but the leader. The enable_on_exec will enable
the leader on exec and the group will be ready for dispatch. That's
how it should work in my mind.


As you indicated the issue is with the timing information and I think
it is not related to enable_on_exec. It is more related to the fact
that to enable a group with a single ioctl() you enable ALL BUT the
leader. But that means that the time_enabled for the !leader is
ticking. Thus scaling won't be as expected yet it is correct
given what happens internally.

I think there needs to be a distinction between 'enabled immediately
but cannot run because group is not totally enabled' and 'cannot run
because the group has been multiplexed out yet all could be dispatched
because all events were dispatched'. In the former, it seems you don't
want time_enabled to tick, while in the latter you do. In other words,
time_enabled ticks for each event if the group is 'dispatch-able' (or
runnable in your terminology) otherwise it does not. time_enabled reflects
the fact that the group could run but did not have access to the PMU
resource because of contention with other groups.


> # ./test-enable_on_exec true
>             2651600 PERF_COUNT_HW_CPU_CYCLES 1111509 1111509 2651600.000000
>             1832720 PERF_COUNT_HW_INSTRUCTIONS 839395242 1111509 1384043177.264637
>
> Paul, would a counter's time start running when its 'enabled' but part
> of a non-runnable group?
>
>
#include <sys/types.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <syscall.h>
#include <err.h>

#include <perfmon/pfmlib_perf_counter.h>


int
child(char **arg)
{
        int i;

        /* burn cycles to detect if monitoring start before exec */
        for(i=0; i < 5000000; i++) syscall(__NR_getpid);
        /*
         * execute the requested command
         */
        execvp(arg[0], arg);
        errx(1, "cannot exec: %s\n", arg[0]);
        /* not reached */
}

int
parent(char **arg)
{
        struct perf_counter_attr hw[2];
        char *name[2], buf;
        int fd[2];
        int status, ret, i;
        uint64_t values[3];
        pid_t pid;
        int ready[2], go[2];


        ret = pipe(ready);
        if (ret)
                err(1, "cannot create pipe ready");

        ret = pipe(go);
        if (ret)
                err(1, "cannot create pipe go");

        /*
         * Create the child task
         */
        if ((pid=fork()) == -1)
                err(1, "Cannot fork process");

        /*
         * and launch the child code
         */
        if (pid == 0) {
                close(ready[0]);
                close(go[1]);

                /*
                 * let the parent know we exist
                 */
               close(ready[1]);
               if (read(go[0], &buf, 1) == -1)
                       err(1, "unable to read go_pipe");

                close(go[0]);
                exit(child(arg));
        }

        close(ready[1]);
        close(go[0]);

        if (read(ready[0], &buf, 1) == -1)
               err(1, "unable to read child_ready_pipe");

        close(ready[0]);

        memset(hw, 0, sizeof(hw));

        name[0] = "PERF_COUNT_HW_CPU_CYCLES";
        hw[0].type = PERF_TYPE_HARDWARE;
        hw[0].config = PERF_COUNT_HW_CPU_CYCLES;
        hw[0].read_format =
PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
        hw[0].disabled = 1;
        hw[0].enable_on_exec = 1;

        name[1] = "PERF_COUNT_HW_CPU_CYCLES";
        hw[1].type = PERF_TYPE_HARDWARE;
        hw[1].config = PERF_COUNT_HW_CPU_CYCLES;
        hw[1].read_format =
PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING;
        hw[1].disabled = 0;
        hw[1].enable_on_exec = 0;

        fd[0] = perf_counter_open(&hw[0], pid, -1, -1, 0);
        if (fd[0] == -1)
                err(1, "cannot open event0");

        fd[1] = perf_counter_open(&hw[1], pid, -1, fd[0], 0);
        if (fd[1] == -1)
                err(1, "cannot open event1");


        close(go[1]);

        waitpid(pid, &status, 0);

        /*
         * the task has disappeared at this point but our session is still
         * present and contains all the latest counts.
         */

        /*
         * now simply read the results.
         */
        for(i=0; i < 2; i++) {
                ret = read(fd[i], values, sizeof(values));
                if (ret < sizeof(values))
                        err(1, "cannot read values event %s", name[i]);

                printf("%20"PRIu64" %s %ld %ld %f\n",
                        values[0],
                        name[i],
                        values[1], values[2],
                        values[2] ? (double)values[0] *
values[1]/values[2] : 0);

                close(fd[i]);
        }
        return 0;
}

int
main(int argc, char **argv)
{
        if (!argv[1])
                errx(1, "you must specify a command to execute\n");

        return parent(argv+1);
}
