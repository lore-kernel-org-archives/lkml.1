Return-Path: <linux-kernel-owner+w=401wt.eu-S1750980AbYLCTwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbYLCTwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYLCTuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:11 -0500
Received: from kroah.org ([198.145.64.141]:34534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392AbYLCTuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:07 -0500
Date: Wed, 3 Dec 2008 11:48:28 -0800
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
       Max Krasnyansky <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 007/104] cpuset: fix regression when failed to generate
	sched domains
Message-ID: <20081203194828.GH8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpuset-fix-regression-when-failed-to-generate-sched-domains.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

commit 700018e0a77b4113172257fcdaa1c58e27a5074f upstream.

Impact: properly rebuild sched-domains on kmalloc() failure

When cpuset failed to generate sched domains due to kmalloc()
failure, the scheduler should fallback to the single partition
'fallback_doms' and rebuild sched domains, but now it only
destroys but not rebuilds sched domains.

The regression was introduced by:

| commit dfb512ec4834116124da61d6c1ee10fd0aa32bd6
| Author: Max Krasnyansky <maxk@qualcomm.com>
| Date:   Fri Aug 29 13:11:41 2008 -0700
|
|    sched: arch_reinit_sched_domains() must destroy domains to force rebuild

After the above commit, partition_sched_domains(0, NULL, NULL) will
only destroy sched domains and partition_sched_domains(1, NULL, NULL)
will create the default sched domain.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cpuset.c |   12 ++++++++----
 kernel/sched.c  |   13 +++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -587,7 +587,6 @@ static int generate_sched_domains(cpumas
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	ndoms = 0;
 	doms = NULL;
 	dattr = NULL;
 	csa = NULL;
@@ -674,10 +673,8 @@ restart:
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
 	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
-	if (!doms) {
-		ndoms = 0;
+	if (!doms)
 		goto done;
-	}
 
 	/*
 	 * The rest of the code, including the scheduler, can deal with
@@ -732,6 +729,13 @@ restart:
 done:
 	kfree(csa);
 
+	/*
+	 * Fallback to the default domain if kmalloc() failed.
+	 * See comments in partition_sched_domains().
+	 */
+	if (doms == NULL)
+		ndoms = 1;
+
 	*domains    = doms;
 	*attributes = dattr;
 	return ndoms;
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7692,13 +7692,14 @@ static int dattrs_equal(struct sched_dom
  *
  * The passed in 'doms_new' should be kmalloc'd. This routine takes
  * ownership of it and will kfree it when done with it. If the caller
- * failed the kmalloc call, then it can pass in doms_new == NULL,
- * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms', it also forces the domains to be rebuilt.
+ * failed the kmalloc call, then it can pass in doms_new == NULL &&
+ * ndoms_new == 1, and partition_sched_domains() will fallback to
+ * the single partition 'fallback_doms', it also forces the domains
+ * to be rebuilt.
  *
- * If doms_new==NULL it will be replaced with cpu_online_map.
- * ndoms_new==0 is a special case for destroying existing domains.
- * It will not create the default domain.
+ * If doms_new == NULL it will be replaced with cpu_online_map.
+ * ndoms_new == 0 is a special case for destroying existing domains,
+ * and it will not create the default domain.
  *
  * Call with hotplug lock held
  */

