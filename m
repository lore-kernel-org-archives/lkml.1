Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbZAOUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbZAOUWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbZAOUBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:10 -0500
Received: from kroah.org ([198.145.64.141]:49127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765931AbZAOUAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:51 -0500
Date: Thu, 15 Jan 2009 11:58:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 36/94] [PATCH 05/44] [CVE-2009-0029] Make sys_pselect7
	static
Message-ID: <20090115195835.GJ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005--CVE-2009-0029-Make-sys_pselect7-static.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit c9da9f2129d6a421c32e334a83770a9e67f7feac upstream.

Not a single architecture has wired up sys_pselect7 plus it is the
only system call with seven parameters. Just make it static and
rename it to do_pselect which will do the work for sys_pselect6.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/compat.c |    6 +++---
 fs/select.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1697,7 +1697,7 @@ asmlinkage long compat_sys_select(int n,
 }
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
+static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 	struct compat_timespec __user *tsp, compat_sigset_t __user *sigmask,
 	compat_size_t sigsetsize)
@@ -1763,8 +1763,8 @@ asmlinkage long compat_sys_pselect6(int 
 				(compat_size_t __user *)(sig+sizeof(up))))
 			return -EFAULT;
 	}
-	return compat_sys_pselect7(n, inp, outp, exp, tsp, compat_ptr(up),
-					sigsetsize);
+	return do_compat_pselect(n, inp, outp, exp, tsp, compat_ptr(up),
+				 sigsetsize);
 }
 
 asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
--- a/fs/select.c
+++ b/fs/select.c
@@ -532,9 +532,9 @@ asmlinkage long sys_select(int n, fd_set
 }
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
-		fd_set __user *exp, struct timespec __user *tsp,
-		const sigset_t __user *sigmask, size_t sigsetsize)
+static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
+		       fd_set __user *exp, struct timespec __user *tsp,
+		       const sigset_t __user *sigmask, size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts, end_time, *to = NULL;
@@ -600,7 +600,7 @@ asmlinkage long sys_pselect6(int n, fd_s
 			return -EFAULT;
 	}
 
-	return sys_pselect7(n, inp, outp, exp, tsp, up, sigsetsize);
+	return do_pselect(n, inp, outp, exp, tsp, up, sigsetsize);
 }
 #endif /* HAVE_SET_RESTORE_SIGMASK */
 

