Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424Ab0A0I2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0A0I2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706Ab0A0I2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:10 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:51210 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0A0I2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hE7RhMnVg7krXFOv4ahDiStds8SVpoc0lHr8n4nTlgIIqEOAOLf3DiaC49y0ZWnWOI
         eLf92+vLGdNmtBhU1ra9YplIPOCr3eMUkmd7KU0EUqlqIfvLT86RjDOCLMR6PcazbROo
         MNay7leEx/+yeE2T54viFEk07f4boAuGv3PkA=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 00/12] perf trace: Python scripting support
Date: Wed, 27 Jan 2010 02:27:51 -0600
Message-Id: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a Python scripting engine to perf trace.  In the
process, it also creates a scripting-engines directory under perf/util
and moves the existing Perl support there, to avoid cluttering the
main perf/util directory with scripting support files.

It also includes some minor bugfixes and adds Documentation for the
Python support, which includes a step-by-step example detailing how to
write a new trace stream processing script using Python.

Finally, it adds several new scripts, all dealing with aggregation of
system call trace data.  To make those scripts more user-friendly, it
adds a couple patches that export some of the syscall metadata, enough
to allow syscall names rather than raw numbers to be printed in the
output.

NOTE: in order to run the 'record' side of these scripts, you need to
first revert commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f "perf
record: Intercept all events" - recording the syscall events seems to
always trigger the infinite loop in there.

Here's the new current listing of available scripts:

# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  failed-syscalls [comm]               system-wide failed syscalls
  rw-by-pid                            system-wide r/w activity
  syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
  failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
  syscall-counts [comm]                system-wide syscall counts

And some sample output from the four new ones:


The 'syscall-counts' script just gives a high-level overview of all
syscalls on the system, listed by syscall:

root@tropicana:~# perf trace record syscall-counts
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 32.165 MB perf.data (~1405309 samples) ]

root@tropicana:~# perf trace report syscall-counts

syscall events:

event                                          count
----------------------------------------  -----------
sys_write                                     269407
sys_getdents                                    2782
sys_close                                       2004
sys_swapoff                                     1095
sys_read                                         920
sys_sched_setparam                               511
sys_open                                         331
sys_newfstat                                     326
sys_mmap                                         217
sys_munmap                                       216
sys_select                                       173
sys_getgid                                       128
sys_futex                                         89
sys_poll                                          76
174                                               64
sys_setuid                                        64
sys_setitimer                                     50
15                                                25
sys_rt_sigprocmask                                24
sys_lseek                                          7
sys_inotify_add_watch                              6
sys_writev                                         5
sys_ioctl                                          5
sys_wait4                                          2
sys_perf_event_open                                1
sys_fcntl                                          1


The 'syscall-counts-by-pid' script dives down into more detail,
listing the system calls by comm/pid:

root@tropicana:~# perf trace report syscall-counts

syscall events by comm/pid:

comm [pid]/syscalls                            count
----------------------------------------  ----------

gnome-screensav [6351]
  sys_read                                         8
  sys_poll                                         2

firefox [6505]
  sys_futex                                       72
  sys_write                                       19

firefox [6502]
  sys_read                                        61
  sys_select                                      41
  sys_poll                                        41
  sys_futex                                       17
  sys_inotify_add_watch                            2
  sys_write                                        1

perf [13629]
  sys_write                                   269386
  sys_read                                       790
  sys_newfstat                                   326
  sys_open                                       326
  sys_close                                      324
  sys_getdents                                   222
  sys_mmap                                       217
  sys_munmap                                     216
  sys_lseek                                        7
  sys_ioctl                                        4
  sys_perf_event_open                              1
  sys_fcntl                                        1
  15                                               1
  sys_poll                                         1

pulseaudio [6275]
  sys_poll                                         1

gnome-panel [6329]
  sys_inotify_add_watch                            4
  sys_poll                                         1
  sys_read                                         1

apache2 [6004]
  sys_wait4                                        2
  sys_select                                       2

wterm [6659]
  sys_read                                         7
  sys_select                                       3
  sys_write                                        1

mysqld [5120]
  sys_select                                       2

mysqld [5119]
  sys_select                                       2

npviewer.bin [13313]
  sys_getdents                                  2560
  sys_close                                     1679
  sys_swapoff                                   1095
  sys_sched_setparam                             511
  sys_getgid                                     128
  174                                             64
  sys_setuid                                      64

Xorg [5853]
  sys_select                                     123
  sys_setitimer                                   50
  sys_read                                        50
  15                                              24
  sys_rt_sigprocmask                              24
  sys_poll                                        24
  sys_writev                                       5


The 'failed-syscalls' script likewise gives a high-level overview of
all failed syscalls on the system, listed both by comm and by syscall:

root@tropicana:~# perf trace record failed-syscalls
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 32.653 MB perf.data (~1426644 samples) ]

root@tropicana:~# perf trace report failed-syscalls

failed syscalls, by comm:

comm                    # errors
--------------------  ----------            
npviewer.bin                2468
firefox                       91
Xorg                          31
gnome-screensav                6
wterm                          5
gnome-panel                    5
trashapplet                    4
hald-addon-stor                4
gvfsd-trash                    2
gnome-settings-                2
sh                             1
update-notifier                1


failed syscalls, by syscall:

syscall                           # errors
------------------------------  ----------            
sys_close                             2468
sys_read                                81
sys_futex                               29
sys_select                              15
undefined                               15
sys_inotify_add_watch                    6
sys_open                                 4
sys_access                               1
sys_wait4                                1


And again, diving into more detail, the 'failed-syscalls-by-pid'
script lists the failed system calls by comm/pid and error:

root@tropicana:~# perf trace report failed-syscalls-by-pid
perf trace started with Python script /root/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py


syscall errors:

comm [pid]                           count
------------------------------  ----------

gnome-screensav [6351]
  syscall: sys_read        
    err = -11                            6

firefox [6505]
  syscall: sys_futex       
    err = -110                          28

firefox [6502]
  syscall: sys_read        
    err = -11                           60
  syscall: sys_access      
    err = -2                             1
  syscall: sys_inotify_add_watch
    err = -2                             2

gnome-panel [6329]
  syscall: sys_read        
    err = -11                            1
  syscall: sys_inotify_add_watch
    err = -2                             4

wterm [6659]
  syscall: sys_read        
    err = -11                            5

trashapplet [6364]
  syscall: sys_read        
    err = -11                            4

sh [13717]
  syscall: sys_wait4       
    err = -512                           1

npviewer.bin [13313]
  syscall: sys_close       
    err = -11                         2468

Xorg [5853]
  syscall: sys_read        
    err = -11                            1
  syscall: undefined       
    err = -4                            15
  syscall: sys_select      
    err = -514                          15

gnome-settings- [6297]
  syscall: sys_read        
    err = -11                            2

hald-addon-stor [5721]
  syscall: sys_open        
    err = -123                           1

hald-addon-stor [5715]
  syscall: sys_open        
    err = -123                           1

hald-addon-stor [5724]
  syscall: sys_open        
    err = -123                           1

hald-addon-stor [5718]
  syscall: sys_open        
    err = -123                           1

gvfsd-trash [6370]
  syscall: sys_read        
    err = -11                            1

gvfsd-trash [13719]
  syscall: sys_futex       
    err = -110                           1

update-notifier [6395]
  syscall: sys_read        
    err = -11                            1


These scripts can be used to get a general idea of syscall activity on
the system, which can be used to direct further investigation in the
form of either more refined scripts and/or looking at the source of
apps that seem to be acting strangely.

For instance, the output of failed-syscalls-by-pid shows npviewer.bin,
a flash plugin wrapper, seems to be making a lot of failed close
system calls, while the output of syscalls-by-pid doesn't show a lot
of open calls.  So it's apparently wasting a lot of time closing
nonexistent files (this script was run for only a very short time).
It might be useful at this point to record
syscalls::sys_enter/exit_close syscalls and write a script that would
hash the fds by error code to find out which files it's trying
unsuccessfully to close.  That might be enough information to go
examine and fix the offending code in the wrapper, or put the blame on
the wrappee if that's where the problem is...


Tom Zanussi (12): perf trace/scripting: Fix supported language listing
  option perf trace/scripting: fix bug in Util.pm perf
  trace/scripting: move common code out of Perl-specific files perf
  trace/scripting: move Perl scripting files to scripting-engines dir
  perf trace/scripting: remove check-perf-trace from listed scripts
  perf trace/scripting: add Python scripting engine perf
  trace/scripting: add syscall tracing scripts perf: export some
  syscall metadata perf tools: save syscall map perf trace/scripting:
  make the syscall map available as a Python dict perf
  trace/scripting: make the syscall map available as a Perl hash perf
  trace/scripting: add perf-trace-python Documentation

 kernel/trace/trace_syscalls.c                      |   87 +++
 tools/perf/Documentation/perf-trace-perl.txt       |    3 +-
 tools/perf/Documentation/perf-trace-python.txt     |  624 ++++++++++++++++++
 tools/perf/Documentation/perf-trace.txt            |   15 +-
 tools/perf/Makefile                                |   33 +-
 tools/perf/builtin-trace.c                         |    5 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   49 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |   27 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |   24 +-
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +-
 .../perf/scripts/perl/bin/check-perf-trace-report  |    6 -
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    4 +
 tools/perf/scripts/perl/failed-syscalls.pl         |   51 ++
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |  110 ++++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   91 +++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   37 ++
 .../python/bin/failed-syscalls-by-pid-record       |    2 +
 .../python/bin/failed-syscalls-by-pid-report       |    4 +
 .../python/bin/syscall-counts-by-pid-record        |    2 +
 .../python/bin/syscall-counts-by-pid-report        |    4 +
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +
 .../perf/scripts/python/bin/syscall-counts-report  |    4 +
 tools/perf/scripts/python/check-perf-trace.py      |   83 +++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   69 ++
 tools/perf/scripts/python/syscall-counts-by-pid.py |   65 ++
 tools/perf/scripts/python/syscall-counts.py        |   59 ++
 .../perf/util/scripting-engines/trace-event-perl.c |  568 +++++++++++++++++
 .../util/scripting-engines/trace-event-python.c    |  576 +++++++++++++++++
 tools/perf/util/trace-event-info.c                 |   25 +
 tools/perf/util/trace-event-parse.c                |   78 +++
 tools/perf/util/trace-event-perl.c                 |  661 --------------------
 tools/perf/util/trace-event-perl.h                 |   55 --
 tools/perf/util/trace-event-read.c                 |   18 +
 tools/perf/util/trace-event-scripting.c            |  167 +++++
 tools/perf/util/trace-event.h                      |   20 +-
 37 files changed, 2895 insertions(+), 744 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-trace-python.txt
 delete mode 100644 tools/perf/scripts/perl/bin/check-perf-trace-report
 create mode 100644 tools/perf/scripts/perl/bin/failed-syscalls-record
 create mode 100644 tools/perf/scripts/perl/bin/failed-syscalls-report
 create mode 100644 tools/perf/scripts/perl/failed-syscalls.pl
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Context.c
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
 create mode 100644 tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
 create mode 100644 tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-by-pid-record
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-by-pid-report
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-record
 create mode 100644 tools/perf/scripts/python/bin/syscall-counts-report
 create mode 100644 tools/perf/scripts/python/check-perf-trace.py
 create mode 100644 tools/perf/scripts/python/failed-syscalls-by-pid.py
 create mode 100644 tools/perf/scripts/python/syscall-counts-by-pid.py
 create mode 100644 tools/perf/scripts/python/syscall-counts.py
 create mode 100644 tools/perf/util/scripting-engines/trace-event-perl.c
 create mode 100644 tools/perf/util/scripting-engines/trace-event-python.c
 delete mode 100644 tools/perf/util/trace-event-perl.c
 delete mode 100644 tools/perf/util/trace-event-perl.h
 create mode 100644 tools/perf/util/trace-event-scripting.c

