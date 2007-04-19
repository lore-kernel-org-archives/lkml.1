Return-Path: <linux-kernel-owner+w=401wt.eu-S1422821AbXDSX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbXDSX4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423004AbXDSXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:55:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:36621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821AbXDSXyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:53 -0400
Message-Id: <20070419234704.241168916@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:07 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu> <20070419232303.300441585@schurl.suse.de>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 4/7] Make getcwd() only return valid paths
Content-Disposition: inline; filename=fix-getcwd.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make getcwd() fail with -ENOENT if the current working directory is
disconnected: the process is not asking for some previous name of that
directory but for the current name; returning a path meaningless in the
context of that process makes no sense.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/dcache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1910,10 +1910,12 @@ asmlinkage long sys_getcwd(char __user *
 	read_unlock(&current->fs->lock);
 
 	cwd = __d_path(pwd, pwdmnt, root, rootmnt, page, PAGE_SIZE, 1);
-	cwd = __connect_d_path(cwd, page);
 	error = PTR_ERR(cwd);
 	if (IS_ERR(cwd))
 		goto out;
+	error = -ENOENT;
+	if (*cwd != '/')
+		goto out;
 
 	error = -ERANGE;
 	len = PAGE_SIZE + page - cwd;

-- 
Andreas Gruenbacher <agruen@suse.de>
SUSE Labs, SUSE LINUX Products GmbH
GF: Markus Rex, HRB 16746 (AG Nuernberg)

GPG: AF77 FAD1 1819 D442 400F  4BC8 409A 6903 4FDD EE02

