Return-Path: <linux-kernel-owner+w=401wt.eu-S1764021AbXE2So7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764021AbXE2So7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXE2Sou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:44:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:42773 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXE2Sot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:44:49 -0400
Date: Tue, 29 May 2007 22:44:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix leakage of -ERESTARTSYS to userland
Message-ID: <20070529184435.GA174@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Satoru Takeuchi.

kill_pgrp(task_pgrp(current)) sends the signal to the current's thread group,
but can choose any sub-thread as a target for signal_wake_up(). This means
that job_control() and tty_check_change() may return -ERESTARTSYS without
signal_pending().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/drivers/char/n_tty.c~	2007-04-05 12:18:26.000000000 +0400
+++ t/drivers/char/n_tty.c	2007-05-28 10:57:58.000000000 +0400
@@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
 			    is_current_pgrp_orphaned())
 				return -EIO;
 			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
+			set_thread_flag(TIF_SIGPENDING);
 			return -ERESTARTSYS;
 		}
 	}
--- t/drivers/char/tty_io.c~	2007-04-05 12:18:26.000000000 +0400
+++ t/drivers/char/tty_io.c	2007-05-29 22:15:52.000000000 +0400
@@ -1121,7 +1121,8 @@ int tty_check_change(struct tty_struct *
 		return 0;
 	if (is_current_pgrp_orphaned())
 		return -EIO;
-	(void) kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	kill_pgrp(task_pgrp(current), SIGTTOU, 1);
+	set_thread_flag(TIF_SIGPENDING);
 	return -ERESTARTSYS;
 }
 

