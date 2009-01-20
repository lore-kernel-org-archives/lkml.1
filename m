Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZATKm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZATKm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZATKmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:42:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:44130 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbZATKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:42:11 -0500
X-Greylist: delayed 1713 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 05:42:11 EST
Subject: Detailed Stack Information Patch [0/3]
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 Jan 2009 11:16:37 +0100
Message-Id: <1232446597.784.15.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch which give you a better overview of the userland
application stack usage, especially for embedded linux.

Currently you are only able to dump the main process/thread stack usage
which is showed in proc/pid/status by the "VmStk" Value. But you get no
information about the consumed stack memory of the the threads.

The patch is splitted in three parts.


Part 1 :
--------

This is an enhancement in the /proc/<pid>/tasks/<tid>/maps and
smaps which marks the mapping where the thread stack pointer reside with
"[thread stack]".

Also there is a new entry "stack usage" in proc/pid/status, which will
you give the current stack usage.

This feature will be enabled the which "enable /proc/<pid> stack
monitoring" under "General setup-->"


Part 2:
-------

This enable a new /proc/stackmon file entry. A cat /proc/stackmon
will produce a output like:

   bytes   pages maxpages vm_start vm_end   processid threadid  name
     436       1       1  afdbf000-afdd4000 pid:  409 tid:  409 syslogd
    1168       1       1  afd12000-afd27000 pid:  411 tid:  411 sh
     516       1       1  afe6c000-afe81000 pid:  412 tid:  412 getty
    4580       2       2  af918000-af92d000 pid:  419 tid:  419 cat
The first value is the current effektive stack usage in bytes.

The second value is the current real stack usage in pages. This means
how many pages are really occupied by the stack.

The thrird value is the maximum real stack usage in pages. This value
will be determinate by the difference of the highest used page in the
mapping and the page of stack start address.

The fourth value is the start- and end- address of the mapping where the
stack currently reside.

The fifth value process id.

The sixth value is thread id.

And the seventh and last entry is the name of the process.

This feature will be enabled the which "enable /proc/<pid> stack
monitoring" under "General setup-->".


Part 3:
-------

There is also an additional stack monitor which can be enabled by boot
time or by the /sys filesystem. Which this you are able to detect if a
application use more stack than a given value. If the application
exceeds this value, it will receive a SIGTRAP signal. 

If there is a debugger attached at this time, there is the ability to
examinate the stack usage. Otherwise the application will be terminated.
In both cases a kernel log entry "pid:%d (%s) tid:%d stack size %lu
exceeds max stack size." will be written.

There are following entries under /sys/kernel/stackmon to control the
monitor.

mode:
 Setting this to an value not equal zero will start the stack monitoring
thread. Default is 0. Setting it to zero will stop the kernel thread.

stacksize:
 This value is the stack size in kb which triggers a SIGTRAP to the
application, if the stack usage is equal or more. Default is 256 kb.
 
ticks:
 Number of ticks between the monitoring invocation. A higher value will
give a less change to trigger a stack over usage, but will also result
in a less CPU usage. Default is 1.

All this parameters can also set at boot time with the kernel parameter
"stackmon=<stacksize>:<mode>:<ticks>".

The monitor can also compiled as a module.


This patch is against 2.6.28.1. The patch is cpu independent, so it
should work on all linux supported architectures, it was tested under
x86 and powerpc. Also there is not dependency a library: glibc, uclibc
and all other should work.

I hope you like it and want ask what is necessary for inclusion into the
main stream kernel or linux-next? If you have ideas how to do things in
a better way, please let me know.

Have a nice day,
Stefani


