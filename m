Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZLRRDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZLRRDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZLRRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:03:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZLRRDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:03:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH BUGFIX] kmod: Fix resource leak in call_usermodehelper_pipe()
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Dec 2009 12:07:00 -0500
Message-ID: <20091218170700.18940.97922.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix resource (write-pipe file) leak in call_usermodehelper_pipe().

When call_usermodehelper_exec() is failed, write-pipe file is opened
and call_usermodehelper_pipe() just returns an error. Since it is
hard for caller to classify the error is occured when opening pipe
or executing helper, caller can't close the pipe by themselves.

I've found this resoruce leak when testing coredump.
You can check how the resource leaks as below;

$ echo "|nocommand" > /proc/sys/kernel/core_pattern
$ ulimit -c unlimited
$ while [ 1 ]; do ./segv; done &> /dev/null &
$ cat /proc/meminfo (<- repeat it)

where segv.c is;
//-----
int main () {
        char *p = 0;
        *p = 1;
}
//-----

This patch closes write-pipe file if call_usermodehelper_exec()
is failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 25b1031..bf0e231 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -520,13 +520,15 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 		return -ENOMEM;
 
 	ret = call_usermodehelper_stdinpipe(sub_info, filp);
-	if (ret < 0)
-		goto out;
+	if (ret < 0) {
+		call_usermodehelper_freeinfo(sub_info);
+		return ret;
+	}
 
-	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+	if (ret < 0)	/* Failed to execute helper, close pipe */
+		filp_close(*filp, NULL);
 
-  out:
-	call_usermodehelper_freeinfo(sub_info);
 	return ret;
 }
 EXPORT_SYMBOL(call_usermodehelper_pipe);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
