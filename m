Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXLGRCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXLGRCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXLGRCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:02:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:45641 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbXLGRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:02:47 -0500
Date: Fri, 7 Dec 2007 20:03:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] uglify while_each_pid_task() to make sure we don't count the execing pricess twice
Message-ID: <20071207170334.GA13832@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a window when de_thread() switches the leader and drops tasklist_lock.
In that window do_each_pid_task(PIDTYPE_PID) finds both new and old leaders.

The problem is pretty much theoretical and probably can be ignored. Currently
the only users of do_each_pid_task(PIDTYPE_PID) are send_sigio/send_sigurg, so
they can send the signal to the same process twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/include/linux/pid.h~2_do_each_pid_task	2007-10-25 16:22:12.000000000 +0400
+++ PT/include/linux/pid.h	2007-12-07 18:24:21.000000000 +0300
@@ -160,7 +160,13 @@ static inline pid_t pid_vnr(struct pid *
 			hlist_for_each_entry_rcu((task), pos___,	\
 				&pid->tasks[type], pids[type].node) {
 
+			/*
+			 * Both old and new leaders may be attached to
+			 * the same pid in the middle of de_thread().
+			 */
 #define while_each_pid_task(pid, type, task)				\
+				if (type == PIDTYPE_PID)		\
+					break;				\
 			}						\
 	} while (0)
 

