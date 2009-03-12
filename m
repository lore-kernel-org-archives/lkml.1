Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZCLFTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZCLFTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZCLFTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:19:46 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:57726 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZCLFTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:19:45 -0400
Message-ID: <49B89B22.7080303@cosmosbay.com>
Date: Thu, 12 Mar 2009 06:18:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, bcrl@kvack.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] fs: fput() can be called from interrupt context
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>	<49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <49B87CFE.4000701@cosmosbay.com>
In-Reply-To: <49B87CFE.4000701@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 06:18:28 +0100 (CET)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Eric Dumazet a écrit :
>>> Jeff Moyer a écrit :
>>>> Avi Kivity <avi@redhat.com> writes:
>>>>
>>>>> Jeff Moyer wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Believe it or not, I get numerous questions from customers about the
>>>>>> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
>>>>>> number of io events that can be reserved, system wide, for aio
>>>>>> completions.  Each time io_setup is called, a ring buffer is allocated
>>>>>> that can hold nr_events I/O completions.  That ring buffer is then
>>>>>> mapped into the process' address space, and the pages are pinned in
>>>>>> memory.  So, the reason for this upper limit (I believe) is to keep a
>>>>>> malicious user from pinning all of kernel memory.  Now, this sounds like
>>>>>> a much better job for the memlock rlimit to me, hence the following
>>>>>> patch.
>>>>>>   
>>>>> Is it not possible to get rid of the pinning entirely?  Pinning
>>>>> interferes with page migration which is important for NUMA, among
>>>>> other issues.
>>>> aio_complete is called from interrupt handlers, so can't block faulting
>>>> in a page.  Zach mentions there is a possibility of handing completions
>>>> off to a kernel thread, with all of the performance worries and extra
>>>> bookkeeping that go along with such a scheme (to help frame my concerns,
>>>> I often get lambasted over .5% performance regressions).
>>> This aio_completion from interrupt handlers keep us from using SLAB_DESTROY_BY_RCU
>>> instead of call_rcu() for "struct file" freeing.
>>>
>>> http://lkml.org/lkml/2008/12/17/364
>>>
>>> I would love if we could get rid of this mess...
>> Speaking of that, I tried to take a look at this aio stuff and have one question.
>>
>> Assuming that __fput() cannot be called from interrupt context.
>> -> fput() should not be called from interrupt context as well.
>>
>> How comes we call fput(req->ki_eventfd) from really_put_req()
>> from interrupt context ?
>>
>> If user program closes eventfd, then inflight AIO requests can trigger
>> a bug.
>>
> 
> Path could be :
> 
> 1) fput() changes so that calling it from interrupt context is possible
>    (Using a working queue to make sure __fput() is called from process context)
> 
> 2) Changes aio to use fput() as is (and zap its internal work_queue and aio_fput_routine() stuff)
> 
> 3) Once atomic_long_dec_and_test(&filp->f_count) only performed in fput(),
>    SLAB_DESTROY_BY_RCU for "struct file" get back :)
> 

Please find first patch against linux-2.6

Next patch (2) can cleanup aio code, but it probably can wait linux-2.6.30

Thank you

[PATCH] fs: fput() can be called from interrupt context

Current aio/eventfd code can call fput() from interrupt context, which is
not allowed.

In order to fix the problem and prepare SLAB_DESTROY_BY_RCU use for "struct file"
allocation/freeing in 2.6.30, we might extend existing workqueue infrastructure and
allow fput() to be called from interrupt context.

This unfortunalty adds a pointer to 'struct file'.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 fs/file.c               |   55 ++++++++++++++++++++++++++------------
 fs/file_table.c         |   10 +++++-
 include/linux/fdtable.h |    1
 include/linux/fs.h      |    1
 4 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f313314..8c819a8 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -24,6 +24,7 @@ struct fdtable_defer {
 	spinlock_t lock;
 	struct work_struct wq;
 	struct fdtable *next;
+	struct file *fhead;
 };
 
 int sysctl_nr_open __read_mostly = 1024*1024;
@@ -67,24 +68,53 @@ static void free_fdtable_work(struct work_struct *work)
 	struct fdtable_defer *f =
 		container_of(work, struct fdtable_defer, wq);
 	struct fdtable *fdt;
+	struct file *fhead;
 
-	spin_lock_bh(&f->lock);
-	fdt = f->next;
-	f->next = NULL;
-	spin_unlock_bh(&f->lock);
-	while(fdt) {
+	spin_lock_irq(&f->lock);
+	fdt      = f->next;
+	fhead    = f->fhead;
+	f->next  = NULL;
+	f->fhead = NULL;
+	spin_unlock_irq(&f->lock);
+
+	while (fdt) {
 		struct fdtable *next = fdt->next;
+
 		vfree(fdt->fd);
 		free_fdset(fdt);
 		kfree(fdt);
 		fdt = next;
 	}
+
+	while (fhead) {
+		struct file *next = fhead->f_next;
+
+		__fput(fhead);
+		fhead = next;
+	}
+}
+
+void fd_defer_queue(struct fdtable *fdt, struct file *file)
+{
+	struct fdtable_defer *fddef = &get_cpu_var(fdtable_defer_list);
+
+	spin_lock_irq(&fddef->lock);
+	if (fdt) {
+		fdt->next = fddef->next;
+		fddef->next = fdt;
+	}
+	if (file) {
+		file->f_next = fddef->fhead;
+		fddef->fhead = file;
+	}
+	spin_unlock_irq(&fddef->lock);
+	schedule_work(&fddef->wq);
+	put_cpu_var(fdtable_defer_list);
 }
 
 void free_fdtable_rcu(struct rcu_head *rcu)
 {
 	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	struct fdtable_defer *fddef;
 
 	BUG_ON(!fdt);
 
@@ -101,16 +131,8 @@ void free_fdtable_rcu(struct rcu_head *rcu)
 		kfree(fdt->fd);
 		kfree(fdt->open_fds);
 		kfree(fdt);
-	} else {
-		fddef = &get_cpu_var(fdtable_defer_list);
-		spin_lock(&fddef->lock);
-		fdt->next = fddef->next;
-		fddef->next = fdt;
-		/* vmallocs are handled from the workqueue context */
-		schedule_work(&fddef->wq);
-		spin_unlock(&fddef->lock);
-		put_cpu_var(fdtable_defer_list);
-	}
+	} else
+		fd_defer_queue(fdt, NULL);
 }
 
 /*
@@ -410,6 +432,7 @@ static void __devinit fdtable_defer_list_init(int cpu)
 	spin_lock_init(&fddef->lock);
 	INIT_WORK(&fddef->wq, free_fdtable_work);
 	fddef->next = NULL;
+	fddef->fhead = NULL;
 }
 
 void __init files_defer_init(void)
diff --git a/fs/file_table.c b/fs/file_table.c
index bbeeac6..77f42d8 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -21,6 +21,7 @@
 #include <linux/fsnotify.h>
 #include <linux/sysctl.h>
 #include <linux/percpu_counter.h>
+#include <linux/interrupt.h>
 
 #include <asm/atomic.h>
 
@@ -220,10 +221,15 @@ int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
 }
 EXPORT_SYMBOL(init_file);
 
+
 void fput(struct file *file)
 {
-	if (atomic_long_dec_and_test(&file->f_count))
-		__fput(file);
+	if (atomic_long_dec_and_test(&file->f_count)) {
+		if (unlikely(!in_interrupt()))
+			fd_defer_queue(NULL, file);
+		else
+			__fput(file);
+	}
 }
 
 EXPORT_SYMBOL(fput);
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 09d6c5b..42e5e8e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -35,6 +35,7 @@ struct fdtable {
 	struct fdtable *next;
 };
 
+extern void fd_defer_queue(struct fdtable *fdt, struct file *file);
 /*
  * Open file table structure
  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 92734c0..94beb0e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -872,6 +872,7 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+	struct file		*f_next;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);

