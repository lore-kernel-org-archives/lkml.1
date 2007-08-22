Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXHVIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXHVIxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXHVIwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:33 -0400
Received: from 1wt.eu ([62.212.114.60]:1893 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbXHVIwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:32 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083942.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:48 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Patrick McHardy <kaber@trash.net>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 04/58] gen estimator timer unload race
Content-Disposition: inline; filename=0004-gen-estimator-timer-unload-race.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[NET]: Fix gen_estimator timer removal race

As noticed by Jarek Poplawski <jarkao2@o2.pl>, the timer removal in
gen_kill_estimator races with the timer function rearming the timer.

Check whether the timer list is empty before rearming the timer
in the timer function to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/gen_estimator.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 3cad026..33d82bf 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -128,7 +128,8 @@ static void est_timer(unsigned long arg)
 		spin_unlock(e->stats_lock);
 	}
 
-	mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
+	if (elist[idx].list != NULL)
+		mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
 	read_unlock(&est_lock);
 }
 
-- 
1.5.2.5

-- 
