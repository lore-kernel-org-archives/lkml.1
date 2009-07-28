Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZG1X50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZG1X50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZG1X5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:57:22 -0400
Received: from kroah.org ([198.145.64.141]:35826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbZG1XuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:57 2009
Message-Id: <20090728234157.512872004@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 41/71] dm raid1: wake kmirrord when requeueing delayed bios after remote recovery
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=dm-raid1-wake-kmirrord-when-requeueing-delayed-bios-after-remote-recovery.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 69885683d22d8c05910fd808c01fdce1322739b4 upstream.

The recent commit 7513c2a761d69d2a93f17146b3563527d3618ba0 (dm raid1:
add is_remote_recovering hook for clusters) changed do_writes() to
update the ms->writes list but forgot to wake up kmirrord to process it.

The rule is that when anything is being added on ms->reads, ms->writes
or ms->failures and the list was empty before we must call
wakeup_mirrord (for immediate processing) or delayed_wake (for delayed
processing).  Otherwise the bios could sit on the list indefinitely.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -638,6 +638,7 @@ static void do_writes(struct mirror_set 
 		spin_lock_irq(&ms->lock);
 		bio_list_merge(&ms->writes, &requeue);
 		spin_unlock_irq(&ms->lock);
+		delayed_wake(ms);
 	}
 
 	/*


