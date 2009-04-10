Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbZDJIzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbZDJIzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZDJIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:55:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbZDJIy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:54:59 -0400
Date: Fri, 10 Apr 2009 10:53:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>, Matt Helsley <matthltc@us.ibm.com>,
       yamamoto@valinux.co.jp, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/30] Remove struct mm_struct::exe_file et al
Message-ID: <20090410085305.GC17962@elte.hu>
References: <20090410023312.GC27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023312.GC27788@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task 
> exe symlink". introduced struct mm_struct::exe_file and struct 
> mm_struct::num_exe_file_vmas.
> 
> The rationale is weak: unifying MMU and no-MMU version of 
> /proc/*/exe code. For this a) struct mm_struct becomes bigger, b) 
> mmap/munmap/exit become slower, c) patch adds more code than 
> removes in fact.

Hm, nommu unification was not the only effect of that original 
patch.

The other effect was to introduce a managed 'which is the first 
executable vma in the mm' abstraction in struct mm. Your patch 
removes that abstraction and re-introduces a linear ->vma_next walk:

> +	down_read(&mm->mmap_sem);
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {

Which can walk along thousands (or tens of thousands) of vmas until 
it finds the first executable vma. For example on PIE binaries it's 
quite possible to have a lot of non-PROT_EXEC vmas before the first 
EXEC vma is met.

So your revert reintroduces that linear walk. It might not matter 
much (/proc/*/exe might be sufficiently uninteresting in practice to 
not deserve an optimization), but it's still worth a mention and a 
discussion in the changelog.

Thanks,

	Ingo
