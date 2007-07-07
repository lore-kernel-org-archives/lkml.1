Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbXGGSsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbXGGSsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbXGGSsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:48:12 -0400
Received: from mail.screens.ru ([213.234.233.54]:33023 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbXGGSsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:48:10 -0400
Date: Sat, 7 Jul 2007 22:48:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Vadim Lobanov <vlobanov@speakeasy.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] do_sys_poll: simplify playing with on-stack data
Message-ID: <20070707184802.GA193@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Lessens both the source and compiled code (100 bytes) and imho makes
the code much more understandable.

With this patch "struct poll_list *head" always points to on-stack stack_pps,
so we can remove all "is it on-stack" and "was it initialized" checks.

Also, move poll_initwait/poll_freewait and -EINTR detection closer to the
do_poll()'s callsite.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 select.c |   92 ++++++++++++++++++++++++---------------------------------------
 1 files changed, 36 insertions(+), 56 deletions(-)

--- t/fs/select.c~1_simplify	2007-05-21 13:57:56.000000000 +0400
+++ t/fs/select.c	2007-07-07 20:08:36.000000000 +0400
@@ -653,86 +653,66 @@ static int do_poll(unsigned int nfds,  s
 int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 {
 	struct poll_wqueues table;
- 	int fdcount, err;
- 	unsigned int i;
-	struct poll_list *head;
- 	struct poll_list *walk;
+ 	int err = -EFAULT, fdcount, len, size;
 	/* Allocate small arguments on the stack to save memory and be
 	   faster - use long to make sure the buffer is aligned properly
 	   on 64 bit archs to avoid unaligned access */
 	long stack_pps[POLL_STACK_ALLOC/sizeof(long)];
-	struct poll_list *stack_pp = NULL;
+	struct poll_list *const head = (struct poll_list *)stack_pps;
+ 	struct poll_list *walk = head;
+ 	unsigned long todo = nfds;
 
-	/* Do a sanity check on nfds ... */
 	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
 		return -EINVAL;
 
-	poll_initwait(&table);
+	len = min(nfds, N_STACK_PPS);
+	for (;;) {
+		walk->next = NULL;
+		walk->len = len;
+		if (!len)
+			break;
 
-	head = NULL;
-	walk = NULL;
-	i = nfds;
-	err = -ENOMEM;
-	while(i!=0) {
-		struct poll_list *pp;
-		int num, size;
-		if (stack_pp == NULL)
-			num = N_STACK_PPS;
-		else
-			num = POLLFD_PER_PAGE;
-		if (num > i)
-			num = i;
-		size = sizeof(struct poll_list) + sizeof(struct pollfd)*num;
-		if (!stack_pp)
-			stack_pp = pp = (struct poll_list *)stack_pps;
-		else {
-			pp = kmalloc(size, GFP_KERNEL);
-			if (!pp)
-				goto out_fds;
-		}
-		pp->next=NULL;
-		pp->len = num;
-		if (head == NULL)
-			head = pp;
-		else
-			walk->next = pp;
+		if (copy_from_user(walk->entries, ufds + nfds-todo,
+					sizeof(struct pollfd) * walk->len))
+			goto out_fds;
 
-		walk = pp;
-		if (copy_from_user(pp->entries, ufds + nfds-i, 
-				sizeof(struct pollfd)*num)) {
-			err = -EFAULT;
+		todo -= walk->len;
+		if (!todo)
+			break;
+
+		len = min(todo, POLLFD_PER_PAGE);
+		size = sizeof(struct poll_list) + sizeof(struct pollfd) * len;
+		walk = walk->next = kmalloc(size, GFP_KERNEL);
+		if (!walk) {
+			err = -ENOMEM;
 			goto out_fds;
 		}
-		i -= pp->len;
 	}
 
+	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
+	if (!fdcount && signal_pending(current))
+		fdcount = -EINTR;
+	poll_freewait(&table);
 
-	/* OK, now copy the revents fields back to user space. */
-	walk = head;
-	err = -EFAULT;
-	while(walk != NULL) {
+	for (walk = head; walk; walk = walk->next) {
 		struct pollfd *fds = walk->entries;
 		int j;
 
-		for (j=0; j < walk->len; j++, ufds++) {
-			if(__put_user(fds[j].revents, &ufds->revents))
+		for (j = 0; j < walk->len; j++, ufds++)
+			if (__put_user(fds[j].revents, &ufds->revents))
 				goto out_fds;
-		}
-		walk = walk->next;
   	}
+
 	err = fdcount;
-	if (!fdcount && signal_pending(current))
-		err = -EINTR;
 out_fds:
-	walk = head;
-	while(walk!=NULL) {
-		struct poll_list *pp = walk->next;
-		if (walk != stack_pp)
-			kfree(walk);
-		walk = pp;
+	walk = head->next;
+	while (walk) {
+		struct poll_list *pos = walk;
+		walk = walk->next;
+		kfree(pos);
 	}
-	poll_freewait(&table);
+
 	return err;
 }
 

