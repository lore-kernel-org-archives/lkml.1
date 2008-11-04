Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYKDS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYKDS6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKDS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:58:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYKDS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:58:04 -0500
Date: Tue, 4 Nov 2008 10:57:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: __bprm_mm_init(): remove uneeded goto
Message-Id: <20081104105707.39dc5e30.akpm@linux-foundation.org>
In-Reply-To: <20081104140314.1b196764@doriath.conectiva>
References: <20081104140314.1b196764@doriath.conectiva>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 14:03:14 -0200
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:

> 
> It is only really used if insert_vm_struct() fails, we can inline it
> and drop some (uneeded) lines of code.
> 
> Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
> 
> ---
>  fs/exec.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/fs/exec.c
> ===================================================================
> --- linux-2.6.orig/fs/exec.c
> +++ linux-2.6/fs/exec.c
> @@ -232,13 +232,13 @@ static void flush_arg_page(struct linux_
>  
>  static int __bprm_mm_init(struct linux_binprm *bprm)
>  {
> -	int err = -ENOMEM;
> +	int err;
>  	struct vm_area_struct *vma = NULL;
>  	struct mm_struct *mm = bprm->mm;
>  
>  	bprm->vma = vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
>  	if (!vma)
> -		goto err;
> +		return -ENOMEM;
>  
>  	down_write(&mm->mmap_sem);
>  	vma->vm_mm = mm;
> @@ -257,7 +257,9 @@ static int __bprm_mm_init(struct linux_b
>  	err = insert_vm_struct(mm, vma);
>  	if (err) {
>  		up_write(&mm->mmap_sem);
> -		goto err;
> +		kmem_cache_free(vm_area_cachep, vma);
> +		bprm->vma = NULL;
> +		return err;
>  	}
>  
>  	mm->stack_vm = mm->total_vm = 1;
> @@ -266,14 +268,6 @@ static int __bprm_mm_init(struct linux_b
>  	bprm->p = vma->vm_end - sizeof(void *);
>  
>  	return 0;
> -
> -err:
> -	if (vma) {
> -		bprm->vma = NULL;
> -		kmem_cache_free(vm_area_cachep, vma);
> -	}
> -
> -	return err;
>  }
>  
>  static bool valid_arg_len(struct linux_binprm *bprm, long len)

eek, that made the code worse.

Please avoid multiple `return' statements in functions.  The first one
you have there is OK - it occurs before any resources have been
allocated and it's right at the start of the function, etc.

But the second `return' is a no-no.  Doing this is a fairly common
source of locking errors and resource leaks as the code evolves.  And
what frequently happens is that someone changes the code to allocate
some new resource or to take some new lock and then they end up putting
an unlock or a free ahead of each and every `return' statement in the
function, which is daft.

It would be better to do this:

--- a/fs/exec.c~__bprm_mm_init-remove-uneeded-goto
+++ a/fs/exec.c
@@ -233,13 +233,13 @@ static void flush_arg_page(struct linux_
 
 static int __bprm_mm_init(struct linux_binprm *bprm)
 {
-	int err = -ENOMEM;
+	int err;
 	struct vm_area_struct *vma = NULL;
 	struct mm_struct *mm = bprm->mm;
 
 	bprm->vma = vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
-		goto err;
+		return -ENOMEM;
 
 	down_write(&mm->mmap_sem);
 	vma->vm_mm = mm;
@@ -258,6 +258,8 @@ static int __bprm_mm_init(struct linux_b
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
+		kmem_cache_free(vm_area_cachep, vma);
+		bprm->vma = NULL;
 		goto err;
 	}
 
@@ -267,13 +269,7 @@ static int __bprm_mm_init(struct linux_b
 	bprm->p = vma->vm_end - sizeof(void *);
 
 	return 0;
-
 err:
-	if (vma) {
-		bprm->vma = NULL;
-		kmem_cache_free(vm_area_cachep, vma);
-	}
-
 	return err;
 }
 
_


But that's still not very good, because if someone later adds some new
lock-taking or resource-allocating to this function, how does their
error-handling path avoid duplicating the existing unlock and free?

So a better approach is this:

--- a/fs/exec.c~__bprm_mm_init-remove-uneeded-goto
+++ a/fs/exec.c
@@ -233,13 +233,13 @@ static void flush_arg_page(struct linux_
 
 static int __bprm_mm_init(struct linux_binprm *bprm)
 {
-	int err = -ENOMEM;
+	int err;
 	struct vm_area_struct *vma = NULL;
 	struct mm_struct *mm = bprm->mm;
 
 	bprm->vma = vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
-		goto err;
+		return -ENOMEM;
 
 	down_write(&mm->mmap_sem);
 	vma->vm_mm = mm;
@@ -256,10 +256,8 @@ static int __bprm_mm_init(struct linux_b
 	vma->vm_flags = VM_STACK_FLAGS;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	err = insert_vm_struct(mm, vma);
-	if (err) {
-		up_write(&mm->mmap_sem);
+	if (err)
 		goto err;
-	}
 
 	mm->stack_vm = mm->total_vm = 1;
 	up_write(&mm->mmap_sem);
@@ -267,13 +265,10 @@ static int __bprm_mm_init(struct linux_b
 	bprm->p = vma->vm_end - sizeof(void *);
 
 	return 0;
-
 err:
-	if (vma) {
-		bprm->vma = NULL;
-		kmem_cache_free(vm_area_cachep, vma);
-	}
-
+	up_write(&mm->mmap_sem);
+	bprm->vma = NULL;
+	kmem_cache_free(vm_area_cachep, vma);
 	return err;
 }
 
_

Now, if someone later adds more resource-allocating or lock-taking to
this function they can use `goto err' on the error path.  Or they can
add a new err_unlocked: after the up_write() or whatever.

The above code now uses the most common pattern for a kernel
function.  One we've learned from hard experience!

