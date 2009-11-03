Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKCKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKCKU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZKCKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:20:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28172 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZKCKUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:20:55 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 05:20:55 EST
X-IronPort-AV: E=Sophos;i="4.44,673,1249272000"; 
   d="scan'208";a="71258634"
Subject: [PATCH] Correct nr_processes() when CPUs have been unplugged
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 3 Nov 2009 10:11:14 +0000
Message-ID: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_processes() returns the sum of the per cpu counter process_counts for
all online CPUs. This counter is incremented for the current CPU on
fork() and decremented for the current CPU on exit(). Since a process
does not necessarily fork and exit on the same CPU the process_count for
an individual CPU can be either positive or negative and effectively has
no meaning in isolation.

Therefore calculating the sum of process_counts over only the online
CPUs omits the processes which were started or stopped on any CPU which
has since been unplugged. Only the sum of process_counts across all
possible CPUs has meaning.

The only caller of nr_processes() is proc_root_getattr() which
calculates the number of links to /proc as
        stat->nlink = proc_root.nlink + nr_processes();

You don't have to be all that unlucky for the nr_processes() to return a
negative value leading to a negative number of links (or rather, an
apparently enormous number of links). If this happens then you can get
failures where things like "ls /proc" start to fail because they got an
-EOVERFLOW from some stat() call.

Example with some debugging inserted to show what goes on:
        # ps haux|wc -l
        nr_processes: CPU0:     90
        nr_processes: CPU1:     1030
        nr_processes: CPU2:     -900
        nr_processes: CPU3:     -136
        nr_processes: TOTAL:    84
        proc_root_getattr. nlink 12 + nr_processes() 84 = 96
        84
        # echo 0 >/sys/devices/system/cpu/cpu1/online
        # ps haux|wc -l
        nr_processes: CPU0:     85
        nr_processes: CPU2:     -901
        nr_processes: CPU3:     -137
        nr_processes: TOTAL:    -953
        proc_root_getattr. nlink 12 + nr_processes() -953 = -941
        75
        # stat /proc/
        nr_processes: CPU0:     84
        nr_processes: CPU2:     -901
        nr_processes: CPU3:     -137
        nr_processes: TOTAL:    -954
        proc_root_getattr. nlink 12 + nr_processes() -954 = -942
          File: `/proc/'
          Size: 0               Blocks: 0          IO Block: 1024   directory
        Device: 3h/3d   Inode: 1           Links: 4294966354
        Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
        Access: 2009-11-03 09:06:55.000000000 +0000
        Modify: 2009-11-03 09:06:55.000000000 +0000
        Change: 2009-11-03 09:06:55.000000000 +0000

I'm not 100% convinced that the per_cpu regions remain valid for offline
CPUs, although my testing suggests that they do. If not then I think the
correct solution would be to aggregate the process_count for a given CPU
into a global base value in cpu_down().

This bug appears to pre-date the transition to git and it looks like it
may even have been present in linux-2.6.0-test7-bk3 since it looks like
the code Rusty patched in http://lwn.net/Articles/64773/ was already
wrong.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/kernel/fork.c b/kernel/fork.c
index 4b36858..7af7217 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -89,7 +89,7 @@ int nr_processes(void)
 	int cpu;
 	int total = 0;
 
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu)
 		total += per_cpu(process_counts, cpu);
 
 	return total;


