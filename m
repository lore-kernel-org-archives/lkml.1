Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXBAE2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXBAE2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161167AbXBAE2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:28:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35682 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161173AbXBAE2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:28:14 -0500
Date: Wed, 31 Jan 2007 22:28:11 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Message-ID: <20070201042811.GA17176@sergelap.austin.ibm.com>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pekka J Enberg (penberg@cs.helsinki.fi):
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revokeat(2) and frevoke(2) system calls invalidate open file
> descriptors and shared mappings of an inode. After an successful
> revocation, operations on file descriptors fail with the EBADF or
> ENXIO error code for regular and device files,
> respectively. Attempting to read from or write to a revoked mapping
> causes SIGBUS.
> 
> The actual operation is done in two passes:
> 
>  1. Revoke all file descriptors that point to the given inode. We do
>     this under tasklist_lock so that after this pass, we don't need
>     to worry about racing with close(2) or dup(2).
> 
>  2. Take down shared memory mappings of each revoked file and close
>     the file pointer.
> 
> The file descriptors are kept until the owning task does close(2) and
> memory mapping ranges preserved until the owning task does munmap(2).

With the attached patch, this passes all your revoke tests on s390,
as well as ltp runalltests.sh.

thanks,
-serge

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] revoke: do s390 syscalls

revoke: do s390 syscalls

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
(cherry picked from 9962b52d7bd7b70b99e7515d30b8217b0de491b3 commit)

---

 arch/s390/kernel/compat_wrapper.S |   11 +++++++++++
 arch/s390/kernel/syscalls.S       |    2 ++
 include/asm-s390/unistd.h         |    4 +++-
 3 files changed, 16 insertions(+), 1 deletions(-)

3f0afa7b9a6b8c9ec930bdef73601f7260c79f47
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 71e54ef..b5c2bfa 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1665,3 +1665,14 @@ sys_getcpu_wrapper:
 	llgtr	%r3,%r3			# unsigned *
 	llgtr	%r4,%r4			# struct getcpu_cache *
 	jg	sys_getcpu
+
+	.globl sys_revokeat_wrapper
+sys_revokeat_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# const char *
+	jg	sys_revokeat
+
+	.globl sys_frevoke_wrapper
+sys_frevoke_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	jg	sys_frevoke
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index a4ceae3..85a6673 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -321,3 +321,5 @@ SYSCALL(sys_vmsplice,sys_vmsplice,compat
 NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,sys_ni_syscall)
+SYSCALL(sys_revokeat,sys_revokeat,sys_revokeat_wrapper)
+SYSCALL(sys_frevoke,sys_frevoke,sys_frevoke_wrapper)
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index fb6fef9..6651cb1 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -250,8 +250,10 @@
 /* Number 310 is reserved for new sys_move_pages */
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
+#define __NR_revokeat		313
+#define __NR_frevoke		314
 
-#define NR_syscalls 313
+#define NR_syscalls 315
 
 /* 
  * There are some system calls that are not present on 64 bit, some
-- 
1.1.6
