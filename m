Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYKZDr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYKZDr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 22:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYKZDrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 22:47:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:42923 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYKZDrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 22:47:09 -0500
Date: Tue, 25 Nov 2008 19:46:56 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: [RFC][PATCH 5/5] Clear si_pid for signal from ancestor ns
Message-ID: <20081126034656.GE23238@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126034242.GA23120@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 9885a182bd9feeeb85abf7b2e09340e392ebf43d Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 11:04:34 -0800
Subject: [PATCH 5/5] Clear si_pid for signal from ancestor ns

Since processes don't have valid pid numbers in a descendant pid namespaces,
the siginfo->si_pid field must be set to 0 when signal is sent from an
ancestor namespace.

TODO:
	- siginfo->si_pid may need to be cleared in other locations (eg:
	  __do_notify(), F_SETSIG) and will be addressed in separate patches.

	- rt_sigqueueinfo(): siginfo->si_pid value is unreliable/undefined
	  when rt_sigqueueinfo() is used to signal a process in a descendant
	  namespace

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8c294c1..14eb986 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -881,6 +881,8 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 		default:
 			copy_siginfo(&q->info, info);
 			q->info.si_signo &= ~SIG_FROM_USER;
+			if (from_ancestor_ns)
+				q->info.si_pid = 0;
 			break;
 		}
 	} else if (!is_si_special(info)) {
-- 
1.5.2.5

