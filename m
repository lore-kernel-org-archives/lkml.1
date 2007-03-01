Return-Path: <linux-kernel-owner+w=401wt.eu-S965441AbXCAROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbXCAROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965439AbXCARNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:13:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965421AbXCARNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:13:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=a72MsxwvlUzRhKz2wi/748NPcIILd6aXK5MO3sixfmD661ZRrx+RFEfu4R+GK/UF7
	/s+OjetB9rDBVFvBEORUQ==
Date: Thu, 1 Mar 2007 09:13:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch -mm 7/7] x86_64: fake numa for cpusets document
In-Reply-To: <Pine.LNX.4.64.0703010131070.10045@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0703010131480.10045@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0703010127130.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128150.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010128490.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010129180.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010130310.10045@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703010131070.10045@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a document to explain how to use numa=fake in conjunction with
cpusets for coarse memory resource management.

An attempt to get more awareness and testing for this feature.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86_64/fake-numa-for-cpusets |   66 ++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86_64/fake-numa-for-cpusets

diff --git a/Documentation/x86_64/fake-numa-for-cpusets b/Documentation/x86_64/fake-numa-for-cpusets
new file mode 100644
--- /dev/null
+++ b/Documentation/x86_64/fake-numa-for-cpusets
@@ -0,0 +1,66 @@
+Using numa=fake and CPUSets for Resource Management
+Written by David Rientjes <rientjes@cs.washington.edu>
+
+This document describes how the numa=fake x86_64 command-line option can be used
+in conjunction with cpusets for coarse memory management.  Using this feature,
+you can create fake NUMA nodes that represent contiguous chunks of memory and
+assign them to cpusets and their attached tasks.  This is a way of limiting the
+amount of system memory that are available to a certain class of tasks.
+
+For more information on the features of cpusets, see Documentation/cpusets.txt.
+There are a number of different configurations you can use for your needs.  For
+more information on the numa=fake command line option and its various ways of
+configuring fake nodes, see Documentation/x86_64/boot-options.txt.
+
+For the purposes of this introduction, we'll assume a very primitive NUMA
+emulation setup of "numa=fake=4*512,".  This will split our system memory into
+four equal chunks of 512M each that we can now use to assign to cpusets.  As
+you become more familiar with using this combination for resource control,
+you'll determine a better setup to minimize the number of nodes you have to deal
+with.
+
+A machine may be split as follows with "numa=fake=4*512," as reported by dmesg:
+
+	Faking node 0 at 0000000000000000-0000000020000000 (512MB)
+	Faking node 1 at 0000000020000000-0000000040000000 (512MB)
+	Faking node 2 at 0000000040000000-0000000060000000 (512MB)
+	Faking node 3 at 0000000060000000-0000000080000000 (512MB)
+	...
+	On node 0 totalpages: 130975
+	On node 1 totalpages: 131072
+	On node 2 totalpages: 131072
+	On node 3 totalpages: 131072
+
+Now following the instructions for mounting the cpusets filesystem from
+Documentation/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
+address spaces) to individual cpusets:
+
+	[root@xroads /]# mkdir exampleset
+	[root@xroads /]# mount -t cpuset none exampleset
+	[root@xroads /]# mkdir exampleset/ddset
+	[root@xroads /]# cd exampleset/ddset
+	[root@xroads /exampleset/ddset]# echo 0-1 > cpus
+	[root@xroads /exampleset/ddset]# echo 0-1 > mems
+
+Now this cpuset, 'ddset', will only allowed access to fake nodes 0 and 1 for
+memory allocations (1G).
+
+You can now assign tasks to these cpusets to limit the memory resources
+available to them according to the fake nodes assigned as mems:
+
+	[root@xroads /exampleset/ddset]# echo $$ > tasks
+	[root@xroads /exampleset/ddset]# dd if=/dev/zero of=tmp bs=1024 count=1G
+	[1] 13425
+
+Notice the difference between the system memory usage as reported by
+/proc/meminfo between the restricted cpuset case above and the unrestricted
+case (i.e. running the same 'dd' command without assigning it to a fake NUMA
+cpuset):
+				Unrestricted	Restricted
+	MemTotal:		3091900 kB	3091900 kB
+	MemFree:		  42113 kB	1513236 kB
+
+This allows for coarse memory management for the tasks you assign to particular
+cpusets.  Since cpusets can form a hierarchy, you can create some pretty
+interesting combinations of use-cases for various classes of tasks for your
+memory management needs.
