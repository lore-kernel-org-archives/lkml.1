Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYHRQPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYHRQPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYHRQPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:15:00 -0400
Received: from sacred.ru ([62.205.161.221]:57273 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYHRQPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:15:00 -0400
Message-ID: <48A99FF3.8090201@openvz.org>
Date: Mon, 18 Aug 2008 20:14:43 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] binfmt_misc: fix false -ENOEXEC when coupled with other binary
 handlers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 18 Aug 2008 20:14:42 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the binfmt_misc binary handler is registered *before* the
e.g. script one (when for example being compiled as a module) the
following situation may occur:

1. user launches a script, whose interpreter is a misc binary;
2. the load_misc_binary sets the misc_bang and returns -ENOEVEC,
   since the binary is a script;
3. the load_script_binary loads one and calls for search_binary_hander
   to run the interpreter;
4. the load_misc_binary is called again, but refuses to load the
   binary due to misc_bang bit set.

The fix is to move the misc_bang setting lower - prior to the actual
call to the search_binary_handler.

Caused by the commit 3a2e7f47 (binfmt_misc.c: avoid potential kernel 
stack overflow)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>

---

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 7562053..8d7e88e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -120,8 +120,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (bprm->misc_bang)
 		goto _ret;
 
-	bprm->misc_bang = 1;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -199,6 +197,8 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
 
+	bprm->misc_bang = 1;
+
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;
