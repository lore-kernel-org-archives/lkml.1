Return-Path: <linux-kernel-owner+w=401wt.eu-S937709AbZAPVs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937709AbZAPVs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762474AbZAPVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:48:46 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:26510 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZAPVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:48:45 -0500
Subject: Re: [PATCH 0/2] ftrace: updates to tip
From: Chris Mason <chris.mason@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090116004050.273665842@goodmis.org>
References: <20090116004050.273665842@goodmis.org>
Content-Type: multipart/mixed; boundary="=-kGXLmDXiHeSMzJ/IiZYb"
Date: Fri, 16 Jan 2009 16:47:47 -0500
Message-Id: <1232142467.5090.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.49710087.01AC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kGXLmDXiHeSMzJ/IiZYb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2009-01-15 at 19:40 -0500, Steven Rostedt wrote:
> Ingo,
> 
> The first patch is critical, and needs to stay with trace_output.c
> Not that critical since trace_output.c is not in mainline yet.
> 
> The second patch gives the ability to stack trace functions.
> I've been leery about adding this and still keep it a separate
> option from the "stacktrace" that already exists. This is because
> when enabled with no filtering, the lag between typing and seeing
> what is typed can be up to 10 seconds or more.
> 

I mostly asked for this because I often try to find the most common
reason a given function is called, and oprofile isn't always a great way
to catch it.  systemtap can do it too if you can get systemtap to work
against your current devel kernel, but there are limits on how much
memory it'll use.

I've attached some simple python code that parses the output of the
function stack tracer, it makes some dumb assumptions about the format
but isn't a bad proof of concept.  The first such assumption is that
you're only filtering on a single function.

Here is some example output, trying to find the most common causes of
native_smp_send_reschedule() during a btrfs dbench run.

It relates to the Oracle OLTP thread because oracle heavily uses IPC
semaphores to trigger wakeups of processes as various events finish.
I'd bet that try_to_wakeup is the most common cause of the reschedule
calls there as well.

For btrfs, the btree lock mutexes come back into the profile yet again.
It would be interesting to change the spinning mutex code to look for
spinners and skip the wakeup on unlock, but that's a different thread
entirely.

The short version is: thanks Steve, this is really cool!

12058 hits: 
 <= check_preempt_wakeup
 <= try_to_wake_up
 <= wake_up_process
 <= __mutex_unlock_slowpath
 <= mutex_unlock
 <= btrfs_tree_unlock
 <= unlock_up
 ===========

11678 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= wake_up_process
 <= __mutex_unlock_slowpath
 <= mutex_unlock
 <= btrfs_tree_unlock
 <= unlock_up
 ===========

1569 hits: 
 <= check_preempt_wakeup
 <= try_to_wake_up
 <= default_wake_function
 <= autoremove_wake_function
 <= wake_bit_function
 <= __wake_up_common
 <= __wake_up
 ===========

1505 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= default_wake_function
 <= autoremove_wake_function
 <= wake_bit_function
 <= __wake_up_common
 <= __wake_up
 ===========

1377 hits: # the output isn't perfectly parsable, or I'm dumb
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0
 ===========

1194 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= wake_up_process
 <= btrfs_queue_worker
 <= schedule_bio
 <= btrfs_map_bio
 <= __btrfs_submit_bio_done
 ===========

1108 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= default_wake_function
 <= autoremove_wake_function
 <= __wake_up_common
 <= __wake_up
 <= cache_drop_leaf_ref
 ===========

935 hits: 
 <= check_preempt_wakeup
 <= try_to_wake_up
 <= wake_up_process
 <= btrfs_queue_worker
 <= schedule_bio
 <= btrfs_map_bio
 <= __btrfs_submit_bio_done
 ===========

856 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= wake_up_process
 <= btrfs_queue_worker
 <= btrfs_wq_submit_bio
 <= btrfs_submit_bio_hook
 <= submit_one_bio
 ===========

502 hits: 
 <= check_preempt_wakeup
 <= try_to_wake_up
 <= wake_up_process
 <= btrfs_queue_worker
 <= btrfs_wq_submit_bio
 <= btrfs_submit_bio_hook
 <= submit_one_bio
 ===========

442 hits: 
 <= check_preempt_curr_idle
 <= try_to_wake_up
 <= wake_up_process
 <= __mutex_unlock_slowpath
 <= mutex_unlock
 <= btrfs_tree_unlock
 <= btrfs_release_path
 ===========

327 hits: 
 <= check_preempt_wakeup
 <= try_to_wake_up
 <= default_wake_function
 <= autoremove_wake_function
 <= __wake_up_common
 <= __wake_up
 <= cache_drop_leaf_ref
 ===========


... output continues for a bit



--=-kGXLmDXiHeSMzJ/IiZYb
Content-Disposition: attachment; filename="trace-histogram"
Content-Type: text/x-python; name="trace-histogram"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#!/usr/bin/env python
#
# this is a fairly trivial parser of the ftrace function stack trace output
# the idea is to find the most common stack traces that lead to calling
# given function, even those that don't use much CPU time and won't
# show up in other profilers.
#
# It assumes ftrace output looks like this:
#       some text including the function name
# <= func
# <= func2
# <= func3
#       some text including the function name
# <= func4
# <= func5
# <= func6
#
# The traces above would generate two histogram entries, one for
# func,func2,func3 and one for func4,func5,fun6
#

import sys, os, signal

stacks = {}

last = []
printed = False

def summary(arg1, arg2):
    global printed;

    printed = True
    count = {}

    for lines, c in stacks.items():
        count.setdefault(c, []).append(lines + ' ===========\n')

    limit = 50
    keys = count.keys()
    keys.sort()
    for x in keys.__reversed__():
        print "%d hits: \n%s" % (x, "".join(count[x]))
        limit -= 1
        if limit <= 0:
            break
    sys.exit(0)

signal.signal(signal.SIGTERM, summary)
signal.signal(signal.SIGINT, summary)

while True:
    try:
        l = sys.stdin.readline()
    except:
        break

    if not l:
        break

    if l[0] == '#':
        continue
    if not l.startswith(' <='):
        if last:
            lines = ''.join(last)
            val = stacks.get(lines, 0) + 1
            stacks[lines] = val
        # we don't put the header line into the trace because that might
        # have timestamp info in it.
        last = []
    else:
        last.append(l)

if not printed:
    summary(1, 2)

--=-kGXLmDXiHeSMzJ/IiZYb--

