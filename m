Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXEFXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXEFXtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXEFXtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:49:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1667 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXEFXtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:49:17 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Date: Sun, 06 May 2007 16:49:15 -0700
Subject: [patch 1/4] KMON - kmon device/instrumentation ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27461.1178495355.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serie introduces a way to log high frequency/volume data
out of the kernel. Logging scheduler operations for example, with
loads that generate tenths of thousands of context switches per second
(possibly from multiple CPUs), can overload the kernel printk. Also,
logging in binary form helps in reducing the size of the logged data
that is tranfered from kernel to userspace. The kmon logger uses per
CPU buffers (rings) that are flushed at a given frequency to all the
instances of the kmon devices. Those per CPU buffers are allocated
only when at least an instance of the kmon device is opened, and are
deallocated when the last one is closed.
On the kernel side, the API:

int kmon_add_data(const void *data, unsigned long size);

can be used to log a blob of data into the per-CPU kmon rings. The
kmon_add_data() API can be called from any context. The data is 
prepended by an header with the following format:

[0]  = CPU number where the log happened (1 byte)
[1]  = Nanosecond time reported by ktime_get() (little-endian - 8 bytes)
[9]  = Size of the data blob (little-endian - 2 bytes)

Following the header, the data blob is stored.
A blob usually begins with a byte specifying the blob type. The currently
defined blob formats are:

[KMON_DT_TSKQUEUE - Task enqueue]
[0]  = Blob ID - KMON_DT_TSKQUEUE (1 byte)
[1]  = Task PID (little-endian - 2 bytes)

[KMON_DT_TSKDEQUEUE - Task dequeue]
[0]  = Blob ID - KMON_DT_TSKDEQUEUE (1 byte)
[1]  = Task PID (little-endian - 2 bytes)

[KMON_DT_TSKSWITCH - Task switch]
[0]  = Blob ID - KMON_DT_TSKQUEUE (1 byte)
[1]  = Prev task PID (little-endian - 2 bytes)
[3]  = Next task PID (little-endian - 2 bytes)

[KMON_DT_TSKWAKEUP - Task wakeup]
[0]  = Blob ID - KMON_DT_TSKQUEUE (1 byte)
[1]  = From task PID - 0 == IRQ context (little-endian - 2 bytes)
[3]  = To task PID (little-endian - 2 bytes)


The kmon device (/dev/kmon) is a misc-device that supports poll, read
and ioctl. The poll(2) system call returns POLLIN when data is available
to be read, and returns POLLERR if a kmon buffer overrun happened.
The kmon buffer overrun can happen if the caller is not prompt enough
to fetch data out of the kmon rings.
Once the kmon device is opened, it is put in stopped mode. The user
must issue an ioctl(KMON_START) to tell the kernel to start logging
the data. An ioctl(KMON_STOP) can be used to put the kmon device back
in stopped mode. When the kmon device is in stopped mode, the user can
call ioctl(KMON_BUFFSIZE, &long) to set the device buffer size (whose
default is 1MB).
An utility to use the kmon device is available here:

http://www.xmailserver.org/kmon/kmonlog.c

$ kmonlog [-d KDEV] [-b BUFSIZ] [-o OUTFIL] [-t MSTEST]
          [-m BMAX] [-p PIDFIL] [-h]

-d KDEV   = Sets the kmon device file (default "/dev/kmon")
-b BUFSIZ = Sets the kmon device buffer size (default 1MB)
-o OUTFIL = Sets the output file name (default STDOUT)
-t MSTEST = Sets the sample time in millisecs (default unlimited)
-m BMAX   = Sets the maximum data to be fetched (default unlimited)
-p PIDFIL = Sets the PID file name (default "pids.dat")

The kmonlog binary fetches the data out of the kmon interface, and
compiles a PID information file (linking PIDs to their process binaries
and command lines), that can be used to link logged PIDs to processes names.
The pids.dat file looks like (only the PIDs that appear in the kmon log
are listed):

0       [IDLE]
1       init [2]
4       [watchdog/0]
7       [watchdog/1]
8       [events/0]
9       [events/1]
225     [pdflush]
4970    [kjournald]
5838    /usr/sbin/cupsd;
5871    /usr/sbin/gpm;-m;/dev/psaux;-t;exps2;-Rms3;
7572    icewmtray;
7611    irssi;
25302   rxvt;-sl;1000;-bg;black;-fg;white;-fn;9x15;-geometry;118x84;+sb;
25307   rxvt;-sl;1000;-bg;black;-fg;white;-fn;9x15;-geometry;118x84;+sb;
25311   /usr/lib/iceape/iceape-bin;

Another small utility can translate the kmon binary log into text:

http://www.xmailserver.org/kmon/kmonparse.c

That emits something like:

cpu=0,ts=14929534,op=DEQ,pid=25311
cpu=0,ts=14929535,op=SWC,prev=25311,next=0
cpu=0,ts=14953518,op=WAK,from=0,to=8
cpu=0,ts=14953520,op=QUE,pid=8
cpu=0,ts=14953522,op=SWC,prev=0,next=8
cpu=1,ts=14912505,op=WAK,from=9,to=27233
cpu=1,ts=14912507,op=QUE,pid=27233
cpu=1,ts=14912510,op=DEQ,pid=9
cpu=1,ts=14912513,op=SWC,prev=9,next=0
cpu=1,ts=14962510,op=WAK,from=0,to=9
cpu=1,ts=14962512,op=QUE,pid=9
cpu=1,ts=14962514,op=SWC,prev=0,next=9
cpu=0,ts=14953524,op=WAK,from=8,to=27233
cpu=0,ts=14953526,op=QUE,pid=27233
cpu=0,ts=14953528,op=DEQ,pid=8

Times gets a default scaling to microsecs (configurable with the '-s'
option of kmonparse), and they get re-based according to the first
entry in the kmon log.
I had something similar to kmon a long time ago, and it helped me a lot
in fetching out scheduler data when the system is under real life load.
You can study task migrations, latencies, run-time patterns, etc...
The Quilt patch series are kept here:

http://www.xmailserver.org/kmon/patches/



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


