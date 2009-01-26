Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZAZTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZAZTib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZAZTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:38:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbZAZTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:38:22 -0500
Date: Mon, 26 Jan 2009 11:37:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mikew@google.com, rientjes@google.com, rohitseth@google.com,
       hugh@veritas.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
       edwintorok@gmail.com, lee.schermerhorn@hp.com, npiggin@suse.de
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
Message-Id: <20090126113728.58212a30.akpm@linux-foundation.org>
In-Reply-To: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 11:40:19 -0800
Ying Han <yinghan@google.com> wrote:

> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -591,6 +591,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigne
>  #ifdef CONFIG_X86_64
>  	unsigned long flags;
>  #endif
> +	unsigned int retry_flag = FAULT_FLAG_RETRY;
> 
>  	tsk = current;
>  	mm = tsk->mm;
> @@ -689,6 +690,7 @@ again:
>  		down_read(&mm->mmap_sem);
>  	}
> 
> +retry:
>  	vma = find_vma(mm, address);
>  	if (!vma)
>  		goto bad_area;
> @@ -715,6 +717,7 @@ again:
>  good_area:
>  	si_code = SEGV_ACCERR;
>  	write = 0;
> +	write |= retry_flag;
>  	switch (error_code & (PF_PROT|PF_WRITE)) {
>  	default:	/* 3: write, present */
>  		/* fall through */
> @@ -743,6 +746,15 @@ good_area:
>  			goto do_sigbus;
>  		BUG();
>  	}
> +
> +	if (fault & VM_FAULT_RETRY) {
> +		if (write & FAULT_FLAG_RETRY) {
> +			retry_flag &= ~FAULT_FLAG_RETRY;
> +			goto retry;
> +		}
> +		BUG();
> +	}
> +
>  	if (fault & VM_FAULT_MAJOR)
>  		tsk->maj_flt++;
>  	else

This code is mixing flags from the FAULT_FLAG_foor domain into local
variable `write'.  But that's inappropriate because `write' is a
boolean, and in one of Ingo's trees, `write' gets bits other than bit 0
set, and it all generally ends up a mess.

Can we not do that?  I assume that a previous version of this patch
kept those things separated?

Something like this, I think?

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix
+++ a/arch/x86/mm/fault.c
@@ -799,7 +799,7 @@ void __kprobes do_page_fault(struct pt_r
 	struct vm_area_struct *vma;
 	int write;
 	int fault;
-	unsigned int retry_flag = FAULT_FLAG_RETRY;
+	int retry_flag = 1;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -951,6 +951,7 @@ good_area:
 	}
 
 	write |= retry_flag;
+
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -969,8 +970,8 @@ good_area:
 	 * be removed or changed after the retry.
 	 */
 	if (fault & VM_FAULT_RETRY) {
-		if (write & FAULT_FLAG_RETRY) {
-			retry_flag &= ~FAULT_FLAG_RETRY;
+		if (retry_flag) {
+			retry_flag = 0;
 			goto retry;
 		}
 		BUG();


Question: why is this code passing `write==true' into handle_mm_fault()
in the retry case?

