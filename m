Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYLZNU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYLZNU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYLZNUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:20:17 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54425 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYLZNUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:20:15 -0500
To: xiyou.wangcong@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Check return from argv_split() in do_coredump().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp>
	<20081226144548.GB3156@hack.private>
	<200812260700.mBQ70uH3009595@www262.sakura.ne.jp>
	<20081226150653.GD3156@hack.private>
In-Reply-To: <20081226150653.GD3156@hack.private>
Message-Id: <200812262220.FAE48915.OSLtOFJFVHOFQM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 26 Dec 2008 22:20:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Americo Wang wrote:
> fail_unlock:
>         if (helper_argv)
> 	                argv_free(helper_argv);
> 
>         current->fsuid = fsuid; //<=== goto this line
>         coredump_finish(mm);
> 
> You need to add a new label, of course. :)
> 
Ah, you were talking about destination of goto statement. I see.

Unfortunately, -mm source uses "revert_creds(old_cred); put_cred(cred);"
instead of "current->fsuid = fsuid;".
To keep this patch applicable to all afftected versions,
I'd like not to introduce a new label.

> if (helper_argv)
> 	                argv_free(helper_argv);
Well, I think it's better to check "if (helper_argv)" inside argv_free()
in case the caller forgets to check.

Regards.
--------------------
Subject: Check return from argv_split() in do_coredump().

do_coredump() accesses helper_argv[0] without checking helper_argv != NULL.
Though, likely helper_argv != NULL.

Below versions have this problem.

  2.6.24.7
  2.6.25.20
  2.6.26.8
  2.6.27.10
  2.6.28
  mmotm 2008-12-24-01-20

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28-rc9-mm1.orig/fs/exec.c
+++ linux-2.6.28-rc9-mm1/fs/exec.c
@@ -1808,6 +1808,8 @@ int do_coredump(long signr, int exit_cod
 
  	if (ispipe) {
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		if (!helper_argv)
+			goto fail_unlock;
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
 		if (delimit)
