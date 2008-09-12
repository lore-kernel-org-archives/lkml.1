Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYILUgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYILUgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYILUg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:36:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:33185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYILUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ADwql7JQ1vypkHSlT5QJZEEroseAlxNe+S2kmSWpg48yCm4VYG9zWNvrEivSwJFZ76
         EV/NQEuYP2VZ5j0lYBQl7PZlKNNuM77vo0e27NcdTmMnUjvq7U+N43gNoqDCR/tkd946
         98IQv7rwqSFQ8hbNm48jDYqNLHMNxpYIiSwI8=
Date: Fri, 12 Sep 2008 22:36:24 +0200
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH] utsname: completely overwrite prior information
Message-ID: <20080912203624.GA25965@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 25c69de4760e20cf7562cf92a55b65a71546093e Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 11 Sep 2008 19:59:50 +0200
Subject: [PATCH] utsname: completely overwrite prior information

On sethostname() and setdomainname(), previous information may be
retained if it was longer than than the new hostname/domainname.

This can be demonstrated trivially by calling sethostname() first
with a long name, then with a short name, and then calling uname()
to retrieve the full buffer that contains the hostname (and
possibly parts of the old hostname), one just has to look past the
terminating zero.

I don't know if we should really care that much (hence the RFC);
the only scenarios I can possibly think of is administrator
putting something sensitive in the hostname (or domain name) by
accident, and changing it back will not undo the mistake entirely,
though it's not like we can recover gracefully from "rm -rf /"
either... The other scenario is namespaces (CLONE_NEWUTS) where
some information may be unintentionally "inherited" from the
previous namespace (a program wants to hide the original name and
does clone + sethostname, but some information is still left).

I think the patch may be defended on grounds of the principle of
least surprise. But I am not adamant :-)

(I guess the question now is whether userspace should be able to
write embedded NULs into the buffer or not...)

At least the observation has been made and the patch has been
presented.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/sys.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..78b4515 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1352,7 +1352,8 @@ asmlinkage long sys_sethostname(char __user *name, int len)
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		memcpy(utsname()->nodename, tmp, len);
-		utsname()->nodename[len] = 0;
+		memset(utsname()->nodename + len, 0,
+			sizeof(utsname()->nodename) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
@@ -1398,7 +1399,8 @@ asmlinkage long sys_setdomainname(char __user *name, int len)
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		memcpy(utsname()->domainname, tmp, len);
-		utsname()->domainname[len] = 0;
+		memset(utsname()->domainname + len, 0,
+			sizeof(utsname()->domainname) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
-- 
1.5.5.1

