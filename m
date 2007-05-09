Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbXEIWKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbXEIWKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbXEIWKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:10:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759340AbXEIWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:10:10 -0400
Date: Wed, 9 May 2007 14:51:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [bisect] NFS regression breaks X
In-Reply-To: <46423D62.2070200@garzik.org>
Message-ID: <alpine.LFD.0.98.0705091440461.4062@woody.linux-foundation.org>
References: <46423D62.2070200@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 May 2007, Jeff Garzik wrote:
> 
> I love bisect :)

Yeah, me too.

> bisect has identified the following commit as the one that
> causes my GNOME login to die, within 10 seconds of logging in:
> 
> 	commit 2bea90d43a050bbc4021d44e59beb34f384438db

Ok, that commit looks nice in many ways, so I'd be loathe to revert it 
entirely.

Can you try it with this patch that re-introduces the "total overkill" 
slack calculations, and probably makes them even worse (there's a few 
left-shifts added, and now it will left-shift the extra slacktoo).

But there are also some unexplained changes in that patch, so maybe the 
size allocation isn't the big problem. For example, now "call_allocate()" 
will set task->tk_status to zero which is totally strange.

But if it's the allocation that is too small, this patch may help.

Trond, Chuck?

		Linus

--
 net/sunrpc/clnt.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index d8fbee4..5b78692 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -738,6 +738,8 @@ call_reserveresult(struct rpc_task *task)
 	rpc_exit(task, status);
 }
 
+#define RPC_SLACK_SPACE		(1024u)	/* apparently NOT total overkill */
+
 /*
  * 2.	Allocate the buffer. For details, see sched.c:rpc_malloc.
  *	(Note: buffer memory is freed in xprt_release).
@@ -745,7 +747,7 @@ call_reserveresult(struct rpc_task *task)
 static void
 call_allocate(struct rpc_task *task)
 {
-	unsigned int slack = task->tk_auth->au_cslack;
+	unsigned int slack;
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = task->tk_xprt;
 	struct rpc_procinfo *proc = task->tk_msg.rpc_proc;
@@ -764,6 +766,9 @@ call_allocate(struct rpc_task *task)
 			BUG_ON(proc->p_replen == 0);
 	}
 
+	/* Apparently not total overkill */
+	slack =  max(task->tk_auth->au_cslack, RPC_SLACK_SPACE);
+
 	/*
 	 * Calculate the size (in quads) of the RPC call
 	 * and reply headers, and convert both values
