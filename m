Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0BDKvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 05:51:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0BDKvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 05:51:09 -0500
Date: Thu, 4 Feb 2010 11:50:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Frank Heckenbach <f.heckenbach@fh-soft.de>, linux-kernel@vger.kernel.org
Subject: Re: CLONE_VM: parent terminates silently when child segfaults
Message-ID: <20100204105017.GA21188@redhat.com>
References: <1264625298.4591.700948@ngc224.gerwinski.de> <2375c9f91002040001t1064c8c9h8990b40b63290dd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91002040001t1064c8c9h8990b40b63290dd5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Américo Wang wrote:
>
> On Thu, Jan 28, 2010 at 4:48 AM, Frank Heckenbach
> <f.heckenbach@fh-soft.de> wrote:
> > When a process cloned with CLONE_VM is killed by SIGSEGV, the parent
> > process is terminated silently.
>
> Becase SIGSEGV and SIGILL are coredump signals, when you use CLONE_VM,
> child process will share the memory space with its parent, what would
> you expect the parent behaves when its child coredumping their shared memory
> space?

Yes, exactly. The coredump signals kill/dump all threads which share
this ->mm, this is intentional.

As for status = 0 I agree, this looks strange. In fact I already
suggested the change below a long ago, but I don't remember why it
was declined (or probably it was unnoticed).

The patch below doesn't add 0x80 to ->group_exit_code in case we
really dumped the core, but at least the coredumping signal is
visible to do_wait/etc.

Oleg.

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1550,6 +1550,7 @@ static int zap_process(struct task_struc
 	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
+	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
 	t = start;
@@ -1574,7 +1575,6 @@ static inline int zap_threads(struct tas
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
-		tsk->signal->group_exit_code = exit_code;
 		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);

