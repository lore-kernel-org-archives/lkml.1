Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZANOI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZANOI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZANOIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:08:50 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52639 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZANOIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:08:49 -0500
Date: Wed, 14 Jan 2009 14:08:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       yinghan@google.com
Subject: Re: [RFC][PATCH] don't show pgoff of vma if vma is pure ANON (was
 Re: mmotm 2009-01-12-16-53 uploaded)
In-Reply-To: <20090114162245.923c4caf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0901141349410.5465@blonde.anvils>
References: <200901130053.n0D0rhev023334@imap1.linux-foundation.org>
 <20090113181317.48e910af.kamezawa.hiroyu@jp.fujitsu.com> <496CC9D8.6040909@google.com>
 <20090114162245.923c4caf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, KAMEZAWA Hiroyuki wrote:
> Hmm, is this brutal ?
> 
> ==
> Recently, it's argued that what proc/pid/maps shows is ugly when a
> 32bit binary runs on 64bit host.
> 
> /proc/pid/maps outputs vma's pgoff member but vma->pgoff is of no use
> information is the vma is for ANON.
> By this patch, /proc/pid/maps shows just 0 if no file backing store.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---

Brutal, but sensible enough: revert to how things looked before
we ever starting putting vm_pgoff to work on anonymous areas.

I slightly regret losing that visible clue to whether an anonymous
vma has ever been mremap moved.  But have I ever actually used that
info?  No, never.

I presume you test !vma->vm_file so the lines fit in, fair enough.
But I think you'll find checkpatch.pl protests at "(!vma->vm_file)?"

I dislike its decisions on the punctuation of the ternary operator
- perhaps even more than Andrew dislikes the operator itself!
Do we write a space before a question mark? no: nor before a colon;
but I also dislike getting into checkpatch.pl arguments!

While you're there, I'd also be inclined to make task_nommu.c
use the same loff_t cast as task_mmu.c is using.

Hugh

> Index: mmotm-2.6.29-Jan13/fs/proc/task_mmu.c
> ===================================================================
> --- mmotm-2.6.29-Jan13.orig/fs/proc/task_mmu.c
> +++ mmotm-2.6.29-Jan13/fs/proc/task_mmu.c
> @@ -220,7 +220,8 @@ static void show_map_vma(struct seq_file
>  			flags & VM_WRITE ? 'w' : '-',
>  			flags & VM_EXEC ? 'x' : '-',
>  			flags & VM_MAYSHARE ? 's' : 'p',
> -			((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
> +			(!vma->vm_file)? 0 :
> +				((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
>  			MAJOR(dev), MINOR(dev), ino, &len);
>  
>  	/*
> Index: mmotm-2.6.29-Jan13/fs/proc/task_nommu.c
> ===================================================================
> --- mmotm-2.6.29-Jan13.orig/fs/proc/task_nommu.c
> +++ mmotm-2.6.29-Jan13/fs/proc/task_nommu.c
> @@ -143,7 +143,8 @@ static int nommu_vma_show(struct seq_fil
>  		   flags & VM_WRITE ? 'w' : '-',
>  		   flags & VM_EXEC ? 'x' : '-',
>  		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
> -		   (unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
> +		   (!vma->vm_file) ? 0 :
> +			(unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
>  		   MAJOR(dev), MINOR(dev), ino, &len);
>  
>  	if (file) {
> 
