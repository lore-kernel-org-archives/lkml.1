Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYJ1QHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYJ1QHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJ1QHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:07:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYJ1QHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:07:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=jMyqTkCm5Hn84WJFUJRFS54RutokN0P/BKSsPX12yzK9FsgHj1drEob0cwjhH88NW
	rnrhoM8KdzN1f7wYJRjRQ==
Date: Tue, 28 Oct 2008 09:06:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch] oom: fix zone_scan_mutex name
Message-ID: <alpine.DEB.1.10.0810280259140.15270@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_scan_mutex is actually a spinlock, so name it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -31,7 +31,7 @@
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks;
-static DEFINE_SPINLOCK(zone_scan_mutex);
+static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
 /**
@@ -470,7 +470,7 @@ int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 	struct zone *zone;
 	int ret = 1;
 
-	spin_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		if (zone_is_oom_locked(zone)) {
 			ret = 0;
@@ -480,7 +480,7 @@ int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		/*
-		 * Lock each zone in the zonelist under zone_scan_mutex so a
+		 * Lock each zone in the zonelist under zone_scan_lock so a
 		 * parallel invocation of try_set_zone_oom() doesn't succeed
 		 * when it shouldn't.
 		 */
@@ -488,7 +488,7 @@ int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 	}
 
 out:
-	spin_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_lock);
 	return ret;
 }
 
@@ -502,11 +502,11 @@ void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 	struct zoneref *z;
 	struct zone *zone;
 
-	spin_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		zone_clear_flag(zone, ZONE_OOM_LOCKED);
 	}
-	spin_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_lock);
 }
 
 /**
