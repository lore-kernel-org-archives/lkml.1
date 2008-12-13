Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYLMCf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYLMCf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYLMCe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:34:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:58248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYLMCey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PVJalYTzuMNZzJM7Sd4Do0E3oOt+bZeq9AtxRqe1JcR34WgaqK3UfAXwQTq/5SuKVs
         xv+57CGPiQ7qrOuRSxU1acFfiYUQoH+NXMNGYFE5itUFI6C1zhM8aSw3mE6J9oRS0qmT
         0mzDLBia+Xo2XY5RzbdIZaMdBbL2nag/66E3A=
Message-ID: <2f11576a0812121834n4125d053xcc85a5aa87264b66@mail.gmail.com>
Date: Sat, 13 Dec 2008 11:34:53 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx accounting
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Hugh Dickins" <hugh@veritas.com>, "Jay Lan" <jlan@sgi.com>,
       "Jiri Pirko" <jpirko@redhat.com>, "Jonathan Lim" <jlim@sgi.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081212140524.GA29488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212140524.GA29488@redhat.com>
X-Google-Sender-Auth: 0dcef3dcbdb281ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (changes: update the changelog/comments)
>
> xacct_add_tsk() relies on do_exit()->update_hiwater_xxx() and uses
> mm->hiwater_xxx directly, this leads to 2 problems:
>
>        - taskstats_user_cmd() can call fill_pid()->xacct_add_tsk()
>          at any moment before the task exits, so we should check the
>          current values of rss/vm anyway.
>
>        - do_exit()->update_hiwater_xxx() calls are racy. An exiting
>          thread can be preempted right before mm->hiwater_xxx = new_val,
>          and another thread can use A_LOT of memory and exit in between.
>          When the first thread resumes it can be the last thread in the
>          thread group, in that case we report the wrong hiwater_xxx
>          values which do not take A_LOT into account.
>
> Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() helpers and
> change xacct_add_tsk() to use them. The first helper will also be
> used by rusage->ru_maxrss accounting.
>
> Kill do_exit()->update_hiwater_xxx() calls. Unless we are going to
> decrease rss/vm there is no point to update mm->hiwater_xxx, and
> nobody can look at this mm_struct when exit_mmap() actually unmaps
> the memory.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks! looks good to me.
   Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> --- K-28/mm/mmap.c~HIWATER      2008-12-02 17:12:40.000000000 +0100
> +++ K-28/mm/mmap.c      2008-12-11 09:13:07.000000000 +0100
> @@ -2103,7 +2103,7 @@ void exit_mmap(struct mm_struct *mm)
>        lru_add_drain();
>        flush_cache_mm(mm);
>        tlb = tlb_gather_mmu(mm, 1);
> -       /* Don't update_hiwater_rss(mm) here, do_exit already did */
> +       /* update_hiwater_rss(mm) here? but nobody should be looking */
>        /* Use -1 here to ensure all VMAs in the mm are unmapped */
>        end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
>        vm_unacct_memory(nr_accounted);

I also think hiwatermark don't need update here.
