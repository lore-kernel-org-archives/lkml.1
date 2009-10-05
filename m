Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbZJEKYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbZJEKYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZJEKYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:24:34 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33814 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbZJEKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:24:33 -0400
Date: Mon, 5 Oct 2009 19:23:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86: hw-breakpoints: Actually flush thread breakpoints in flush_thread().
Message-ID: <20091005102306.GA7889@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	Alan Stern <stern@rowland.harvard.edu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I noticed this whilst hacking up SH support, applies to the current
  tracing/hw-breakpoints topic branch. ]

flush_thread() tries to do a TIF_DEBUG check before calling in to
flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
but for some reason, the x86 code is manually clearing TIF_DEBUG
immediately before the test, so this path will never be taken.

This kills off the erroneous clear_tsk_thread_flag() and lets
flush_thread_hw_breakpoint() actually get invoked.

Presumably folks were getting lucky with testing and the
free_thread_info() -> free_thread_xstate() path was taking care of the
flush there.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 arch/x86/kernel/process.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1092a1a..c62f647 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -110,8 +110,6 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
 		flush_thread_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
