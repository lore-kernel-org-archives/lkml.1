Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZANWOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZANWOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZANWOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:14:23 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:55087 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZANWOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:14:22 -0500
Date: Thu, 15 Jan 2009 01:14:21 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: Bryan Donlan <bdonlan@gmail.com>, David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Matthias Andree <matthias.andree@gmx.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [take3] OOM documentation update [was: Linux killed Kenny, bastard!]
Message-ID: <20090114221420.GB6039@ioremap.net>
References: <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com> <20090114161225.GA9584@ioremap.net> <20090114170606.GB12102@ioremap.net> <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490901141353u3990148ft1b20220a8317f7dc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index d105eb4..eed2fbb 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2311,6 +2311,32 @@ increase the likelihood of this process being killed by the oom-killer.  Valid
 values are in the range -16 to +15, plus the special value -17, which disables
 oom-killing altogether for this process.
 
+The process to be killed in an out-of-memory situation is selected among all others
+based on its badness score. This value equals the original memory size of the process
+and is then updated according to its CPU time (utime + stime) and the
+run time (uptime - start time). The longer it runs the smaller is the score.
+Badness score is divided by the square root of the CPU time and then by
+the double square root of the run time.
+
+Swapped out tasks are killed first. Half of each child's memory size is added to
+the parent's score if they do not share the same memory. Thus forking servers
+are the prime candidates to be killed. Having only one 'hungry' child will make
+parent less preferable than the child.
+
+/proc/<pid>/oom_score shows process' current badness score.
+
+The following heuristics are then applied:
+ * if the task was reniced, its score doubles
+ * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
+ 	or CAP_SYS_RAWIO) have their score divided by 4
+ * if oom condition happened in one cpuset and checked task does not belong
+ 	to it, its score is divided by 8
+ * the resulting score is multiplied by two to the power of oom_adj, i.e.
+	points <<= oom_adj when it is positive and
+	points >>= -(oom_adj) otherwise
+
+The task with the highest badness score is then killed.
+
 2.13 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 

-- 
	Evgeniy Polyakov
