Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYF3Ep1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYF3Ep1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYF3EpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:45:17 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:54634 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750878AbYF3EpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:45:16 -0400
X-Nifty-SrcIP: [61.124.20.110]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=Tnt2tLb7FTj+u4hl97A1O8/RYDtCZo3OxZidVhKWUi2xJNhrHjNe0f69WQyxCSlk7myg3OCj+H3SkO3r54+odg==  ;
Date: Mon, 30 Jun 2008 13:44:45 +0900 (JST)
Message-Id: <20080630.134445.193700135.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace GET/SET FPXREGS broken
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Jun_30_13_44_45_2008_097)--"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Mon_Jun_30_13_44_45_2008_097)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi
When I update kernel 2.6.25 from 2.6.24, gdb does not work.
On 2.6.25, ptrace(PTRACE_GETFPXREGS, ...) returns ENODEV.
But 2.6.24 kernel's ptrace() returns EIO.
It is issue of compatibility.
I attached test program as pt.c and patch for fix it.

----Next_Part(Mon_Jun_30_13_44_45_2008_097)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="pt.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <sys/ptrace.h>
#include <sys/types.h>


struct user_fxsr_struct {
	unsigned short	cwd;
	unsigned short	swd;
	unsigned short	twd;
	unsigned short	fop;
	long	fip;
	long	fcs;
	long	foo;
	long	fos;
	long	mxcsr;
	long	reserved;
	long	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
	long	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
	long	padding[56];
};

int main(void)
{
  pid_t pid;

  pid = fork();

  switch(pid){
  case -1:/*  error */
    break;
  case 0:/*  child */
    child();
    break;
  default:
    parent(pid);
    break;
  }
  return 0;
}

int child(void)
{
  ptrace(PTRACE_TRACEME);
  kill(getpid(), SIGSTOP);
  sleep(10);
  return 0;
}
int parent(pid_t pid)
{
  int ret;
  struct user_fxsr_struct fpxregs;

  ret = ptrace(PTRACE_GETFPXREGS, pid, 0, &fpxregs);
  if(ret < 0){
    printf("%d: %s.\n", errno, strerror(errno));
  }
  kill(pid, SIGCONT);
  wait(pid);
  return 0;
}

/* in the kerel, at kernel/i387.c get_fpxregs() */

----Next_Part(Mon_Jun_30_13_44_45_2008_097)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fxsr.patch"

--- a/arch/x86/kernel/i387.c	2008-04-17 11:49:44.000000000 +0900
+++ b/arch/x86/kernel/i387.c	2008-06-30 13:22:57.000000000 +0900
@@ -130,7 +130,7 @@
 		void *kbuf, void __user *ubuf)
 {
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	init_fpu(target);
 
@@ -145,7 +145,7 @@
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	init_fpu(target);
 	set_stopped_child_used_math(target);

----Next_Part(Mon_Jun_30_13_44_45_2008_097)----
