Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbZEMSEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbZEMSEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZEMSEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:04:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbZEMSEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:04:20 -0400
Date: Wed, 13 May 2009 14:04:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: [PATCH][GIT PULL] x86/function-graph: fix constraint for recording
 old return value
Message-ID: <alpine.DEB.2.00.0905131400200.30591@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

After upgrading my distcc boxes from gcc 4.2.2 to 4.4.0, function graph 
tracer broke. Seems that the variable "old" needs to be denoted as an 
"early clobber". I've put this against the urgent tree and I'm Cc'ing 
stable because by the time 30 (and other) kernels get to users, they may 
be using gcc 4.4.0. I would expect that we will get more complaints about 
this as more people start using the newer gcc.

-- Steve


Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      x86/function-graph: fix constraint for recording old return value

----
 arch/x86/kernel/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit aa512a27e9e8ed32f31b15eec67ab1ceca33839b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed May 13 13:52:19 2009 -0400

    x86/function-graph: fix constraint for recording old return value
    
    After upgrading from gcc 4.2.2 to 4.4.0, the function graph tracer broke.
    Investigating, I found that in the asm that replaces the return value,
    gcc was using the same register for the old value as it was for the
    new value.
    
    	mov	(addr), old
    	mov	new, (addr)
    
    But if old and new are the same register, we clobber new with old!
    I first thought this was a bug in gcc 4.4.0 and reported it:
    
      http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40132
    
    Andrew Pinski responded (quickly), saying that it was correct gcc behavior
    and the code needed to denote old as an "early clobber".
    
    Instead of "=r"(old), we need "=&r"(old).
    
    [Impact: keep function graph tracer from breaking with gcc 4.4.0 ]
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18dfa30..b79c553 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -442,7 +442,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		_ASM_EXTABLE(1b, 4b)
 		_ASM_EXTABLE(2b, 4b)
 
-		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [old] "=&r" (old), [faulted] "=r" (faulted)
 		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
 	);

