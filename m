Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0CCHHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:07:04 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39879 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0CCHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=msM2v2Qw61dS/MMr5EeGr/6OcQwj6u+X9DnlVDeIggP138rJKRYmL0fOKZcZnQYWqd
         Eb4ahgNn446Vj+KYTEvQ9paT4XbDLHODlHQ1bpQTym6W6WP53xlRb9FU5NPeecKEMPqk
         r4CAqGE/z9Dg3BbjLn7rHdEtfdLMO7h2/of/I=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [RFC PATCH 0/7] perf: 'live mode'
Date: Wed,  3 Mar 2010 01:05:22 -0600
Message-Id: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a perf session entails two steps: first 'perf record' or
'perf trace record' records the perf data to disk, then 'perf report'
or 'perf trace report' reads the saved data from disk and reports the
results.

This experimental patchset makes some changes to perf that instead
allow the perf data to be piped directly from the record step to the
report step, without ever touching the disk.

This is especially useful for 'perf trace' - adding this capability
means that the trace scripts are no longer relegated to simple
post-processing, but can be run in a continuous 'live mode', forever
processing the event stream and e.g. periodically dumping current
results, essentially becoming special-purpose 'top' applications, or
continuously scanning the event stream for arbitrarily complex
conditions to flag, etc...

Being able to feed the event stream over a pipe also makes it possible
to do things like trace over the network using e.g. netcat.

It turns out that perf is pretty close to being able to do this
already, with the exception of the header data; most of the work of
this patchset deals with changing that.  It does so in a mainly
additive way: it doesn't make any changes to the existing disk format
or normal disk-mode processing, just adds special treatment for the
cases when 'perf [trace] record' records to stdout or 'perf [trace]
report reads from stdin.

Here are some quick examples.  Basically using '-' as the filename to
the -o and -i options send/read the data from stdout/stdin:

Here's a simple 'perf record' | 'perf report' run:

root@tropicana:~# perf record -o - -c 1 -f -a -M -R -e raw_syscalls:sys_enter | perf report -i -
^C# Samples: 120234
#
# Overhead          Command              Shared Object  Symbol
# ........  ...............  .........................  ......
#
    98.65%             perf  libpthread-2.8.90.so       [.] __read
     0.46%             perf  libpthread-2.8.90.so       [.] __write_nocancel
     0.32%             perf  libpthread-2.8.90.so       [.] __open_nocancel
     0.29%             perf  libpthread-2.8.90.so       [.] __libc_close
     0.07%             perf  libc-2.8.90.so             [.] 0x000000000a4b15
     0.03%             perf  libc-2.8.90.so             [.] __fxstat64
     0.03%             perf  libc-2.8.90.so             [.] __open
     0.03%             perf  libc-2.8.90.so             [.] close
     0.02%             Xorg  libc-2.8.90.so             [.] __select
     0.01%             Xorg  libpthread-2.8.90.so       [.] __read
     0.01%             perf  libpthread-2.8.90.so       [.] __libc_lseek
     0.01%             Xorg  libc-2.8.90.so             [.] setitimer
     0.01%             perf  libc-2.8.90.so             [.] __xstat64
     0.01%          firefox  libpthread-2.8.90.so       [.] __read
     0.00%             perf  libc-2.8.90.so             [.] llseek
     0.00%             Xorg  libpthread-2.8.90.so       [.] __restore_rt
     0.00%             Xorg  libc-2.8.90.so             [.] sigprocmask
     0.00%             Xorg  libc-2.8.90.so             [.] __poll
     0.00%            wterm  libc-2.8.90.so             [.] __read
     0.00%  gnome-screensav  libpthread-2.8.90.so       [.] __read
     0.00%          firefox  libc-2.8.90.so             [.] __poll
     0.00%             Xorg  libc-2.8.90.so             [.] writev
     0.00%  gnome-settings-  libpthread-2.8.90.so       [.] __read
     0.00%            wterm  libc-2.8.90.so             [.] __select
     0.00%             perf  libc-2.8.90.so             [.] statfs
     0.00%           mysqld  libc-2.8.90.so             [.] __select
     0.00%          firefox  libpthread-2.8.90.so       [.] __pthread_cond_timedwait
     0.00%          firefox  libpthread-2.8.90.so       [.] __lll_unlock_wake
     0.00%          firefox  libpthread-2.8.90.so       [.] 0x0000000000decb
     0.00%          firefox  libc-2.8.90.so             [.] __select
     0.00%             perf  libc-2.8.90.so             [.] getcwd
     0.00%             perf  libc-2.8.90.so             [.] mmap64
     0.00%  gnome-settings-  libc-2.8.90.so             [.] __poll
     0.00%  gnome-screensav  libc-2.8.90.so             [.] __poll
     0.00%          firefox  libc-2.8.90.so             [.] writev
     0.00%          apache2  libpthread-2.8.90.so       [.] __waitpid
     0.00%          apache2  libc-2.8.90.so             [.] __select
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

Included in this patchset are a couple of 'top' scripts, rwtop and
sctop, that are essentially just modifications of existing scripts.
Basically the original scripts were modified to add a 5 second timer.
In the handler for the timer, the current output summary is printed,
and the state is cleared and begun anew, ad infinitum.

Here are the new scripts as shown in the perf trace list:

root@tropicana:~# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  rwtop                                system-wide r/w top
  failed-syscalls [comm]               system-wide failed syscalls
  rw-by-pid                            system-wide r/w activity
  syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
  failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
  sctop [comm]                         syscall top
  syscall-counts [comm]                system-wide syscall counts


And here's a few iterations of the output of the 'sctop' Python
script:

root@tropicana:~# perf trace record sctop | perf trace report sctop
perf trace started with Python script /root/libexec/perf-core/scripts/python/sctop.py

syscall events:

event                                          count
----------------------------------------  -----------
2                                                179
3                                                158
0                                                 79
78                                                24
5                                                 13
1                                                  3
16                                                 2
298                                                1
137                                                1
79                                                 1
72                                                 1
8                                                  1

syscall events:

event                                          count
----------------------------------------  -----------
0                                             659287
202                                             1995
1                                                812
2                                                246
3                                                224
78                                                56
12                                                51
5                                                 23
23                                                22
8                                                 18
7                                                 18
4                                                  9
38                                                 6
61                                                 5
254                                                4
20                                                 2
16                                                 2
137                                                1
15                                                 1
14                                                 1
9                                                  1

syscall events:

event                                          count
----------------------------------------  -----------
0                                             647178
202                                             1209
1                                                324
12                                                52
7                                                 29
14                                                 6
16                                                 4
23                                                 3
3                                                  3
72                                                 2
21                                                 1
11                                                 1
9                                                  1
5                                                  1
4                                                  1
2                                                  1

.
.
.

Obviously, it would be better to have a real top-like display for
these rather than a continuously scrolling mode like this, and of
course it will be much more useful once we get the syscall name
injection events going (the column on the left shows syscall numbers
only).


Last, but not least, here's an example that uses netcat to run the
'rwtop' Perl script over the network:

On the system being traced:

root@tropicana:~# perf trace record rwtop | nc localhost 7777
^C

On the system collecting the data and printing the output every 5
seconds:

root@tropicana:~# nc -l -p 7777 | perf trace report rwtop
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/rwtop.pl


read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
  6672  perf                      156016     6238975     6238980
  6670  nc                           741     6070272     6054460
  6675  perf                        3235     9445712     4589634
  6674  nc                          1376    11272192     1586892
  6342  gvfsd-trash                    2        4096         194
  5856  Xorg                           5        8264          76
  6335  trashapplet                    5       16384          48
  6378  gnome-power-man                3       12288          32
  6298  gnome-panel                    1        4096           0

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  -----------  ----------
  6675  perf                       15651    16412612
  6670  nc                           741     6054460
  6674  nc                          1376     1586892
  6342  gvfsd-trash                    2          93
  6676  gvfsd-trash                    1          35

read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
  6672  perf                      166458     6657104     6656232
  6670  nc                           787     6447104     6447104
  6342  gvfsd-trash                    2        4096         194
  6335  trashapplet                    5       16384          48

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  -----------  ----------
  6675  perf                       13734    15206704
  6670  nc                           787     6447104
  6342  gvfsd-trash                    2          93
  6677  gvfsd-trash                    1          35

read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
  6672  perf                      167645     6704272     6704048
  6670  nc                           793     6496256     6529024
  6298  gnome-panel                    1        4096           0

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  -----------  ----------
  6675  perf                       13473    15011968
  6670  nc                           797     6529024
failed to read event payload

read counts by pid:

   pid                  comm     # reads  bytes_requested  bytes_read
------  --------------------  -----------  ----------  ----------
  6670  nc                           217     1777664     1875968
  6672  perf                       45782     1830816     1830560
  6451  wterm                          3       19873         607
  5856  Xorg                           3          72          72
  6480  wterm                          3       12288          32
  6263  gnome-settings-                3       12288          32
  6326  gnome-screensav                4       16384          32

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  -----------  ----------
  6675  perf                        3821     4635048
  6670  nc                           229     1875968
  6672  perf                          11         592

perf trace Perl script stopped


There are some rough edges and inefficiencies, and I guess 'event
injection' may be a better way to do this in the end, but it seems to
work pretty well already, and I think it shows how useful such a
capability can be.

Tom Zanussi (7):
  perf: introduce special handling for pipe input/output
  perf: add pipe-specific header read/write and event processing code
  perf: convert perf header attrs into attr events
  perf: convert perf event types into event type events
  perf: convert perf tracing data into a tracing_data event
  perf: convert perf header build_ids into build_id events
  perf trace/scripting: rwtop and sctop scripts

 tools/perf/builtin-record.c                |   66 +++++-
 tools/perf/builtin-report.c                |   13 +-
 tools/perf/builtin-trace.c                 |   11 +
 tools/perf/scripts/perl/bin/rwtop-record   |    2 +
 tools/perf/scripts/perl/bin/rwtop-report   |    6 +
 tools/perf/scripts/perl/rwtop.pl           |  165 +++++++++++++
 tools/perf/scripts/python/bin/sctop-record |    2 +
 tools/perf/scripts/python/bin/sctop-report |    4 +
 tools/perf/scripts/python/sctop.py         |   64 +++++
 tools/perf/util/event.h                    |   35 +++
 tools/perf/util/header.c                   |  348 +++++++++++++++++++++++++++-
 tools/perf/util/header.h                   |   38 +++-
 tools/perf/util/session.c                  |  214 ++++++++++++++++-
 tools/perf/util/session.h                  |   23 ++-
 tools/perf/util/trace-event-info.c         |   24 ++
 tools/perf/util/trace-event-read.c         |   89 ++++----
 tools/perf/util/trace-event.h              |    4 +-
 17 files changed, 1035 insertions(+), 73 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
 create mode 100644 tools/perf/scripts/perl/rwtop.pl
 create mode 100644 tools/perf/scripts/python/bin/sctop-record
 create mode 100644 tools/perf/scripts/python/bin/sctop-report
 create mode 100644 tools/perf/scripts/python/sctop.py

