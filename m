Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZEHNlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZEHNlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZEHNlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:41:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZEHNlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:41:36 -0400
Date: Fri, 8 May 2009 09:37:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, nauman@google.com,
       dpshah@google.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090508133740.GD7293@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A014619.1040000@cn.fujitsu.com> <20090506161012.GC8180@redhat.com> <4A027348.6000808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A027348.6000808@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:36:08PM +0800, Li Zefan wrote:
> Vivek Goyal wrote:
> > On Wed, May 06, 2009 at 04:11:05PM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >>> Hi All,
> >>>
> >>> Here is the V2 of the IO controller patches generated on top of 2.6.30-rc4.
> >>> First version of the patches was posted here.
> >> Hi Vivek,
> >>
> >> I did some simple test for V2, and triggered an kernel panic.
> >> The following script can reproduce this bug. It seems that the cgroup
> >> is already removed, but IO Controller still try to access into it.
> >>
> > 
> > Hi Gui,
> > 
> > Thanks for the report. I use cgroup_path() for debugging. I guess that
> > cgroup_path() was passed null cgrp pointer that's why it crashed.
> > 
> > If yes, then it is strange though. I call cgroup_path() only after
> > grabbing a refenrece to css object. (I am assuming that if I have a valid
> > reference to css object then css->cgrp can't be null).
> > 
> 
> Yes, css->cgrp shouldn't be NULL.. I doubt we hit a bug in cgroup here.
> The code dealing with css refcnt and cgroup rmdir has changed quite a lot,
> and is much more complex than it was.
> 
> > Anyway, can you please try out following patch and see if it fixes your
> > crash.
> ...
> > BTW, I tried following equivalent script and I can't see the crash on 
> > my system. Are you able to hit it regularly?
> > 
> 
> I modified the script like this:
> 
> ======================
> #!/bin/sh
> echo 1 > /proc/sys/vm/drop_caches
> mkdir /cgroup 2> /dev/null
> mount -t cgroup -o io,blkio io /cgroup
> mkdir /cgroup/test1
> mkdir /cgroup/test2
> echo 100 > /cgroup/test1/io.weight
> echo 500 > /cgroup/test2/io.weight
> 
> dd if=/dev/zero bs=4096 count=128000 of=500M.1 &
> pid1=$!
> echo $pid1 > /cgroup/test1/tasks
> 
> dd if=/dev/zero bs=4096 count=128000 of=500M.2 &
> pid2=$!
> echo $pid2 > /cgroup/test2/tasks
> 
> sleep 5
> kill -9 $pid1
> kill -9 $pid2
> 
> for ((;count != 2;))
> {
>         rmdir /cgroup/test1 > /dev/null 2>&1
>         if [ $? -eq 0 ]; then
>                 count=$(( $count + 1 ))
>         fi
> 
>         rmdir /cgroup/test2 > /dev/null 2>&1
>         if [ $? -eq 0 ]; then
>                 count=$(( $count + 1 ))
>         fi
> }
> 
> umount /cgroup
> rmdir /cgroup
> ======================
> 
> I ran this script and got lockdep BUG. Full log and my config are attached.
> 
> Actually this can be triggered with the following steps on my box:
> # mount -t cgroup -o blkio,io xxx /mnt
> # mkdir /mnt/0
> # echo $$ > /mnt/0/tasks
> # echo 3 > /proc/sys/vm/drop_cache
> # echo $$ > /mnt/tasks
> # rmdir /mnt/0
> 
> And when I ran the script for the second time, my box was freezed
> and I had to reset it.
> 

Thanks Li and Gui for pointing out the problem. With you script, I could
also produce lock validator warning as well as system freeze. I could
identify at least two trouble spots. With following patch things seems
to be fine on my system. Can you please give it a try.


---
 block/elevator-fq.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: linux11/block/elevator-fq.c
===================================================================
--- linux11.orig/block/elevator-fq.c	2009-05-08 08:47:45.000000000 -0400
+++ linux11/block/elevator-fq.c	2009-05-08 09:27:37.000000000 -0400
@@ -942,6 +942,7 @@ void entity_served(struct io_entity *ent
 	struct io_service_tree *st;
 
 	for_each_entity(entity) {
+		BUG_ON(!entity->on_st);
 		st = io_entity_service_tree(entity);
 		entity->service += served;
 		entity->total_service += served;
@@ -1652,6 +1653,14 @@ static inline int io_group_has_active_en
 			return 1;
 	}
 
+	/*
+	 * Also check there are no active entities being served which are
+	 * not on active tree
+	 */
+
+	if (iog->sched_data.active_entity)
+		return 1;
+
 	return 0;
 }
 
@@ -1738,7 +1747,7 @@ void iocg_destroy(struct cgroup_subsys *
 	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
 	struct hlist_node *n, *tmp;
 	struct io_group *iog;
-	unsigned long flags;
+	unsigned long flags, flags1;
 	int queue_lock_held = 0;
 	struct elv_fq_data *efqd;
 
@@ -1766,7 +1775,8 @@ retry:
 		rcu_read_lock();
 		efqd = rcu_dereference(iog->key);
 		if (efqd != NULL) {
-			if (spin_trylock_irq(efqd->queue->queue_lock)) {
+			if (spin_trylock_irqsave(efqd->queue->queue_lock,
+						flags1)) {
 				if (iog->key == efqd) {
 					queue_lock_held = 1;
 					rcu_read_unlock();
@@ -1780,7 +1790,8 @@ retry:
 				 * elevator hence we can proceed safely without
 				 * queue lock.
 				 */
-				spin_unlock_irq(efqd->queue->queue_lock);
+				spin_unlock_irqrestore(efqd->queue->queue_lock,
+							flags1);
 			} else {
 				/*
 				 * Did not get the queue lock while trying.
@@ -1803,7 +1814,7 @@ retry:
 locked:
 		__iocg_destroy(iocg, iog, queue_lock_held);
 		if (queue_lock_held) {
-			spin_unlock_irq(efqd->queue->queue_lock);
+			spin_unlock_irqrestore(efqd->queue->queue_lock, flags1);
 			queue_lock_held = 0;
 		}
 	}
@@ -1811,6 +1822,7 @@ locked:
 
 	BUG_ON(!hlist_empty(&iocg->group_data));
 
+	free_css_id(&io_subsys, &iocg->css);
 	kfree(iocg);
 }
 
