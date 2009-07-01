Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbZGAAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbZGAAnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbZGAAc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:56 -0400
Received: from kroah.org ([198.145.64.141]:59840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760954AbZGAAcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001552.051321322@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Subject: [patch 22/35] md/raid5: add missing call to schedule() after prepare_to_wait()
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=md-raid5-add-missing-call-to-schedule-after-prepare_to_wait.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 7a3ab908948b6296ee7e81d42f7c176361c51975 upstream.

In the unlikely event that reshape progresses past the current request
while it is waiting for a stripe we need to schedule() before retrying
for 2 reasons:
1/ Prevent list corruption from duplicated list_add() calls without
   intervening list_del().
2/ Give the reshape code a chance to make some progress to resolve the
   conflict.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3465,6 +3465,7 @@ static int make_request(struct request_q
 				spin_unlock_irq(&conf->device_lock);
 				if (must_retry) {
 					release_stripe(sh);
+					schedule();
 					goto retry;
 				}
 			}


