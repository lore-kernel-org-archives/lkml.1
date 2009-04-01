Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbZDAWfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbZDAWfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZDAWfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:35:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZDAWfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:35:20 -0400
Date: Thu, 2 Apr 2009 00:32:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090401223241.GA28168@elte.hu>
References: <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 1 Apr 2009, Ingo Molnar wrote:
> >  
> > The rest (unannotated variables) is to be assumed 
> > "access-rarely" or "we-dont-care", by default. This is actually 
> > 95% of the global variables.
> 
> I'm not at all convinced that this is a good option.
> 
> The thing is, things like "read_mostly" or "access_rarely" may 
> talk about how we access those individual variables, but you're 
> missing a _huge_ chunk of the puzzle if you ignore the 
> _correlations_ of those accesses with accesses to other variables.
> 
> The thign is, if you have variables 'a' and 'b', and they are 
> always accessed together, then it's probably worth it to put them 
> in the same cacheline.
> 
> And that is true EVEN IF 'b' is basically read-only, but 'a' is 
> always written to. Marking 'a' as read-only or read-mostly is 
> actually a bad idea, since the only thing it can ever result in is 
> a bigger cache footprint.
> 
> The fact that the read-only cacheline has "nicer" behavior is 
> totally irrelevant - it's still an extra cacheline that we're 
> accessing. And they aren't free, even if read-only cachelines that 
> can be shared across CPU's are certainly a lot cheaper than ones 
> that bounce.

Yes, i was mainly considering independent/uncorrelated variables in 
my (short, hence simplistic) argument.

And you are perfectly right to point out that correlated-access 
variables should not be annotated in a conflicting (or wasteful) 
way.

But lets see this specific example we are discussing, demonstrated 
on a live kernel.

Lets see how the cacheline usage and alignments look like in 
practice, and what the various effects of Christopher's patch are. 
Lets check whether your and Christoph's intuition is correct that 
this patch is a good change.

Christopher's patch removes __read_mostly annotations, such as 
these:

 static int pcpu_unit_pages __read_mostly;
 static int pcpu_unit_size __read_mostly;
 static int pcpu_chunk_size __read_mostly;
 static int pcpu_nr_slots __read_mostly;
 static size_t pcpu_chunk_struct_size __read_mostly;

I did a 64-bit x86 defconfig build to check how these symbols are 
laid out, before and after the patch.

Before the patch:

ffffffff817d3e60 d shmem_backing_dev_info  [ cacheline: ffffffff817d3f40 ]
ffffffff817d3f50 D sysctl_stat_interval
ffffffff817d3f54 D randomize_va_space
ffffffff817d3f58 D sysctl_max_map_count
ffffffff817d3f5c d vmap_initialized
ffffffff817d3f60 d pcpu_unit_pages             *
ffffffff817d3f64 d pcpu_unit_size              .
ffffffff817d3f68 d pcpu_chunk_size             .
ffffffff817d3f6c d pcpu_nr_slots               .
ffffffff817d3f70 d pcpu_chunk_struct_size      .
ffffffff817d3f78 d pcpu_slot                   .
ffffffff817d3f80 D pcpu_base_addr          [ cacheline: ffffffff817d3f80 ]
ffffffff817d3f90 d filp_cachep                 *
ffffffff817d3f90 d filp_cachep
ffffffff817d3f98 d pipe_mnt
ffffffff817d3fa0 d fasync_cache
ffffffff817d3fa8 D sysctl_vfs_cache_pressure
ffffffff817d3fb0 d dentry_cache
ffffffff817d3fb8 d d_hash_mask
ffffffff817d3fbc d d_hash_shift
ffffffff817d3fc0 d dentry_hashtable        [ cacheline: ffffffff817d3fc0 ]

The .data (write-often) variables have this (before-patch) layout:

ffffffff81919480 b dmap.19506              [ cacheline: ffffffff81919480 ]
ffffffff81919488 b smap.19505                  .
ffffffff81919490 b first_vm.19504          [ cacheline: ffffffff819194c0 ]
ffffffff819194d0 b pcpu_addr_root              .
ffffffff819194d8 b pcpu_lock                   .
ffffffff819194e0 b pcpu_reserved_chunk         .
ffffffff819194e8 b pcpu_reserved_chunk_limit   *
ffffffff819194f0 b __key.21450
ffffffff819194f0 b old_max.21260
ffffffff81919500 B sb_lock                 [ cacheline: ffffffff81919500 ]

So the existing __read_mostly pcpu_* variables touch two cachelines 
in the read-mostly data section, and two cachelines in .data.

After the patch we get one continuous block:

ffffffff81919480 B pcpu_base_addr          [ cacheline: ffffffff81919480 ]
ffffffff81919488 b dmap.19506                  .
ffffffff81919490 b smap.19505                  .
ffffffff819194a0 b first_vm.19504          [ cacheline: ffffffff819194c0 ]
ffffffff819194e0 b pcpu_addr_root              .
ffffffff819194e8 b pcpu_lock                   .
ffffffff819194ec b pcpu_unit_pages             .
ffffffff819194f0 b pcpu_unit_size              .
ffffffff819194f4 b pcpu_chunk_size             .
ffffffff819194f8 b pcpu_nr_slots               .
ffffffff81919500 b pcpu_chunk_struct_size  [ cacheline: ffffffff81919500 ]
ffffffff81919508 b pcpu_reserved_chunk         .
ffffffff81919510 b pcpu_reserved_chunk_limit   .
ffffffff81919518 b pcpu_slot                   *
ffffffff81919520 b __key.21450
ffffffff81919520 b old_max.21260
ffffffff81919530 B sb_lock
ffffffff81919534 b unnamed_dev_lock
ffffffff81919540 b unnamed_dev_ida         [ cacheline: ffffffff81919540 ]

All variables are in 3 cachelines.

So seemingly we have won one cacheline of cache footprint.

But the problem is, the use of the read-mostly variables that Tejun 
annotated does not necessarily correlate with the use of the other 
variables.

One case would be the free_percpu(NULL) fastpath.

We encourage kfree(NULL) and it triggers commonly in the kernel 
today [on distro kernels we checked it can trigger once per 
syscall!] - so i think we should consider free_percpu(NULL) a 
possibly common pattern too. (even though today it's likely _not_ 
common at all.)

And free_percpu(NULL) does this:

void free_percpu(void *ptr)
{
        void *addr = __pcpu_ptr_to_addr(ptr);
        struct pcpu_chunk *chunk;
        unsigned long flags;
        int off;

        if (!ptr)
                return;

Look at the __pcpu_ptr_to_addr(ptr) transformation - that triggers 
an access to pcpu_base_addr.

This is how it's compiled (GCC 4.3.2):

ffffffff810c26f1 <free_percpu>:
ffffffff810c26f1:	55                   	push   %rbp
ffffffff810c26f2:	48 89 e5             	mov    %rsp,%rbp
ffffffff810c26f5:	41 55                	push   %r13
ffffffff810c26f7:	41 54                	push   %r12
ffffffff810c26f9:	53                   	push   %rbx
ffffffff810c26fa:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff810c26fe:	48 85 ff             	test   %rdi,%rdi
ffffffff810c2701:	48 8b 05 78 6d 85 00 	mov    0x856d78(%rip),%rax        # ffffffff81919480 <pcpu_base_addr>
ffffffff810c2708:	0f 84 18 01 00 00    	je     ffffffff810c2826 <free_percpu+0x135>
ffffffff810c270e:	48 2d 00 00 00 00    	sub    $0x0,%rax

The instruction at ffffffff810c2701 will read the pcpu_base_addr 
global variable into RAX.
 
Which this patch just moved out of the read-mostly section and into 
the write-often .data section, and in the symbol map above it will 
share a cacheline with first_vm - wich vm_area_struct will be 
dirtied if another CPU does a [real] percpu_alloc() call on another 
CPU.

So ... we regressed the performance of percpu_free(NULL) with a 
potential cross-CPU cacheline bounce. Without the patch, 
percpu_free(NULL) would never do such a bounce. So i dont think the 
patch is a good idea.

This is generally true of __read_mostly removal.

It is true that read-mostly variables can often be argued to always 
be access-correlated, but often they are not. _Most_ in-kernel 
facilities that are performance critical and have global variables 
also have fastpaths as well.

2)

The other observation i'd like to make about the example above is 
that _after_ the patch, we accidentally got into the same cacheline 
as sb_lock: cacheline ffffffff81919500.

This is not a fault of the patch, but it is a demonstration of the 
problem i was talking about: that our variable placement is 
unplanned and random.

sb_lock can be a very hot lock in certain VFS workloads (on certain 
filesystems - maybe even in other situations), so a workload that 
also does frequent percpu_alloc() calls on another CPU will suffer 
from the worst type of (and hardest to notice) cacheline bouncing: 
two _different_ write-often-variable-accessing workloads bouncing 
the same cacheline.

Before the patch we got lucky and we'd bounce two separate 
cachelines - which on modern systems is twice as fast as bouncing 
the same cacheline.

This example i believe strengthens the observation i made in the 
original mail: my impression is that the best approach is to be 
totally conscious about which variable is where, and to be generous 
with __read_mostly, and to properly align any global write-often 
variables.

I tried to fix these problems in the code and tried to make the 
alignment of the write-mostly bits. One problem is that locks can 
easily end up in the BSS - spread apart from non-zero initialized 
.data global variables - which seems pretty dumb as it splits the 
cacheline again.

It creates such kind of cacheline waste:

ffffffff817cd000 D tasklist_lock
ffffffff817cd040 D mmlist_lock
ffffffff817cd080 d softirq_vec
ffffffff817cd140 d pidmap_lock
ffffffff817cd180 D xtime_lock
ffffffff817cd1c0 d call_function
ffffffff817cd200 d hash_lock
ffffffff817cd240 d irq_desc_legacy
ffffffff817cde40 D kmalloc_caches
ffffffff817d1e80 d pcpu_alloc_mutex
ffffffff817d1ec0 D files_lock
ffffffff817d1f00 d nr_files

Each lock is on a separate cacheline - this is fine, but correlated 
data is not there which is a bit dumb because we waste most of that 
cacheline.

Cannot we force the linker to put zero-initialized variables into 
.data as well, moving all (non-annotated) variables into the same 
section? (A downside is that the kernel image would not compress as 
well, but that is not a big issue as it gets freed after init 
anyway.)

I think it is another important fact that the read-mostly section is 
well-packed (no unnecessary holes), and it is never intruded by 
forced cacheline evictions. So in today's huge L2 caches it can 
remain populated easily and can linger there for a long time. The 
write-intense cachelines on the other hand will only be in a single 
CPU's cache - and the more sockets, the less the chance is that it 
will be in a nearby cache. So that extra cacheline footprint the 
above example shows might be less of a cost in reality.

So the ideal variable layout IMHO would be roughly what i suggested 
in the mail before:

 - known-read-mostly variables in one continous block in the 
   read-mostly section [not cacheline aligned]

 - cacheline-aligned write-often variable starting the list of 
   variables, and all other global variables coming after it. This 
   would mean we start a new cacheline, but we'd also start

In fact ... i'd argue that each separate .o should _probably_ have 
its .data section aligned to cacheline size, on SMP.

This would be a lot more maintainable than explicit cacheline 
alignment for the first write-often variable: we'd only have to 
annotate __read_mostly, and we'd have to move the most important 
variables first (which is a good practice anyway).

The downside would be cacheline waste for tiny .o files with just 
one or two global variables. Precise statistics have to be done how 
the typical case looks like. A really back-of-the-paper wild 
ballpark figure guess would be the vmlinux i just built:

    text    data	    bss	    dec	    hex	filename
 7703478 1141192	 974848	9819518	 95d57e	vmlinux

That kernel has 2403 object files - which gives 474 bytes of .data 
per .o, and 405 bytes of .bss. If we combined the two, the averag 
would be around 1K. A 64 bytes alignment for each such 1K block 
would be more than acceptable and the granularity loss (32 bytes per 
ech block) would be around 75K of .data - or 3.6%.

In fact, the current bss would shrink due to those cacheline-aligned 
locks going back to the .data and being packed right - so i think 
the real figure would be even lower.

Looks like an acceptable equation - or at least one that could be 
considered.

What do you think? I think the current situation is far from ideal, 
the practices are not well settled and are also marred by harmful 
misconceptions, and i think we could do a lot better via a few 
simple measures.

	Ingo

---
 fs/super.c  |   15 ++++++++++-----
 mm/percpu.c |   46 +++++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 20 deletions(-)

Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c
+++ linux/fs/super.c
@@ -42,9 +42,16 @@
 #include <asm/uaccess.h>
 #include "internal.h"
 
+/*
+ * Write-often and accessed-rarely global variables, cacheline aligned:
+ */
 
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(sb_lock);
 LIST_HEAD(super_blocks);
-DEFINE_SPINLOCK(sb_lock);
+
+static struct super_operations default_op;
+
+static DEFINE_MUTEX(sync_fs_mutex);
 
 /**
  *	alloc_super	-	create new superblock
@@ -56,7 +63,6 @@ DEFINE_SPINLOCK(sb_lock);
 static struct super_block *alloc_super(struct file_system_type *type)
 {
 	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);
-	static struct super_operations default_op;
 
 	if (s) {
 		if (security_sb_alloc(s)) {
@@ -466,9 +472,8 @@ restart:
 void sync_filesystems(int wait)
 {
 	struct super_block *sb;
-	static DEFINE_MUTEX(mutex);
 
-	mutex_lock(&mutex);		/* Could be down_interruptible */
+	mutex_lock(&sync_fs_mutex);		/* Could be down_interruptible */
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (!sb->s_op->sync_fs)
@@ -498,7 +503,7 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
-	mutex_unlock(&mutex);
+	mutex_unlock(&sync_fs_mutex);
 }
 
 /**
Index: linux/mm/percpu.c
===================================================================
--- linux.orig/mm/percpu.c
+++ linux/mm/percpu.c
@@ -100,20 +100,27 @@ struct pcpu_chunk {
 	struct page		*page_ar[];	/* #cpus * UNIT_PAGES */
 };
 
-static int pcpu_unit_pages __read_mostly;
-static int pcpu_unit_size __read_mostly;
-static int pcpu_chunk_size __read_mostly;
-static int pcpu_nr_slots __read_mostly;
-static size_t pcpu_chunk_struct_size __read_mostly;
+/*
+ * Read-mostly data:
+ */
+
+/* Constants, set at init time: */
+static int			pcpu_unit_pages		__read_mostly;
+static int			pcpu_unit_size		__read_mostly;
+static int			pcpu_chunk_size		__read_mostly;
+static int			pcpu_nr_slots		__read_mostly;
+static size_t			pcpu_chunk_struct_size	__read_mostly;
 
-/* the address of the first chunk which starts with the kernel static area */
-void *pcpu_base_addr __read_mostly;
+/* The address of the first chunk which starts with the kernel static area: */
+void				*pcpu_base_addr		__read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
-/* optional reserved chunk, only accessible for reserved allocations */
-static struct pcpu_chunk *pcpu_reserved_chunk;
-/* offset limit of the reserved chunk */
-static int pcpu_reserved_chunk_limit;
+/* Optional reserved chunk, only accessible for reserved allocations: */
+static struct pcpu_chunk	*pcpu_reserved_chunk	__read_mostly;
+
+/* Offset limit of the reserved chunk: */
+static int			pcpu_reserved_chunk_limit
+							__read_mostly;
 
 /*
  * Synchronization rules.
@@ -136,12 +143,23 @@ static int pcpu_reserved_chunk_limit;
  * allocation path might be referencing the chunk with only
  * pcpu_alloc_mutex locked.
  */
-static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
+
+/*
+ * Write-often and rarely accessed data, cacheline-aligned:
+ */
+
+/* protects whole alloc and reclaim: */
+static __cacheline_aligned_in_smp DEFINE_MUTEX(pcpu_alloc_mutex);
 static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */
 
-static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
+static struct vm_struct first_vm;	/* first vm-list member */
+static int smap[2], dmap[2];		/* initial static and dynamic maps */
+
+/* chunk list slots: */
+static struct list_head *pcpu_slot;
+
 /* reclaim work to release fully free chunks, scheduled from free path */
 static void pcpu_reclaim(struct work_struct *work);
 static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
@@ -1087,8 +1105,6 @@ size_t __init pcpu_setup_first_chunk(pcp
 				     void *base_addr,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
-	static struct vm_struct first_vm;
-	static int smap[2], dmap[2];
 	size_t size_sum = static_size + reserved_size +
 			  (dyn_size >= 0 ? dyn_size : 0);
 	struct pcpu_chunk *schunk, *dchunk = NULL;
