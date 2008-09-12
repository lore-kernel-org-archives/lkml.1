Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYILWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYILWMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYILWMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:12:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYILWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:12:03 -0400
Date: Fri, 12 Sep 2008 15:11:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] utsname: completely overwrite prior information
Message-Id: <20080912151129.1c8d38f8.akpm@linux-foundation.org>
In-Reply-To: <20080912203624.GA25965@damson.getinternet.no>
References: <20080912203624.GA25965@damson.getinternet.no>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 22:36:24 +0200
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From 25c69de4760e20cf7562cf92a55b65a71546093e Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 11 Sep 2008 19:59:50 +0200
> Subject: [PATCH] utsname: completely overwrite prior information
> 
> On sethostname() and setdomainname(), previous information may be
> retained if it was longer than than the new hostname/domainname.
> 
> This can be demonstrated trivially by calling sethostname() first
> with a long name, then with a short name, and then calling uname()
> to retrieve the full buffer that contains the hostname (and
> possibly parts of the old hostname), one just has to look past the
> terminating zero.
> 
> I don't know if we should really care that much (hence the RFC);
> the only scenarios I can possibly think of is administrator
> putting something sensitive in the hostname (or domain name) by
> accident, and changing it back will not undo the mistake entirely,
> though it's not like we can recover gracefully from "rm -rf /"
> either... The other scenario is namespaces (CLONE_NEWUTS) where
> some information may be unintentionally "inherited" from the
> previous namespace (a program wants to hide the original name and
> does clone + sethostname, but some information is still left).
> 
> I think the patch may be defended on grounds of the principle of
> least surprise. But I am not adamant :-)
> 
> (I guess the question now is whether userspace should be able to
> write embedded NULs into the buffer or not...)
> 
> At least the observation has been made and the patch has been
> presented.
> 

fair enuf.  Did you check allthe other fields in 'struct new_utsname'?

> index 038a7bc..78b4515 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1352,7 +1352,8 @@ asmlinkage long sys_sethostname(char __user *name, int len)
>  	errno = -EFAULT;
>  	if (!copy_from_user(tmp, name, len)) {
>  		memcpy(utsname()->nodename, tmp, len);
> -		utsname()->nodename[len] = 0;
> +		memset(utsname()->nodename + len, 0,
> +			sizeof(utsname()->nodename) - len);

We could do the memset before the memcpy.  It's more work, but less
text.  Whatever.


While we're there, the code generation in there is a bit sloppy.  How's
this look?


From: Andrew Morton <akpm@linux-foundation.org>

utsname() is quite expensive to calculate.  Cache it in a local.

          text    data     bss     dec     hex filename
before:  11136     720      16   11872    2e60 kernel/sys.o
after:   11096     720      16   11832    2e38 kernel/sys.o

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-improve-code-generation kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-improve-code-generation
+++ a/kernel/sys.c
@@ -1415,9 +1415,10 @@ asmlinkage long sys_sethostname(char __u
 	down_write(&uts_sem);
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
-		memcpy(utsname()->nodename, tmp, len);
-		memset(utsname()->nodename + len, 0,
-			sizeof(utsname()->nodename) - len);
+		struct new_utsname *u = utsname();
+
+		memcpy(u->nodename, tmp, len);
+		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
@@ -1429,15 +1430,17 @@ asmlinkage long sys_sethostname(char __u
 asmlinkage long sys_gethostname(char __user *name, int len)
 {
 	int i, errno;
+	struct new_utsname *u;
 
 	if (len < 0)
 		return -EINVAL;
 	down_read(&uts_sem);
-	i = 1 + strlen(utsname()->nodename);
+	u = utsname();
+	i = 1 + strlen(u->nodename);
 	if (i > len)
 		i = len;
 	errno = 0;
-	if (copy_to_user(name, utsname()->nodename, i))
+	if (copy_to_user(name, u->nodename, i))
 		errno = -EFAULT;
 	up_read(&uts_sem);
 	return errno;
@@ -1462,9 +1465,10 @@ asmlinkage long sys_setdomainname(char _
 	down_write(&uts_sem);
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
-		memcpy(utsname()->domainname, tmp, len);
-		memset(utsname()->domainname + len, 0,
-			sizeof(utsname()->domainname) - len);
+		struct new_utsname *u = utsname();
+
+		memcpy(u->domainname, tmp, len);
+		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
_

