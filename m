Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZINNnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZINNnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZINNnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:43:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINNnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:43:42 -0400
Subject: [PATCH][GIT PULL] ring-buffer: typecast cmpxchg to fix PowerPC
 warning
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 14 Sep 2009 09:43:43 -0400
Message-Id: <1252935823.20020.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (1):
      ring-buffer: typecast cmpxchg to fix PowerPC warning

----
 kernel/trace/ring_buffer.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit 08a408161749d2406f94f4e3d47cfdbc826ad1cc
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Sep 14 09:31:35 2009 -0400

    ring-buffer: typecast cmpxchg to fix PowerPC warning
    
    The cmpxchg used by PowerPC does the following:
    
      ({									 \
         __typeof__(*(ptr)) _o_ = (o);					 \
         __typeof__(*(ptr)) _n_ = (n);					 \
         (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
    				    (unsigned long)_n_, sizeof(*(ptr))); \
      })
    
    This does a type check of *ptr to both o and n.
    
    Unfortunately, the code in ring-buffer.c assigns longs to pointers
    and pointers to longs and causes a warning on PowerPC:
    
    ring_buffer.c: In function 'rb_head_page_set':
    ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
    ring_buffer.c:704: warning: initialization makes pointer from integer without a cast
    ring_buffer.c: In function 'rb_head_page_replace':
    ring_buffer.c:797: warning: initialization makes integer from pointer without a cast
    
    This patch adds the typecasts inside cmpxchg to annotate that a long is
    being cast to a pointer and a pointer is being casted to a long and this
    removes the PowerPC warnings.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8786c35..6eef389 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -701,8 +701,8 @@ static int rb_head_page_set(struct ring_buffer_per_cpu *cpu_buffer,
 
 	val &= ~RB_FLAG_MASK;
 
-	ret = (unsigned long)cmpxchg(&list->next,
-				     val | old_flag, val | new_flag);
+	ret = cmpxchg((unsigned long *)&list->next,
+		      val | old_flag, val | new_flag);
 
 	/* check if the reader took the page */
 	if ((ret & ~RB_FLAG_MASK) != val)
@@ -794,7 +794,7 @@ static int rb_head_page_replace(struct buffer_page *old,
 	val = *ptr & ~RB_FLAG_MASK;
 	val |= RB_PAGE_HEAD;
 
-	ret = cmpxchg(ptr, val, &new->list);
+	ret = cmpxchg(ptr, val, (unsigned long)&new->list);
 
 	return ret == val;
 }


