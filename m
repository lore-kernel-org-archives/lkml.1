Return-Path: <linux-kernel-owner+w=401wt.eu-S1750709AbXCGDhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750709AbXCGDhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030494AbXCGDhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:37:18 -0500
Received: from mylar.outflux.net ([69.93.193.226]:48297 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXCGDhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:37:16 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 22:37:16 EST
Date: Tue, 6 Mar 2007 19:14:29 -0800
From: Kees Cook <kees@outflux.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070307031429.GU9621@outflux.net>
References: <20070307012234.GN9621@outflux.net> <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306185942.585e7cd1.akpm@linux-foundation.org>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 06:59:42PM -0800, Andrew Morton wrote:
> On Tue, 6 Mar 2007 18:13:35 -0800 Kees Cook <kees@outflux.net> wrote:
> 
> > On Tue, Mar 06, 2007 at 05:56:09PM -0800, Andrew Morton wrote:
> > > On Tue, 6 Mar 2007 17:22:34 -0800
> > > Kees Cook <kees@outflux.net> wrote:
> > > 
> > > > This is a continuation of a much earlier discussion[1].  As I 
> > > > understand, the problem is:
> > > 
> > > This sounds like a really good way of breaking lots and lots of people's
> > > expensively-developed stuff.  In ways which we won't discover until a year
> > > after we shipped it.
> > > 
> > > So nope, sorry.  Need to find a compatible way of doing this.  Perhaps a
> > > kernel boot parameter or a /proc knob.
> > 
> > Do you have examples of things in the kernel that I can use as a 
> > starting point?
> 
> No, I don't think this has precedent.
> 
> >  Would something like /proc/sys/kernel/maps_protect be 
> > reasonable?
> 
> Yes, that sounds reasonable.
> 
> An alternative is to do it with elf headers, perhaps - let the process
> specify what protections it wants in some manner.
> 
> > If an acceptable toggle is made, would you consider it being enabled by 
> > default (i.e. "tighter security by default")?
> 
> Again, that sounds risky.

[Adding Cc:lkml]

How about using a reduced check, as is done for fd and environ?  This 
would allow root-running system monitors to still do their job.  
Effectively, this changes the test from "is ptracing" to just "can 
ptrace".

If this still isn't considered safe, I'll add the maps_protect file...

--- 
task_mmu.c   |   16 +++++++++++++++-
 task_nommu.c |    6 ++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
---
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7445980..7c9aad3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -134,6 +134,9 @@ static int show_map_internal(struct seq_file *m, void *v, struct mem_size_stats
 	dev_t dev = 0;
 	int len;
 
+	if (!ptrace_may_attach(task))
+		return -EACCES;
+
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -444,11 +447,22 @@ const struct file_operations proc_maps_operations = {
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
+static int show_numa_map_checked(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (!ptrace_may_attach(task))
+		return -EACCES;
+	
+	return show_numa_map(m, v);
+}
+
 static struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map
+        .show   = show_numa_map_checked
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 7cddf6b..c5783b7 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -143,6 +143,12 @@ out:
 static int show_map(struct seq_file *m, void *_vml)
 {
 	struct vm_list_struct *vml = _vml;
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+	
+	if (!ptrace_may_attach(task))
+		return -EACCES;
+
 	return nommu_vma_show(m, vml->vma);
 }
 



-- 
Kees Cook                                            @outflux.net
