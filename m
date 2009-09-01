Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZIAJeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZIAJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZIAJeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:34:17 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:63575 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbZIAJeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:34:05 -0400
X-Trace: 255330205/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.4.130/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.4.130
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGeHnEpPRQSC/2dsb2JhbACBU9ophBoF
X-IronPort-AV: E=Sophos;i="4.44,311,1249254000"; 
   d="scan'208";a="255330205"
Date: Tue, 1 Sep 2009 10:33:31 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [mmotm][BUG] free is bigger than presnet Re: mmotm 2009-08-27-16-51
 uploaded
In-Reply-To: <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909011031140.13740@sister.anvils>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
 <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, KAMEZAWA Hiroyuki wrote:
> 
> I'm not digggin so much but /proc/meminfo corrupted.
> 
> [kamezawa@bluextal cgroup]$ cat /proc/meminfo
> MemTotal:       24421124 kB
> MemFree:        38314388 kB

If that's without my fix to shrink_active_list(), I'd try again with.
Hugh

[PATCH mmotm] vmscan move pgdeactivate modification to shrink_active_list fix

mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
quicker than last time: one bug fixed but another bug introduced.
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
forgot to add NR_LRU_BASE to lru index to make zone_page_state index.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- mmotm/mm/vmscan.c	2009-08-28 10:07:57.000000000 +0100
+++ linux/mm/vmscan.c	2009-08-28 18:30:33.000000000 +0100
@@ -1381,8 +1381,10 @@ static void shrink_active_list(unsigned
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 	__count_vm_events(PGDEACTIVATE, nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
-	__mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
-	__mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
+	__mod_zone_page_state(zone, NR_ACTIVE_ANON + file * LRU_FILE,
+							nr_rotated);
+	__mod_zone_page_state(zone, NR_INACTIVE_ANON + file * LRU_FILE,
+							nr_deactivated);
 	spin_unlock_irq(&zone->lru_lock);
 }
 
