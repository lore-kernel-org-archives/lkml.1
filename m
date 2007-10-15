Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbXJOEfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbXJOEfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbXJOEej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:34:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:33136 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXJOEei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:34:38 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 14:34:31 +1000
Message-Id: <1071015043431.5463@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 5] md: 'sync_action' in sysfs returns wrong value for readonly arrays
References: <20071015143136.5200.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When an array is started read-only, MD_RECOVERY_NEEDED can be set but
no recovery will be running.  This causes 'sync_action' to report the
wrong value.

We could remove the test for MD_RECOVERY_NEEDED, but doing so would
leave a small gap after requesting a sync action, where 'sync_action'
would still report the old value.

So make sure that for a read-only array, 'sync_action' always returns 'idle'.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-10-15 14:06:32.000000000 +1000
+++ ./drivers/md/md.c	2007-10-15 14:06:32.000000000 +1000
@@ -2714,7 +2714,7 @@ action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
+	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 			type = "reshape";
 		else if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
