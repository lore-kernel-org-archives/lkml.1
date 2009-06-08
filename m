Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZFHQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZFHQQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZFHQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:16:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38506 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbZFHQQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:16:26 -0400
Date: Mon, 8 Jun 2009 18:12:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: PTRACE_ATTACH && -EINTR
Message-ID: <20090608161204.GA3986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just realized that ->cred_exec_mutex added a user-visible change
which may confuse user-space.

	ptrace_attach:

		retval = mutex_lock_interruptible(&task->cred_exec_mutex);
		if (retval  < 0)
			goto out;

This doesn't look good, we return -EINTR. Suppose that strace tries to
attach to all sub-threads and ptrace(PTRACE_ATTACH) returns -EINTR just
because the already traced thread sends SIGCHLD. Or tracer's sub-thread
does recalc_sigpending_and_wake().

I think we should at least do

		retval = -ERESTARTSYS;
		if (mutex_lock_interruptible(&task->cred_exec_mutex))
			goto out;

Or even -ERESTARTNOINTR ? Or just mutex_lock() ?

Or ignore this problem since nobody complained?

Oleg.

