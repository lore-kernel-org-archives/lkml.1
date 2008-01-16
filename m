Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYAPHKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYAPHKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYAPHKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:10:08 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:48550 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYAPHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:10:06 -0500
Date: Wed, 16 Jan 2008 08:03:46 +0100
From: Clifford Wolf <clifford@clifford.at>
To: serge@hallyn.com
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rlim in proc/<pid>/status (2nd rev.)
Message-ID: <20080116070346.GA24106@clifford.at>
References: <20080115100631.GA13394@clifford.at> <20080115203659.GA5404@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115203659.GA5404@vino.hallyn.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 15, 2008 at 02:36:59PM -0600, serge@hallyn.com wrote:
> > +	rcu_read_lock();
> > +	if (lock_task_sighand(p, &flags)) {
> > +		for (i=0; i<RLIM_NLIMITS; i++)
> > +			rlim[i] = p->signal->rlim[i];
> 
> I'm confused - where do you unlock_task_sighand()?

oh fsck! thanks for that pointer..

Here is a new version of the patch which solves this issue and the issues
adressed earlier in this thread by kosaki.

yours,
 - clifford

Signed-off-by: Clifford Wolf <clifford@clifford.at>

--- linux/fs/proc/array.c	(revision 750)
+++ linux/fs/proc/array.c	(revision 764)
@@ -239,6 +239,58 @@
 	}
 }
 
+static char *rlim_names[RLIM_NLIMITS] = {
+	[RLIMIT_CPU]        = "CPU",
+	[RLIMIT_FSIZE]      = "FSize",
+	[RLIMIT_DATA]       = "Data",
+	[RLIMIT_STACK]      = "Stack",
+	[RLIMIT_CORE]       = "Core",
+	[RLIMIT_RSS]        = "RSS",
+	[RLIMIT_NPROC]      = "NProc",
+	[RLIMIT_NOFILE]     = "NoFile",
+	[RLIMIT_MEMLOCK]    = "MemLock",
+	[RLIMIT_AS]         = "AddrSpace",
+	[RLIMIT_LOCKS]      = "Locks",
+	[RLIMIT_SIGPENDING] = "SigPending",
+	[RLIMIT_MSGQUEUE]   = "MsgQueue",
+	[RLIMIT_NICE]       = "Nice",
+	[RLIMIT_RTPRIO]     = "RTPrio"
+};
+
+#if RLIM_NLIMITS != 15
+#  error Value of RLIM_NLIMITS changed. \
+         Please update rlim_names in fs/proc/array.c
+#endif
+
+static inline char *task_rlim(struct task_struct *p, char *buffer)
+{
+	unsigned long flags;
+	struct rlimit rlim[RLIM_NLIMITS];
+	int i;
+	
+	rcu_read_lock();
+	if (lock_task_sighand(p, &flags)) {
+		for (i=0; i<RLIM_NLIMITS; i++)
+			rlim[i] = p->signal->rlim[i];
+		unlock_task_sighand(p, &flags);
+	}
+	rcu_read_unlock();
+
+	for (i=0; i<RLIM_NLIMITS; i++) {
+		buffer += sprintf(buffer, "Rlim%s:\t", rlim_names[i]);
+		if (rlim[i].rlim_cur != RLIM_INFINITY)
+			buffer += sprintf(buffer, "%lu\t", rlim[i].rlim_cur);
+		else
+			buffer += sprintf(buffer, "inf\t");
+		if (rlim[i].rlim_max != RLIM_INFINITY)
+			buffer += sprintf(buffer, "%lu\n", rlim[i].rlim_max);
+		else
+			buffer += sprintf(buffer, "inf\n");
+	}
+
+	return buffer;
+}
+
 static inline char *task_sig(struct task_struct *p, char *buffer)
 {
 	unsigned long flags;
@@ -310,6 +362,7 @@
 		buffer = task_mem(mm, buffer);
 		mmput(mm);
 	}
+	buffer = task_rlim(task, buffer);
 	buffer = task_sig(task, buffer);
 	buffer = task_cap(task, buffer);
 	buffer = cpuset_task_status_allowed(task, buffer);

-- 
perl -le '$_=1;(1x$_)!~/^(11+)\1+$/&&print${_}while$_++<1000'|fmt
