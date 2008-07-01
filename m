Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYGAKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYGAKLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYGAKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:11:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbYGAKLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:11:32 -0400
Date: Tue, 1 Jul 2008 12:11:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
Message-ID: <20080701101104.GF31309@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com> <20080630210241.93738154077@magilla.localdomain> <20080701090204.GA1729@elte.hu> <20080701093212.6D9DA15420E@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701093212.6D9DA15420E@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > since the original fix is already upstream, i've applied the delta 
> > patch below. Should we still do this for v2.6.26 or can we defer it 
> > to v2.6.27? As ptrace is the only user of this facility for now this 
> > would be an identity transformation AFAICS and the v2.6.26 release 
> > is very close.
> 
> I don't think there's a problem with 2.6.26 either way.  I agree that 
> the user_regset internal API does not matter much before 2.6.27.

okay - i've queued it up in tip/x86/ptrace for now.

> My patch alone applies to 2.6.25, which is why I CC'd it to stable. I 
> think applying that (and not takada's patch) to stable-2.6.25 would be 
> best.

i think Greg already queued the original fix up for v2.6.25, as per the 
commit notifier below.

so i think it is all sorted fine now?

	Ingo

---------------------->
This is a note to let you know that we have just queued up the patch titled

     Subject: ptrace GET/SET FPXREGS broken

to the 2.6.25-stable tree.  Its filename is

     ptrace-get-set-fpxregs-broken.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Mon Jun 30 09:22:46 2008
From: TAKADA Yoshihito <takada@mbf.nifty.com>
Date: Mon, 30 Jun 2008 18:22:07 +0200
Subject: ptrace GET/SET FPXREGS broken
To: stable@kernel.org
Message-ID: <20080630162207.GC17710@elte.hu>
Content-Disposition: inline

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


Patches currently in stable-queue which might be from takada@mbf.nifty.com are

queue-2.6.25/ptrace-get-set-fpxregs-broken.patch
