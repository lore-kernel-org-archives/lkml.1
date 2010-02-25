Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0BYIUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:20:14 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51180 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0BYIUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:20:11 -0500
Message-Id: <201002250819.o1P8JPwQ063834@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Protect find_task_by_vpid() with RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, oleg@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Feb 2010 17:19:25 +0900
References: <201002240034.o1O0YoMd068517@www262.sakura.ne.jp> <alpine.LRH.2.00.1002251056240.13762@tundra.namei.org> <201002250013.o1P0DHml057484@www262.sakura.ne.jp> <alpine.LRH.2.00.1002251413160.14411@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1002251413160.14411@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25022010 #3416720, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 25 Feb 2010, Tetsuo Handa wrote:
> 
> > James Morris wrote:
> > > On Wed, 24 Feb 2010, Tetsuo Handa wrote:
> > > 
> > > > Caller of find_task_by_vpid() must use rcu_read_lock().
> > > 
> > > The comment for the function says:
> > > 
> > >   Must be called under rcu_read_lock() or with tasklist_lock read-held.
> > > 
> > > In the cases below, you have taken tasklist_lock.
> > 
> > That comment will be updated to
> > "Must be called under rcu_read_lock()." in 2.6.34 .

The patch for updating that comment is at
http://userweb.kernel.org/~akpm/mmotm/broken-out/kernel-pidc-update-comment-on-find_task_by_pid_ns.patch

> > Please see http://lkml.org/lkml/2009/12/10/180 and http://lkml.org/lkml/2009/12/9/472 .
> 
> Ok, please fix the comment as well.

I see. Explanation is in commit d4581a239a40319205762b76c01eb6363f277efa
"sys: Fix missing rcu protection for __task_cred() access".
Thus, I think below comment should be sufficient.
--------------------
[PATCH] TOMOYO: Protect find_task_by_vpid() with RCU.

Holding tasklist_lock is no longer sufficient for find_task_by_vpid().
Explicit rcu_read_lock() is required.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
--
 security/tomoyo/common.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 30dd1c6..ff51f10 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -1232,11 +1232,13 @@ static bool tomoyo_is_select_one(struct tomoyo_io_buffer *head,
 
 	if (sscanf(data, "pid=%u", &pid) == 1) {
 		struct task_struct *p;
+		rcu_read_lock();
 		read_lock(&tasklist_lock);
 		p = find_task_by_vpid(pid);
 		if (p)
 			domain = tomoyo_real_domain(p);
 		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	} else if (!strncmp(data, "domain=", 7)) {
 		if (tomoyo_is_domain_def(data + 7))
 			domain = tomoyo_find_domain(data + 7);
@@ -1635,11 +1637,13 @@ static int tomoyo_read_pid(struct tomoyo_io_buffer *head)
 		const int pid = head->read_step;
 		struct task_struct *p;
 		struct tomoyo_domain_info *domain = NULL;
+		rcu_read_lock();
 		read_lock(&tasklist_lock);
 		p = find_task_by_vpid(pid);
 		if (p)
 			domain = tomoyo_real_domain(p);
 		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		if (domain)
 			tomoyo_io_printf(head, "%d %u %s", pid, domain->profile,
 					 domain->domainname->name);
