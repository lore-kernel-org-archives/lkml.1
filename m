Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZLOIxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZLOIxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZLOIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:53:46 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46968 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZLOIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kqT0K4IPxhlAqJv4moDDoXQQmjUUGmPiA3Se8ro/ALMw4RM5XsqHQsTihgMPAZL0hF
         a8p6FfwAKnCNi+FH2r4qEWeXepWQAkdQJDCUnjtHfvGCfju/51WwAs5syMwGCfgR4dZX
         UB3IuZr+ceSHwUg6JXiIQwxBaSKcZNU4OwUl8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 0/6] perf trace/scripting updates
Date: Tue, 15 Dec 2009 02:53:34 -0600
Message-Id: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a few oversights and adds some options to aid
usability.

With these patches, the list of available trace scripts can be easily
displayed, and the script names shown in the list can be used to
record and invoke the individual scripts without forcing the user to
remember and enter long command-lines.

For example, getting r/w activity for a program e.g. firefox is as
easy as running 'perf trace -l', noting that the rw-by-file script
exists, and using that name to record data and display the results
using 'perf trace record rw-by-file' and 'perf trace report rw-by-file
firefox':

root@tropicana:~# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  check-perf-trace                     useless but exhaustive test script
  rw-by-pid                            system-wide r/w activity

root@tropicana:~# perf trace record rw-by-file
^C[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 65.388 MB perf.data (~2856833 samples) ]

root@tropicana:~# perf trace report rw-by-file firefox
perf trace started with Perl script /root/libexec/perf-core/scripts/perl/rw-by-file.pl

file read counts for firefox:

    fd     # reads  bytes_requested
------  ----------  -----------
     3        3796    15548416
    45          12       33075
    32          28       28672
    16          20       20480
    58           6       17279
    22           4       16384
    46           2       11289
    57           2        8192
    26           2        8192
    60           2        8192
    47           5        4160
    12          78        3874
    44           2         606
    19         179         179
    42           8         128
    53           1          16

file write counts for firefox:

    fd    # writes  bytes_written
------  ----------  -----------
    52          51       55528
    26          13       53248
    55          22       45100
    45           8       23632
    42          19       19456
    59          28       10304
    58          24        8760
    61           1        7988
    57          13        4640
    20         179         179
    33          28          28
    17          26          26

Note that the perf trace -l option was previously used to display
latency information; this patchset changes that option to -L in the
interest of maintaining consistency with other perf -l options.

The other patches in this patchset fix some oversights, including
adding support for script args, which entails a change to
scripting_ops.


Tom Zanussi (6):
  perf trace/scripting: add support for script args
  perf trace/scripting: don't install unneeded files
  perf trace/scripting: check return val of perl_run()
  perf trace/scripting: list available scripts
  perf trace/scripting: add 'record' and 'report' options
  perf trace/scripting: update Documentation

 tools/perf/Documentation/perf-trace.txt            |   27 ++-
 tools/perf/Makefile                                |    2 -
 tools/perf/builtin-trace.c                         |  302 +++++++++++++++++++-
 .../perf/scripts/perl/bin/check-perf-trace-report  |    1 +
 tools/perf/scripts/perl/bin/rw-by-file-report      |    4 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    1 +
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    1 +
 tools/perf/scripts/perl/bin/workqueue-stats-report |    1 +
 tools/perf/scripts/perl/rw-by-file.pl              |    5 +-
 tools/perf/util/trace-event-perl.c                 |   42 ++-
 tools/perf/util/trace-event.h                      |    2 +-
 11 files changed, 356 insertions(+), 32 deletions(-)

