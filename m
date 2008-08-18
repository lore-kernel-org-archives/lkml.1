Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYHRTcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYHRTcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYHRTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:31:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:48205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933229AbYHRTbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:31:34 -0400
Date: Mon, 18 Aug 2008 12:19:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sven Wegener <sven.wegener@stealer.net>,
       Simon Horman <horms@verge.net.au>
Subject: [patch 17/49] ipvs: Fix possible deadlock in estimator code
Message-ID: <20080818191953.GR10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipvs-fix-possible-deadlock-in-estimator-code.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

commit 8ab19ea36c5c5340ff598e4d15fc084eb65671dc upstream

There is a slight chance for a deadlock in the estimator code. We can't call
del_timer_sync() while holding our lock, as the timer might be active and
spinning for the lock on another cpu. Work around this issue by using
try_to_del_timer_sync() and releasing the lock. We could actually delete the
timer outside of our lock, as the add and kill functions are only every called
from userspace via [gs]etsockopt() and are serialized by a mutex, but better
make this explicit.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipvs/ip_vs_est.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipvs/ip_vs_est.c
+++ b/net/ipv4/ipvs/ip_vs_est.c
@@ -172,8 +172,11 @@ void ip_vs_kill_estimator(struct ip_vs_s
 		kfree(est);
 		killed++;
 	}
-	if (killed && est_list == NULL)
-		del_timer_sync(&est_timer);
+	while (killed && !est_list && try_to_del_timer_sync(&est_timer) < 0) {
+		write_unlock_bh(&est_lock);
+		cpu_relax();
+		write_lock_bh(&est_lock);
+	}
 	write_unlock_bh(&est_lock);
 }
 

-- 
