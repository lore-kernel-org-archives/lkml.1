Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXJ3WRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXJ3WRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXJ3WRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:17:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:56069 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbXJ3WRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:17:32 -0400
Message-ID: <4727AE44.10902@suse.com>
Date: Tue, 30 Oct 2007 18:20:52 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] mmap: restore -ENODEV on missing f_op->mmap
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit 80c5606c3b45e0176c32d3108ade1e1cb0b954f3 from Linus moved the
 VM_MAYEXEC code further down, but in the process broke the mmap_23_1
 test from the LTP suite. 

 Moving it down means that the test for FMODE_READ ends up above
 the test for f_op->mmap. If the write side of the pipe is called for
 mmap(), we end up returning -EACCES rather than -ENODEV. Was this
 an intended change of behavior? Unless there's a global error precedence
 in SuS that I missed, I think both error codes could be valid here,
 but it is a difference in behavior. Do any spec gurus know for certain?

 Personally, I think this is probably a case of LTP codifying existing
 behavior rather than testing the for the specification. If that's the case
 and nobody really cares about the change in behavior, I'm fine letting this
 drop.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 mm/mmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mmap.c	2007-10-12 20:43:48.000000000 -0400
+++ b/mm/mmap.c	2007-10-23 15:44:45.000000000 -0400
@@ -900,6 +900,9 @@
 	int accountable = 1;
 	unsigned long reqprot = prot;
 
+	if (file && (!file->f_op || !file->f_op->mmap))
+		return -ENODEV;
+
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
 	 *
@@ -997,8 +1000,6 @@
 			if (is_file_hugepages(file))
 				accountable = 0;
 
-			if (!file->f_op || !file->f_op->mmap)
-				return -ENODEV;
 			break;
 
 		default:

-- 
Jeff Mahoney
SUSE Labs
