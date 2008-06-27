Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYF0GyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYF0GyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbYF0Gu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:50:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178AbYF0GuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:50:24 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:50:16 +1000
Message-Id: <1080627065016.10436@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 009 of 29] md: Don't try to make md arrays dirty if that is not meaningful.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arrays personalities such as 'raid0' and 'linear' have no redundancy,
and so marking them as 'clean' or 'dirty' is not meaningful.
So always allow write requests without requiring a superblock update.

Such arrays types are detected by ->sync_request being NULL.  If it is
not possible to send a sync request we don't need a 'dirty' flag because
all a dirty flag does is trigger some sync_requests.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:31:35.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:33:00.000000000 +1000
@@ -5536,6 +5536,8 @@ void md_allow_write(mddev_t *mddev)
 		return;
 	if (mddev->ro)
 		return;
+	if (!mddev->pers->sync_request)
+		return;
 
 	spin_lock_irq(&mddev->write_lock);
 	if (mddev->in_sync) {
