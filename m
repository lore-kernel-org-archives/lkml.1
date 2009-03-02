Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZCBWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZCBWCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZCBWBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:01:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbZCBWBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:01:53 -0500
Date: Mon, 2 Mar 2009 22:58:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: fix CLONE_PARENT && parent_exec_id
	interaction
Message-ID: <20090302215845.GA22307@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com> <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain> <20090226223031.GA14477@redhat.com> <20090302212256.GA19262@redhat.com> <alpine.LFD.2.00.0903021332130.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903021332130.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Linus Torvalds wrote:
> 
> 
> On Mon, 2 Mar 2009, Oleg Nesterov wrote:
> > 
> > I am re-sending this patch simplified to one-liner. If this patch is
> > accepted, I think it makes sense to move the first
> > "p->parent_exec_id = p->self_exec_id" in copy_process() down, under
> > the "else" branch. Just for readability.
> > 
> > Note! This patch doesn't even try to address the original CVE. Let me
> > repeat, I am not the security expert, please correct me. But, unless
> > parent or child change security context (via exec), it is OK to send
> > any ->exit_signal when the child exits.
> > 
> > Comments?
> 
> I think this looks correct and sane. And I agree with your "also move down 
> the "p->parent_exec_id = p->self_exec_id" thing. In fact, I'd agree with 
> it so much that I think it should be part of this patch, just because that 
> not only clarifies the code, but it also makes it more obvious what the 
> real change of this one single _patch_ is.

Agreed, please find v2 below. But I failed to make the comment...

Also, "p->parent_exec_id = current->parent_exec_id" is not really needed
in v2, it was already copied by dup_task_struct(). But I think it is better
to make the code a bit more explicit.

------------------
[PATCH v2] copy_process: fix CLONE_PARENT && parent_exec_id interaction

CLONE_PARENT can fool the ->self_exec_id/parent_exec_id logic. If we
re-use the old parent, we must also re-use ->parent_exec_id to make
sure exit_notify() sees the right ->xxx_exec_id's when the CLONE_PARENT'ed
task exits.

Also, move down the "p->parent_exec_id = p->self_exec_id" thing, to place
two different cases together.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/fork.c~3_CLONE_PARENT	2009-03-02 20:24:59.000000000 +0100
+++ 6.29-rc3/kernel/fork.c	2009-03-02 22:38:39.000000000 +0100
@@ -1177,10 +1177,6 @@ static struct task_struct *copy_process(
 #endif
 	clear_all_latency_tracing(p);
 
-	/* Our parent execution domain becomes current domain
-	   These must match for thread signalling to apply */
-	p->parent_exec_id = p->self_exec_id;
-
 	/* ok, now we should be set up.. */
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
@@ -1218,10 +1214,13 @@ static struct task_struct *copy_process(
 		set_task_cpu(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
-	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
+	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
-	else
+		p->parent_exec_id = current->parent_exec_id;
+	} else {
 		p->real_parent = current;
+		p->parent_exec_id = current->self_exec_id;
+	}
 
 	spin_lock(&current->sighand->siglock);
 

