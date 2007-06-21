Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXFUOgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXFUOgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXFUOfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:35:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbXFUOfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:35:51 -0400
Date: Thu, 21 Jun 2007 10:35:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: [PATCH] CIFS: make cifsd (more)
 signal-safe
Message-Id: <20070621103545.1a034268.jlayton@redhat.com>
In-Reply-To: <20070606085550.GA7351@infradead.org>
References: <20070605152340.f09fa6f2.jlayton@redhat.com>
	<20070606085550.GA7351@infradead.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 09:55:50 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jun 05, 2007 at 03:23:40PM -0400, Jeff Layton wrote:
> > I recently sent a similar, smaller patch for this problem. After some
> > discussion with Steve and Shaggy, I think I better understand why cifsd
> > allows signals through, and I realize that my earlier patch wasn't
> > comprehensive enough
> > 
> > The mount and unmount calls will send a KILL signal to cifsd to wake it
> > up if it happens to be blocked in kernel_recvmsg. The problem is that
> > it doesn't distinguish between "legitimate" signals sent for this
> > reason and spurious signals sent by a userspace process (for instance).
> > While this is definitely a "don't do that" sort of situation, we might
> > as well try to have cifsd be as signal-safe as possible.
> > 
> > The following patch does this by making sure that we set tcpStatus to
> > CifsExiting before sending cifsd a signal, and having cifsd check for
> > that when it sees that it's been signalled. If the tcpStatus is not set
> > correctly, it ignores it, flushes signals and moves on.
> > 
> > I've tested a similar backported version of this on an earlier kernel,
> > but have not tested this particular patch as of yet.
> 
> The right way to fix this is to stop sending signals at all and have
> a kernel-internal way to get out of kernel_recvmsg.  Uses of signals by
> kernel thread generally are bugs.
> 

I've looked at different ways to do this and haven't seen a clean way
to do this. I made an initial stab at having tcp_recvmsg check
kthread_stop and break out of the loop if it sees it. Herbert Xu stated
that he didn't think that was right -- after all, why should
tcp_recvmsg care about khthreads?

As I see it we're left with using signals, or setting up some other
signal-type infrastructure that's just available in the kernel. That
seems redundant to me, and I'm not clear as to why use of signals by
kthreads is a bad thing.

So, here's a second attempt at this. This changes cifsd to ignore all
signals and changes the cifs mount/umount code to use force_sig()
instead of send_sig(). I don't think this is any worse than what we're
doing today and it insulates cifsd from signals sent from userspace.

This should apply to the current cifs-2.6 git tree.

Seem reasonable?

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f4e9266..27c1ebe 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -348,7 +348,6 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	int isMultiRsp;
 	int reconnect;
 
-	allow_signal(SIGKILL);
 	current->flags |= PF_MEMALLOC;
 	server->tsk = current;	/* save process info to wake at shutdown */
 	cFYI(1, ("Demultiplex PID: %d", current->pid));
@@ -2074,7 +2073,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 				   always wake up processes blocked in
 				   tcp in recv_mesg then we could remove the
 				   send_sig call */
-				send_sig(SIGKILL,srvTcp->tsk,1);
+				force_sig(SIGKILL,srvTcp->tsk);
 				tsk = srvTcp->tsk;
 				if(tsk)
 					kthread_stop(tsk);
@@ -2093,7 +2092,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 					if ((temp_rc == -ESHUTDOWN) &&
 					   (pSesInfo->server) && (pSesInfo->server->tsk)) {
 						struct task_struct *tsk;
-						send_sig(SIGKILL,pSesInfo->server->tsk,1);
+						force_sig(SIGKILL,pSesInfo->server->tsk);
 						tsk = pSesInfo->server->tsk;
 						if (tsk)
 							kthread_stop(tsk);
@@ -3345,7 +3344,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 			} else if (rc == -ESHUTDOWN) {
 				cFYI(1,("Waking up socket by sending it signal"));
 				if (cifsd_task) {
-					send_sig(SIGKILL,cifsd_task,1);
+					force_sig(SIGKILL,cifsd_task);
 					kthread_stop(cifsd_task);
 				}
 				rc = 0;
