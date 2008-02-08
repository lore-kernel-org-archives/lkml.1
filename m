Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbYBHCDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbYBHCDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYBHCDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:03:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:40862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYBHCDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:03:39 -0500
From: NeilBrown <neilb@suse.de>
To: J.Bruce@suse.de, Fields@suse.de, " <bfields@fieldses.org>@suse.de"@suse.de
Date: Fri, 8 Feb 2008 13:03:37 +1100
Message-Id: <1080208020337.14371@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] knfsd: Remove NLM_HOST_MAX and associated logic.
References: <20080208130300.14320.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lockd caches information about hosts that have recently held locks it
expedite the taking of further locks.

It periodically discards this information for hosts that have not been
used for a few minutes.

lockd currently has a value NLM_HOST_MAX, and changes the 'garbage
collection' behaviour when the number of hosts exceeds this threshold.

However it's behaviour in strange an likely not what was intended.
When the number of hosts exceeds the max, it scans *less* often (every
2 minutes vs every minute) and allows unused host information to
remain around longer (5 minutes instead of 2).

Having this limit is of dubious value anyway, and we have not
suffered from the code not getting the limit right, so remove the
limit altogether.  We go with the larger values (discard 5 minute old
hosts every 2 minutes) as that is probably safer.

Maybe the periodic garbage collection should be replace to with
'shrinker' handler so we just respond to memory pressure....

Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/lockd/host.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff .prev/fs/lockd/host.c ./fs/lockd/host.c
--- .prev/fs/lockd/host.c	2008-02-07 14:20:54.000000000 +1100
+++ ./fs/lockd/host.c	2008-02-08 12:54:28.000000000 +1100
@@ -19,12 +19,11 @@
 
 
 #define NLMDBG_FACILITY		NLMDBG_HOSTCACHE
-#define NLM_HOST_MAX		64
 #define NLM_HOST_NRHASH		32
 #define NLM_ADDRHASH(addr)	(ntohl(addr) & (NLM_HOST_NRHASH-1))
 #define NLM_HOST_REBIND		(60 * HZ)
-#define NLM_HOST_EXPIRE		((nrhosts > NLM_HOST_MAX)? 300 * HZ : 120 * HZ)
-#define NLM_HOST_COLLECT	((nrhosts > NLM_HOST_MAX)? 120 * HZ :  60 * HZ)
+#define NLM_HOST_EXPIRE		(300 * HZ)
+#define NLM_HOST_COLLECT	(120 * HZ)
 
 static struct hlist_head	nlm_hosts[NLM_HOST_NRHASH];
 static unsigned long		next_gc;
@@ -142,9 +141,7 @@ nlm_lookup_host(int server, const struct
 	INIT_LIST_HEAD(&host->h_granted);
 	INIT_LIST_HEAD(&host->h_reclaim);
 
-	if (++nrhosts > NLM_HOST_MAX)
-		next_gc = 0;
-
+	nrhosts++;
 out:
 	mutex_unlock(&nlm_host_mutex);
 	return host;
