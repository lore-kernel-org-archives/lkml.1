Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbXK0Ruw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbXK0Ruw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXK0Rup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:50:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59171 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbXK0Ruo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:50:44 -0500
Date: Tue, 27 Nov 2007 20:50:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] do_wait-fix-security-checks-fix
Message-ID: <20071127175053.GA9569@tv-sign.ru>
References: <20071124153323.GA6696@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071124153323.GA6696@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Oleg Nesterov wrote:
>
> -		if (!flag) {
> +		if (flag)
> +			continue;

This "last obvious cleanup right before sending the patch" is terribly wrong,
we can't continue, we must advance the tsk to the next_thread().

Please apply.

--- PT/kernel/exit.c~SEC_FIX	2007-11-26 17:10:41.000000000 +0300
+++ PT/kernel/exit.c	2007-11-27 20:41:10.000000000 +0300
@@ -1527,16 +1527,17 @@ repeat:
 			if (retval != 0) /* tasklist_lock released */
 				goto end;
 		}
-		if (flag)
-			continue;
-		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
-			flag = eligible_child(pid, options, p);
-			if (!flag)
-				continue;
-			if (likely(flag > 0))
-				break;
-			retval = flag;
-			goto end;
+		if (!flag) {
+			list_for_each_entry(p, &tsk->ptrace_children,
+								ptrace_list) {
+				flag = eligible_child(pid, options, p);
+				if (!flag)
+					continue;
+				if (likely(flag > 0))
+					break;
+				retval = flag;
+				goto end;
+			}
 		}
 		if (options & __WNOTHREAD)
 			break;

