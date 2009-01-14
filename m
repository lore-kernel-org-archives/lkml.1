Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbZANQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbZANQMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbZANQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:12:28 -0500
Received: from netgear.net.ru ([195.178.208.66]:59310 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759044AbZANQM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:12:27 -0500
Date: Wed, 14 Jan 2009 19:12:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>
Subject: OOM documentation update [was: Linux killed Kenny, bastard!]
Message-ID: <20090114161225.GA9584@ioremap.net>
References: <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com> <20090113152106.GA1134@ioremap.net> <alpine.DEB.2.00.0901131140340.8522@chino.kir.corp.google.com> <20090113213316.GB27227@ioremap.net> <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901131336040.17683@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply.
While existing interface do not fix the problems, they should be at least documented.

Sign.

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index d105eb4..f7530a1 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2311,6 +2311,30 @@ increase the likelihood of this process being killed by the oom-killer.  Valid
 values are in the range -16 to +15, plus the special value -17, which disables
 oom-killing altogether for this process.
 
+Process to be killed at out-of-memory situation is selected among all others
+based on its badness score. This value equals to the memory size of the process
+originally and then changed according to its cpu time (utime + stime) and the
+run time (uptime - start time). The longer it runs the smaller is the score.
+Badness score is devided by the sqare root of the cpu time and then by
+the double square root of the run time.
+
+/proc/<pid>/oom_score shows process' current badness score.
+
+Following heueristics are then applied:
+ * if task was reniced, its score doubles
+ * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
+ 	or CAP_SYS_RAWIO) have their score divided by 4
+ * if oom condition happened in one cpuset and checked task does not belong
+ 	to it, its score is divided by 8
+ * resulted score is multiplied by the two in the power of oom_adj when it is
+ 	positive, and devided otherwise, i.e.
+	points <<= oom_adj when it is positive and
+	points >>= oom_adj otherwise
+
+Swapped tasks are killed first.
+Task with the biggest number of badness points is selected to be killed.
+Usually children tasks are prefered compared to their parent.
+
 2.13 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
 

-- 
	Evgeniy Polyakov
