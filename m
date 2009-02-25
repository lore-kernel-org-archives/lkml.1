Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZBYTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZBYTqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZBYTqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:46:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbZBYTqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:46:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
In-Reply-To: Oleg Nesterov's message of  Wednesday, 25 February 2009 20:02:11 +0100 <20090225190211.GA7445@redhat.com>
References: <20090225190211.GA7445@redhat.com>
Emacs: no job too big... no job.
Message-Id: <20090225193927.1ED25FC3DA@magilla.sf.frob.com>
Date: Wed, 25 Feb 2009 11:39:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I think I said before, I don't really know what the actual use case is
for CLONE_PARENT without CLONE_THREAD.  So it's easy to approve changing
its behavior, but I do vaguely worry about who expected what behavior before.

Just for readability, I would prefer that you just change the first line
above that sets p->exit_signal initially.  i.e. (but with some comments):

diff --git a/kernel/fork.c b/kernel/fork.c
index a66fbde..f56793b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1184,7 +1184,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->parent_exec_id = p->self_exec_id;
 
 	/* ok, now we should be set up.. */
-	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
+	p->exit_signal = ((clone_flags & CLONE_THREAD) ? -1 :
+			  (clone_flags & CLONE_PARENT) ?
+			  current->group_leader->exit_signal :
+			  (clone_flags & CSIGNAL));
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
 


Thanks,
Roland
