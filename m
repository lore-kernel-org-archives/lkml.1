Return-Path: <linux-kernel-owner+w=401wt.eu-S935504AbXGXJKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935504AbXGXJKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934575AbXGXJKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:10:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46394 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934266AbXGXJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:10:29 -0400
Date: Tue, 24 Jul 2007 02:09:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH]: allow individual core dump methods to be unlimited
 when sending to a pipe
Message-Id: <20070724020939.7644f18c.akpm@linux-foundation.org>
In-Reply-To: <20070722153947.GA11941@hmsreliant.homelinux.net>
References: <20070722153947.GA11941@hmsreliant.homelinux.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 11:39:47 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:

> 	This is a follow on to the patch entitled:
> update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
> It allows individual core dump methods to have the core dump size limit passed
> into them.  Its more efficient than each method having to retrieve it on their
> own, and it allows for do_coredump to specify a infinite limit in the event that
> a pipe is configured in /proc/sys/kernel/core_pattern, in which case ulimit -c
> should not apply.

Needed this warning fix:

fs/exec.c: In function 'do_coredump':
fs/exec.c:1761: warning: large integer implicitly truncated to unsigned type

diff -puN fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix fs/exec.c
--- a/fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix
+++ a/fs/exec.c
@@ -1703,7 +1703,7 @@ int do_coredump(long signr, int exit_cod
 	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
-	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 
 	audit_core_dumps(signr);
 
_

which makes me worry about how much care was taken here on 32/64 issues,
and crsos-arch issues (the underlying type for compat_ulong_t, for one).

Could you please go over it with a toothcomb, see if there are any other
slipups there?


Thanks.
