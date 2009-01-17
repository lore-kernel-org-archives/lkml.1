Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZAQLFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZAQLFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 06:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZAQLFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 06:05:03 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:45353 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZAQLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 06:05:00 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Jens Axboe <axboe@suse.de>
Subject: [PATCH 1/1] relay: fix lock imbalance in relay_late_setup_files
Date: Sat, 17 Jan 2009 12:04:36 +0100
Message-Id: <1232190276-21200-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fail path in relay_late_setup_files() omits
mutex_unlock(&relay_channels_mutex);
Add it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Jens Axboe <axboe@suse.de>
---
 kernel/relay.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 8ca1587..738bc85 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -714,8 +714,10 @@ int relay_late_setup_files(struct rchan *chan,
 
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
caught by stanse
