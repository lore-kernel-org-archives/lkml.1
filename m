Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZDSOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZDSOWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbZDSOWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:22:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33750 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbZDSOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a7yj7HfLcNPhZo4igRocl0gE3q1EZj0y+DLrK3a3MBjclI6InUt7Q4HMXIfJzrC/Aa
         tNuQ5AdJyTA4kTnbEOT2jo89sQiv0LmRdohtKXblUm9tIasVo6SCupTmRMBXso0mWeHC
         wtbKsLRllQ6pnjsRTAJ9+ktTAR2v9A2ACxTRg=
Date: Sun, 19 Apr 2009 16:22:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion
	warning
Message-ID: <20090419142201.GB6262@nowhere>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere> <20090419134927.GA6262@nowhere> <20090419140154.GB28919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419140154.GB28919@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 04:01:54PM +0200, Ingo Molnar wrote:
> It would be nice to have this ... but there's no need to do that 
> atomic thing - just use printk_once() please. (if we race with 
> another instance and get two messages that's not a problem)
> 
> 	Ingo


Ah, indeed I forgot about printk_once()
I've updated the repo with the following v2 on:
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing tracing/recursion

---
>From e894732989e345ea012de146c37d71dd7ed3575d Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 19 Apr 2009 16:18:16 +0200
Subject: [PATCH v2] tracing/core: Add current context on tracing recursion warning

In case of tracing recursion detection, we only get the stacktrace.
But the current context may be very useful to debug the issue.

This patch adds the softirq/hardirq/nmi context with the warning
using lockdep context display to have a familiar output.

v2: Use printk_once()

[ Impact: more information in tracing recursion ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ring_buffer.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b421b0e..e315178 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1495,6 +1495,16 @@ static int trace_recursive_lock(void)
 	if (unlikely(current->trace_recursion & (1 << level))) {
 		/* Disable all tracing before we do anything else */
 		tracing_off_permanent();
+
+		printk_once(KERN_WARNING "Tracing recursion: "
+			    "[HC%u[%lu]:SC%u[%lu]:NMI[%lu]:HE%u:SE%u]\n",
+			    current->hardirq_context,
+			    hardirq_count() >> HARDIRQ_SHIFT,
+			    current->softirq_context,
+			    softirq_count() >> SOFTIRQ_SHIFT,
+			    in_nmi(), current->hardirqs_enabled,
+			    current->softirqs_enabled);
+
 		WARN_ON_ONCE(1);
 		return -1;
 	}
-- 
1.6.1


