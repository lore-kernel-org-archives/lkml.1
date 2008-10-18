Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYJRTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYJRTRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYJRTFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:47748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYJRTF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:26 -0400
Date: Sat, 18 Oct 2008 11:48:13 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       David Rientjes <rientjes@google.com>
Subject: [patch 21/26] x86: avoid dereferencing beyond stack + THREAD_SIZE
Message-ID: <20081018184813.GV301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-avoid-dereferencing-beyond-stack-thread_size.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: David Rientjes <rientjes@google.com>

commit 60e6258cd43f9b06884f04f0f7cefb9c40f17a32 upstream

It's possible for get_wchan() to dereference past task->stack + THREAD_SIZE
while iterating through instruction pointers if fp equals the upper boundary,
causing a kernel panic.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -740,12 +740,12 @@ unsigned long get_wchan(struct task_stru
 	if (!p || p == current || p->state==TASK_RUNNING)
 		return 0; 
 	stack = (unsigned long)task_stack_page(p);
-	if (p->thread.sp < stack || p->thread.sp > stack+THREAD_SIZE)
+	if (p->thread.sp < stack || p->thread.sp >= stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
 	do { 
 		if (fp < (unsigned long)stack ||
-		    fp > (unsigned long)stack+THREAD_SIZE)
+		    fp >= (unsigned long)stack+THREAD_SIZE)
 			return 0; 
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))

-- 
