Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZIGVEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZIGVEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZIGVEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:04:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbZIGVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:04:08 -0400
Date: Mon, 7 Sep 2009 14:03:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 3/8] Simplify exec_permission_lite() further
In-Reply-To: <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 10:53:56 -0700

This function is only called for path components that are already known
to be directories (they have a '->lookup' method).  So don't bother
doing that whole S_ISDIR() testing, the whole point of the 'lite()'
version is that we know that we are looking at a directory component,
and that we're only checking name lookup permission.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/namei.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bf8aa95..e39e5cb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -445,13 +445,7 @@ static int exec_permission_lite(struct inode *inode)
 	if (mode & MAY_EXEC)
 		goto ok;
 
-	if ((inode->i_mode & S_IXUGO) && capable(CAP_DAC_OVERRIDE))
-		goto ok;
-
-	if (S_ISDIR(inode->i_mode) && capable(CAP_DAC_OVERRIDE))
-		goto ok;
-
-	if (S_ISDIR(inode->i_mode) && capable(CAP_DAC_READ_SEARCH))
+	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
 		goto ok;
 
 	return -EACCES;
-- 
1.6.4.1.209.g74b8

