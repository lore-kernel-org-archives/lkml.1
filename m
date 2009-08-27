Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZH0H14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZH0H14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZH0H1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:27:55 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:41648 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZH0H1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:27:55 -0400
Date: Thu, 27 Aug 2009 09:27:39 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH]: tracing: s390 arch updates for tracing syscalls
Message-ID: <20090827072738.GA4301@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
	jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <cover.1249932670.git.jbaron@redhat.com> <20090825123111.GD4639@cetus.boeblingen.de.ibm.com> <20090826165323.GC6759@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826165323.GC6759@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 06:53:25PM +0200, Frederic Weisbecker wrote:
> > Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
> > ---
> >  arch/s390/include/asm/ftrace.h |    4 ++++
> 
> Btw, the stat have changes in ftrace.h but your patch haven't.
> Is there something missing?
No. diffstat has not been refreshed after removing the
FTRACE_SYSCALL_MAX constant.
Here is the patch again with the refreshed diffstat:

Syscall tracing updates for s390 architecture.

This patch includes s390 arch updates for:
- tracing: Map syscall name to number (syscall_name_to_nr())
- tracing: Call arch_init_ftrace_syscalls at boot
- tracing: add support traceopint ids (set_syscall_{enter,exit}_id())
  
Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 arch/s390/kernel/ftrace.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -220,6 +220,29 @@ struct syscall_metadata *syscall_nr_to_m
 	return syscalls_metadata[nr];
 }
 
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+	for (i = 0; i < NR_syscalls; i++)
+		if (syscalls_metadata[i])
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
 	struct syscall_metadata *start;
@@ -237,24 +260,19 @@ static struct syscall_metadata *find_sys
 	return NULL;
 }
 
-void arch_init_ftrace_syscalls(void)
+static int __init arch_init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	int i;
-	static atomic_t refs;
-
-	if (atomic_inc_return(&refs) != 1)
-		goto out;
 	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
 				    GFP_KERNEL);
 	if (!syscalls_metadata)
-		goto out;
+		return -ENOMEM;
 	for (i = 0; i < NR_syscalls; i++) {
 		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
 		syscalls_metadata[i] = meta;
 	}
-	return;
-out:
-	atomic_dec(&refs);
+	return 0;
 }
+arch_initcall(arch_init_ftrace_syscalls);
 #endif
