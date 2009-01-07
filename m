Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZAGHzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZAGHzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZAGHzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:55:15 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33360 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZAGHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:55:12 -0500
Date: Tue, 6 Jan 2009 23:52:42 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: [PATCH 7/7][v6] SI_USER: Masquerade si_pid when crossing pid ns
	boundary
Message-ID: <20090107075242.GG27985@us.ibm.com>
References: <20090107074558.GA27881@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107074558.GA27881@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 24 Dec 2008 14:14:18 -0800
Subject: [PATCH 7/7][v6] SI_USER: Masquerade si_pid when crossing pid ns boundary

When sending a signal to a descendant namespace, set ->si_pid to 0 since
the sender does not have a pid in the receiver's namespace.

Note:
	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
	  signal across a pid namespace boundary, the value in ->si_pid
	  will be cleared to 0.

Changelog[v5]:
	- (Oleg Nesterov) Address both sys_kill() and sys_tkill() cases
	  in send_signal() to simplify code (this drops patch 7/7 from
	  earlier version of patchset).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 6ad47c0..d96ac1a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -917,6 +917,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			break;
 		default:
 			copy_siginfo(&q->info, info);
+			if (from_ancestor_ns)
+				q->info.si_pid = 0;
 			break;
 		}
 	} else if (!is_si_special(info)) {
-- 
1.5.2.5

