Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZAWPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZAWPIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZAWPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:08:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZAWPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:08:14 -0500
Subject: Re: [RFC PATCH 01/19] lockdep: annotate reclaim context
 (__GFP_NOFS)
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1232697657.4791.8.camel@laptop>
References: <20090122173701.674448070@chello.nl>
	 <20090122174052.061744802@chello.nl> <1232653234.4890.135.camel@laptop>
	 <1232656187.4890.136.camel@laptop>  <20090123073326.GA19986@wotan.suse.de>
	 <1232697657.4791.8.camel@laptop>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 16:08:08 +0100
Message-Id: <1232723288.4826.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 09:00 +0100, Peter Zijlstra wrote:
> 
> Yeah, I'll stick a check in there, that ought to suffice.

FWIW, I've ended up with the below, which I folded into your patch
(along with the fix from MinChan Kim).

--- 
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2471,16 +2471,21 @@ void lockdep_trace_alloc(gfp_t gfp_mask)
 {
 	struct task_struct *curr = current;
 
+	if (unlikely(!debug_locks))
+		return;
+
+	/* no reclaim without waiting on it */
+	if (!(gfp_mask & __GFP_WAIT))
+		return;
+
 	/* this guy won't enter reclaim */
-	if (curr->flags & PF_MEMALLOC)
+	if ((curr->flags & PF_MEMALLOC) && !(gfp_mask & __GFP_NOMEMALLOC))
 		return;
 
 	/* We're only interested __GFP_FS allocations for now */
 	if (!(gfp_mask & __GFP_FS))
 		return;
 
-	if (unlikely(!debug_locks))
-		return;
 	if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
 		return;
 


