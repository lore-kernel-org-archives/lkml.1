Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYARAg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYARAg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbYARAfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:35:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759564AbYARAfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:54 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:46 -0200
Message-Id: <12006165651341-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1200616561270-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com> <1200616561270-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inour new model, pages are assigned to a virtual cpu, not to a guest.
Wemove it to the lg_cpu structure.

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/lg.h          |    3 ++-
drivers/lguest/lguest_user.c |    8 ++++----
drivers/lguest/x86/core.c    |    4 ++--
3 files changed, 8 insertions(+), 7 deletions(-)

diff--git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index11a3ae2..eb473a5 100644
---a/drivers/lguest/lg.h
+++b/drivers/lguest/lg.h
@@-57,6 +57,8 @@ struct lg_cpu {
	unsigned long regs_page;
	struct lguest_regs *regs;

+	structlguest_pages *last_pages;
+
	int cpu_pgd; /* which pgd this cpu is currently using */

	/* If a hypercall was asked for, this points to the arguments. */
@@-92,7 +94,6 @@ struct lguest

	/* Bitmap of what has changed: see CHANGED_* above. */
	int changed;
-	structlguest_pages *last_pages;

	struct pgdir pgdirs[4];

diff--git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
indexf4f6df8..a87fca6 100644
---a/drivers/lguest/lguest_user.c
+++b/drivers/lguest/lguest_user.c
@@-131,6 +131,10 @@ static int lg_cpu_start(struct lg_cpu *cpu, unsigned id, unsigned long start_ip)
	 * reference, it is destroyed before close() is called. */
	cpu->mm = get_task_mm(cpu->tsk);

+	/*We remember which CPU's pages this Guest used last, for optimization
+	* when the same Guest runs on the same CPU twice. */
+	cpu->last_pages= NULL;
+
	return 0;
}

@@-192,10 +196,6 @@ static int initialize(struct file *file, const unsigned long __user *input)
	if (err)
		goto free_regs;

-	/*We remember which CPU's pages this Guest used last, for optimization
-	* when the same Guest runs on the same CPU twice. */
-	lg->last_pages= NULL;
-
	/* We keep our "struct lguest" in the file's private_data. */
	file->private_data = lg;

diff--git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index25f48fd..3e457f2 100644
---a/drivers/lguest/x86/core.c
+++b/drivers/lguest/x86/core.c
@@-80,9 +80,9 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
	 * same Guest we ran last time (and that Guest hasn't run anywhere else
	 * meanwhile).  If that's not the case, we pretend everything in the
	 * Guest has changed. */
-	if(__get_cpu_var(last_cpu) != cpu || lg->last_pages != pages) {
+	if(__get_cpu_var(last_cpu) != cpu || cpu->last_pages != pages) {
		__get_cpu_var(last_cpu) = cpu;
-		lg->last_pages= pages;
+		cpu->last_pages= pages;
		lg->changed = CHANGED_ALL;
	}

--
1.5.0.6

