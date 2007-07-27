Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXG0UQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXG0UQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965145AbXG0UOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:14:36 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4989 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbXG0UOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:14:34 -0400
Date: Fri, 27 Jul 2007 16:13:57 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Cc: nhorman@tuxdriver.com
Subject: [PATCH 3/3] core_pattern: fix up a few miscelaneous bugs
Message-ID: <20070727201357.GD18946@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey
	This patch fixes up a few bugs I found while testing my other work.
Specifically:

1) Fixes call_usermodehelper_pipe to not wait for program exit on the user mode
helper process.  Since this context fill the pipe.  The user mode helper, if it
reads stdin, will block waiting for the pipe to have data on it, and we will
wait forever for the usermodehelper to exit.  Changed this to wait only for a
successful exec.

2) Fixes do_coredump to detect a crash in the user mode helper process and abort
the attempt  to recursively dump core to another copy of the helper process,
potentially ad-infinitum.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 fs/exec.c     |   14 +++++++++++++-
 kernel/kmod.c |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/exec.c b/fs/exec.c
index 6855a52..1398d07 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1791,12 +1791,24 @@
 		goto fail_unlock;
 
  	if (ispipe) {
-		core_limit = RLIM_INFINITY;
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
 		if (delimit)
 			*delimit = '\0';
+		delimit = strrchr(helper_argv[0], '/');
+		if (delimit) 
+			delimit++;
+		else
+			delimit = helper_argv[0];
+		if (!strcmp(delimit, current->comm))
+		{	
+			printk(KERN_NOTICE "Recursive core dump detected, Aborting\n");
+			goto fail_unlock;
+		}
+
+		core_limit = RLIM_INFINITY;
+
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9809cc1..c6a4f8a 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -505,7 +505,7 @@
 	if (ret < 0)
 		goto out;
 
-	return call_usermodehelper_exec(sub_info, 1);
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
