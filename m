Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZHQCob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZHQCob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZHQCoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:44:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36916 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbZHQCoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:44:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 17 Aug 2009 11:42:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Message-Id: <20090817114242.1419bd1f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090817023802.GF5039@cr0.nay.redhat.com>
References: <20090815233629.A067.A69D9226@jp.fujitsu.com>
	<20090817023802.GF5039@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 10:38:02 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Sat, Aug 15, 2009 at 11:36:41PM +0900, KOSAKI Motohiro wrote:
> >From: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
> >Subject: [PATCH] proc: let task status file print utime and stime.
> >
> >The task status file in proc file system did not contain
> >user-time and system-time. Thus, users could not get
> >those information of running task easily. I think
> >these values should be provived in human readable format.
> >By this patch, users can get stime and utime very easily.
> 
> 
> Why? /proc/<pid>/stat already has these.
> 

I wonder /proc/<pid>/stat is unreadable for usual human.
Most of ents in /proc/<pid>/status is duplicated output of 
some other files(i.e. /proc/<pid>/stat) and /proc/<pid>/status is
for human readble format.

In another thinking, in old days, /proc/<pid>/stat was enough because most of
users uses scanf() or some C langage to read fixed-format data.
/proc/<pid>/status is useful for some script languages which has 
good parser per line. 

?
-Kame

> 
> >
> >Signed-off-by: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
> >Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> >Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >---
> > fs/proc/array.c |   11 +++++++++--
> > 1 files changed, 9 insertions(+), 2 deletions(-)
> >
> >diff --git a/fs/proc/array.c b/fs/proc/array.c
> >index 725a650..29afa68 100644
> >--- a/fs/proc/array.c
> >+++ b/fs/proc/array.c
> >@@ -162,6 +162,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
> > 	struct fdtable *fdt = NULL;
> > 	const struct cred *cred;
> > 	pid_t ppid, tpid;
> >+	struct timeval utime, stime;
> > 
> > 	rcu_read_lock();
> > 	ppid = pid_alive(p) ?
> >@@ -173,6 +174,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
> > 			tpid = task_pid_nr_ns(tracer, ns);
> > 	}
> > 	cred = get_cred((struct cred *) __task_cred(p));
> >+	cputime_to_timeval(task_utime(p), &utime);
> >+	cputime_to_timeval(task_stime(p), &stime);
> > 	seq_printf(m,
> > 		"State:\t%s\n"
> > 		"Tgid:\t%d\n"
> >@@ -180,13 +183,17 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
> > 		"PPid:\t%d\n"
> > 		"TracerPid:\t%d\n"
> > 		"Uid:\t%d\t%d\t%d\t%d\n"
> >-		"Gid:\t%d\t%d\t%d\t%d\n",
> >+		"Gid:\t%d\t%d\t%d\t%d\n"
> >+		"Utime:\t%lu.%06lu\n"
> >+		"Stime:\t%lu.%06lu\n",
> > 		get_task_state(p),
> > 		task_tgid_nr_ns(p, ns),
> > 		pid_nr_ns(pid, ns),
> > 		ppid, tpid,
> > 		cred->uid, cred->euid, cred->suid, cred->fsuid,
> >-		cred->gid, cred->egid, cred->sgid, cred->fsgid);
> >+		cred->gid, cred->egid, cred->sgid, cred->fsgid,
> >+		(unsigned long) utime.tv_sec, (unsigned long) utime.tv_usec,
> >+		(unsigned long) stime.tv_sec, (unsigned long) stime.tv_usec);
> > 
> > 	task_lock(p);
> > 	if (p->files)
> >-- 
> >1.4.4.4
> >
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

