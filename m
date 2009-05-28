Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbZE1Lpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbZE1Lpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZE1Lpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:45:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118AbZE1Lpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:45:35 -0400
Date: Thu, 28 May 2009 13:41:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12 v2] ptrace: mv task_struct->ptrace_message
	ptrace_ctx->message
Message-ID: <20090528114100.GA18744@redhat.com>
References: <20090528113601.GA18725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528113601.GA18725@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Oleg Nesterov wrote:
>
> ptrace_event() can use current->ptrace_ctx safely. If mask == 0 and we do
> not check task_ptrace() we are called from tracehook_report_clone_complete(),
> in this case trace == T means current was traced when it called do_fork().

Perhaps it is better to optimize out "mask != 0" check in ptrace_event().
This special !mask case is only needed for _report_clone(), we can use
mask == PT_PTRACED instead.

Oleg.

--- PTRACE/include/linux/ptrace.h~10_HOOK_COMPLETE	2009-05-28 11:19:33.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-28 11:49:29.000000000 +0200
@@ -157,7 +157,7 @@ int generic_ptrace_pokedata(struct task_
  */
 static inline int ptrace_event(int mask, int event, unsigned long message)
 {
-	if (mask && likely(!(task_ptrace(current) & mask)))
+	if (likely(!(task_ptrace(current) & mask)))
 		return 0;
 	current->ptrace_message = message;
 	ptrace_notify((event << 8) | SIGTRAP);
--- PTRACE/include/linux/tracehook.h~10_HOOK_COMPLETE	2009-05-28 08:41:11.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-28 11:50:14.000000000 +0200
@@ -344,7 +344,7 @@ static inline void tracehook_report_clon
 						   struct task_struct *child)
 {
 	if (unlikely(trace))
-		ptrace_event(0, trace, pid);
+		ptrace_event(PT_PTRACED, trace, pid);
 }
 
 /**

