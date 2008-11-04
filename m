Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYKDXwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYKDXwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYKDXkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:47732 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340AbYKDXkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:16 -0500
Date: Tue, 4 Nov 2008 15:33:03 -0800
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
Subject: [patch 41/57] x86: avoid dereferencing beyond stack + THREAD_SIZE
Message-ID: <20081104233303.GP659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-avoid-dereferencing-beyond-stack-thread_size.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Rientjes <rientjes@google.com>

commit e1e23bb0513520035ec934fa3483507cb6648b7c upstream

x86: avoid dereferencing beyond stack + THREAD_SIZE

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
@@ -729,12 +729,12 @@ unsigned long get_wchan(struct task_stru
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
