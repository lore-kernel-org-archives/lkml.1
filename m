Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZA1RzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZA1RzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZA1Rxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:53:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:42387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZA1Rxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:53:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: greg@kroah.com
Cc: chrisw@sous-sol.org, stable@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH stable-28 3/3] relay: fix lock imbalance in relay_late_setup_files
Date: Wed, 28 Jan 2009 18:53:41 +0100
Message-Id: <1233165221-20106-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1233165221-20106-4-git-send-email-jslaby@suse.cz>
References: <1233165221-20106-1-git-send-email-jslaby@suse.cz>
 <1233165221-20106-2-git-send-email-jslaby@suse.cz>
 <1233165221-20106-3-git-send-email-jslaby@suse.cz>
 <1233165221-20106-4-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

One fail path in relay_late_setup_files() omits
mutex_unlock(&relay_channels_mutex);
Add it.

Commit b786c6a98ef6fa81114ba7b9fbfc0d67060775e3.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/relay.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 09ac200..9d79b78 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -663,8 +663,10 @@ int relay_late_setup_files(struct rchan *chan,
 
 	mutex_lock(&relay_channels_mutex);
 	/* Is chan already set up? */
-	if (unlikely(chan->has_base_filename))
+	if (unlikely(chan->has_base_filename)) {
+		mutex_unlock(&relay_channels_mutex);
 		return -EEXIST;
+	}
 	chan->has_base_filename = 1;
 	chan->parent = parent;
 	curr_cpu = get_cpu();
-- 
1.6.1

