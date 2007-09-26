Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXIZO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXIZO5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXIZO5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:57:34 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:48062 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXIZO5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:57:33 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: __kernel_vsyscall () hangs in SIGCHLD handler
Date: Wed, 26 Sep 2007 07:57:20 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709260757.20478.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some reason that syslog() sleeps in __kernel_vsyscall() when 
invoked from a signal handler?  Is it that I am not allowed to call any 
system calls from inside a signal handler?

I use syslog() from a daemon client/server sys. app. that (tries) to log 
whenever a child exits.  I've registered a sigChld handler via 
sigaction(using SA_SIGINFO semantics), and everything works fine and is 
fully functional, including calls to syslog() in the normal program 
flow.  However, if I try to use syslog() from inside the signal handler 
itself, it never returns.

Tracing the program with gdb, I get:

 Attaching to program: lfsad, process 8845
`system-supplied DSO at 0xffffe000' has disappeared; keeping its 
symbols.
[Thread debugging using libthread_db enabled]
[New Thread -1211890000 (LWP 8845)]
Loaded symbols for /usr/lib/libxml2.so.2
Loaded symbols for /lib/libz.so.1
Loaded symbols for /lib/libm.so.6
Loaded symbols for /lib/librt.so.1
Loaded symbols for /lib/libc.so.6
Loaded symbols for /lib/libdl.so.2
Loaded symbols for /lib/ld-linux.so.2
Loaded symbols for /lib/libpthread.so.0
Reading symbols from /lib/libnss_files.so.2...done.
Loaded symbols for /lib/libnss_files.so.2
0xffffe410 in __kernel_vsyscall ()
(gdb) bt
#0  0xffffe410 in __kernel_vsyscall ()
#1  0xb7d2457e in __lll_mutex_lock_wait () from /lib/libc.so.6
#2  0xb7d14d6d in _L_mutex_lock_621 () from /lib/libc.so.6
#3  0x08511b18 in ?? ()
#4  0xbf86b64d in ?? ()
#5  0xbf86b628 in ?? ()
#6  0xbf86b578 in ?? ()
#7  0xb7d76320 in ?? () from /lib/libc.so.6
#8  0xfbad8001 in ?? ()
#9  0x00000014 in ?? ()
#10 0x00000000 in ?? ()

If I check its status in /proc/8845/status, I see that its sleeping.  If 
I remove the call to syslog() in the signal handler, everything is 
fine, no sleeping, and the rest of the syslog() work fine.

Am I doing something wrong?

Thanks,
John

