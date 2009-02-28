Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbZB1DI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbZB1DI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZB1DIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:08:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZB1DIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:08:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/2] x86-64: 32/64 syscall arch holes
Message-Id: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 19:02:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, a 32-bit process (TIF_IA32) can switch to 64-bit mode with
ljmp, and then use the "syscall" instruction to make a 64-bit system
call.  A 64-bit process make a 32-bit system call with int $0x80.

Both these uses can confuse some things that think they know what system
call and arguments the registers mean.  This is easily fixed by checking
TS_COMPAT ("syscall we are in is 32-bit") instead of TIF_IA32 ("this task
was started as 32-bit").

I don't know of any other arch that is susceptible to a similar problem.
I think on other 32/64 arch's either the syscall table is the same anyway,
or it's not possible to make an other-wordsize flavored syscall at all,
or both.

It occurred to me that the audit case was wrong, but I didn't try to test
it.  A test program similar to the seccomp exploit would be the way to do
it (but omit the prctl call) and there are many more options of a syscall
number whose presumed-arch meaning is harmless and not noticed by your
audit setup, but whose actually-other-arch meaning is something that could
be malicious and that your audit setup intends to flag.

The following changes since commit 778ef1e6cbb049c9bcbf405936ee6f2b6e451892:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/syscall-arch-holes

Roland McGrath (2):
      x86-64: syscall-audit: fix 32/64 syscall hole
      x86-64: seccomp: fix 32/64 syscall hole

 arch/x86/include/asm/seccomp_64.h |   14 ++++++++------
 arch/x86/kernel/ptrace.c          |    2 +-
 kernel/seccomp.c                  |   11 ++++++++---
 3 files changed, 17 insertions(+), 10 deletions(-)

Thanks,
Roland
