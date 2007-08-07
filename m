Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbXHGUt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbXHGUt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935119AbXHGUrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:47:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbXHGUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:47:17 -0400
Date: Tue, 7 Aug 2007 13:43:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 10/84] gen estimator timer unload race
Message-ID: <20070807204311.GK23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="gen-estimator-timer-unload-race.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

[NET]: Fix gen_estimator timer removal race

As noticed by Jarek Poplawski <jarkao2@o2.pl>, the timer removal in
gen_kill_estimator races with the timer function rearming the timer.

Check whether the timer list is empty before rearming the timer
in the timer function to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/gen_estimator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
