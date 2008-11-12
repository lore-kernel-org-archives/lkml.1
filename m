Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYKLAY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYKLAY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYKLAYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:24:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:33393 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYKLAYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:24:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=FTXPYpZQ24FX/RcWvaU1lEpkjzOnMIxHYDc9BsRpf6sma2p189lz9/BOpK6tmjtTcX
         +h2Rbo3UY5sOt4eo9KqviwIUWc1NSqoGfNd8FM+u/F/5Cp45moL0hv6JAFAEev3o9siW
         ekb/8jztyrv/w91R9MsNc4OO6cg0JbDPwjeHU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
Date: Wed, 12 Nov 2008 01:24:41 +0100
User-Agent: KMail/1.8.2
Cc: Helge Deller <deller@gmx.de>, Jiri Slaby <jirislaby@gmail.com>,
       Jeroen Roovers <jer@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <200811022024.31528.vda.linux@googlemail.com> <alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JJiGJPkXz+Ng6rX"
Message-Id: <200811120124.41222.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JJiGJPkXz+Ng6rX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 12 November 2008 00:22, Jiri Kosina wrote:
> On Sun, 2 Nov 2008, Denys Vlasenko wrote:
> > > I fully bisected it, and the final "buggy" patch seems to have been 
> > > Denys Vlasenko's patch: cb8f488c33539f096580e202f5438a809195008f (see 
> > > http://github.com/jonsmirl/digispeaker/commit/cb8f488c33539f096580e202f5438a809195008f) 
> > > Denys: Any reason you removed "!prev" in front of "expand_stack"?
>
> > Looks like I erroneously thought it can't be NULL,
> > or that expand_upwards() is ok with getting NULL vma parameter.
> > I looked again and neither is true.
> > Sorry, looks like I indeed broke this.
> 
> Hmm, so ... ? Seems like this didn't get fixed in Linus' tree yet?

I found my original email in "sent" folder. The patch in that mail
does NOT remove !prev. That change had beed added by someone else.
See attached file with original email.

Ok, I think we are not much interested in who did it, let's
fix it for good.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- linux-2.6.28-rc4/mm/mmap.c	Mon Nov 10 01:36:15 2008
+++ linux-2.6.28-rc4.fix/mm/mmap.c	Wed Nov 12 01:21:39 2008
@@ -1704,7 +1704,7 @@
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (expand_stack(prev, addr))
+	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)

--Boundary-00=_JJiGJPkXz+Ng6rX
Content-Type: text/plain;
  charset="iso-8859-1";
  name="deinline_mmap.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="deinline_mmap.txt"

=46rom vda.linux@googlemail.com Sat Jul  5 18:37:30 2008
=46rom: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH] Deinline a few functions in mmap.c
Date: Sat, 5 Jul 2008 18:37:30 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset=3D"us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051837.30219.vda.linux@googlemail.com>
Status: RO
X-Status: RSC
X-KMail-EncryptionState: =20
X-KMail-SignatureState: =20
X-KMail-MDN-Sent: =20

__vma_link_file and expand_downwards functions are not small,
yeat they are marked inline. They probably had one callsite
sometime in the past, but now they have more.
In order to prevent similar thing, I also deinlined
expand_upwards, despite it having only pne callsite.
Nowadays gcc auto-inlines such static functions anyway.
In find_extend_vma, I removed one extra level of indirection.

Patch is deliberately generated with -U $BIGNUM to make
it easier to see that functions are big.

Result:

# size */*/mmap.o */vmlinux
   text    data     bss     dec     hex filename
   9514     188      16    9718    25f6 0.org/mm/mmap.o
   9237     188      16    9441    24e1 deinline/mm/mmap.o
6124402  858996  389480 7372878  70804e 0.org/vmlinux
6124113  858996  389480 7372589  707f2d deinline/vmlinux

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
=2D-
vda

=2D-- 0.org/mm/mmap.c	Wed Jul  2 00:40:52 2008
+++ deinline/mm/mmap.c	Sat Jul  5 16:19:30 2008
@@ -389,41 +389,41 @@
 	if (prev) {
 		vma->vm_next =3D prev->vm_next;
 		prev->vm_next =3D vma;
 	} else {
 		mm->mmap =3D vma;
 		if (rb_parent)
 			vma->vm_next =3D rb_entry(rb_parent,
 					struct vm_area_struct, vm_rb);
 		else
 			vma->vm_next =3D NULL;
 	}
 }
=20
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
 	rb_link_node(&vma->vm_rb, rb_parent, rb_link);
 	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
 }
=20
=2Dstatic inline void __vma_link_file(struct vm_area_struct *vma)
+static void __vma_link_file(struct vm_area_struct *vma)
 {
 	struct file * file;
=20
 	file =3D vma->vm_file;
 	if (file) {
 		struct address_space *mapping =3D file->f_mapping;
=20
 		if (vma->vm_flags & VM_DENYWRITE)
 			atomic_dec(&file->f_path.dentry->d_inode->i_writecount);
 		if (vma->vm_flags & VM_SHARED)
 			mapping->i_mmap_writable++;
=20
 		flush_dcache_mmap_lock(mapping);
 		if (unlikely(vma->vm_flags & VM_NONLINEAR))
 			vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		else
 			vma_prio_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
 	}
 }
@@ -1558,41 +1558,41 @@
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
 	if (security_vm_enough_memory(grow))
 		return -ENOMEM;
=20
 	/* Ok, everything looks good - let it rip */
 	mm->total_vm +=3D grow;
 	if (vma->vm_flags & VM_LOCKED)
 		mm->locked_vm +=3D grow;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, grow);
 	return 0;
 }
=20
 #if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
 /*
  * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
  */
 #ifndef CONFIG_IA64
=2Dstatic inline
+static
 #endif
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	int error;
=20
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
=20
 	/*
 	 * We must make sure the anon_vma is allocated
 	 * so that the anon_vma locking is not a noop.
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
 	anon_vma_lock(vma);
=20
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
@@ -1608,41 +1608,41 @@
=20
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
 		unsigned long size, grow;
=20
 		size =3D address - vma->vm_start;
 		grow =3D (address - vma->vm_end) >> PAGE_SHIFT;
=20
 		error =3D acct_stack_growth(vma, size, grow);
 		if (!error)
 			vma->vm_end =3D address;
 	}
 	anon_vma_unlock(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
=20
 /*
  * vma is the first one with address < vma->vm_start.  Have to extend vma.
  */
=2Dstatic inline int expand_downwards(struct vm_area_struct *vma,
+static int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	int error;
=20
 	/*
 	 * We must make sure the anon_vma is allocated
 	 * so that the anon_vma locking is not a noop.
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
=20
 	address &=3D PAGE_MASK;
 	error =3D security_file_mmap(NULL, 0, 0, 0, address, 1);
 	if (error)
 		return error;
=20
 	anon_vma_lock(vma);
=20
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -1670,68 +1670,68 @@
 int expand_stack_downwards(struct vm_area_struct *vma, unsigned long addre=
ss)
 {
 	return expand_downwards(vma, address);
 }
=20
 #ifdef CONFIG_STACK_GROWSUP
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
 	return expand_upwards(vma, address);
 }
=20
 struct vm_area_struct *
 find_extend_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma, *prev;
=20
 	addr &=3D PAGE_MASK;
 	vma =3D find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <=3D addr))
 		return vma;
=2D	if (!prev || expand_stack(prev, addr))
+	if (!prev || expand_upwards(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
 		make_pages_present(addr, prev->vm_end);
 	return prev;
 }
 #else
 int expand_stack(struct vm_area_struct *vma, unsigned long address)
 {
 	return expand_downwards(vma, address);
 }
=20
 struct vm_area_struct *
 find_extend_vma(struct mm_struct * mm, unsigned long addr)
 {
 	struct vm_area_struct * vma;
 	unsigned long start;
=20
 	addr &=3D PAGE_MASK;
 	vma =3D find_vma(mm,addr);
 	if (!vma)
 		return NULL;
 	if (vma->vm_start <=3D addr)
 		return vma;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return NULL;
 	start =3D vma->vm_start;
=2D	if (expand_stack(vma, addr))
+	if (expand_downwards(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED)
 		make_pages_present(addr, start);
 	return vma;
 }
 #endif
=20
 /*
  * Ok - we have the memory areas we should free on the vma list,
  * so release them, and do the vma updates.
  *
  * Called with the mm semaphore held.
  */
 static void remove_vma_list(struct mm_struct *mm, struct vm_area_struct *v=
ma)
 {
 	/* Update high watermark before we lower total_vm */
 	update_hiwater_vm(mm);
 	do {
 		long nrpages =3D vma_pages(vma);
=20


--Boundary-00=_JJiGJPkXz+Ng6rX
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6.28-rc4.mmap.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.28-rc4.mmap.c.patch"

--- linux-2.6.28-rc4/mm/mmap.c	Mon Nov 10 01:36:15 2008
+++ linux-2.6.28-rc4.fix/mm/mmap.c	Wed Nov 12 01:21:39 2008
@@ -1704,7 +1704,7 @@
 	vma = find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <= addr))
 		return vma;
-	if (expand_stack(prev, addr))
+	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
 		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)

--Boundary-00=_JJiGJPkXz+Ng6rX--
