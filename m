Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZD2QGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZD2QGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZD2QGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:06:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZD2QGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:06:00 -0400
Date: Wed, 29 Apr 2009 18:01:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] do_wait: do take security_task_wait() into account
Message-ID: <20090429160123.GA4591@redhat.com>
References: <20090428223025.GA11997@redhat.com> <20090428233305.GA14221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428233305.GA14221@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was never able to understand what should we actually do when
security_task_wait() fails, but the current code doesn't look right.

If ->task_wait() returns the error, we update *notask_error correctly.
But then we either reap the child (despite the fact this was forbidden)
or clear *notask_error (and hide the securiy policy problems).

This patch assumes that "stolen by ptrace" doesn't matter. If selinux
denies the child we should ignore it but make sure we report -EACCESS
instead of -ECHLD if there are no other eligible children.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~WAIT_SECURITY	2009-04-29 12:46:15.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-04-29 16:19:40.000000000 +0200
@@ -1476,6 +1476,7 @@ static int wait_consider_task(struct tas
 		 */
 		if (*notask_error)
 			*notask_error = ret;
+		return 0;
 	}
 
 	if (likely(!ptrace) && unlikely(task_ptrace(p))) {

