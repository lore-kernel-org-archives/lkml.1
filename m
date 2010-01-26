Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046Ab0AZXuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0AZXuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289Ab0AZXuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:50:01 -0500
Received: from kroah.org ([198.145.64.141]:35431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab0AZXoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233930.454173125@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [73/98] md: fix small irregularity with start_ro module parameter
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 0f9552b5dc4fe10da37fa3f4a4ca185d90fa41c9 upstream.

The start_ro modules parameter can be used to force arrays to be
started in 'auto-readonly' in which they are read-only until the first
write.  This ensures that no resync/recovery happens until something
else writes to the device.  This is important for resume-from-disk
off an md array.

However if an array is started 'readonly' (by writing 'readonly' to
the 'array_state' sysfs attribute) we want it to be really 'readonly',
not 'auto-readonly'.

So strengthen the condition to only set auto-readonly if the
array is not already read-only.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4173,7 +4173,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->barriers_work = 1;
 	mddev->ok_start_degraded = start_dirty_degraded;
 
-	if (start_readonly)
+	if (start_readonly && mddev->ro == 0)
 		mddev->ro = 2; /* read-only, but switch on first write */
 
 	err = mddev->pers->run(mddev);


