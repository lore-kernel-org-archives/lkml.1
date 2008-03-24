Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbYCXSbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbYCXSbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbYCXSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:31:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36712 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYCXSb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:31:26 -0400
Date: Mon, 24 Mar 2008 21:36:03 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] pids: initial fixes, unsafe dereference of the special pids
Message-ID: <20080324183603.GA9644@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without rcu ot tasklist lock held, it is not safe to dereference the
result of task_session/task_pgrp. Even if the task == current.

Because we can race with another thread doing setpgrp/setsid, and use
the already freed/reused/unmapped memory if preempted.

The problem is old, surprisingly it wasn't noticed before. Fortunately
it is not very serious.

We have a lot of users which should be fixed. This series only fixes
sys_getsid/sys_getpgid syscalls.

Perhaps we can (should) add rcu lock/unlock to task_xxx_vnr(), but I'm
not sure. In any case, I think it is good to factor out pid_vnr() calls
like these patches do.

Oleg.

