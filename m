Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZIKA3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZIKA3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZIKA3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:20 -0400
Received: from kroah.org ([198.145.64.141]:38112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZIKA3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:11 2009
Message-Id: <20090911002411.791389158@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 18/22] dm raid1: do not allow log_failure variable to unset after being set
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dm-raid1-do-not-allow-log_failure-variable-to-unset-after-being-set.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jonathan Brassow <jbrassow@redhat.com>

commit d2b698644c97cb033261536a4f2010924a00eac9 upstream.

This patch fixes a bug which was triggering a case where the primary leg
could not be changed on failure even when the mirror was in-sync.

The case involves the failure of the primary device along with
the transient failure of the log device.  The problem is that
bios can be put on the 'failures' list (due to log failure)
before 'fail_mirror' is called due to the primary device failure.
Normally, this is fine, but if the log device failure is transient,
a subsequent iteration of the work thread, 'do_mirror', will
reset 'log_failure'.  The 'do_failures' function then resets
the 'in_sync' variable when processing bios on the failures list.
The 'in_sync' variable is what is used to determine if the
primary device can be switched in the event of a failure.  Since
this has been reset, the primary device is incorrectly assumed
to be not switchable.

The case has been seen in the cluster mirror context, where one
machine realizes the log device is dead before the other machines.
As the responsibilities of the server migrate from one node to
another (because the mirror is being reconfigured due to the failure),
the new server may think for a moment that the log device is fine -
thus resetting the 'log_failure' variable.

In any case, it is inappropiate for us to reset the 'log_failure'
variable.  The above bug simply illustrates that it can actually
hurt us.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-raid1.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -648,7 +648,13 @@ static void do_writes(struct mirror_set 
 	 */
 	dm_rh_inc_pending(ms->rh, &sync);
 	dm_rh_inc_pending(ms->rh, &nosync);
-	ms->log_failure = dm_rh_flush(ms->rh) ? 1 : 0;
+
+	/*
+	 * If the flush fails on a previous call and succeeds here,
+	 * we must not reset the log_failure variable.  We need
+	 * userspace interaction to do that.
+	 */
+	ms->log_failure = dm_rh_flush(ms->rh) ? 1 : ms->log_failure;
 
 	/*
 	 * Dispatch io.


