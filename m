Return-Path: <linux-kernel-owner+w=401wt.eu-S968032AbXFHHdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968032AbXFHHdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938269AbXFHHXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:24 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58306 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938345AbXFHHXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:22 -0400
Message-Id: <20070608072210.773117000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru,
       takeuchi_satoru@jp.fujitsu.com, roland@redhat.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 26/54] tty: fix leakage of -ERESTARTSYS to userland
Content-Disposition: inline; filename=tty-fix-leakage-of-erestartsys-to-userland.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oleg Nesterov <oleg@tv-sign.ru>

Spotted by Satoru Takeuchi.

kill_pgrp(task_pgrp(current)) sends the signal to the current's thread
group, but can choose any sub-thread as a target for signal_wake_up(). 
This means that job_control() and tty_check_change() may return
-ERESTARTSYS without signal_pending().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/char/n_tty.c  |    1 +
 drivers/char/tty_io.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21.4.orig/drivers/char/n_tty.c
+++ linux-2.6.21.4/drivers/char/n_tty.c
@@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
 			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
+			set_thread_flag(TIF_SIGPENDING);
 			return -ERESTARTSYS;
 		}
 	}
--- linux-2.6.21.4.orig/drivers/char/tty_io.c
+++ linux-2.6.21.4/drivers/char/tty_io.c
@@ -1121,7 +1121,8 @@ int tty_check_change(struct tty_struct *
 		return 0;
 	if (is_current_pgrp_orphaned())
 		return -EIO;
-	(void) kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	set_thread_flag(TIF_SIGPENDING);
 	return -ERESTARTSYS;
 }
 

-- 
