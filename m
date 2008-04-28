Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbYD1HBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbYD1HBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763457AbYD1HBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:01:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763390AbYD1HBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:01:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
X-Fcc: ~/Mail/linus
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: mips ptrace compat build error
In-Reply-To: Adrian Bunk's message of  Wednesday, 23 April 2008 19:06:07 +0300 <20080423160607.GS28933@cs181133002.pp.htv.fi>
References: <20080423160607.GS28933@cs181133002.pp.htv.fi>
X-Shopping-List: (1) Spastic admonition pronunciations
   (2) No-Action stones
   (3) Despotic condiments
   (4) Prototypical dependent commanders
Message-Id: <20080428070135.3B92026F8F0@magilla.localdomain>
Date: Mon, 28 Apr 2008 00:01:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay; I was out sick last week.

I thought I'd checked for other arch's that would be affected, but I think
I may only have noticed those that actually use compat_ptrace_request.
Every CONFIG_COMPAT arch ought to clean up to use compat_ptrace_request
anyway, replacing calls to ptrace_request or their own implementations of
things like PTRACE_GETEVENTMSG that compat_ptrace_request takes care of.

I'm not in a position to test mips, but this patch is probably what you
need to restore the build.  I'd recommend that you follow this up with a
cleanup patch to use compat_ptrace_request, and another to replace
sys32_ptrace with compat_arch_ptrace and set __ARCH_WANT_COMPAT_SYS_PTRACE.


Thanks,
Roland


diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 572c610..99372f7 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -775,14 +775,25 @@ asmlinkage int sys32_rt_sigpending(compat_sigset_t __user *uset,
 	return ret;
 }
 
+int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
+{
+	memset(to, 0, sizeof *to);
+
+	if (copy_from_user(to, from, 3*sizeof(int)) ||
+	    copy_from_user(to->_sifields._pad,
+			   from->_sifields._pad, SI_PAD_SIZE))
+		return -EFAULT;
+
+	return 0;
+}
+
 asmlinkage int sys32_rt_sigqueueinfo(int pid, int sig, compat_siginfo_t __user *uinfo)
 {
 	siginfo_t info;
 	int ret;
 	mm_segment_t old_fs = get_fs();
 
-	if (copy_from_user(&info, uinfo, 3*sizeof(int)) ||
-	    copy_from_user(info._sifields._pad, uinfo->_sifields._pad, SI_PAD_SIZE))
+	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
 	set_fs(KERNEL_DS);
 	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *)&info);
