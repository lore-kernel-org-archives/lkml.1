Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZIWGTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZIWGTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZIWGTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZIWGTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:19:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] x86: clean up orig_ax handling
In-Reply-To: Roland McGrath's message of  Tuesday, 22 September 2009 19:40:49 -0700 <20090923024049.AA85913F37@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
	<20090923024049.AA85913F37@magilla.sf.frob.com>
X-Shopping-List: (1) Grandiloquent squeeze axes
   (2) Prosthetic melons
   (3) Tyrannical destroyer toothpicks
   (4) Autonomous warriors
Message-Id: <20090923061834.BE13A22@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 23:18:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the aforementioned other tack on this.  

I said earlier that getreg() (i.e. 64-bit ptrace/core-dump fetches)
should sign-extend the low 32 bits of orig_ax up.  But I've changed my
mind.  It's true that today you can store 0xffffffff via either 64-bit
ptrace or 32-bit ptrace and then read back -1 via 64-bit ptrace.  (This
wasn't always so, and so we can hope that no debugger really depends on
it.)  What seems more important is that tracing and core dumps correctly
show the full orig_ax value incoming in %rax from userland, since
%rax=__NR_foo|(1UL<<32) behaves differently (i.e. -ENOSYS) than
%eax=_NR_foo in actual fact when user-mode does "syscall" with those
values.  In a bogon case like that, you would like to have traces/dumps
tell you why the task is not making a proper syscall rather than lie
about what register bits it entered the kernel with.

Patches 1-3 change no ptrace-tests outcomes, i.e. don't regress on the
test cases that went with the original sign-extension changes.  They
reintroduce e.g. the ability to blindly read and write back the whole
regset when at syscall-entry tracing with %rax=__NR_foo|(1UL<<32) and
have that fail with -ENOSYS as it would without tracing rather than
perturb the tracee to call sys_foo instead.  (Not that this is useful.)

Patch 4 does Linus's fix for the outstanding bug.  I've verified it works.


Thanks,
Roland
---
The following changes since commit 7fa07729e439a6184bd824746d06a49cca553f15:
  Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/orig_ax

Roland McGrath (4):
      asm-generic: syscall_get_nr returns int
      x86: syscall_get_nr returns int
      x86: ptrace: do not sign-extend orig_ax on write
      x86: ptrace: set TS_COMPAT when 32-bit ptrace sets orig_eax>=0

 arch/x86/include/asm/syscall.h |   14 +++++++-------
 arch/x86/kernel/ptrace.c       |   21 ++++++++-------------
 include/asm-generic/syscall.h  |    8 ++++++--
 3 files changed, 21 insertions(+), 22 deletions(-)
