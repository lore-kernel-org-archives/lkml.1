Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbYGAPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbYGAPYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbYGAPW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:58207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760392AbYGAPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:27 -0400
Date: Tue, 1 Jul 2008 08:19:16 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 7/9] ptrace GET/SET FPXREGS broken
Message-ID: <20080701151915.GH3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ptrace-get-set-fpxregs-broken.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: TAKADA Yoshihito <takada@mbf.nifty.com>

Commit 11dbc963a8f6128595d0f6ecf138dc369e144997 upstream

ptrace GET/SET FPXREGS broken

When I update kernel 2.6.25 from 2.6.24, gdb does not work.
On 2.6.25, ptrace(PTRACE_GETFPXREGS, ...) returns ENODEV.

But 2.6.24 kernel's ptrace() returns EIO.
It is issue of compatibility.

I attached test program as pt.c and patch for fix it.

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/i387.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -130,7 +130,7 @@ int xfpregs_get(struct task_struct *targ
 		void *kbuf, void __user *ubuf)
 {
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	init_fpu(target);
 
@@ -145,7 +145,7 @@ int xfpregs_set(struct task_struct *targ
 	int ret;
 
 	if (!cpu_has_fxsr)
-		return -ENODEV;
+		return -EIO;
 
 	init_fpu(target);
 	set_stopped_child_used_math(target);

-- 
