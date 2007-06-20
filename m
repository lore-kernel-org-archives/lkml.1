Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbXFTWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbXFTWh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXFTWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:37:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:45414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXFTWhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:37:52 -0400
Date: Wed, 20 Jun 2007 15:38:20 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] audit: fix oops removing watch if audit disabled
Message-ID: <20070620223820.GA16416@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a watched file will oops if audit is disabled (auditctl -e 0).

To reproduce:
- auditctl -e 1
- touch /tmp/foo
- auditctl -w /tmp/foo
- auditctl -e 0
- rm /tmp/foo (or mv)

Signed-off-by: Tony Jones <tonyj@suse.de>
---

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 74cc0fc..ce61f42 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -947,7 +947,7 @@ static void audit_update_watch(struct au
 
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
-		if (invalidating &&
+		if (invalidating && current->audit_context &&
 		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
 			audit_set_auditable(current->audit_context);
 
