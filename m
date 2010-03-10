Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0CJSvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:51:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab0CJSu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:50:59 -0500
Date: Wed, 10 Mar 2010 19:44:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] call_usermodehelper: call info->init() after
	set_user_nice()
Message-ID: <20100310184439.GA3386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly cosmetic, but imho it makes sense to call sub_info->init() right
before kernel_execve(). This looks more natural and allows ->init() hook
to change the priority if needed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- mm/kernel/kmod.c~5_MOVE_INIT_DOWN	2010-03-10 17:36:37.000000000 +0100
+++ mm/kernel/kmod.c	2010-03-10 19:40:24.000000000 +0100
@@ -159,6 +159,11 @@ static int ____call_usermodehelper(void 
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/*
+	 * Our parent is keventd, which runs with elevated scheduling priority.
+	 * Avoid propagating that into the userspace child.
+	 */
+	set_user_nice(current, 0);
 
 	if (sub_info->init) {
 		retval = sub_info->init(sub_info);
@@ -166,14 +171,7 @@ static int ____call_usermodehelper(void 
 			goto fail;
 	}
 
-	/*
-	 * Our parent is keventd, which runs with elevated scheduling priority.
-	 * Avoid propagating that into the userspace child.
-	 */
-	set_user_nice(current, 0);
-
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
-
 	/* Exec failed? */
 fail:
 	sub_info->retval = retval;

