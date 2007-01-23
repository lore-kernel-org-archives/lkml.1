Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbXAWA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbXAWA1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932585AbXAWA1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:27:41 -0500
Received: from ns.suse.de ([195.135.220.2]:35475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXAWA1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:27:21 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:26:56 +1100
Message-Id: <1070123002656.29477@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 4] md: Make sure the events count in an md array never returns to zero.
References: <20070123112437.29357.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we sometimes step the array events count backwards
(when transitioning dirty->clean where nothing else interesting
has happened - so that we don't need to write to spares all the time),
it is possible for the event count to return to zero, which is
potentially confusing and triggers and MD_BUG.

We could possibly remove the MD_BUG, but is just as easy, and
probably safer, to make sure we never return to zero.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-01-23 11:13:44.000000000 +1100
+++ ./drivers/md/md.c	2007-01-23 11:23:58.000000000 +1100
@@ -1633,7 +1633,8 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1))
+	    && (mddev->events & 1)
+	    && mddev->events != 1)
 		mddev->events--;
 	else {
 		/* otherwise we have to go forward and ... */
