Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbYGVX2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbYGVX2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYGVXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbYGVXUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:00 -0400
Date: Tue, 22 Jul 2008 16:16:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 30/47] exec: fix stack excutability without PT_GNU_STACK
Message-ID: <20080722231635.GE8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="exec-fix-stack-excutability-without-pt_gnu_stack.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Hugh Dickins <hugh@veritas.com>

commit 96a8e13ed44e380fc2bb6c711d74d5ba698c00b2 upstream

Kernel Bugzilla #11063 points out that on some architectures (e.g. x86_32)
exec'ing an ELF without a PT_GNU_STACK program header should default to an
executable stack; but this got broken by the unlimited argv feature because
stack vma is now created before the right personality has been established:
so breaking old binaries using nested function trampolines.

Therefore re-evaluate VM_STACK_FLAGS in setup_arg_pages, where stack
vm_flags used to be set, before the mprotect_fixup.  Checking through
our existing VM_flags, none would have changed since insert_vm_struct:
so this seems safer than finding a way through the personality labyrinth.

Reported-by: pageexec@freemail.hu
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -605,7 +605,7 @@ int setup_arg_pages(struct linux_binprm 
 	bprm->exec -= stack_shift;
 
 	down_write(&mm->mmap_sem);
-	vm_flags = vma->vm_flags;
+	vm_flags = VM_STACK_FLAGS;
 
 	/*
 	 * Adjust stack execute permissions; explicitly enable for

-- 
