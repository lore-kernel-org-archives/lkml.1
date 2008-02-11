Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYBKW3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYBKW3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYBKW27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:28:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52031 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbYBKW26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:28:58 -0500
Date: Mon, 11 Feb 2008 14:28:55 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@us.ibm.com>, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid
	context at include/asm/uaccess_32.h:449
Message-ID: <20080211222855.GA9138@us.ibm.com>
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com> <20080209162643.fd3822f1.akpm@linux-foundation.org> <20080210212528.GA17442@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210212528.GA17442@us.ibm.com>
X-Operating-System: Linux 2.6.24-7-generic (i686)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.2008 [13:25:28 -0800], Nishanth Aravamudan wrote:
> On 09.02.2008 [16:26:43 -0800], Andrew Morton wrote:
> > On Sat, 9 Feb 2008 14:03:28 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
> > 
> > > Command run:
> > >      find /proc | xargs tail
> > > 
> > > [ 2710.028219] BUG: sleeping function called from invalid context at
> > > include/asm/uaccess_32.h:449
> > > [ 2710.028229] in_atomic():1, irqs_disabled():0
> > > [ 2710.028232] 1 lock held by head/9380:
> > > [ 2710.028234]  #0:  (hugetlb_lock){--..}, at: [<c016734f>]
> > > hugetlb_overcommit_handler+0x16/0x3e
> > > [ 2710.028248] Pid: 9380, comm: head Not tainted 2.6.24-git20 #5
> > > [ 2710.028260]  [<c0118749>] __might_sleep+0xc2/0xc9
> > > [ 2710.028267]  [<c021cb39>] copy_to_user+0x32/0x49
> > > [ 2710.028277]  [<c0123f6a>] do_proc_doulongvec_minmax+0x1df/0x27f
> > > [ 2710.028289]  [<c012403c>] proc_doulongvec_minmax+0x15/0x17
> > > [ 2710.028295]  [<c0167363>] hugetlb_overcommit_handler+0x2a/0x3e
> > > [ 2710.028303]  [<c01a1462>] proc_sys_read+0x5e/0x7b
> > > [ 2710.028311]  [<c01a1404>] ? proc_sys_read+0x0/0x7b
> > > [ 2710.028317]  [<c0170d7a>] vfs_read+0x8a/0x106
> > > [ 2710.028325]  [<c017116f>] sys_read+0x3b/0x60
> > > [ 2710.028331]  [<c0103e32>] sysenter_past_esp+0x5f/0xa5
> > 
> > Ugh, how did I let that one through?
> 
> Don't blame yourself, blame me.
> 
> > Guys, how often mut it be said?
> 
> Hopefully this is often enough.
> 
> > PLEASE always test all code with all kernel deubg options enabled.
> 
> Yep, 100% my error. Am testing a fix now, will post soon.

While I'm not removing the brown paper bag from my head, I was unable to
reproduce the BUG on my 2-way x86_64 at home. I then noticed Miles'
system is x86_32. After wrangling with our testing grid, I got a 32-bit
system booting 2.6.24-git22. Didn't reproduce there either, with
CONFIG_DEBUG_SPINLOCK_SLEEP=y. What am I doing wrong? I think the
following is the right fix, but have not see the original BUG to know
for sure. I did the `find /proc | xargs tail`, but shouldn't I hit the
BUG just simply `cat`'ing or `echo`ing into the file?

Miles, could you test the following?

Thanks,
Nish

hugetlb: fix overcommit locking

proc_doulongvec_minmax() calls copy_to_user()/copy_from_user(), so we
can't hold hugetlb_lock over the call. Use a dummy variable to store the
sysctl result, like in hugetlb_sysctl_handler(), then grab the lock to
update nr_overcommit_huge_pages.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 7ca198b..addca4c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -33,8 +33,8 @@ int hugetlb_reserve_pages(struct inode *inode, long from, long to);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
 extern unsigned long max_huge_pages;
+extern unsigned long sysctl_overcommit_huge_pages;
 extern unsigned long hugepages_treat_as_movable;
-extern unsigned long nr_overcommit_huge_pages;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d41ef6b..2024632 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -978,8 +978,8 @@ static struct ctl_table vm_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nr_overcommit_hugepages",
-		.data		= &nr_overcommit_huge_pages,
-		.maxlen		= sizeof(nr_overcommit_huge_pages),
+		.data		= &sysctl_overcommit_huge_pages,
+		.maxlen		= sizeof(sysctl_overcommit_huge_pages),
 		.mode		= 0644,
 		.proc_handler	= &hugetlb_overcommit_handler,
 	},
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d9a3803..cb1b3a7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -24,14 +24,15 @@
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
 static unsigned long surplus_huge_pages;
+static unsigned long nr_overcommit_huge_pages;
 unsigned long max_huge_pages;
+unsigned long sysctl_overcommit_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
 static unsigned int free_huge_pages_node[MAX_NUMNODES];
 static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
-unsigned long nr_overcommit_huge_pages;
 static int hugetlb_next_nid;
 
 /*
@@ -609,8 +610,9 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 			struct file *file, void __user *buffer,
 			size_t *length, loff_t *ppos)
 {
-	spin_lock(&hugetlb_lock);
 	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+	spin_lock(&hugetlb_lock);
+	nr_overcommit_huge_pages = sysctl_overcommit_huge_pages;
 	spin_unlock(&hugetlb_lock);
 	return 0;
 }
