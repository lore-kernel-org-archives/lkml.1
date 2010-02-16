Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0BPODc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:03:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab0BPODa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:03:30 -0500
Date: Tue, 16 Feb 2010 15:02:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
Message-ID: <20100216140242.GC16448@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216140126.GA16448@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_personality_ia32() sets TS_COMPAT for unknown reason.

This doesn't hurt but this is unneeded and confusing, TS_COMPAT
means we are inside the 32bit syscall.

In fact I'd say this is not right, but fortunetely do_execve() can
never return something which could confuse syscall_get_error().
And apart from do_signal() we never check TS_COMPAT during return
to user-mode.

Another reason why I think this is not right. I am not sure I fully
understand this asm, but it seems to me that system_call_fastpath
can "leak" TS_COMPAT. While probably this doesn't really matter, we
can return to user-mode with this bit set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/process_64.c |    3 ---
 1 file changed, 3 deletions(-)

--- exec/arch/x86/kernel/process_64.c~2_dont_set_compat	2010-02-16 13:26:34.000000000 +0100
+++ exec/arch/x86/kernel/process_64.c	2010-02-16 13:46:25.000000000 +0100
@@ -528,9 +528,6 @@ void set_personality_ia32(void)
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
 	current->personality |= force_personality32;
-
-	/* Prepare the first "return" to user space */
-	current_thread_info()->status |= TS_COMPAT;
 }
 
 unsigned long get_wchan(struct task_struct *p)

