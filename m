Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbZDJQWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbZDJQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZDJQWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:22:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46620 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZDJQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:22:41 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Matt Helsley <matthltc@us.ibm.com>,
       yamamoto@valinux.co.jp, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/30] Remove struct mm_struct::exe_file et al
References: <20090410023312.GC27788@x200.localdomain>
	<20090410085305.GC17962@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 10 Apr 2009 09:22:28 -0700
In-Reply-To: <20090410085305.GC17962@elte.hu> (Ingo Molnar's message of "Fri\, 10 Apr 2009 10\:53\:05 +0200")
Message-ID: <m1ljq8eawr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, hch@infradead.org, orenl@cs.columbia.edu, dave@linux.vnet.ibm.com, serue@us.ibm.com, xemul@parallels.com, containers@lists.linux-foundation.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, yamamoto@valinux.co.jp, matthltc@us.ibm.com, adobriyan@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 aka "procfs task 
>> exe symlink". introduced struct mm_struct::exe_file and struct 
>> mm_struct::num_exe_file_vmas.
>> 
>> The rationale is weak: unifying MMU and no-MMU version of 
>> /proc/*/exe code. For this a) struct mm_struct becomes bigger, b) 
>> mmap/munmap/exit become slower, c) patch adds more code than 
>> removes in fact.
>
> Hm, nommu unification was not the only effect of that original 
> patch.
>
> The other effect was to introduce a managed 'which is the first 
> executable vma in the mm' abstraction in struct mm. Your patch 
> removes that abstraction and re-introduces a linear ->vma_next walk:
>
>> +	down_read(&mm->mmap_sem);
>> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
>> +		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
>
> Which can walk along thousands (or tens of thousands) of vmas until 
> it finds the first executable vma. For example on PIE binaries it's 
> quite possible to have a lot of non-PROT_EXEC vmas before the first 
> EXEC vma is met.
>
> So your revert reintroduces that linear walk. It might not matter 
> much (/proc/*/exe might be sufficiently uninteresting in practice to 
> not deserve an optimization), but it's still worth a mention and a 
> discussion in the changelog.

There is also Andrew Morton's suggestion of just keeping a struct path
in mm_struct instead of struct file.  That should be the best of both
worlds.


Eric
