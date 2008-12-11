Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYLKTm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYLKTm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbYLKTTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:20 -0500
Received: from kroah.org ([198.145.64.141]:56644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756699AbYLKTTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:18 -0500
Date: Thu, 11 Dec 2008 11:16:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [patch 67/83] sched: fix a bug in sched domain degenerate
Message-ID: <20081211191617.GO5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-a-bug-in-sched-domain-degenerate.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit f29c9b1ccb52904ee442a933cf3dee628f9f4e62 upstream.

Impact: re-add incorrectly eliminated sched domain layers

(1) on i386 with SCHED_SMT and SCHED_MC enabled
	# mount -t cgroup -o cpuset xxx /mnt
	# echo 0 > /mnt/cpuset.sched_load_balance
	# mkdir /mnt/0
	# echo 0 > /mnt/0/cpuset.cpus
	# dmesg
	CPU0 attaching sched-domain:
	 domain 0: span 0 level CPU
	  groups: 0

(2) on i386 with SCHED_MC enabled but SCHED_SMT disabled
	# same with (1)
	# dmesg
	CPU0 attaching NULL sched-domain.

The bug is that some sched domains may be skipped unintentionally when
degenerating (optimizing) sched domains.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6802,15 +6802,17 @@ cpu_attach_domain(struct sched_domain *s
 	struct sched_domain *tmp;
 
 	/* Remove the sched domains which do not contribute to scheduling. */
-	for (tmp = sd; tmp; tmp = tmp->parent) {
+	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
 		if (!parent)
 			break;
+
 		if (sd_parent_degenerate(tmp, parent)) {
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
-		}
+		} else
+			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {

