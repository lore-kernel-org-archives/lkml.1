Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXC3WKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXC3WKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXC3WKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:10:47 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:38139 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932563AbXC3WKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:10:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=t6lKSzeq0E2bluA/BTosEbq9Xmf8Qn9w0fgdjs4G/NfLVxEHwbXMD4bGZDrYtvdMIw26FmJTb8/CpJrR1o1zOMEnLpwkDZ5/QtKT/voe3hS5Hufv7IRIam0Zx7FRZzp1yjzacGrF670ziirozdfBq/d+ed4HhTwPROcZcqmHQQs=  ;
X-YMail-OSG: .hV9kvIVM1m5Q7_JK038mRBmgwS4U3yNssCy9ig5Jm8mB2f.5uuZ.pWT2kMGl8nTP9OIY2L02Ant3cqv5VykuJ6PBMIj4wSW4UMKcZkGnj5tQwzF
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/2] UML - Speed up exec
Date: Sat, 31 Mar 2007 00:10:34 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
References: <20070330145257.GA5471@c2.user-mode-linux.org>
In-Reply-To: <20070330145257.GA5471@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_arYDG3JNq8iFiOT"
Message-Id: <200703310010.34803.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_arYDG3JNq8iFiOT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On venerd=EC 30 marzo 2007, Jeff Dike wrote:
> flush_thread doesn't need to do a full page table walk in order to
> clear the address space.  It knows what the end result needs to be, so
> it can call unmap directly.
>
> This results in a 10-20% speedup in an exec from bash.

Oh, yeah!
When porting part of Ingo's work, I realized that a similar thing can be do=
ne=20
for fork().

If the whole address space is unmapped in init_new_context_skas(), the firs=
t=20
fix_range_common() call won't need to call unmap at all. He did this with=20
remap_file_pages(), where init_new_context_skas() must "unmap" everything=20
anyway.

This is giving some speedup in lmbench (5% better in fork proc, 2% better i=
n=20
exec proc), but the results are still controversial, there is one benchmark=
=20
with a 2% slowdown (called 'mmap latency').

In a loop, it maps, touches a byte per page and unmaps a region with growin=
g=20
size (up to 32MB).

However, since results aren't yet stable for some other benchmark (context=
=20
switching benchmark is crazy), I'm still studying on this.

> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  arch/um/kernel/skas/exec.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.21-mm/arch/um/kernel/skas/exec.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.21-mm.orig/arch/um/kernel/skas/exec.c	2007-03-30
> 10:28:24.000000000 -0400 +++
> linux-2.6.21-mm/arch/um/kernel/skas/exec.c	2007-03-30 10:30:15.000000000
> -0400 @@ -17,7 +17,17 @@
>
>  void flush_thread_skas(void)
>  {
> -	force_flush_all();
> +	void *data =3D NULL;
> +	unsigned long end =3D proc_mm ? task_size : CONFIG_STUB_START;
> +	int ret;
> +
> +	ret =3D unmap(&current->mm->context.skas.id, 0, end, 1, &data);
> +	if(ret){
> +		printk("flush_thread_skas - clearing address space failed, "
> +		       "err =3D %d\n", ret);
> +		force_sig(SIGKILL, current);
> +	}
> +
>  	switch_mm_skas(&current->mm->context.skas.id);
>  }


=2D-=20
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade

--Boundary-00=_arYDG3JNq8iFiOT
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="first-flush-optim.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="first-flush-optim.diff"

Index: linux-2.6.git/arch/um/include/skas/mmu-skas.h
===================================================================
--- linux-2.6.git.orig/arch/um/include/skas/mmu-skas.h
+++ linux-2.6.git/arch/um/include/skas/mmu-skas.h
@@ -16,6 +16,7 @@ struct mmu_context_skas {
 	unsigned long last_pmd;
 #endif
 	uml_ldt_t ldt;
+	int first_flush;
 };
 
 extern void switch_mm_skas(struct mm_id * mm_idp);
Index: linux-2.6.git/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6.git.orig/arch/um/kernel/skas/mmu.c
+++ linux-2.6.git/arch/um/kernel/skas/mmu.c
@@ -77,6 +77,7 @@ int init_new_context_skas(struct task_st
 	struct mmu_context_skas *to_mm = &mm->context.skas;
 	unsigned long stack = 0;
 	int ret = -ENOMEM;
+	void *unused = NULL;
 
 	if(skas_needs_stub){
 		stack = get_zeroed_page(GFP_KERNEL);
@@ -121,6 +122,14 @@ int init_new_context_skas(struct task_st
 		else to_mm->id.u.pid = start_userspace(stack);
 	}
 
+	mm->context.skas.first_flush = 1;
+	ret = unmap(&mm->context.skas.id, 0, TASK_SIZE, 1, &unused);
+	if (ret < 0) {
+		printk("init_new_context_skas - unmap failed, "
+		       "errno = %d; continuing\n", ret);
+		mm->context.skas.first_flush = 0;
+	}
+
 	ret = init_new_ldt(to_mm, from_mm);
 	if(ret < 0){
 		printk("init_new_context_skas - init_ldt"
Index: linux-2.6.git/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.git.orig/arch/um/kernel/tlb.c
+++ linux-2.6.git/arch/um/kernel/tlb.c
@@ -139,10 +139,17 @@ void fix_range_common(struct mm_struct *
 	void *flush = NULL;
 	int op_index = -1, last_op = ARRAY_SIZE(ops) - 1;
 	int ret = 0;
+	int first_flush;
 
 	if(mm == NULL)
 		return;
 
+	/* Nothing is mapped in this address space, so no call to add_munmap()
+	 * must be done */
+	first_flush = mm->context.skas.first_flush;
+
+	mm->context.skas.first_flush = 0;
+
 	ops[0].type = NONE;
 	for(addr = start_addr; addr < end_addr && !ret;){
 		npgd = pgd_offset(mm, addr);
@@ -151,9 +158,10 @@ void fix_range_common(struct mm_struct *
 			if(end > end_addr)
 				end = end_addr;
 			if(force || pgd_newpage(*npgd)){
-				ret = add_munmap(addr, end - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
+				if (!first_flush)
+					ret = add_munmap(addr, end - addr, ops,
+							 &op_index, last_op, mmu,
+							 &flush, do_ops);
 				pgd_mkuptodate(*npgd);
 			}
 			addr = end;
@@ -166,9 +174,10 @@ void fix_range_common(struct mm_struct *
 			if(end > end_addr)
 				end = end_addr;
 			if(force || pud_newpage(*npud)){
-				ret = add_munmap(addr, end - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
+				if (!first_flush)
+					ret = add_munmap(addr, end - addr, ops,
+							 &op_index, last_op, mmu,
+							 &flush, do_ops);
 				pud_mkuptodate(*npud);
 			}
 			addr = end;
@@ -181,9 +190,10 @@ void fix_range_common(struct mm_struct *
 			if(end > end_addr)
 				end = end_addr;
 			if(force || pmd_newpage(*npmd)){
-				ret = add_munmap(addr, end - addr, ops,
-						 &op_index, last_op, mmu,
-						 &flush, do_ops);
+				if (!first_flush)
+					ret = add_munmap(addr, end - addr, ops,
+							 &op_index, last_op, mmu,
+							 &flush, do_ops);
 				pmd_mkuptodate(*npmd);
 			}
 			addr = end;
@@ -207,7 +217,8 @@ void fix_range_common(struct mm_struct *
 					       PAGE_SIZE, r, w, x, ops,
 					       &op_index, last_op, mmu,
 					       &flush, do_ops);
-			else ret = add_munmap(addr, PAGE_SIZE, ops,
+			else if (!first_flush)
+				ret = add_munmap(addr, PAGE_SIZE, ops,
 					      &op_index, last_op, mmu,
 					      &flush, do_ops);
 		}
@@ -219,7 +230,7 @@ void fix_range_common(struct mm_struct *
 		*npte = pte_mkuptodate(*npte);
 		addr += PAGE_SIZE;
 	}
-	if(!ret)
+	if (!ret && op_index > -1)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
 
 /* This is not an else because ret is modified above */

--Boundary-00=_arYDG3JNq8iFiOT--
