Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbYDQB2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbYDQB2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbYDQBJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:33 -0400
Received: from sous-sol.org ([216.99.217.87]:59004 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761403AbYDQBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:31 -0400
Message-Id: <20080417010357.765373351@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Davide Libenzi <davidel@xmailserver.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: signalfd: fix for incorrect SI_QUEUE user data reporting
Content-Disposition: inline; filename=signalfd-fix-for-incorrect-si_queue-user-data-reporting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Davide Libenzi <davidel@xmailserver.org>

upstream commit: 0859ab59a8a48d2a96b9d2b7100889bcb6bb5818

Michael Kerrisk found out that signalfd was not reporting back user data
pushed using sigqueue:

  http://groups.google.com/group/linux.kernel/msg/9397cab8551e3123

The following patch makes signalfd report back the ssi_ptr and ssi_int members
of the signalfd_siginfo structure.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Acked-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/signalfd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -110,9 +110,14 @@ static int signalfd_copyinfo(struct sign
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
 		break;
-	default: /* this is just in case for now ... */
+	default:
+		/*
+		 * This case catches also the signals queued by sigqueue().
+		 */
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
+		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
+		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
 	}
 

-- 
